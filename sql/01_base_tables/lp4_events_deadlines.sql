CREATE TABLE EventType (
    event_type_id INTEGER PRIMARY KEY,
    type_name VARCHAR NOT NULL,
    importance_level INTEGER
);

CREATE TABLE Event (
    event_id INTEGER PRIMARY KEY,
    event_name VARCHAR NOT NULL,
    event_date DATE NOT NULL,
    event_time TIME,
    event_type_id INTEGER,
    discipline_id INTEGER,
    group_id INTEGER,
    teacher_id INTEGER,
    event_location VARCHAR,
    auto_reminder BOOLEAN DEFAULT false
);

CREATE TABLE EventCreator (
    creator_id SERIAL PRIMARY KEY,
    teacher_id INTEGER,
    event_id INTEGER,
    creation_date DATE DEFAULT CURRENT_DATE,
    can_modify BOOLEAN DEFAULT true
);

CREATE TABLE Notification (
    notification_id INTEGER PRIMARY KEY,
    title VARCHAR NOT NULL,
    message TEXT,
    notification_type VARCHAR NOT NULL,
    student_id INTEGER,
    event_id INTEGER,
    sent_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Deadline (
    deadline_id INTEGER PRIMARY KEY,
    deadline_date DATE NOT NULL,
    deadline_priority VARCHAR,
    deadline_status VARCHAR,
    student_id INTEGER,
    event_id INTEGER,
    discipline_id INTEGER
);

CREATE TABLE EventResult (
    result_id INTEGER PRIMARY KEY,
    event_id INTEGER,
    student_id INTEGER,
    grade_id INTEGER,
    attendance_status VARCHAR
);