package com.pangishaspace.controller;

import com.pangishaspace.model.User;
import com.pangishaspace.model.Vendor;
import com.pangishaspace.service.AdminService;
import com.pangishaspace.service.VendorService;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/admin")
@CrossOrigin
public class AdminController {

    private final VendorService vendorService;
    private final AdminService adminService;

    public AdminController(VendorService vendorService,
                           AdminService adminService) {
        this.vendorService = vendorService;
        this.adminService = adminService;
    }

    @PostMapping("/vendors/{vendorId}/approve")
    public Vendor approveVendor(@PathVariable UUID vendorId,
                                @RequestBody User admin) {

        Vendor vendor = vendorService.findById(vendorId);
        Vendor approved = vendorService.approveVendor(vendor);

        adminService.logAction(
                admin,
                "APPROVE_VENDOR",
                "vendors",
                vendorId
        );

        return approved;
    }
}
