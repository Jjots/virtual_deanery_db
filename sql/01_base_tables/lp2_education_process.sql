-- =========================================================
-- Файл: lp2_education_process.sql
-- Назначение: создание таблиц локального представления
-- "Учебные планы и дисциплины" (Архитектор учебного процесса)
-- =========================================================

-- Таблица: Факультет (Faculty)
CREATE TABLE faculty (
    faculty_id        SERIAL PRIMARY KEY,
    faculty_name      VARCHAR(100) NOT NULL,
    faculty_abbr      VARCHAR(20),
    faculty_phone     VARCHAR(20),
    faculty_email     VARCHAR(50)
);

-- Таблица: Кафедра (Department)
CREATE TABLE department (
    department_id         SERIAL PRIMARY KEY,
    department_name       VARCHAR(100) NOT NULL,
    department_head_name  VARCHAR(100),
    faculty_id            INT NOT NULL,
    CONSTRAINT fk_department_faculty
        FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id)
        ON DELETE CASCADE
);

-- Таблица: Дисциплина (Discipline)
CREATE TABLE discipline (
    discipline_id     SERIAL PRIMARY KEY,
    discipline_name   VARCHAR(100) NOT NULL,
    discipline_code   VARCHAR(20) UNIQUE NOT NULL,
    department_id     INT NOT NULL,
    discipline_type   VARCHAR(30) CHECK (discipline_type IN ('Обязательная', 'Элективная')),
    allow_notifications BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_discipline_department
        FOREIGN KEY (department_id) REFERENCES department(department_id)
        ON DELETE CASCADE
);

-- Таблица: Учебный план (Curriculum)
CREATE TABLE curriculum (
    curriculum_id     SERIAL PRIMARY KEY,
    curriculum_name   VARCHAR(100) NOT NULL,
    curriculum_level  VARCHAR(50),
    approve_year      INT CHECK (approve_year >= 2000),
    faculty_id        INT,
    education_form_id INT,
    CONSTRAINT fk_curriculum_faculty
        FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id),
    CONSTRAINT fk_curriculum_education_form
        FOREIGN KEY (education_form_id) REFERENCES education_form(education_form_id)
);

-- Таблица: Семестр (Semester)
CREATE TABLE semester (
    semester_id      SERIAL PRIMARY KEY,
    semester_number  INT NOT NULL CHECK (semester_number BETWEEN 1 AND 12),
    academic_year    VARCHAR(9), -- например: 2024/2025
    curriculum_id    INT NOT NULL,
    CONSTRAINT fk_semester_curriculum
        FOREIGN KEY (curriculum_id) REFERENCES curriculum(curriculum_id)
        ON DELETE CASCADE
);

-- Таблица: Связь учебного плана и дисциплин (CurriculumDiscipline)
CREATE TABLE curriculum_discipline (
    curriculum_discipline_id SERIAL PRIMARY KEY,
    curriculum_id    INT NOT NULL,
    discipline_id    INT NOT NULL,
    semester_id      INT NOT NULL,
    lecture_hours    INT DEFAULT 0,
    lab_hours        INT DEFAULT 0,
    practical_hours  INT DEFAULT 0,
    credit_units     DECIMAL(3,1),
    assessment_type  VARCHAR(50),
    CONSTRAINT fk_cd_curriculum
        FOREIGN KEY (curriculum_id) REFERENCES curriculum(curriculum_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_cd_discipline
        FOREIGN KEY (discipline_id) REFERENCES discipline(discipline_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_cd_semester
        FOREIGN KEY (semester_id) REFERENCES semester(semester_id)
        ON DELETE CASCADE
);

-- Таблица: Форма обучения (EducationForm) — если не общая
CREATE TABLE education_form (
    education_form_id SERIAL PRIMARY KEY,
    education_form_name VARCHAR(50) NOT NULL CHECK (education_form_name IN ('Очная', 'Заочная', 'Очно-заочная'))
);

-- =========================================================
-- Конец файла lp2_education_process.sql
-- =========================================================
