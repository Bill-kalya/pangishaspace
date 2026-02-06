package com.pangishaspace.dto;

import java.util.UUID;

public record KioskLocationDTO(
        UUID id,
        String name,
        double latitude,
        double longitude
) {}
