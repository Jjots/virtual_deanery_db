CREATE TABLE AssessmentType (
    assessment_type_id SERIAL PRIMARY KEY,
    assessment_name VARCHAR(50) NOT NULL,
    grading_scale VARCHAR(20) NOT NULL,
    max_retakes INTEGER DEFAULT 1
);

CREATE TABLE Grade (
    grade_id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL,
    discipline_id INTEGER NOT NULL,
    semester_id INTEGER NOT NULL,
    event_id INTEGER NOT NULL,
    teacher_id INTEGER NOT NULL,
    grade_sheet_id INTEGER,
    assessment_type_id INTEGER NOT NULL,
    grade_value VARCHAR(10) NOT NULL,
    is_final BOOLEAN DEFAULT FALSE,
    record_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    teacher_comment TEXT
);

CREATE TABLE AcademicDebt (
    debt_id SERIAL PRIMARY KEY,
    grade_id INTEGER NOT NULL,
    student_id INTEGER NOT NULL,
    discipline_id INTEGER NOT NULL,
    semester_id INTEGER NOT NULL,
    event_id INTEGER NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    debt_status VARCHAR(30),
    resolution_date DATE,
    admin_comment TEXT
);

CREATE TABLE Retake (
    retake_id SERIAL PRIMARY KEY,
    academic_debt_id INTEGER NOT NULL,
    event_id INTEGER NOT NULL,
    teacher_id INTEGER NOT NULL,
    assessment_type_id INTEGER NOT NULL,
    result_grade_id INTEGER,
    attempt_number INTEGER NOT NULL,
    notification_sent BOOLEAN DEFAULT FALSE,
    scheduled_date TIMESTAMP,
    retake_notes TEXT
);