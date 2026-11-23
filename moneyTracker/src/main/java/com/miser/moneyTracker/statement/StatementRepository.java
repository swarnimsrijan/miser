package com.miser.moneyTracker.statement;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface StatementRepository extends JpaRepository<Statement, Long> {
    List<Statement> findByUserIdOrderByUploadedAtDesc(Long userId);
    /** Failed uploads (e.g. missing password) must not block a retry of the same file. */
    boolean existsByUserIdAndChecksumAndStatusNot(Long userId, String checksum, String status);
}
