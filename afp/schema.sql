-- Repo-local build state. Same pattern as the AFP opportunities repo's
-- base.sqlite: fixed-name artifacts on disk, one row per unit of work here.
-- AFP reads this database; agents write it via the recording contract in AGENTS.md.

CREATE TABLE IF NOT EXISTS build_milestones (
  id TEXT PRIMARY KEY,
  milestone_key TEXT NOT NULL UNIQUE,   -- e.g. "m1-core-flow" (from spec 08-milestones.md)
  milestone_index INTEGER NOT NULL,
  title TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',  -- pending | in_progress | completed | failed | blocked
  spec_ref TEXT,                           -- path into spec/ that defines this milestone
  summary TEXT,
  artifact_path TEXT,                      -- afp/reports/milestone-N-report.md
  verify_json TEXT,                        -- snapshot of afp/artifacts/verify.json at completion
  attempts INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS build_evidence (
  id TEXT PRIMARY KEY,
  milestone_key TEXT NOT NULL,
  title TEXT NOT NULL,
  kind TEXT NOT NULL,                      -- report | screenshot | verify_json | review
  file_path TEXT NOT NULL,
  why_it_matters TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  UNIQUE (milestone_key, file_path)
);

CREATE TABLE IF NOT EXISTS build_runs (
  id TEXT PRIMARY KEY,
  milestone_key TEXT,                   -- NULL for ad-hoc tasks
  task_text TEXT,                       -- the ad-hoc objective when milestone_key is NULL
  agent TEXT NOT NULL DEFAULT 'claude_code',
  status TEXT NOT NULL DEFAULT 'queued',  -- queued | running | verifying | completed | failed
  prompt TEXT,
  agent_session_id TEXT,
  agent_thread_id TEXT,
  agent_turn_id TEXT,
  transcript_path TEXT,
  final_answer TEXT,
  verify_json TEXT NOT NULL DEFAULT '{}',  -- AFP's authoritative verify report
  verify_pass INTEGER,                     -- 1/0 once verified, NULL before
  reviewed_at TEXT,                        -- the hard review gate: set by the operator in AFP
  error TEXT,
  started_at TEXT,
  completed_at TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_build_runs_status ON build_runs(status);
