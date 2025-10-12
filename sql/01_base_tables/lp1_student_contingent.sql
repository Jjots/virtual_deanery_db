CREATE TABLE faculty (
    faculty_id INTEGER PRIMARY KEY,
    faculty_name VARCHAR NOT NULL,
    dean_name VARCHAR NOT NULL,
    dean_surname VARCHAR NOT NULL,
    dean_patronymic VARCHAR,
    faculty_phone VARCHAR,
    faculty_email VARCHAR
);

CREATE TABLE educationform (
    education_form_id INTEGER PRIMARY KEY,
    education_form_name VARCHAR NOT NULL,
    education_form_code VARCHAR NOT NULL,
    education_form_duration INTEGER
);

CREATE TABLE enrollmentorder (
    order_id INTEGER PRIMARY KEY,
    order_number VARCHAR NOT NULL,
    order_date DATE NOT NULL,
    order_base VARCHAR NOT NULL,
    order_type VARCHAR NOT NULL
);

CREATE TABLE studentgroup (
    group_id INTEGER PRIMARY KEY,
    group_name VARCHAR NOT NULL,
    enrollment_year INTEGER NOT NULL,
    faculty_id INTEGER,
    max_students INTEGER,
    education_form_id INTEGER,
    is_active BOOLEAN DEFAULT true,
    curriculum_id INTEGER
);

CREATE TABLE student (
    student_id INTEGER PRIMARY KEY,
    student_name VARCHAR NOT NULL,
    student_surname VARCHAR NOT NULL,
    student_patronymic VARCHAR,
    record_book_id VARCHAR NOT NULL,
    birth_date DATE NOT NULL,
    student_email VARCHAR,
    student_phone VARCHAR,
    group_id INTEGER,
    enrollment_order_id INTEGER,
    education_form_id INTEGER,
    student_status VARCHAR NOT NULL
);