package com.pangishaspace.service;

import com.pangishaspace.model.User;
import com.pangishaspace.model.Vendor;
import com.pangishaspace.repository.VendorRepository;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class VendorService {

    private final VendorRepository vendorRepository;

    public VendorService(VendorRepository vendorRepository) {
        this.vendorRepository = vendorRepository;
    }

    public Vendor findById(UUID id) {
        return vendorRepository.findById(id).orElse(null);
    }

    public Vendor createVendorProfile(
            User user,
            String businessName,
            String nationalId,
            String kraPin
    ) {
        Vendor vendor = new Vendor();
        vendor.setUser(user);
        vendor.setBusinessName(businessName);
        vendor.setNationalId(nationalId);
        vendor.setKraPin(kraPin);
        vendor.setStatus("PENDING");

        return vendorRepository.save(vendor);
    }

    public Vendor approveVendor(Vendor vendor) {
        vendor.setStatus("APPROVED");
        return vendorRepository.save(vendor);
    }

    public Vendor rejectVendor(Vendor vendor) {
        vendor.setStatus("REJECTED");
        return vendorRepository.save(vendor);
    }
}
