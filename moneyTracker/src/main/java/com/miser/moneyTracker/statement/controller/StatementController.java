package com.miser.moneyTracker.statement.controller;

import com.miser.moneyTracker.statement.entity.Statement;
import com.miser.moneyTracker.statement.service.StatementService;
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
    public Statement upload(@RequestParam("file") MultipartFile file,
                            @RequestParam(required = false) Long accountId,
                            @RequestParam(required = false) Long creditCardId) {
        return statementService.upload(file, accountId, creditCardId);
    }

    @GetMapping
    public List<Statement> getAll() {
        return statementService.getAllForCurrentUser();
    }
}
