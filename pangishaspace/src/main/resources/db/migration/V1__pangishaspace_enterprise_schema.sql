-- =====================================================
-- PangishaSpace Enterprise Database Schema
-- PostgreSQL 16 + PostGIS 3.6
-- =====================================================

BEGIN;

-- -----------------------------------------------------
-- Enable Extensions
-- -----------------------------------------------------
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS pgcrypto; -- for UUIDs / password hashing

-- -----------------------------------------------------
-- USERS & ROLES (AUTHENTICATION / AUTHORIZATION)
-- -----------------------------------------------------

CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT
);

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(30) UNIQUE,
    password_hash TEXT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_roles (
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    role_id INT REFERENCES roles(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, role_id)
);

-- -----------------------------------------------------
-- VENDOR PROFILE (EXTENDS USER)
-- -----------------------------------------------------

CREATE TABLE vendors (
    id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    business_name VARCHAR(200) NOT NULL,
    national_id VARCHAR(50),
    kra_pin VARCHAR(50),
    status VARCHAR(30) DEFAULT 'PENDING', -- PENDING | APPROVED | REJECTED
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------------------
-- KIOSKS (SPATIAL DATA)
-- -----------------------------------------------------

CREATE TABLE kiosks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vendor_id UUID REFERENCES vendors(id) ON DELETE SET NULL,
    kiosk_name VARCHAR(200),
    location GEOGRAPHY(Point, 4326) NOT NULL,
    county VARCHAR(100),
    town VARCHAR(100),
    status VARCHAR(30) DEFAULT 'ACTIVE', -- ACTIVE | REMOVED | ILLEGAL
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Spatial index for fast map / distance queries
CREATE INDEX idx_kiosks_location ON kiosks USING GIST (location);

-- -----------------------------------------------------
-- DOCUMENTS (VERIFICATION FILES)
-- -----------------------------------------------------

CREATE TABLE documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vendor_id UUID REFERENCES vendors(id) ON DELETE CASCADE,
    document_type VARCHAR(100), -- ID, Permit, License
    file_url TEXT NOT NULL,
    verification_status VARCHAR(30) DEFAULT 'PENDING', -- PENDING | APPROVED | REJECTED
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    verified_at TIMESTAMP
);

-- -----------------------------------------------------
-- PUBLIC REPORTS (ILLEGAL KIOSKS)
-- -----------------------------------------------------

CREATE TABLE reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reporter_id UUID REFERENCES users(id) ON DELETE SET NULL,
    description TEXT,
    photo_url TEXT,
    location GEOGRAPHY(Point, 4326),
    status VARCHAR(30) DEFAULT 'OPEN', -- OPEN | UNDER_REVIEW | RESOLVED
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_reports_location ON reports USING GIST (location);

-- -----------------------------------------------------
-- ADMIN ACTION LOGS (AUDIT TRAIL)
-- -----------------------------------------------------

CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    admin_id UUID REFERENCES users(id),
    action VARCHAR(200),
    target_table VARCHAR(100),
    target_id UUID,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------------------
-- SEED ROLES
-- -----------------------------------------------------

INSERT INTO roles (name, description) VALUES
('ADMIN', 'System administrator'),
('VENDOR', 'Registered kiosk vendor'),
('PUBLIC', 'Public reporter');

COMMIT;
