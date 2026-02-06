package com.pangishaspace.service;

import com.pangishaspace.dto.HeatmapPointDTO;
import com.pangishaspace.repository.AnalyticsRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AnalyticsService {

    private final AnalyticsRepository repo;

    public AnalyticsService(AnalyticsRepository repo) {
        this.repo = repo;
    }

    public List<HeatmapPointDTO> kioskHeatmap() {
        return repo.kioskDensity()
                .stream()
                .map(r -> new HeatmapPointDTO(
                        ((Number) r[0]).doubleValue(),
                        ((Number) r[1]).doubleValue(),
                        ((Number) r[2]).longValue()
                ))
                .toList();
    }
}
