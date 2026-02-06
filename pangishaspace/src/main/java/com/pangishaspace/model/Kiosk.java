package com.pangishaspace.model;

import jakarta.persistence.*;
import org.locationtech.jts.geom.Point;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "kiosks")
public class Kiosk {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vendor_id", nullable = false)
    private Vendor vendor;

    @Column(nullable = false)
    private String kioskName;

    @Column(nullable = false)
    private String county;

    @Column(nullable = false)
    private String town;

    @Column(length = 255)
    private String street;

    @Column(columnDefinition = "geography(Point,4326)", nullable = false)
    private Point location;

    @Column(nullable = false)
    private String status = "ACTIVE";

    @Column(nullable = false)
    private final LocalDateTime createdAt = LocalDateTime.now();

    // ===== Getters & Setters =====

    public UUID getId() {
        return id;
    }

    public Vendor getVendor() {
        return vendor;
    }

    public void setVendor(Vendor vendor) {
        this.vendor = vendor;
    }

    public String getKioskName() {
        return kioskName;
    }

    public void setKioskName(String kioskName) {
        this.kioskName = kioskName;
    }

    public String getCounty() {
        return county;
    }

    public void setCounty(String county) {
        this.county = county;
    }

    public String getTown() {
        return town;
    }

    public void setTown(String town) {
        this.town = town;
    }

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public Point getLocation() {
        return location;
    }

    public void setLocation(Point location) {
        this.location = location;
    }

    public String getStatus() {
        return status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
}
