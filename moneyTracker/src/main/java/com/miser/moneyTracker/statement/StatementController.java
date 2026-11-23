package com.miser.moneyTracker.statement;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.util.List;

@RestController
@RequestMapping("/api/statements")
@RequiredArgsConstructor
public class StatementController {

    private final StatementService statementService;

    @PostMapping("/upload")
    @ResponseStatus(HttpStatus.CREATED)
    /**
     * Multipart upload. {@code password} (for encrypted PDF/XLSX statements) must
     * be sent as a multipart form field: query strings end up in access logs,
     * so a password in the URL is rejected.
     */
    public StatementResponse upload(@RequestParam("file") MultipartFile file,
                                    @RequestParam(required = false) Long accountId,
                                    @RequestParam(required = false) Long creditCardId,
                                    @RequestParam(required = false) String password,
                                    HttpServletRequest request) {
        String query = request.getQueryString();
        if (query != null && query.matches("(?i)(^|.*&)password=.*")) {
            throw new IllegalArgumentException(
                    "Send the statement password as a form field, not in the URL");
        }
        return statementService.upload(file, accountId, creditCardId, password);
    }

    @GetMapping
    public List<StatementResponse> getAll() {
        return statementService.getAllForCurrentUser();
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable Long id) {
        statementService.delete(id);
    }
}
