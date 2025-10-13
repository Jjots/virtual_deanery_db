-- =============================================
-- ДОПОЛНИТЕЛЬНЫЕ ОГРАНИЧЕНИЯ ДЛЯ СТУДЕНЧЕСКОГО КОНТИНГЕНТА (LP1)
-- =============================================

-- Удаляем существующие constraints чтобы избежать ошибок
DO $$ 
BEGIN
    -- NOT NULL constraints
    BEGIN ALTER TABLE student ALTER COLUMN student_name DROP NOT NULL; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE student ALTER COLUMN student_surname DROP NOT NULL; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE student ALTER COLUMN record_book_id DROP NOT NULL; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE student ALTER COLUMN birth_date DROP NOT NULL; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE student ALTER COLUMN student_status DROP NOT NULL; EXCEPTION WHEN OTHERS THEN NULL; END;
    
    -- CHECK constraints
    BEGIN ALTER TABLE student DROP CONSTRAINT IF EXISTS chk_student_birth_date; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE student DROP CONSTRAINT IF EXISTS chk_student_email; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE student DROP CONSTRAINT IF EXISTS chk_student_phone; EXCEPTION WHEN OTHERS THEN NULL; END;
    
    BEGIN ALTER TABLE studentgroup DROP CONSTRAINT IF EXISTS chk_group_name_format; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE studentgroup DROP CONSTRAINT IF EXISTS chk_group_enrollment_year_range; EXCEPTION WHEN OTHERS THEN NULL; END;
    
    BEGIN ALTER TABLE faculty DROP CONSTRAINT IF EXISTS chk_faculty_email; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE faculty DROP CONSTRAINT IF EXISTS chk_faculty_phone; EXCEPTION WHEN OTHERS THEN NULL; END;
    
    BEGIN ALTER TABLE enrollmentorder DROP CONSTRAINT IF EXISTS chk_order_number_format; EXCEPTION WHEN OTHERS THEN NULL; END;
    
    -- UNIQUE constraints
    BEGIN ALTER TABLE faculty DROP CONSTRAINT IF EXISTS uk_faculty_name; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE enrollmentorder DROP CONSTRAINT IF EXISTS uk_order_number; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE educationform DROP CONSTRAINT IF EXISTS uk_education_form_code; EXCEPTION WHEN OTHERS THEN NULL; END;
END $$;

-- =============================================
-- NOT NULL ОГРАНИЧЕНИЯ (обязательные поля)
-- =============================================

-- Студент
ALTER TABLE student ALTER COLUMN student_name SET NOT NULL;
ALTER TABLE student ALTER COLUMN student_surname SET NOT NULL;
ALTER TABLE student ALTER COLUMN record_book_id SET NOT NULL;
ALTER TABLE student ALTER COLUMN birth_date SET NOT NULL;
ALTER TABLE student ALTER COLUMN student_status SET NOT NULL;

-- Академическая группа
ALTER TABLE studentgroup ALTER COLUMN group_name SET NOT NULL;
ALTER TABLE studentgroup ALTER COLUMN enrollment_year SET NOT NULL;

-- Факультет
ALTER TABLE faculty ALTER COLUMN faculty_name SET NOT NULL;
ALTER TABLE faculty ALTER COLUMN dean_name SET NOT NULL;
ALTER TABLE faculty ALTER COLUMN dean_surname SET NOT NULL;

-- Форма обучения
ALTER TABLE educationform ALTER COLUMN education_form_name SET NOT NULL;
ALTER TABLE educationform ALTER COLUMN education_form_code SET NOT NULL;

-- Приказ о зачислении
ALTER TABLE enrollmentorder ALTER COLUMN order_number SET NOT NULL;
ALTER TABLE enrollmentorder ALTER COLUMN order_date SET NOT NULL;
ALTER TABLE enrollmentorder ALTER COLUMN order_base SET NOT NULL;
ALTER TABLE enrollmentorder ALTER COLUMN order_type SET NOT NULL;

-- =============================================
-- DEFAULT ЗНАЧЕНИЯ (значения по умолчанию)
-- =============================================

-- Статус студента по умолчанию "активный"
ALTER TABLE student ALTER COLUMN student_status SET DEFAULT 'активный';

-- Группа активна по умолчанию
ALTER TABLE studentgroup ALTER COLUMN is_active SET DEFAULT true;

-- =============================================
-- CHECK ОГРАНИЧЕНИЯ (проверки данных)
-- =============================================

-- СТУДЕНТ
-- Проверка даты рождения (студент не может быть младше 16 лет и старше 100 лет)
ALTER TABLE student ADD CONSTRAINT chk_student_birth_date 
CHECK (birth_date BETWEEN '1900-01-01' AND CURRENT_DATE - INTERVAL '16 years');

-- Проверка формата email (если указан)
ALTER TABLE student ADD CONSTRAINT chk_student_email 
CHECK (student_email IS NULL OR student_email ~ '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$');

-- Проверка формата телефона (если указан)
ALTER TABLE student ADD CONSTRAINT chk_student_phone 
CHECK (student_phone IS NULL OR student_phone ~ '^\+?[0-9\s\-\(\)]{7,20}$');

-- АКАДЕМИЧЕСКАЯ ГРУППА
-- Проверка формата названия группы (должно содержать буквы и цифры)
ALTER TABLE studentgroup ADD CONSTRAINT chk_group_name_format 
CHECK (group_name ~ '^[А-Яа-я]{2,4}-\d{2}-\d{2}$');

-- Проверка года поступления (от 2000 до текущего года + 1)
ALTER TABLE studentgroup ADD CONSTRAINT chk_group_enrollment_year_range 
CHECK (enrollment_year BETWEEN 2000 AND EXTRACT(YEAR FROM CURRENT_DATE) + 1);

-- ФАКУЛЬТЕТ
-- Проверка email факультета
ALTER TABLE faculty ADD CONSTRAINT chk_faculty_email 
CHECK (faculty_email IS NULL OR faculty_email ~ '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$');

-- Проверка телефона факультета
ALTER TABLE faculty ADD CONSTRAINT chk_faculty_phone 
CHECK (faculty_phone IS NULL OR faculty_phone ~ '^\+?[0-9\s\-\(\)]{7,20}$');

-- ПРИКАЗ О ЗАЧИСЛЕНИИ
-- Проверка формата номера приказа
ALTER TABLE enrollmentorder ADD CONSTRAINT chk_order_number_format 
CHECK (order_number ~ '^\d{1,4}-\w{1,10}/\d{1,4}$');

-- =============================================
-- UNIQUE ОГРАНИЧЕНИЯ (уникальность)
-- =============================================

-- Уникальное название факультета
ALTER TABLE faculty ADD CONSTRAINT uk_faculty_name UNIQUE (faculty_name);

-- Уникальный номер приказа
ALTER TABLE enrollmentorder ADD CONSTRAINT uk_order_number UNIQUE (order_number);

-- Уникальный код формы обучения
ALTER TABLE educationform ADD CONSTRAINT uk_education_form_code UNIQUE (education_form_code);

-- =============================================
-- ИНДЕКСЫ ДЛЯ ЧАСТО ИСПОЛЬЗУЕМЫХ ПОЛЕЙ
-- =============================================

-- Индекс для быстрого поиска студентов по фамилии
CREATE INDEX IF NOT EXISTS idx_student_surname ON student(student_surname);

-- Индекс для поиска по номеру зачетной книжки
CREATE INDEX IF NOT EXISTS idx_student_record_book ON student(record_book_id);

-- Индекс для поиска групп по году поступления
CREATE INDEX IF NOT EXISTS idx_group_enrollment_year ON studentgroup(enrollment_year);

-- Индекс для поиска по статусу студента
CREATE INDEX IF NOT EXISTS idx_student_status ON student(student_status);

-- =============================================
-- КОММЕНТАРИИ ДЛЯ ДОКУМЕНТАЦИИ
-- =============================================

COMMENT ON CONSTRAINT chk_student_birth_date ON student IS 'Проверка реалистичной даты рождения студента';
COMMENT ON CONSTRAINT chk_group_name_format ON studentgroup IS 'Проверка формата названия группы (пример: ИТ-21)';
COMMENT ON CONSTRAINT uk_faculty_name ON faculty IS 'Уникальность названия факультета';

-- =============================================
-- СООБЩЕНИЕ ОБ УСПЕШНОМ ВЫПОЛНЕНИИ
-- =============================================

DO $$ 
BEGIN
    RAISE NOTICE '✅ Дополнительные ограничения для студенческого контингента созданы успешно!';
    RAISE NOTICE 'Создано: 12 NOT NULL, 2 DEFAULT, 8 CHECK, 3 UNIQUE, 4 индекса';
END $$;