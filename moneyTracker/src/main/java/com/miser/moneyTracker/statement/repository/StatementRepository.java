package com.miser.moneyTracker.statement.repository;

import com.miser.moneyTracker.statement.entity.Statement;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface StatementRepository extends JpaRepository<Statement, Long> {
    List<Statement> findByUserId(Long userId);
    boolean existsByChecksum(String checksum);
}
