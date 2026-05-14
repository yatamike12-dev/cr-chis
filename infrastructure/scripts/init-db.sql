-- infrastructure/scripts/init-db.sql

-- Enable PostGIS for geographic data
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================
-- USERS & RBAC
-- ============================================================

CREATE TYPE user_role AS ENUM (
  'bhw',           -- Community Health Worker (field)
  'supervisor',    -- Supervises a cluster of BHWs
  'county_officer',-- County Health Officer
  'state_official',-- State Ministry of Health
  'partner',       -- UNICEF / NGO partner
  'national_moh',  -- National Ministry of Health
  'admin'          -- System administrator
);

CREATE TABLE users (
  id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email         VARCHAR(255) UNIQUE NOT NULL,
  phone         VARCHAR(20),
  password_hash VARCHAR(255) NOT NULL,
  full_name     VARCHAR(255) NOT NULL,
  role          user_role NOT NULL DEFAULT 'bhw',
  county_id     UUID,
  state_id      UUID,
  is_active     BOOLEAN DEFAULT true,
  last_login_at TIMESTAMPTZ,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- GEOGRAPHIC ENTITIES
-- ============================================================

CREATE TABLE states (
  id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name       VARCHAR(100) NOT NULL,
  code       VARCHAR(10) UNIQUE NOT NULL,
  geom       GEOMETRY(MULTIPOLYGON, 4326),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE counties (
  id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  state_id   UUID REFERENCES states(id),
  name       VARCHAR(100) NOT NULL,
  code       VARCHAR(10) UNIQUE NOT NULL,
  geom       GEOMETRY(MULTIPOLYGON, 4326),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE communities (
  id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  county_id  UUID REFERENCES counties(id),
  name       VARCHAR(100) NOT NULL,
  location   GEOMETRY(POINT, 4326),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- HOUSEHOLDS
-- ============================================================

CREATE TABLE households (
  id                UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  bhw_id            UUID REFERENCES users(id),
  county_id         UUID REFERENCES counties(id),
  community_id      UUID REFERENCES communities(id),

  -- Identification
  household_code    VARCHAR(50) UNIQUE NOT NULL,
  head_of_household VARCHAR(255) NOT NULL,
  phone             VARCHAR(20),

  -- Location
  gps_location      GEOMETRY(POINT, 4326),
  address           TEXT,
  landmark          VARCHAR(255),

  -- Vulnerability indicators
  has_disability    BOOLEAN DEFAULT false,
  is_food_insecure  BOOLEAN DEFAULT false,
  water_source      VARCHAR(50),  -- piped, borehole, river, rainwater
  latrine_type      VARCHAR(50),  -- none, pit, VIP, flush
  roofing_material  VARCHAR(50),  -- thatch, iron_sheet, concrete

  -- Status
  risk_score        NUMERIC(5,2) DEFAULT 0,
  sync_status       VARCHAR(20) DEFAULT 'synced',  -- synced, pending, conflict
  created_offline   BOOLEAN DEFAULT false,
  local_id          VARCHAR(100),  -- UUID assigned offline on device

  created_at        TIMESTAMPTZ DEFAULT NOW(),
  updated_at        TIMESTAMPTZ DEFAULT NOW(),
  deleted_at        TIMESTAMPTZ  -- soft delete
);

CREATE INDEX idx_households_gps ON households USING GIST(gps_location);
CREATE INDEX idx_households_county ON households(county_id);
CREATE INDEX idx_households_bhw ON households(bhw_id);

-- ============================================================
-- FAMILY MEMBERS
-- ============================================================

CREATE TABLE family_members (
  id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  household_id  UUID REFERENCES households(id) ON DELETE CASCADE,

  full_name     VARCHAR(255) NOT NULL,
  date_of_birth DATE,
  sex           VARCHAR(10),  -- male, female, other
  relationship  VARCHAR(50),  -- head, spouse, child, other

  -- Health indicators
  is_pregnant       BOOLEAN DEFAULT false,
  is_under_five     BOOLEAN DEFAULT false,
  is_malnourished   BOOLEAN DEFAULT false,
  immunization_status VARCHAR(30),  -- up_to_date, incomplete, zero_dose, unknown
  muac_cm           NUMERIC(5,2),  -- Mid-upper arm circumference (nutrition)
  has_chronic_disease BOOLEAN DEFAULT false,
  chronic_disease_notes TEXT,

  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- HEALTH VISITS
-- ============================================================

CREATE TABLE health_visits (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  household_id    UUID REFERENCES households(id),
  bhw_id          UUID REFERENCES users(id),
  visit_date      DATE NOT NULL,
  visit_type      VARCHAR(50),  -- routine, referral_followup, alert_response

  -- Climate observations
  flood_risk_observed    BOOLEAN DEFAULT false,
  stagnant_water_nearby  BOOLEAN DEFAULT false,
  unusual_illness_noted  BOOLEAN DEFAULT false,
  notes                  TEXT,

  -- Sync
  local_id        VARCHAR(100),
  sync_status     VARCHAR(20) DEFAULT 'synced',

  created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- SYNC QUEUE
-- ============================================================

CREATE TABLE sync_queue (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  device_id       VARCHAR(100) NOT NULL,
  user_id         UUID REFERENCES users(id),
  entity_type     VARCHAR(50) NOT NULL,  -- household, family_member, health_visit
  entity_local_id VARCHAR(100) NOT NULL,
  payload         JSONB NOT NULL,
  operation       VARCHAR(20) NOT NULL,  -- create, update, delete
  status          VARCHAR(20) DEFAULT 'pending',  -- pending, processing, synced, failed
  retry_count     INTEGER DEFAULT 0,
  error_message   TEXT,
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  synced_at       TIMESTAMPTZ
);

CREATE INDEX idx_sync_queue_status ON sync_queue(status, created_at);

-- ============================================================
-- ALERTS
-- ============================================================

CREATE TYPE alert_severity AS ENUM ('low', 'medium', 'high', 'critical');
CREATE TYPE alert_status AS ENUM ('active', 'acknowledged', 'resolved');

CREATE TABLE alert_rules (
  id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name          VARCHAR(100) NOT NULL,
  category      VARCHAR(50) NOT NULL,  -- malaria, nutrition, flood, immunization
  condition     JSONB NOT NULL,        -- rule definition as JSON
  severity      alert_severity NOT NULL,
  is_active     BOOLEAN DEFAULT true,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE alerts (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  rule_id         UUID REFERENCES alert_rules(id),
  county_id       UUID REFERENCES counties(id),
  community_id    UUID REFERENCES communities(id),
  household_id    UUID REFERENCES households(id),

  title           VARCHAR(255) NOT NULL,
  message         TEXT NOT NULL,
  category        VARCHAR(50) NOT NULL,
  severity        alert_severity NOT NULL,
  status          alert_status DEFAULT 'active',

  sms_sent        BOOLEAN DEFAULT false,
  sms_sent_at     TIMESTAMPTZ,
  recipients      JSONB,  -- array of phone numbers

  acknowledged_by UUID REFERENCES users(id),
  acknowledged_at TIMESTAMPTZ,
  resolved_at     TIMESTAMPTZ,

  created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_alerts_county ON alerts(county_id, status);
CREATE INDEX idx_alerts_severity ON alerts(severity, status, created_at);

-- ============================================================
-- RISK SCORES
-- ============================================================

CREATE TABLE risk_scores (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  entity_type     VARCHAR(30) NOT NULL,  -- household, community, county
  entity_id       UUID NOT NULL,
  score_type      VARCHAR(50) NOT NULL,  -- flood, malaria, nutrition, zero_dose, composite
  score           NUMERIC(5,2) NOT NULL,
  factors         JSONB,  -- contributing factors breakdown
  calculated_at   TIMESTAMPTZ DEFAULT NOW(),
  valid_until     TIMESTAMPTZ
);

CREATE INDEX idx_risk_scores_entity ON risk_scores(entity_type, entity_id, score_type);

-- ============================================================
-- DHIS2 SYNC LOG
-- ============================================================

CREATE TABLE dhis2_sync_log (
  id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  sync_type     VARCHAR(50) NOT NULL,  -- household, alert, risk_score
  entity_id     UUID,
  dhis2_uid     VARCHAR(50),
  status        VARCHAR(20) NOT NULL,  -- success, failed, partial
  request_body  JSONB,
  response_body JSONB,
  error_message TEXT,
  synced_at     TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- COMMUNITY FEEDBACK
-- ============================================================

CREATE TABLE community_feedback (
  id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  community_id  UUID REFERENCES communities(id),
  submitted_by  UUID REFERENCES users(id),
  channel       VARCHAR(30),  -- sms, app, voice
  category      VARCHAR(50),  -- service_quality, alert_accuracy, data_error
  message       TEXT NOT NULL,
  sentiment     VARCHAR(20),  -- positive, neutral, negative
  is_resolved   BOOLEAN DEFAULT false,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);