package com.pangishaspace.controller;

import com.pangishaspace.dto.HeatmapPointDTO;
import com.pangishaspace.service.AnalyticsService;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admin/analytics")
public class AnalyticsController {

    private final AnalyticsService service;

    public AnalyticsController(AnalyticsService service) {
        this.service = service;
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/kiosk-heatmap")
    public List<HeatmapPointDTO> heatmap() {
        return service.kioskHeatmap();
    }
}
