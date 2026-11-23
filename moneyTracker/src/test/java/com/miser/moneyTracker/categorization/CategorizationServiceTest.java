package com.miser.moneyTracker.categorization;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;

class CategorizationServiceTest {

    @Test
    void extractsMerchantFromUpiNarration() {
        assertEquals("swiggy",
                CategorizationService.extractMerchantName("upi-swiggy-swiggy@icici-402935"));
    }

    @Test
    void extractsMerchantFromPosNarration() {
        assertEquals("big bazaar mumbai",
                CategorizationService.extractMerchantName("pos 411111 big bazaar mumbai"));
    }

    @Test
    void skipsRailKeywordsAndNumbers() {
        assertEquals("john doe",
                CategorizationService.extractMerchantName("neft/hdfc0001234/john doe/salary"));
    }

    @Test
    void returnsNullForUnusableNarrations() {
        assertNull(CategorizationService.extractMerchantName("1234567890"));
        assertNull(CategorizationService.extractMerchantName(""));
        assertNull(CategorizationService.extractMerchantName(null));
    }
}
