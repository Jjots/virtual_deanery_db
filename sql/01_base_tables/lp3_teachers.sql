CREATE TABLE academic_degree (
    degree_id INTEGER PRIMARY KEY,
    title VARCHAR(100),
    science_field VARCHAR(100)
);

CREATE TABLE academic_position (
    position_id INTEGER PRIMARY KEY,
    title VARCHAR(100),
    description TEXT
);

CREATE TABLE teacher (
    teacher_id INTEGER PRIMARY KEY,
    teacher_surname VARCHAR(100),
    teacher_name VARCHAR(100),
    teacher_patronymic VARCHAR(100),
    teacher_birth_date DATE,
    teacher_gender VARCHAR(10),
    teacher_email VARCHAR(100),
    teacher_phone VARCHAR(20),
    position_id INTEGER,
    degree_id INTEGER,
    department_id INTEGER,
    can_create_events BOOLEAN
);

CREATE TABLE teacher_load (
    load_id SERIAL PRIMARY KEY,
    teacher_id INTEGER,
    discipline_id INTEGER,
    semester_id INTEGER,
    total_hours INTEGER,
    lecture_hours INTEGER,
    seminar_hours INTEGER,
    lab_hours INTEGER
);

CREATE TABLE grade_sheet (
    grade_sheet_id INTEGER PRIMARY KEY,
    creation_date DATE,
    list_status VARCHAR(50),
    teacher_id INTEGER,
    event_id INTEGER,
    student_id INTEGER
);