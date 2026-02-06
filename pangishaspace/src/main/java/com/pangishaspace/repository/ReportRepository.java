package com.pangishaspace.repository;

import com.pangishaspace.model.Report;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.UUID;

public interface ReportRepository extends JpaRepository<Report, UUID> {

    @Query(value = """
        SELECT * FROM reports
        WHERE status = 'OPEN'
        """, nativeQuery = true)
    List<Report> findOpenReports();
}
