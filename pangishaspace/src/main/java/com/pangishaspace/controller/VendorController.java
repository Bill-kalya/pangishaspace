package com.pangishaspace.controller;

import com.pangishaspace.model.Kiosk;
import com.pangishaspace.model.User;
import com.pangishaspace.model.Vendor;
import com.pangishaspace.service.KioskService;
import com.pangishaspace.service.VendorService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/vendors")
@CrossOrigin
public class VendorController {

    private final VendorService vendorService;
    private final KioskService kioskService;

    public VendorController(VendorService vendorService,
                            KioskService kioskService) {
        this.vendorService = vendorService;
        this.kioskService = kioskService;
    }

    @PostMapping("/profile")
    public Vendor createVendor(@RequestBody VendorRequest request) {

        return vendorService.createVendorProfile(
                request.user(),
                request.businessName(),
                request.nationalId(),
                request.kraPin()
        );
    }

    @PostMapping("/kiosks")
    public Kiosk createKiosk(@RequestBody KioskRequest request) {

        return kioskService.createKiosk(
                request.vendor(),
                request.kioskName(),
                request.latitude(),
                request.longitude(),
                request.county(),
                request.town()
        );
    }

    // DTOs
    public record VendorRequest(
            User user,
            String businessName,
            String nationalId,
            String kraPin
    ) {}

    public record KioskRequest(
            Vendor vendor,
            String kioskName,
            double latitude,
            double longitude,
            String county,
            String town
    ) {}
}
