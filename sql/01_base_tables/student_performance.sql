-- =============================================
-- Локальное Представление 5: СИСТЕМА УСПЕВАЕМОСТИ
-- Архитектор успеваемости
-- Без внешних ключей (другие ЛП еще не созданы)
-- =============================================

-- Удаление существующих таблиц (если нужно пересоздать)
DROP TABLE IF EXISTS Retake;
DROP TABLE IF EXISTS AcademicDebt;
DROP TABLE IF EXISTS Grade;
DROP TABLE IF EXISTS AssessmentType;

-- =============================================
-- 1. ТИП КОНТРОЛЯ
-- =============================================
CREATE TABLE AssessmentType (
    assessment_type_id INTEGER PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL,          -- 'Экзамен', 'Зачет', 'Курсовая работа'
    grading_scale VARCHAR(20) NOT NULL,      -- '5-балльная', 'Зачет/Незачет', '100-балльная'
    max_retakes INTEGER NOT NULL DEFAULT 1,  -- Максимальное количество пересдач
    
    CONSTRAINT chk_grading_scale CHECK (grading_scale IN ('5-балльная', 'Зачет/Незачет', '100-балльная')),
    CONSTRAINT chk_max_retakes CHECK (max_retakes >= 0)
);

-- =============================================
-- 2. ОЦЕНКА
-- =============================================
CREATE TABLE Grade (
    grade_id INTEGER PRIMARY KEY,
    
    -- Внешние ключи на другие модули (БЕЗ FK CONSTRAINTS)
    student_id INTEGER NOT NULL,          -- Будет FK → Student.student_id
    discipline_id INTEGER NOT NULL,       -- Будет FK → Discipline.discipline_id
    semester_id INTEGER NOT NULL,         -- Будет FK → Semester.semester_id
    event_id INTEGER NOT NULL,            -- Будет FK → Event.event_id
    teacher_id INTEGER NOT NULL,          -- Будет FK → Teacher.teacher_id
    grade_sheet_id INTEGER,               -- Будет FK → GradeSheet.grade_sheet_id
    
    -- Локальные связи ЛП5
    assessment_type_id INTEGER NOT NULL,  -- FK → AssessmentType.assessment_type_id
    
    -- Атрибуты оценки
    grade_value VARCHAR(10) NOT NULL,     -- '5', '4', '3', '2', 'Зачет', 'Незачет'
    is_final BOOLEAN DEFAULT FALSE,       -- Флаг итоговой оценки за семестр
    record_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    teacher_comment TEXT
);

-- =============================================
-- 3. АКАДЕМИЧЕСКИЙ ДОЛГ
-- =============================================
CREATE TABLE AcademicDebt (
    debt_id INTEGER PRIMARY KEY,
    
    -- Связь с оценкой (1:1)
    grade_id INTEGER NOT NULL UNIQUE,     -- Будет FK → Grade.grade_id
    
    -- Внешние ключи для быстрого доступа (БЕЗ FK CONSTRAINTS)
    student_id INTEGER NOT NULL,          -- Будет FK → Student.student_id
    discipline_id INTEGER NOT NULL,       -- Будет FK → Discipline.discipline_id
    semester_id INTEGER NOT NULL,         -- Будет FK → Semester.semester_id
    event_id INTEGER NOT NULL,            -- Будет FK → Event.event_id
    teacher_id INTEGER NOT NULL,          -- Будет FK → Teacher.teacher_id
    
    -- Атрибуты долга
    debt_status VARCHAR(20) NOT NULL DEFAULT 'Активен',
    creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolution_type VARCHAR(30),          -- 'Пересдача', 'Автоматический зачет'
    resolution_date DATE,
    admin_comment TEXT,
    
    CONSTRAINT chk_debt_status CHECK (debt_status IN ('Активен', 'Погашен', 'Назначена пересдача')),
    CONSTRAINT chk_resolution_type CHECK (resolution_type IN ('Пересдача', 'Автоматический зачет', 'Академический отпуск', NULL))
);

-- =============================================
-- 4. ПЕРЕСДАЧА
-- =============================================
CREATE TABLE Retake (
    retake_id INTEGER PRIMARY KEY,
    
    -- Связь с долгом
    academic_debt_id INTEGER NOT NULL,    -- Будет FK → AcademicDebt.debt_id
    
    -- Мероприятие пересдачи
    scheduled_event_id INTEGER NOT NULL,  -- Будет FK → Event.event_id
    
    -- Преподаватель, принимающий пересдачу
    teacher_id INTEGER NOT NULL,          -- Будет FK → Teacher.teacher_id
    
    -- Тип контроля пересдачи
    assessment_type_id INTEGER NOT NULL,  -- Будет FK → AssessmentType.assessment_type_id
    
    -- Результат пересдачи (может быть NULL пока не сдана)
    result_grade_id INTEGER UNIQUE,       -- Будет FK → Grade.grade_id
    
    -- Атрибуты пересдачи
    attempt_number INTEGER NOT NULL,      -- 1, 2, 3...
    notification_sent BOOLEAN DEFAULT FALSE,
    scheduled_date TIMESTAMP,
    retake_notes TEXT,
    
    CONSTRAINT chk_attempt_number CHECK (attempt_number > 0)
);

-- =============================================
-- ВНУТРЕННИЕ СВЯЗИ ЛП5 (только локальные FK)
-- =============================================

-- Grade -> AssessmentType
ALTER TABLE Grade ADD CONSTRAINT fk_grade_assessment_type 
    FOREIGN KEY (assessment_type_id) REFERENCES AssessmentType(assessment_type_id);

-- AcademicDebt -> Grade (1:1 связь)
ALTER TABLE AcademicDebt ADD CONSTRAINT fk_debt_grade 
    FOREIGN KEY (grade_id) REFERENCES Grade(grade_id);

-- Retake -> AcademicDebt
ALTER TABLE Retake ADD CONSTRAINT fk_retake_debt 
    FOREIGN KEY (academic_debt_id) REFERENCES AcademicDebt(debt_id);

-- Retake -> AssessmentType  
ALTER TABLE Retake ADD CONSTRAINT fk_retake_assessment_type 
    FOREIGN KEY (assessment_type_id) REFERENCES AssessmentType(assessment_type_id);

-- Retake -> Grade (для результата пересдачи)
ALTER TABLE Retake ADD CONSTRAINT fk_retake_result_grade 
    FOREIGN KEY (result_grade_id) REFERENCES Grade(grade_id);

-- =============================================
-- ИНДЕКСЫ ДЛЯ ПРОИЗВОДИТЕЛЬНОСТИ
-- =============================================

-- Индексы для Grade
CREATE INDEX idx_grade_student ON Grade(student_id);
CREATE INDEX idx_grade_discipline ON Grade(discipline_id);
CREATE INDEX idx_grade_semester ON Grade(semester_id);
CREATE INDEX idx_grade_event ON Grade(event_id);
CREATE INDEX idx_grade_teacher ON Grade(teacher_id);
CREATE INDEX idx_grade_assessment_type ON Grade(assessment_type_id);
CREATE INDEX idx_grade_final ON Grade(is_final) WHERE is_final = TRUE;

-- Индексы для AcademicDebt
CREATE INDEX idx_debt_student ON AcademicDebt(student_id);
CREATE INDEX idx_debt_discipline ON AcademicDebt(discipline_id);
CREATE INDEX idx_debt_status ON AcademicDebt(debt_status);
CREATE INDEX idx_debt_grade ON AcademicDebt(grade_id);

-- Индексы для Retake
CREATE INDEX idx_retake_debt ON Retake(academic_debt_id);
CREATE INDEX idx_retake_event ON Retake(scheduled_event_id);
CREATE INDEX idx_retake_teacher ON Retake(teacher_id);
CREATE INDEX idx_retake_attempt ON Retake(attempt_number);
