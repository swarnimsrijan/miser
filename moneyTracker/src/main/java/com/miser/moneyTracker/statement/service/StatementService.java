package com.miser.moneyTracker.statement.service;

import com.miser.moneyTracker.statement.entity.Statement;
import com.miser.moneyTracker.statement.entity.StatementType;
import com.miser.moneyTracker.statement.repository.StatementRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.util.List;

@Service
@RequiredArgsConstructor
public class StatementService {

    private final StatementRepository statementRepository;

    public Statement upload(MultipartFile file, Long accountId, Long creditCardId) {
        String filename = file.getOriginalFilename();
        StatementType type = detectType(filename);

        Statement statement = Statement.builder()
                .statementType(type)
                .fileUrl("/uploads/" + filename)
                .status("PENDING")
                .build();
        // TODO: set user, account/creditCard, compute checksum, trigger parsing
        return statementRepository.save(statement);
    }

    public List<Statement> getAllForCurrentUser() {
        // TODO: filter by current user
        return statementRepository.findAll();
    }

    private StatementType detectType(String filename) {
        if (filename == null) return StatementType.CSV;
        String lower = filename.toLowerCase();
        if (lower.endsWith(".pdf")) return StatementType.PDF;
        if (lower.endsWith(".xlsx") || lower.endsWith(".xls")) return StatementType.XLSX;
        return StatementType.CSV;
    }
}
