package com.miser.moneyTracker.creditcard.repository;

import com.miser.moneyTracker.creditcard.entity.CreditCard;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface CreditCardRepository extends JpaRepository<CreditCard, Long> {
    List<CreditCard> findByUserId(Long userId);
}
