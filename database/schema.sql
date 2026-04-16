-- =============================================
-- BrainFit DB Schema (MVP)
-- MySQL 8.0+
-- =============================================

-- 1) users: 사용자 기본 테이블
CREATE TABLE users (
    user_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    login_type VARCHAR(20) NOT NULL,           -- guest, kakao, google, apple
    login_key VARCHAR(100) NULL,
    nickname VARCHAR(50) NOT NULL,
    birth_year INT NULL,
    gender VARCHAR(10) NULL,                   -- male, female, other
    user_mode VARCHAR(20) NOT NULL,            -- senior, student, general
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2) user_profile: 추가 프로필 정보
CREATE TABLE user_profile (
    profile_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    school_grade VARCHAR(20) NULL,
    guardian_name VARCHAR(50) NULL,
    guardian_phone VARCHAR(20) NULL,
    target_goal VARCHAR(30) NULL,              -- memory, focus, routine
    sleep_target_hours DECIMAL(3,1) NULL,
    consent_yn CHAR(1) NOT NULL DEFAULT 'N',
    marketing_yn CHAR(1) NOT NULL DEFAULT 'N',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_profile_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 3) daily_condition: 일일 체크인 데이터
CREATE TABLE daily_condition (
    condition_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    sleep_hours DECIMAL(3,1) NULL,
    sleep_quality TINYINT NULL,                -- 1~5
    stress_level TINYINT NULL,                 -- 1~5
    mood_level TINYINT NULL,                   -- 1~5
    anxiety_level TINYINT NULL,                -- 1~5 마음·불안 (참고용)
    motivation_level TINYINT NULL,             -- 1~5 의욕
    fatigue_level TINYINT NULL,                -- 1~5
    exercise_yn CHAR(1) NOT NULL DEFAULT 'N',
    screen_time_min INT NULL,
    note VARCHAR(255) NULL,
    emotion_note VARCHAR(255) NULL,            -- 한 줄 마음 메모
    mind_check_completed CHAR(1) NOT NULL DEFAULT 'N',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_daily_condition_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 4) questionnaire_master: 문진 문항 마스터
CREATE TABLE questionnaire_master (
    question_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    category VARCHAR(20) NOT NULL,             -- memory, focus, lifestyle
    target_mode VARCHAR(20) NOT NULL,          -- senior, student, general
    question_text VARCHAR(255) NOT NULL,
    answer_type VARCHAR(20) NOT NULL,          -- scale_0_3, yes_no, scale_1_5
    score_weight DECIMAL(4,2) NOT NULL DEFAULT 1.0,
    active_yn CHAR(1) NOT NULL DEFAULT 'Y',
    sort_order INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 5) questionnaire_session: 문진 세션
CREATE TABLE questionnaire_session (
    session_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    category VARCHAR(20) NOT NULL,
    started_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ended_at DATETIME NULL,
    total_score DECIMAL(6,2) NULL,
    result_level VARCHAR(20) NULL,             -- normal, observe, manage
    CONSTRAINT fk_questionnaire_session_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 6) questionnaire_answer: 문진 응답
CREATE TABLE questionnaire_answer (
    answer_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    session_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    question_id BIGINT NOT NULL,
    answer_value VARCHAR(20) NOT NULL,
    score_value DECIMAL(6,2) NULL,
    answered_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_questionnaire_answer_session FOREIGN KEY (session_id) REFERENCES questionnaire_session(session_id),
    CONSTRAINT fk_questionnaire_answer_user FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT fk_questionnaire_answer_question FOREIGN KEY (question_id) REFERENCES questionnaire_master(question_id)
);

-- 7) test_master: 인지 테스트 정의
CREATE TABLE test_master (
    test_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    test_code VARCHAR(30) NOT NULL UNIQUE,     -- WORD_MEMORY, DIGIT_SPAN, REACTION, STROOP, CPT
    test_name VARCHAR(100) NOT NULL,
    domain_type VARCHAR(30) NOT NULL,          -- memory, focus, reaction, executive
    duration_sec INT NOT NULL,
    active_yn CHAR(1) NOT NULL DEFAULT 'Y',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 8) test_session: 테스트 실행 세션
CREATE TABLE test_session (
    session_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    test_id BIGINT NOT NULL,
    session_type VARCHAR(20) NOT NULL,         -- daily, weekly, baseline
    started_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ended_at DATETIME NULL,
    raw_score DECIMAL(8,2) NULL,
    normalized_score DECIMAL(8,2) NULL,
    accuracy DECIMAL(5,2) NULL,
    reaction_time_avg INT NULL,
    reaction_time_sd INT NULL,
    result_level VARCHAR(20) NULL,
    CONSTRAINT fk_test_session_user FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT fk_test_session_test FOREIGN KEY (test_id) REFERENCES test_master(test_id)
);

-- 9) test_event_log: 문항별 상세 로그
CREATE TABLE test_event_log (
    event_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    session_id BIGINT NOT NULL,
    event_order INT NOT NULL,
    stimulus_value VARCHAR(100) NULL,
    user_input_value VARCHAR(100) NULL,
    correct_yn CHAR(1) NOT NULL DEFAULT 'N',
    reaction_time_ms INT NULL,
    extra_data JSON NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_test_event_log_session FOREIGN KEY (session_id) REFERENCES test_session(session_id)
);

-- 10) training_game_master: 훈련 게임 정의
CREATE TABLE training_game_master (
    game_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    game_code VARCHAR(30) NOT NULL UNIQUE,     -- CARD_MATCH, N_BACK, TAP_REACTION, SEQUENCE_MEMORY
    game_name VARCHAR(100) NOT NULL,
    domain_type VARCHAR(30) NOT NULL,
    active_yn CHAR(1) NOT NULL DEFAULT 'Y',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 11) training_game_result: 훈련 결과
CREATE TABLE training_game_result (
    game_result_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    game_id BIGINT NOT NULL,
    level_no INT NOT NULL,
    score DECIMAL(8,2) NOT NULL,
    accuracy DECIMAL(5,2) NULL,
    duration_sec INT NULL,
    streak_count INT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_training_game_result_user FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT fk_training_game_result_game FOREIGN KEY (game_id) REFERENCES training_game_master(game_id)
);

-- 12) score_summary_daily: 일별 핵심 점수 요약
CREATE TABLE score_summary_daily (
    summary_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    summary_date DATE NOT NULL,
    memory_score DECIMAL(5,2) NULL,
    focus_score DECIMAL(5,2) NULL,
    reaction_score DECIMAL(5,2) NULL,
    executive_score DECIMAL(5,2) NULL,
    summary_status VARCHAR(20) NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_score_summary_daily (user_id, summary_date),
    CONSTRAINT fk_score_summary_daily_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 13) insight_report: 인사이트 리포트
CREATE TABLE insight_report (
    report_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    report_type VARCHAR(20) NOT NULL,          -- daily, weekly, monthly
    report_date DATE NOT NULL,
    memory_score DECIMAL(5,2) NULL,
    focus_score DECIMAL(5,2) NULL,
    reaction_score DECIMAL(5,2) NULL,
    summary_text TEXT NULL,
    recommendation_text TEXT NULL,
    detail_locked_yn CHAR(1) NOT NULL DEFAULT 'Y',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_insight_report_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 14) guardian_link: 보호자 연결
CREATE TABLE guardian_link (
    link_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    guardian_name VARCHAR(50) NOT NULL,
    guardian_phone VARCHAR(20) NULL,
    guardian_email VARCHAR(100) NULL,
    share_summary_yn CHAR(1) NOT NULL DEFAULT 'Y',
    share_alert_yn CHAR(1) NOT NULL DEFAULT 'Y',
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_guardian_link_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 15) ad_reward_log: 광고 보상 로그
CREATE TABLE ad_reward_log (
    reward_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    reward_type VARCHAR(30) NOT NULL,          -- report_detail, extra_training, bonus_ticket
    ad_network VARCHAR(30) NOT NULL,           -- admob
    rewarded_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expire_at DATETIME NULL,
    used_yn CHAR(1) NOT NULL DEFAULT 'N',
    CONSTRAINT fk_ad_reward_log_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 16) weather_data: 날씨 데이터
CREATE TABLE weather_data (
    weather_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    location_code VARCHAR(50) NOT NULL,
    temperature DECIMAL(4,1),
    humidity INT,
    weather_type VARCHAR(20),                  -- sunny, cloudy, overcast, rain, snow, fog
    pm25 INT,
    feels_like DECIMAL(4,1) NULL,
    pressure INT NULL,
    recorded_at DATETIME NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_weather_data_location_recorded ON weather_data(location_code, recorded_at);

-- 17) device_measurement: 센서/키오스크 연동 데이터 (향후 확장)
CREATE TABLE device_measurement (
    measurement_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    source_type VARCHAR(20) NOT NULL,          -- kiosk, wearable, sensor
    measure_type VARCHAR(30) NOT NULL,         -- hrv, bp, sleep, steps, body_composition
    measure_value DECIMAL(10,2) NULL,
    measure_json JSON NULL,
    measured_at DATETIME NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_device_measurement_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- user_profile에 지역 정보 추가
ALTER TABLE user_profile ADD COLUMN location_code VARCHAR(50) NULL;

-- =============================================
-- 인덱스
-- =============================================
CREATE INDEX idx_daily_condition_user_created ON daily_condition(user_id, created_at);
CREATE INDEX idx_questionnaire_session_user_started ON questionnaire_session(user_id, started_at);
CREATE INDEX idx_test_session_user_started ON test_session(user_id, started_at);
CREATE INDEX idx_training_game_result_user_created ON training_game_result(user_id, created_at);
CREATE INDEX idx_insight_report_user_date ON insight_report(user_id, report_date);
CREATE INDEX idx_device_measurement_user_measured ON device_measurement(user_id, measured_at);
CREATE INDEX idx_guardian_link_user ON guardian_link(user_id);
CREATE INDEX idx_ad_reward_log_user ON ad_reward_log(user_id, rewarded_at);

-- =============================================
-- 마스터 데이터 시드
-- =============================================

-- 테스트 마스터
INSERT INTO test_master (test_code, test_name, domain_type, duration_sec) VALUES
('WORD_MEMORY',      '단어 기억 테스트',     'memory',    60),
('DIGIT_SPAN',       '숫자 역순 테스트',     'memory',    60),
('NUMBER_MEMORY',    '숫자 암기 테스트',     'memory',    60),
('VISUAL_PATTERN',   '시각 패턴 기억',       'memory',    60),
('STROOP',           'Stroop 테스트',        'focus',     60),
('CPT',              'CPT 테스트',           'focus',     90),
('TRAIL_MAKING',     '트레일 메이킹',        'focus',     60),
('REACTION_SPEED',   '반응속도 테스트',      'reaction',  30),
('VISUAL_TRACKING',  '시각 추적 테스트',     'focus',     45);

-- 게임 마스터
INSERT INTO training_game_master (game_code, game_name, domain_type) VALUES
('CARD_MATCH',       '카드 짝 맞추기',       'memory'),
('N_BACK',           'N-Back',              'memory'),
('SEQUENCE_MEMORY',  '순서 기억',            'memory'),
('SELECTIVE_FOCUS',  '선택 집중',            'focus'),
('TAP_REACTION',     '반응속도 탭',          'reaction'),
('BREATHING',        '호흡 훈련',            'focus');

-- 시니어 기억력 문진
INSERT INTO questionnaire_master (category, target_mode, question_text, answer_type, sort_order) VALUES
('memory', 'senior', '최근 약속이나 일정을 자주 잊는다', 'scale_0_3', 1),
('memory', 'senior', '물건을 어디에 뒀는지 기억이 나지 않는다', 'scale_0_3', 2),
('memory', 'senior', '대화 중 하려던 말을 잊는 경우가 있다', 'scale_0_3', 3),
('memory', 'senior', '전화번호나 비밀번호를 외우기 어렵다', 'scale_0_3', 4),
('memory', 'senior', '같은 질문이나 이야기를 반복할 때가 있다', 'scale_0_3', 5),
('memory', 'senior', '날짜나 요일을 혼동할 때가 있다', 'scale_0_3', 6),
('memory', 'senior', '길을 찾거나 방향 감각이 떨어졌다', 'scale_0_3', 7);

-- 학생 집중력 문진
INSERT INTO questionnaire_master (category, target_mode, question_text, answer_type, sort_order) VALUES
('focus', 'student', '수업이나 공부 중 다른 생각을 자주 한다', 'scale_0_3', 1),
('focus', 'student', '한 가지 일에 30분 이상 집중하기 어렵다', 'scale_0_3', 2),
('focus', 'student', '공부를 시작하기까지 오래 걸린다', 'scale_0_3', 3),
('focus', 'student', '스마트폰 알림에 자주 방해받는다', 'scale_0_3', 4),
('focus', 'student', '공부한 내용이 잘 기억나지 않는다', 'scale_0_3', 5),
('focus', 'student', '시험 전에 벼락치기를 자주 한다', 'scale_0_3', 6),
('focus', 'student', '멀티태스킹을 자주 한다', 'scale_0_3', 7);
