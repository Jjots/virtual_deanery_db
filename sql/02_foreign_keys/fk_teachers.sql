-- =============================================
-- FOREIGN KEYS для локального представления преподавателей
-- =============================================

-- Связь: Преподаватель → Учёная степень
ALTER TABLE teacher 
    ADD CONSTRAINT fk_teacher_degree 
    FOREIGN KEY (degree_id) 
    REFERENCES academic_degree(degree_id);

-- Связь: Преподаватель → Академическая должность
ALTER TABLE teacher 
    ADD CONSTRAINT fk_teacher_position 
    FOREIGN KEY (position_id) 
    REFERENCES academic_position(position_id);

-- Связь: Преподаватель → Кафедра
ALTER TABLE teacher 
    ADD CONSTRAINT fk_teacher_department 
    FOREIGN KEY (department_id) 
    REFERENCES department(department_id);

-- Связь: Нагрузка преподавателя → Преподаватель
ALTER TABLE teacher_load 
    ADD CONSTRAINT fk_teacher_load_teacher 
    FOREIGN KEY (teacher_id) 
    REFERENCES teacher(teacher_id);

-- Связь: Нагрузка преподавателя → Дисциплина
ALTER TABLE teacher_load 
    ADD CONSTRAINT fk_teacher_load_discipline 
    FOREIGN KEY (discipline_id) 
    REFERENCES discipline(discipline_id);

-- Связь: Нагрузка преподавателя → Семестр
ALTER TABLE teacher_load 
    ADD CONSTRAINT fk_teacher_load_semester 
    FOREIGN KEY (semester_id) 
    REFERENCES semester(semester_id);

-- Связь: Ведомость → Преподаватель
ALTER TABLE grade_sheet 
    ADD CONSTRAINT fk_grade_sheet_teacher 
    FOREIGN KEY (teacher_id) 
    REFERENCES teacher(teacher_id);

-- Связь: Ведомость → Студент
ALTER TABLE grade_sheet 
    ADD CONSTRAINT fk_grade_sheet_student 
    FOREIGN KEY (student_id) 
    REFERENCES student(student_id);

-- Связь: Ведомость → Событие
ALTER TABLE grade_sheet 
    ADD CONSTRAINT fk_grade_sheet_event 
    FOREIGN KEY (event_id) 
    REFERENCES event(event_id);

-- =============================================
-- Проверки и ограничения
-- =============================================

-- Проверка корректности пола преподавателя
ALTER TABLE teacher 
    ADD CONSTRAINT chk_teacher_gender 
    CHECK (teacher_gender IN ('мужской', 'женский'));

-- Проверка корректности часов нагрузки
ALTER TABLE teacher_load 
    ADD CONSTRAINT chk_teacher_load_hours 
    CHECK (total_hours >= (lecture_hours + seminar_hours + lab_hours));

-- =============================================
-- Индексы для ускорения поиска
-- =============================================

CREATE INDEX idx_teacher_position_id ON teacher(position_id);
CREATE INDEX idx_teacher_degree_id ON teacher(degree_id);
CREATE INDEX idx_teacher_department_id ON teacher(department_id);
CREATE INDEX idx_teacher_load_teacher_id ON teacher_load(teacher_id);
CREATE INDEX idx_teacher_load_discipline_id ON teacher_load(discipline_id);
CREATE INDEX idx_teacher_load_semester_id ON teacher_load(semester_id);
CREATE INDEX idx_grade_sheet_teacher_id ON grade_sheet(teacher_id);
CREATE INDEX idx_grade_sheet_student_id ON grade_sheet(student_id);
CREATE INDEX idx_grade_sheet_event_id ON grade_sheet(event_id);

-- Уникальность email только для не-NULL значений
CREATE UNIQUE INDEX uk_teacher_email ON teacher(teacher_email) WHERE teacher_email IS NOT NULL;

-- =============================================
-- Сообщение об успешном выполнении
-- =============================================

DO $$ BEGIN
    RAISE NOTICE 'Foreign keys for teacher local representation created successfully';
END $$;
