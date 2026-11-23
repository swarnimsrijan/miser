package com.miser.moneyTracker.merchant;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface MerchantRepository extends JpaRepository<Merchant, Long> {
    Optional<Merchant> findByNormalizedName(String normalizedName);
}
