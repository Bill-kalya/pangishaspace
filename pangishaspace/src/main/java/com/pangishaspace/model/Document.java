package com.pangishaspace.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "documents")
public class Document {

    @Id
    @GeneratedValue
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "vendor_id")
    private Vendor vendor;

    private String documentType;
    private String fileUrl;

    private String verificationStatus = "PENDING";

    private LocalDateTime uploadedAt = LocalDateTime.now();
    private LocalDateTime verifiedAt;

    // getters & setters
}
