package com.pangishaspace.dto;

public record HeatmapPointDTO(
        double latitude,
        double longitude,
        long intensity
) {}
