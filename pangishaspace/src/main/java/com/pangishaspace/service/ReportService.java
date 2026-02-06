package com.pangishaspace.service;

import com.pangishaspace.model.Report;
import com.pangishaspace.model.User;
import com.pangishaspace.repository.ReportRepository;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ReportService {

    private final ReportRepository reportRepository;
    private final GeometryFactory geometryFactory = new GeometryFactory();

    public ReportService(ReportRepository reportRepository) {
        this.reportRepository = reportRepository;
    }

    public Report submitReport(User reporter,
                               String description,
                               String photoUrl,
                               double latitude,
                               double longitude) {

        Point location = geometryFactory.createPoint(
                new org.locationtech.jts.geom.Coordinate(longitude, latitude)
        );
        location.setSRID(4326);

        Report report = new Report();
        report.setReporter(reporter);
        report.setDescription(description);
        report.setPhotoUrl(photoUrl);
        report.setLocation(location);

        return reportRepository.save(report);
    }

    public List<Report> getOpenReports() {
        return reportRepository.findOpenReports();
    }
}
