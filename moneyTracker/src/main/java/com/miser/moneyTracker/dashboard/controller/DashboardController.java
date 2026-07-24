package com.miser.moneyTracker.dashboard.controller;

import com.miser.moneyTracker.dashboard.service.DashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/api/dashboard")
@RequiredArgsConstructor
public class DashboardController {

    private final DashboardService dashboardService;

    @GetMapping("/summary")
    public Map<String, Object> summary() {
        return dashboardService.getSummary();
    }

    @GetMapping("/category")
    public Map<String, Object> byCategory() {
        return dashboardService.getByCategory();
    }

    @GetMapping("/monthly")
    public Map<String, Object> monthly() {
        return dashboardService.getMonthly();
    }

    @GetMapping("/merchant")
    public Map<String, Object> byMerchant() {
        return dashboardService.getByMerchant();
    }

    @GetMapping("/networth")
    public Map<String, Object> networth() {
        return dashboardService.getNetworth();
    }

    @GetMapping("/cashflow")
    public Map<String, Object> cashflow() {
        return dashboardService.getCashflow();
    }
}
