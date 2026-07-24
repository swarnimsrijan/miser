package com.miser.moneyTracker.report.controller;

import com.miser.moneyTracker.report.service.ReportService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/reports")
@RequiredArgsConstructor
public class ReportController {

    private final ReportService reportService;

    @GetMapping("/pdf")
    public ResponseEntity<byte[]> pdf() {
        // TODO: implement PDF export
        return ResponseEntity.ok().build();
    }

    @GetMapping("/excel")
    public ResponseEntity<byte[]> excel() {
        // TODO: implement Excel export
        return ResponseEntity.ok().build();
    }

    @GetMapping("/csv")
    public ResponseEntity<byte[]> csv() {
        // TODO: implement CSV export
        return ResponseEntity.ok().build();
    }
}
