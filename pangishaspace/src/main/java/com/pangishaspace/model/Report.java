package com.pangishaspace.model;

import jakarta.persistence.*;
import org.locationtech.jts.geom.Point;
import java.util.UUID;

@Entity
@Table(name = "reports")
public class Report {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "reporter_id")
    private User reporter;

    private String description;

    private String photoUrl;

    @Column(columnDefinition = "geometry(Point,4326)")
    private Point location;

    // ===== GETTERS & SETTERS =====

    public UUID getId() {
        return id;
    }

    public User getReporter() {
        return reporter;
    }

    public void setReporter(User reporter) {
        this.reporter = reporter;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPhotoUrl() {
        return photoUrl;
    }

    public void setPhotoUrl(String photoUrl) {
        this.photoUrl = photoUrl;
    }

    public Point getLocation() {
        return location;
    }

    public void setLocation(Point location) {
        this.location = location;
    }
}
