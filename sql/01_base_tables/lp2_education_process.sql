CREATE TABLE department (
    department_id         SERIAL PRIMARY KEY,
    department_name       VARCHAR(100) NOT NULL,
    department_head_name  VARCHAR(100),
    faculty_id            INT
);

CREATE TABLE discipline (
    discipline_id     SERIAL PRIMARY KEY,
    discipline_name   VARCHAR(100) NOT NULL,
    discipline_code   VARCHAR(20) UNIQUE NOT NULL,
    department_id     INT,
	default_deadline_days INT,
	allow_notifications BOOLEAN DEFAULT FALSE,
    discipline_type   VARCHAR(30) CHECK (discipline_type IN ('Обязательная', 'Элективная'))
);

CREATE TABLE curriculum (
    curriculum_id     SERIAL PRIMARY KEY,
    curriculum_name   VARCHAR(100) NOT NULL,
    approve_year      INT CHECK (approve_year >= 2000),
    faculty_id        INT,
    education_form_id INT,
	departament_id INT
);

CREATE TABLE semester (
    semester_id      SERIAL PRIMARY KEY,
    semester_number  INT NOT NULL CHECK (semester_number BETWEEN 1 AND 12),
    academic_year    VARCHAR(9), 
    curriculum_id    INT
);

CREATE TABLE curriculum_discipline (
    curriculum_discipline_id SERIAL PRIMARY KEY,
    curriculum_id    INT,
    discipline_id    INT,
    semester_id      INT,
    lecture_hours    INT DEFAULT 0,
    seminar_hours    INT DEFAULT 0,
    assessment_type  VARCHAR(50)
);
