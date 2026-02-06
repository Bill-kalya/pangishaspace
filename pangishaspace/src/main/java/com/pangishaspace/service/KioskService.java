package com.pangishaspace.service;

import com.pangishaspace.dto.KioskLocationDTO;
import com.pangishaspace.model.Kiosk;
import com.pangishaspace.model.Vendor;
import com.pangishaspace.repository.KioskRepository;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.geom.Coordinate;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class KioskService {

    private final KioskRepository kioskRepository;
    private final GeometryFactory geometryFactory = new GeometryFactory();

    public KioskService(KioskRepository kioskRepository) {
        this.kioskRepository = kioskRepository;
    }

    public Kiosk createKiosk(
            Vendor vendor,
            String kioskName,
            double latitude,
            double longitude,
            String county,
            String street
    ) {
        Point location = geometryFactory.createPoint(
                new Coordinate(longitude, latitude)
        );
        location.setSRID(4326);

        Kiosk kiosk = new Kiosk();
        kiosk.setVendor(vendor);
        kiosk.setKioskName(kioskName);
        kiosk.setCounty(county);
        kiosk.setTown(street);
        kiosk.setLocation(location);

        return kioskRepository.save(kiosk);
    }

    public List<KioskLocationDTO> findNearby(double lat, double lng, double radius) {
        List<Kiosk> kiosks = kioskRepository.findNearby(lat, lng, radius);
        return kiosks.stream()
                .map(kiosk -> new KioskLocationDTO(
                        kiosk.getId(),
                        kiosk.getKioskName(),
                        kiosk.getLocation().getY(),
                        kiosk.getLocation().getX()
                ))
                .toList();
    }
}
