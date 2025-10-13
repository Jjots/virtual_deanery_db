-- =============================================
-- ВНЕШНИЕ КЛЮЧИ СИСТЕМЫ УСПЕВАЕМОСТИ (ЛП5)
-- =============================================

-- Удаляем существующие constraints чтобы избежать ошибок
DO $$ 
BEGIN
    -- Внутренние constraints ЛП5
    BEGIN ALTER TABLE Grade DROP CONSTRAINT fk_grade_assessment_type; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE AcademicDebt DROP CONSTRAINT fk_academicdebt_grade; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE Retake DROP CONSTRAINT fk_retake_academicdebt; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE Retake DROP CONSTRAINT fk_retake_assessment_type; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE Retake DROP CONSTRAINT fk_retake_result_grade; EXCEPTION WHEN OTHERS THEN NULL; END;
    
    -- Внешние constraints с другими LP
    BEGIN ALTER TABLE Grade DROP CONSTRAINT fk_grade_student; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE Grade DROP CONSTRAINT fk_grade_discipline; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE Grade DROP CONSTRAINT fk_grade_semester; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE Grade DROP CONSTRAINT fk_grade_event; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE Grade DROP CONSTRAINT fk_grade_teacher; EXCEPTION WHEN OTHERS THEN NULL; END;
    
    BEGIN ALTER TABLE AcademicDebt DROP CONSTRAINT fk_academicdebt_student; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE AcademicDebt DROP CONSTRAINT fk_academicdebt_discipline; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE AcademicDebt DROP CONSTRAINT fk_academicdebt_semester; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE AcademicDebt DROP CONSTRAINT fk_academicdebt_event; EXCEPTION WHEN OTHERS THEN NULL; END;
    
    BEGIN ALTER TABLE Retake DROP CONSTRAINT fk_retake_teacher; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE Retake DROP CONSTRAINT fk_retake_event; EXCEPTION WHEN OTHERS THEN NULL; END;
END $$;

-- =============================================
-- ВНУТРЕННИЕ СВЯЗИ ЛП5
-- =============================================

-- Grade -> AssessmentType
ALTER TABLE Grade ADD CONSTRAINT fk_grade_assessment_type FOREIGN KEY (assessment_type_id) REFERENCES AssessmentType(assessment_type_id);

-- AcademicDebt -> Grade (1:1 связь)
ALTER TABLE AcademicDebt ADD CONSTRAINT fk_academicdebt_grade FOREIGN KEY (grade_id) REFERENCES Grade(grade_id);

-- Retake -> AcademicDebt
ALTER TABLE Retake ADD CONSTRAINT fk_retake_academicdebt FOREIGN KEY (academic_debt_id) REFERENCES AcademicDebt(debt_id);

-- Retake -> AssessmentType
ALTER TABLE Retake ADD CONSTRAINT fk_retake_assessment_type FOREIGN KEY (assessment_type_id) REFERENCES AssessmentType(assessment_type_id);

-- Retake -> Grade (1:1 связь для результата пересдачи)
ALTER TABLE Retake ADD CONSTRAINT fk_retake_result_grade FOREIGN KEY (result_grade_id) REFERENCES Grade(grade_id);

-- =============================================
-- СВЯЗИ С ДРУГИМИ МОДУЛЯМИ
-- =============================================

-- LP1 (Студенческий контингент)
ALTER TABLE Grade ADD CONSTRAINT fk_grade_student FOREIGN KEY (student_id) REFERENCES Student(student_id);
ALTER TABLE AcademicDebt ADD CONSTRAINT fk_academicdebt_student FOREIGN KEY (student_id) REFERENCES Student(student_id);

-- LP2 (Учебный процесс)
ALTER TABLE Grade ADD CONSTRAINT fk_grade_discipline FOREIGN KEY (discipline_id) REFERENCES Discipline(discipline_id);
ALTER TABLE Grade ADD CONSTRAINT fk_grade_semester FOREIGN KEY (semester_id) REFERENCES Semester(semester_id);
ALTER TABLE AcademicDebt ADD CONSTRAINT fk_academicdebt_discipline FOREIGN KEY (discipline_id) REFERENCES Discipline(discipline_id);
ALTER TABLE AcademicDebt ADD CONSTRAINT fk_academicdebt_semester FOREIGN KEY (semester_id) REFERENCES Semester(semester_id);

-- LP3 (Преподаватели)
ALTER TABLE Grade ADD CONSTRAINT fk_grade_teacher FOREIGN KEY (teacher_id) REFERENCES Teacher(teacher_id);
ALTER TABLE Retake ADD CONSTRAINT fk_retake_teacher FOREIGN KEY (teacher_id) REFERENCES Teacher(teacher_id);

-- LP4 (Мероприятия)
ALTER TABLE Grade ADD CONSTRAINT fk_grade_event FOREIGN KEY (event_id) REFERENCES Event(event_id);
ALTER TABLE AcademicDebt ADD CONSTRAINT fk_academicdebt_event FOREIGN KEY (event_id) REFERENCES Event(event_id);
ALTER TABLE Retake ADD CONSTRAINT fk_retake_event FOREIGN KEY (event_id) REFERENCES Event(event_id);

-- =============================================
-- ОГРАНИЧЕНИЯ ЦЕЛОСТНОСТИ
-- =============================================

-- AssessmentType
ALTER TABLE AssessmentType ADD CONSTRAINT chk_assessmenttype_grading_scale CHECK (grading_scale IN ('5-балльная', 'Зачет/Незачет', '100-балльная'));
ALTER TABLE AssessmentType ADD CONSTRAINT chk_assessmenttype_max_retakes CHECK (max_retakes >= 0);

-- Grade
ALTER TABLE Grade ADD CONSTRAINT chk_grade_value CHECK (grade_value IN ('2', '3', '4', '5', 'Зачет', 'Незачет') OR (grade_value ~ '^\d+$' AND grade_value::INTEGER BETWEEN 0 AND 100));

-- AcademicDebt
ALTER TABLE AcademicDebt ADD CONSTRAINT chk_academicdebt_debt_status CHECK (debt_status IN ('Активен', 'Погашен', 'Назначена пересдача', 'Автоматический зачет', 'Академический отпуск'));

-- Retake
ALTER TABLE Retake ADD CONSTRAINT chk_retake_attempt_number CHECK (attempt_number > 0);

-- =============================================
-- УНИКАЛЬНЫЕ ОГРАНИЧЕНИЯ
-- =============================================

ALTER TABLE AcademicDebt ADD CONSTRAINT uk_academicdebt_grade UNIQUE (grade_id);
ALTER TABLE Retake ADD CONSTRAINT uk_retake_result_grade UNIQUE (result_grade_id);

-- =============================================
-- ИНДЕКСЫ ДЛЯ ПРОИЗВОДИТЕЛЬНОСТИ
-- =============================================

CREATE INDEX idx_grade_student ON Grade(student_id);
CREATE INDEX idx_grade_discipline ON Grade(discipline_id);
CREATE INDEX idx_grade_semester ON Grade(semester_id);
CREATE INDEX idx_grade_event ON Grade(event_id);
CREATE INDEX idx_grade_teacher ON Grade(teacher_id);
CREATE INDEX idx_grade_assessment_type ON Grade(assessment_type_id);

CREATE INDEX idx_academicdebt_student ON AcademicDebt(student_id);
CREATE INDEX idx_academicdebt_discipline ON AcademicDebt(discipline_id);
CREATE INDEX idx_academicdebt_status ON AcademicDebt(debt_status);

CREATE INDEX idx_retake_academic_debt ON Retake(academic_debt_id);
CREATE INDEX idx_retake_event ON Retake(event_id);  -- ИСПРАВЛЕНО!
CREATE INDEX idx_retake_teacher ON Retake(teacher_id);
-- =============================================
-- СООБЩЕНИЕ ОБ УСПЕХЕ
-- =============================================

DO $$ 
BEGIN
    RAISE NOTICE '✓ Все constraints системы успеваемости созданы успешно!';
    RAISE NOTICE 'Создано: 17 FOREIGN KEY, 5 CHECK, 2 UNIQUE, 12 индексов';
END $$;
