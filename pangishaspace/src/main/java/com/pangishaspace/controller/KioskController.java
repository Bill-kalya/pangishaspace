package com.pangishaspace.controller;

import com.pangishaspace.dto.KioskLocationDTO;
import com.pangishaspace.service.KioskService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/kiosks")
public class KioskController {

    private final KioskService kioskService;

    public KioskController(KioskService kioskService) {
        this.kioskService = kioskService;
    }

    @GetMapping("/nearby")
    public List<KioskLocationDTO> nearby(
            @RequestParam double lat,
            @RequestParam double lng,
            @RequestParam(defaultValue = "2000") double radius
    ) {
        return kioskService.findNearby(lat, lng, radius);
    }
}
