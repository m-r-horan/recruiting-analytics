-- ── RECRUITING ANALYTICS SCHEMA ───────────────────────────────────
-- Vantage Health — HR Recruiting Funnel
-- Two schemas: raw (messy ATS data) and clean (cleaned data)

-- ── CREATE SCHEMAS ────────────────────────────────────────────────
CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS clean;

-- ══════════════════════════════════════════════════════════════════
-- RAW SCHEMA — data lands here exactly as exported from ATS
-- messy source labels, missing dates, inconsistent formatting
-- ══════════════════════════════════════════════════════════════════

-- jobs (dimension) — open and historical job requisitions
CREATE TABLE raw.jobs (
    job_id      VARCHAR(20)  PRIMARY KEY,
    title       VARCHAR(100),
    department  VARCHAR(50),
    level       VARCHAR(20),
    location    VARCHAR(20),
    salary_min  INT,
    salary_max  INT,
    req_type    VARCHAR(20),
    open_date   DATE,
    close_date  DATE,
    status      VARCHAR(20)
);

-- candidates (dimension) — applicant profiles
CREATE TABLE raw.candidates (
    candidate_id    VARCHAR(20)  PRIMARY KEY,
    name            VARCHAR(100),
    email           VARCHAR(100),
    state           VARCHAR(50),
    years_experience INT,
    education_level VARCHAR(50),
    gender          VARCHAR(30),
    ethnicity       VARCHAR(50)
);

-- applications (fact) — one row per candidate per job applied to
-- tracks funnel stage, outcome, dates, and source
CREATE TABLE raw.applications (
    application_id   VARCHAR(20)  PRIMARY KEY,
    candidate_id     VARCHAR(20)  REFERENCES raw.candidates(candidate_id),
    job_id           VARCHAR(20)  REFERENCES raw.jobs(job_id),
    source           VARCHAR(50),           -- messy in raw: 'linkedin' vs 'LinkedIn' etc
    current_stage    VARCHAR(30),
    outcome          VARCHAR(20),
    rejection_reason VARCHAR(100),
    applied_date     DATE,
    screen_date      DATE,                  -- nullable — not all candidates reach this stage
    interview_date   DATE,                  -- nullable
    final_round_date DATE,                  -- nullable
    offer_date       DATE,                  -- nullable
    hire_date        DATE                   -- nullable — only set if hired
);

-- ══════════════════════════════════════════════════════════════════
-- CLEAN SCHEMA — cleaned and standardized data
-- consistent source labels, validated dates, no nulls where unexpected
-- ══════════════════════════════════════════════════════════════════

-- jobs — same structure as raw, clean schema just ensures data quality
CREATE TABLE clean.jobs (
    job_id      VARCHAR(20)  PRIMARY KEY,
    title       VARCHAR(100),
    department  VARCHAR(50),
    level       VARCHAR(20),
    location    VARCHAR(20),
    salary_min  INT,
    salary_max  INT,
    req_type    VARCHAR(20),
    open_date   DATE,
    close_date  DATE,
    status      VARCHAR(20)
);

-- candidates — same structure as raw
CREATE TABLE clean.candidates (
    candidate_id     VARCHAR(20)  PRIMARY KEY,
    name             VARCHAR(100),
    email            VARCHAR(100),
    state            VARCHAR(50),
    years_experience INT,
    education_level  VARCHAR(50),
    gender           VARCHAR(30),
    ethnicity        VARCHAR(50)
);

-- applications — same structure as raw but with cleaned source labels
-- and validated dates
CREATE TABLE clean.applications (
    application_id   VARCHAR(20)  PRIMARY KEY,
    candidate_id     VARCHAR(20)  REFERENCES clean.candidates(candidate_id),
    job_id           VARCHAR(20)  REFERENCES clean.jobs(job_id),
    source           VARCHAR(50),           -- standardized: always 'LinkedIn' not 'linkedin'
    current_stage    VARCHAR(30),
    outcome          VARCHAR(20),
    rejection_reason VARCHAR(100),
    applied_date     DATE,
    screen_date      DATE,
    interview_date   DATE,
    final_round_date DATE,
    offer_date       DATE,
    hire_date        DATE,
    days_to_hire     INT                    -- derived: hire_date - applied_date, added during cleaning
);



