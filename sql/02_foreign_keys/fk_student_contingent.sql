-- =============================================
-- FOREIGN KEYS для студенческого контингента
-- =============================================

-- Связь: Академическая группа → Факультет
ALTER TABLE studentgroup ADD CONSTRAINT fk_group_faculty FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id);

-- Связь: Академическая группа → Форма обучения
ALTER TABLE studentgroup ADD CONSTRAINT fk_group_education_form FOREIGN KEY (education_form_id) REFERENCES educationform(education_form_id);

-- Связь: Студент → Академическая группа
ALTER TABLE student ADD CONSTRAINT fk_student_group FOREIGN KEY (group_id) REFERENCES studentgroup(group_id);

-- Связь: Студент → Приказ о зачислении
ALTER TABLE student ADD CONSTRAINT fk_student_enrollment_order FOREIGN KEY (enrollment_order_id) REFERENCES enrollmentorder(order_id);

-- Связь: Студент → Форма обучения
ALTER TABLE student ADD CONSTRAINT fk_student_education_form FOREIGN KEY (education_form_id) REFERENCES educationform(education_form_id);

-- =============================================
-- Ограничения для целостности данных
-- =============================================

-- Уникальность номера зачетной книжки
ALTER TABLE student ADD CONSTRAINT uk_student_record_book UNIQUE (record_book_id);

-- Проверка статуса студента
ALTER TABLE student ADD CONSTRAINT chk_student_status CHECK (student_status IN ('активный', 'академический отпуск', 'отчислен', 'выпускник'));

-- Проверка года поступления
ALTER TABLE studentgroup ADD CONSTRAINT chk_group_enrollment_year CHECK (enrollment_year >= 2000 AND enrollment_year <= EXTRACT(YEAR FROM CURRENT_DATE) + 1);

-- Проверка количества студентов
ALTER TABLE studentgroup ADD CONSTRAINT chk_group_max_students CHECK (max_students > 0);

-- Проверка даты приказа
ALTER TABLE enrollmentorder ADD CONSTRAINT chk_order_date CHECK (order_date <= CURRENT_DATE);

-- Проверка типа приказа
ALTER TABLE enrollmentorder ADD CONSTRAINT chk_order_type CHECK (order_type IN ('зачисление', 'перевод', 'восстановление'));

-- =============================================
-- Индексы
-- =============================================

-- Уникальность email только для не-NULL значений
CREATE UNIQUE INDEX uk_student_email ON student (student_email) WHERE student_email IS NOT NULL;

-- Основные индексы
CREATE INDEX idx_student_group_id ON student(group_id);
CREATE INDEX idx_student_status ON student(student_status);
CREATE INDEX idx_group_faculty_id ON studentgroup(faculty_id);
CREATE INDEX idx_group_enrollment_year ON studentgroup(enrollment_year);
CREATE INDEX idx_student_record_book ON student(record_book_id);

-- =============================================
-- Сообщение об успешном выполнении
-- =============================================

DO $$ BEGIN
    RAISE NOTICE 'Foreign keys for student contingent created successfully';
END $$;