package com.miser.moneyTracker.merchant.repository;

import com.miser.moneyTracker.merchant.entity.Merchant;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface MerchantRepository extends JpaRepository<Merchant, Long> {
    Optional<Merchant> findByNormalizedName(String normalizedName);
}
