-- 로컬 DB(SQLite/Room) MVP 최소 스키마 초안
-- 웹 앱은 현재 localStorage + bt_* 키로 동일 역할을 수행합니다.
-- Android 네이티브 전환 시 아래를 Room Entity로 옮기기 쉽게 맞춰 두었습니다.

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS user_profile (
  user_id INTEGER PRIMARY KEY AUTOINCREMENT,
  nickname TEXT NOT NULL,
  birth_year INTEGER,
  gender TEXT,
  user_mode TEXT NOT NULL,
  target_goal TEXT,
  location_code TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS daily_condition (
  condition_id INTEGER PRIMARY KEY AUTOINCREMENT,
  sleep_hours REAL,
  sleep_quality INTEGER,
  stress_level INTEGER,
  mood_level INTEGER,
  anxiety_level INTEGER,
  motivation_level INTEGER,
  fatigue_level INTEGER,
  exercise_yn TEXT NOT NULL DEFAULT 'N',
  screen_time_min INTEGER,
  emotion_note TEXT,
  mind_check_completed INTEGER NOT NULL DEFAULT 0,
  created_at INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS questionnaire_result (
  result_id INTEGER PRIMARY KEY AUTOINCREMENT,
  category TEXT NOT NULL,
  total_score REAL,
  result_level TEXT,
  answered_json TEXT NOT NULL,
  created_at INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS test_result (
  result_id INTEGER PRIMARY KEY AUTOINCREMENT,
  test_type TEXT NOT NULL,
  raw_score REAL,
  normalized_score REAL,
  accuracy REAL,
  reaction_time_avg INTEGER,
  reaction_time_sd INTEGER,
  detail_json TEXT,
  created_at INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS training_result (
  result_id INTEGER PRIMARY KEY AUTOINCREMENT,
  game_type TEXT NOT NULL,
  level_no INTEGER NOT NULL,
  score REAL NOT NULL,
  accuracy REAL,
  duration_sec INTEGER,
  created_at INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS daily_score_summary (
  summary_id INTEGER PRIMARY KEY AUTOINCREMENT,
  summary_date TEXT NOT NULL UNIQUE,
  memory_score REAL,
  focus_score REAL,
  reaction_score REAL,
  executive_score REAL,
  summary_status TEXT,
  summary_text TEXT,
  recommendation_text TEXT,
  created_at INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS app_config_cache (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL,
  updated_at INTEGER NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_daily_condition_created ON daily_condition(created_at);
CREATE INDEX IF NOT EXISTS idx_test_result_created ON test_result(created_at);
CREATE INDEX IF NOT EXISTS idx_training_result_created ON training_result(created_at);
