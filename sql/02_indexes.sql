-- ── INDEXES FOR CLEAN SCHEMA ──────────────────────────────────────
-- indexes on frequently filtered/joined columns
-- applications is the fact table so it gets the most indexes

-- applications — foreign keys and commonly filtered columns
CREATE INDEX idx_applications_candidate_id ON clean.applications(candidate_id);
CREATE INDEX idx_applications_job_id       ON clean.applications(job_id);
CREATE INDEX idx_applications_source       ON clean.applications(source);
CREATE INDEX idx_applications_outcome      ON clean.applications(outcome);
CREATE INDEX idx_applications_applied_date ON clean.applications(applied_date);

-- jobs — commonly filtered columns
CREATE INDEX idx_jobs_department ON clean.jobs(department);
CREATE INDEX idx_jobs_status     ON clean.jobs(status);
CREATE INDEX idx_jobs_level      ON clean.jobs(level);

-- candidates — commonly filtered columns
CREATE INDEX idx_candidates_gender    ON clean.candidates(gender);
CREATE INDEX idx_candidates_ethnicity ON clean.candidates(ethnicity);