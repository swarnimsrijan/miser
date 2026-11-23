package com.miser.moneyTracker;

import tools.jackson.databind.JsonNode;
import tools.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.resttestclient.TestRestTemplate;
import org.springframework.boot.resttestclient.autoconfigure.AutoConfigureTestRestTemplate;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;

import java.nio.charset.StandardCharsets;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Full happy-path flow against a real Postgres (Testcontainers):
 * sign in (Keycloak-shaped token) -> create account -> upload CSV statement ->
 * auto-categorized transactions -> dashboard aggregates -> reports ->
 * duplicate rejection; plus the planning features on top.
 */
@Import({TestcontainersConfiguration.class, TestJwtConfiguration.class})
@AutoConfigureTestRestTemplate
@SpringBootTest(
        webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT,
        properties = "app.upload-dir=${java.io.tmpdir}/moneytracker-test-uploads")
class MoneyTrackerE2ETest {

    private static final String STATEMENT_CSV = """
            Account Statement,,,,,
            ,,,,,
            Date,Narration,Chq./Ref.No.,Withdrawal Amt.,Deposit Amt.,Closing Balance
            01/04/2025,UPI-SWIGGY-swiggy@icici-402935,UPI-509912,450.00,,"12,550.00"
            02/04/2025,UPI-UBER-uber@axis-118221,UPI-509913,350.00,,"12,200.00"
            03/04/2025,ACME CORP SALARY APR,NEFT-88123,,"85,000.00","97,200.00"
            """;

    @Autowired private TestRestTemplate rest;
    @Autowired private ObjectMapper objectMapper;

    @Test
    void endToEndStatementFlow() throws Exception {
        // --- sign in: first authenticated call provisions the user ---
        String token = TestJwtConfiguration.token("kc-e2e", "e2e@test.com", "E2E User");
        JsonNode me = getJson(token, "/api/me");
        assertEquals("e2e@test.com", me.get("email").asText());
        assertEquals("E2E User", me.get("name").asText());
        assertEquals(me.get("id").asLong(), getJson(token, "/api/me").get("id").asLong());

        // a validly signed token without a subject must not resolve to any user
        String noSubject = TestJwtConfiguration.token(null, "nosub@test.com", "No Sub");
        assertEquals(HttpStatus.FORBIDDEN, rest.exchange("/api/me", org.springframework.http.HttpMethod.GET,
                new HttpEntity<>(authHeaders(noSubject)), String.class).getStatusCode());

        // unauthenticated and forged requests are rejected
        assertEquals(HttpStatus.UNAUTHORIZED,
                rest.getForEntity("/api/accounts", String.class).getStatusCode());
        HttpHeaders forged = authHeaders(token.substring(0, token.length() - 4) + "AAAA");
        assertEquals(HttpStatus.UNAUTHORIZED, rest.exchange("/api/accounts",
                org.springframework.http.HttpMethod.GET, new HttpEntity<>(forged), String.class).getStatusCode());

        // --- create account against a seeded bank ---
        JsonNode banks = getJson(token, "/api/banks");
        assertTrue(banks.size() >= 8, "seeded banks expected");
        long bankId = banks.get(0).get("id").asLong();

        ResponseEntity<String> accountResponse = exchange(token, "/api/accounts",
                Map.of("bankId", bankId, "nickname", "Main", "accountType", "SAVINGS",
                        "currency", "INR", "accountNumberMasked", "XXXX1234"));
        assertEquals(HttpStatus.CREATED, accountResponse.getStatusCode());
        long accountId = objectMapper.readTree(accountResponse.getBody()).get("id").asLong();

        // --- upload statement ---
        JsonNode statement = upload(token, accountId);
        assertEquals("PARSED", statement.get("status").asText());
        assertEquals(3, statement.get("transactionCount").asLong());
        assertEquals("2025-04-01", statement.get("fromDate").asText());
        assertEquals("2025-04-03", statement.get("toDate").asText());

        // duplicate upload -> 409
        HttpHeaders headers = authHeaders(token);
        headers.setContentType(MediaType.MULTIPART_FORM_DATA);
        ResponseEntity<String> duplicate = rest.postForEntity("/api/statements/upload",
                new HttpEntity<>(multipart(accountId), headers), String.class);
        assertEquals(HttpStatus.CONFLICT, duplicate.getStatusCode());

        // --- transactions are auto-categorized ---
        JsonNode transactions = getJson(token, "/api/transactions").get("content");
        assertEquals(3, transactions.size());
        JsonNode swiggy = findByDescription(transactions, "SWIGGY");
        assertEquals("Food", swiggy.get("category").asText());
        assertEquals("Delivery", swiggy.get("subCategory").asText());
        assertEquals("DEBIT", swiggy.get("transactionType").asText());
        JsonNode uber = findByDescription(transactions, "UBER");
        assertEquals("Travel", uber.get("category").asText());
        assertEquals("Cab", uber.get("subCategory").asText());
        JsonNode salary = findByDescription(transactions, "SALARY");
        assertEquals("CREDIT", salary.get("transactionType").asText());

        // filter by type
        assertEquals(2, getJson(token, "/api/transactions?type=DEBIT").get("content").size());

        // --- recategorize one transaction ---
        JsonNode categories = getJson(token, "/api/categories");
        long otherId = -1;
        for (JsonNode c : categories) {
            if (c.get("name").asText().equals("Other")) otherId = c.get("id").asLong();
        }
        HttpHeaders patchHeaders = authHeaders(token);
        patchHeaders.setContentType(MediaType.APPLICATION_JSON);
        ResponseEntity<String> patched = rest.exchange(
                "/api/transactions/" + swiggy.get("id").asLong() + "/category",
                org.springframework.http.HttpMethod.PATCH,
                new HttpEntity<>(Map.of("categoryId", otherId), patchHeaders), String.class);
        assertEquals(HttpStatus.OK, patched.getStatusCode());
        assertEquals("Other", objectMapper.readTree(patched.getBody()).get("category").asText());

        // --- dashboard ---
        JsonNode summary = getJson(token, "/api/dashboard/summary?from=2025-04-01&to=2025-04-30");
        assertEquals(0, summary.get("totalIncome").decimalValue()
                .compareTo(new java.math.BigDecimal("85000.00")));
        assertEquals(0, summary.get("totalExpense").decimalValue()
                .compareTo(new java.math.BigDecimal("800.00")));

        JsonNode byCategory = getJson(token, "/api/dashboard/category?from=2025-04-01&to=2025-04-30");
        assertEquals(2, byCategory.size()); // Other (recategorized swiggy) + Travel

        JsonNode monthly = getJson(token, "/api/dashboard/monthly?from=2025-04-01&to=2025-04-30");
        assertEquals(1, monthly.size());
        assertEquals("2025-04", monthly.get(0).get("month").asText());

        JsonNode networth = getJson(token, "/api/dashboard/networth");
        assertEquals(0, networth.get("bankBalances").decimalValue()
                .compareTo(new java.math.BigDecimal("97200.00")));

        // --- reports ---
        ResponseEntity<byte[]> csv = rest.exchange("/api/reports/csv",
                org.springframework.http.HttpMethod.GET,
                new HttpEntity<>(authHeaders(token)), byte[].class);
        assertEquals(HttpStatus.OK, csv.getStatusCode());
        String csvBody = new String(csv.getBody(), StandardCharsets.UTF_8);
        assertEquals(4, csvBody.strip().split("\n").length); // header + 3 rows

        ResponseEntity<byte[]> pdf = rest.exchange("/api/reports/pdf",
                org.springframework.http.HttpMethod.GET,
                new HttpEntity<>(authHeaders(token)), byte[].class);
        assertEquals(HttpStatus.OK, pdf.getStatusCode());
        assertTrue(pdf.getBody().length > 4 && new String(pdf.getBody(), 0, 4).equals("%PDF"));

        ResponseEntity<byte[]> excel = rest.exchange("/api/reports/excel",
                org.springframework.http.HttpMethod.GET,
                new HttpEntity<>(authHeaders(token)), byte[].class);
        assertEquals(HttpStatus.OK, excel.getStatusCode());
        assertTrue(excel.getBody().length > 0);

        // --- statement listing ---
        JsonNode statements = getJson(token, "/api/statements");
        assertEquals(1, statements.size());
        assertEquals("PARSED", statements.get(0).get("status").asText());
    }

    @Test
    void uploadRequiresExactlyOneTarget() throws Exception {
        String token = TestJwtConfiguration.token("kc-target", "target@test.com", "T");

        HttpHeaders headers = authHeaders(token);
        headers.setContentType(MediaType.MULTIPART_FORM_DATA);
        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        body.add("file", csvResource());
        // neither accountId nor creditCardId
        ResponseEntity<String> response = rest.postForEntity("/api/statements/upload",
                new HttpEntity<>(body, headers), String.class);
        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
    }

    // --- helpers ---

    private JsonNode upload(String token, long accountId) throws Exception {
        HttpHeaders headers = authHeaders(token);
        headers.setContentType(MediaType.MULTIPART_FORM_DATA);
        ResponseEntity<String> response = rest.postForEntity("/api/statements/upload",
                new HttpEntity<>(multipart(accountId), headers), String.class);
        assertEquals(HttpStatus.CREATED, response.getStatusCode(), response.getBody());
        return objectMapper.readTree(response.getBody());
    }

    private MultiValueMap<String, Object> multipart(long accountId) {
        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        body.add("file", csvResource());
        body.add("accountId", String.valueOf(accountId));
        return body;
    }

    private static ByteArrayResource csvResource() {
        return new ByteArrayResource(STATEMENT_CSV.getBytes(StandardCharsets.UTF_8)) {
            @Override
            public String getFilename() {
                return "statement.csv";
            }
        };
    }

    private HttpHeaders authHeaders(String token) {
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(token);
        return headers;
    }

    private JsonNode getJson(String token, String url) throws Exception {
        ResponseEntity<String> response = rest.exchange(url,
                org.springframework.http.HttpMethod.GET,
                new HttpEntity<>(authHeaders(token)), String.class);
        assertEquals(HttpStatus.OK, response.getStatusCode(), url);
        return objectMapper.readTree(response.getBody());
    }

    private ResponseEntity<String> exchange(String token, String url, Map<String, Object> body) {
        HttpHeaders headers = authHeaders(token);
        headers.setContentType(MediaType.APPLICATION_JSON);
        return rest.postForEntity(url, new HttpEntity<>(body, headers), String.class);
    }

    private static JsonNode findByDescription(JsonNode transactions, String needle) {
        for (JsonNode t : transactions) {
            if (t.get("description").asText().contains(needle)) return t;
        }
        throw new AssertionError("No transaction containing: " + needle);
    }
}
