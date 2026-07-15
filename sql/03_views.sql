-- ── RECRUITING ANALYTICS VIEWS ────────────────────────────────────
-- Vantage Health — HR Recruiting Funnel
-- Views for Power BI dashboard

-- ══════════════════════════════════════════════════════════════════
-- PAGE 1 — PIPELINE ANALYTICS
-- main enriched view joining applications to jobs and candidates
-- ══════════════════════════════════════════════════════════════════

CREATE OR REPLACE VIEW clean.vw_recruiting_pipeline AS
SELECT
    -- application fields
    a.application_id,
    a.source,
    a.current_stage,
    a.outcome,
    a.rejection_reason,
    a.applied_date,
    a.screen_date,
    a.interview_date,
    a.final_round_date,
    a.offer_date,
    a.hire_date,
    a.days_to_hire,

    -- job fields
    j.job_id,
    j.title,
    j.department,
    j.level,
    j.location,
    j.salary_min,
    j.salary_max,
    j.req_type,
    j.open_date,
    j.close_date,
    j.status         AS job_status,

    -- candidate fields
    c.candidate_id,
    c.name           AS candidate_name,
    c.state          AS candidate_state,
    c.years_experience,
    c.education_level,
    c.gender,
    c.ethnicity

FROM clean.applications a
JOIN clean.jobs      j ON a.job_id       = j.job_id
JOIN clean.candidates c ON a.candidate_id = c.candidate_id;


-- ══════════════════════════════════════════════════════════════════
-- PAGE 2 — OPEN ROLES
-- current open requisitions with key attributes
-- no applications data needed here — just job info
-- ══════════════════════════════════════════════════════════════════

CREATE OR REPLACE VIEW clean.vw_open_roles AS
SELECT
    job_id,
    title,
    department,
    level,
    location,
    salary_min,
    salary_max,
    req_type,
    open_date,
    -- days the role has been open — useful for "aging" analysis
    CURRENT_DATE - open_date AS days_open
FROM clean.jobs
WHERE status = 'Open';



