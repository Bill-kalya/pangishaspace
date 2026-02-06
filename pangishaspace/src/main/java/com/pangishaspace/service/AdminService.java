package com.pangishaspace.service;

import com.pangishaspace.model.AuditLog;
import com.pangishaspace.model.User;
import com.pangishaspace.repository.AuditLogRepository;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class AdminService {

    private final AuditLogRepository auditLogRepository;

    public AdminService(AuditLogRepository auditLogRepository) {
        this.auditLogRepository = auditLogRepository;
    }

    public void logAction(User admin,
                          String action,
                          String targetTable,
                          UUID targetId) {

        AuditLog log = new AuditLog();
        log.setAdmin(admin);
        log.setAction(action);
        log.setTargetTable(targetTable);
        log.setTargetId(targetId);

        auditLogRepository.save(log);
    }
}
