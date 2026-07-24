package com.miser.moneyTracker.bank.repository;

import com.miser.moneyTracker.bank.entity.Bank;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BankRepository extends JpaRepository<Bank, Long> {
}
