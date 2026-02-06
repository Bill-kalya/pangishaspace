package com.pangishaspace.repository;

import com.pangishaspace.model.Kiosk;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.UUID;

public interface KioskRepository extends JpaRepository<Kiosk, UUID> {

    @Query(value = """
        SELECT * FROM kiosks
        WHERE ST_DWithin(
            location,
            ST_MakePoint(:lng, :lat)::geography,
            :radius
        )
        """, nativeQuery = true)
    List<Kiosk> findNearby(
            @Param("lat") double lat,
            @Param("lng") double lng,
            @Param("radius") double radiusMeters
    );

    @Query(value = """
        SELECT
          ST_SnapToGrid(location::geometry, 0.002, 0.002) AS cell,
          COUNT(*) AS density
        FROM kiosks
        WHERE status = 'ACTIVE'
        GROUP BY cell
        """, nativeQuery = true)
    List<Object[]> findKioskDensityHeatmap();

    @Query(value = """
        SELECT
          ST_SnapToGrid(location::geometry, 0.002, 0.002) AS cell,
          COUNT(*) AS illegal_count
        FROM kiosks
        WHERE status = 'ILLEGAL'
        GROUP BY cell
        HAVING COUNT(*) > 3
        """, nativeQuery = true)
    List<Object[]> findIllegalKioskHotspots();
}
