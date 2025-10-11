CREATE TABLE department (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    department_head_name VARCHAR(100),
    faculty_id INTEGER
);

CREATE TABLE discipline (
    discipline_id SERIAL PRIMARY KEY,
    discipline_name VARCHAR(100) NOT NULL,
    discipline_code VARCHAR(20) NOT NULL,
    department_id INTEGER,
    default_deadline_days INTEGER,
    allow_notifications BOOLEAN DEFAULT FALSE,
    discipline_type VARCHAR(30)
);

CREATE TABLE curriculum (
    curriculum_id SERIAL PRIMARY KEY,
    curriculum_name VARCHAR(100) NOT NULL,
    approve_year INTEGER,
    faculty_id INTEGER,
    education_form_id INTEGER,
    departament_id INTEGER
);

CREATE TABLE semester (
    semester_id SERIAL PRIMARY KEY,
    semester_number INTEGER NOT NULL,
    academic_year VARCHAR(9),
    curriculum_id INTEGER
);

CREATE TABLE curriculum_discipline (
    curriculum_discipline_id SERIAL PRIMARY KEY,
    curriculum_id INTEGER,
    discipline_id INTEGER,
    semester_id INTEGER,
    lecture_hours INTEGER DEFAULT 0,
    seminar_hours INTEGER DEFAULT 0,
    assessment_type VARCHAR(50)
);