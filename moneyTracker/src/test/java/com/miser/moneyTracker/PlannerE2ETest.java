package com.miser.moneyTracker;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.resttestclient.TestRestTemplate;
import org.springframework.boot.resttestclient.autoconfigure.AutoConfigureTestRestTemplate;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.*;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import tools.jackson.databind.JsonNode;
import tools.jackson.databind.ObjectMapper;

import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Planning features against real Postgres: card-payment reconciliation,
 * recurring detection, budgets, goals, what-if and tips.
 */
@Import({TestcontainersConfiguration.class, TestJwtConfiguration.class})
@AutoConfigureTestRestTemplate
@SpringBootTest(
        webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT,
        properties = "app.upload-dir=${java.io.tmpdir}/moneytracker-test-uploads")
class PlannerE2ETest {

    private static final String BANK_CSV = """
            Date,Narration,Withdrawal Amt.,Deposit Amt.,Closing Balance
            01/01/2025,ACME CORP SALARY JAN,,"100,000.00","100,000.00"
            05/01/2025,NETFLIX SUBSCRIPTION,649.00,,"99,351.00"
            10/01/2025,UPI-SWIGGY-swiggy@icici,"2,000.00",,"97,351.00"
            01/02/2025,ACME CORP SALARY FEB,,"100,000.00","197,351.00"
            05/02/2025,NETFLIX SUBSCRIPTION,649.00,,"196,702.00"
            12/02/2025,UPI-SWIGGY-swiggy@icici,"2,500.00",,"194,202.00"
            01/03/2025,ACME CORP SALARY MAR,,"100,000.00","294,202.00"
            05/03/2025,NETFLIX SUBSCRIPTION,649.00,,"293,553.00"
            14/03/2025,UPI-SWIGGY-swiggy@icici,"9,000.00",,"284,553.00"
            20/03/2025,CC PAYMENT HDFC CARD XX1234,"5,000.00",,"279,553.00"
            """;

    private static final String CARD_CSV = """
            Date,Description,Amount
            02/03/2025,AMAZON PAY,"3,000.00"
            08/03/2025,UBER INDIA,"2,000.00"
            22/03/2025,PAYMENT RECEIVED - THANK YOU,"-5,000.00"
            """;

    @Autowired private TestRestTemplate rest;
    @Autowired private ObjectMapper objectMapper;

    @Test
    void planningFlow() throws Exception {
        String token = TestJwtConfiguration.token("kc-planner", "planner@test.com", "Planner");
        long bankId = get(token, "/api/banks").get(0).get("id").asLong();
        long accountId = post(token, "/api/accounts", Map.of("bankId", bankId, "nickname", "Main",
                "accountType", "SAVINGS", "currency", "INR")).get("id").asLong();
        long cardId = post(token, "/api/credit-cards", Map.of("bankId", bankId, "cardName", "Regalia",
                "currency", "INR")).get("id").asLong();

        upload(token, "accountId", accountId, "bank.csv", BANK_CSV);
        JsonNode cardStatement = upload(token, "creditCardId", cardId, "card.csv", CARD_CSV);
        assertEquals(3, cardStatement.get("transactionCount").asLong());

        // --- reconciliation: the bill payment shows on both statements, counted once ---
        JsonNode all = get(token, "/api/transactions?size=100").get("content");
        List<JsonNode> transfers = new java.util.ArrayList<>();
        all.forEach(t -> { if (t.get("transfer").asBoolean()) transfers.add(t); });
        assertEquals(2, transfers.size(), "bank debit + card credit should be linked");
        JsonNode march = get(token, "/api/dashboard/summary?from=2025-03-01&to=2025-03-31");
        // 649 + 9000 (bank) + 3000 + 2000 (card); the 5000 payment is not spend
        assertEquals(0, new BigDecimal("14649.00").compareTo(march.get("totalExpense").decimalValue()));
        assertEquals(0, new BigDecimal("100000.00").compareTo(march.get("totalIncome").decimalValue()));

        // --- recurring ---
        JsonNode recurring = get(token, "/api/insights/recurring");
        JsonNode netflix = find(recurring, "name", "Netflix");
        assertEquals("MONTHLY", netflix.get("frequency").asText());
        assertEquals(3, netflix.get("occurrences").asInt());

        // --- budgets ---
        long foodId = categoryId(token, "Food");
        put(token, "/api/budgets/" + foodId, Map.of("monthlyLimit", 5000, "alertThresholdPercent", 80));
        JsonNode status = get(token, "/api/budgets/status?month=2025-03");
        JsonNode food = find(status, "category", "Food");
        assertEquals("EXCEEDED", food.get("status").asText());
        assertEquals(0, new BigDecimal("9000.00").compareTo(food.get("spent").decimalValue()));

        // --- goals ---
        JsonNode goal = post(token, "/api/goals", Map.of("name", "Emergency fund",
                "targetAmount", 300000, "targetDate", "2030-12-31", "priority", 1));
        long goalId = goal.get("id").asLong();
        assertNotNull(goal.get("projectedCompletion").asText(null));
        JsonNode contributed = post(token, "/api/goals/" + goalId + "/contributions", Map.of("amount", 50000));
        assertEquals(0, new BigDecimal("50000.00").compareTo(contributed.get("savedAmount").decimalValue()));

        // --- what-if: halve food spend -> more savings each month ---
        JsonNode whatIf = post(token, "/api/planner/what-if", Map.of("months", 6,
                "categoryChanges", List.of(Map.of("categoryId", foodId, "changePercent", -50))));
        assertTrue(whatIf.get("monthlySavingsDelta").decimalValue().signum() > 0);
        assertEquals(6, whatIf.get("scenario").get("months").size());
        assertEquals(1, whatIf.get("goals").size());

        // --- tips include the blown budget ---
        JsonNode tips = get(token, "/api/insights/tips");
        assertNotNull(find(tips, "type", "BUDGET"));

        // --- deleting the card statement releases the bank-side transfer ---
        long cardStatementId = cardStatement.get("id").asLong();
        HttpHeaders headers = auth(token);
        assertEquals(HttpStatus.NO_CONTENT, rest.exchange("/api/statements/" + cardStatementId,
                HttpMethod.DELETE, new HttpEntity<>(headers), String.class).getStatusCode());
        JsonNode remaining = get(token, "/api/transactions?size=100").get("content");
        assertEquals(10, remaining.size());
        remaining.forEach(t -> assertFalse(t.get("transfer").asBoolean()));

        // other users cannot see this user's data
        String other = TestJwtConfiguration.token("kc-other", "other@test.com", "Other");
        assertEquals(0, get(other, "/api/transactions").get("content").size());
        assertEquals(0, get(other, "/api/goals").size());
    }

    // --- helpers ---

    private long categoryId(String token, String name) throws Exception {
        for (JsonNode c : get(token, "/api/categories")) {
            if (c.get("name").asText().equals(name)) return c.get("id").asLong();
        }
        throw new AssertionError("category " + name);
    }

    private static JsonNode find(JsonNode array, String field, String contains) {
        for (JsonNode n : array) {
            if (n.get(field).asText().contains(contains)) return n;
        }
        throw new AssertionError("No element with " + field + " containing " + contains + " in " + array);
    }

    private JsonNode upload(String token, String targetField, long targetId, String filename, String content)
            throws Exception {
        HttpHeaders headers = auth(token);
        headers.setContentType(MediaType.MULTIPART_FORM_DATA);
        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        body.add("file", new ByteArrayResource(content.getBytes(StandardCharsets.UTF_8)) {
            @Override public String getFilename() { return filename; }
        });
        body.add(targetField, String.valueOf(targetId));
        ResponseEntity<String> response = rest.postForEntity("/api/statements/upload",
                new HttpEntity<>(body, headers), String.class);
        assertEquals(HttpStatus.CREATED, response.getStatusCode(), response.getBody());
        return objectMapper.readTree(response.getBody());
    }

    private JsonNode get(String token, String url) throws Exception {
        ResponseEntity<String> r = rest.exchange(url, HttpMethod.GET, new HttpEntity<>(auth(token)), String.class);
        assertEquals(HttpStatus.OK, r.getStatusCode(), url + " -> " + r.getBody());
        return objectMapper.readTree(r.getBody());
    }

    private JsonNode post(String token, String url, Object body) throws Exception {
        return send(token, url, HttpMethod.POST, body);
    }

    private JsonNode put(String token, String url, Object body) throws Exception {
        return send(token, url, HttpMethod.PUT, body);
    }

    private JsonNode send(String token, String url, HttpMethod method, Object body) throws Exception {
        HttpHeaders headers = auth(token);
        headers.setContentType(MediaType.APPLICATION_JSON);
        ResponseEntity<String> r = rest.exchange(url, method, new HttpEntity<>(body, headers), String.class);
        assertTrue(r.getStatusCode().is2xxSuccessful(), url + " -> " + r.getStatusCode() + " " + r.getBody());
        return objectMapper.readTree(r.getBody());
    }

    private static HttpHeaders auth(String token) {
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(token);
        return headers;
    }
}
