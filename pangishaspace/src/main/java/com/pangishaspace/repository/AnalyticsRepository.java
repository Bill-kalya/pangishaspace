package com.pangishaspace.repository;

import com.pangishaspace.dto.HeatmapPointDTO;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.Repository;

import java.util.List;

public interface AnalyticsRepository extends Repository<Object, Long> {

    @Query(value = """
        SELECT
          ST_Y(cell) AS latitude,
          ST_X(cell) AS longitude,
          COUNT(*) AS intensity
        FROM (
          SELECT ST_SnapToGrid(location::geometry, 0.002, 0.002) AS cell
          FROM kiosks
          WHERE status = 'ACTIVE'
        ) t
        GROUP BY cell
        """, nativeQuery = true)
    List<Object[]> kioskDensity();
}
