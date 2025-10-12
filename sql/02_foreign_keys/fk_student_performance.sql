-- =============================================
-- ВНЕШНИЕ КЛЮЧИ СИСТЕМЫ УСПЕВАЕМОСТИ (ЛП5)
-- Связи внутри модуля и с другими LP
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
    BEGIN ALTER TABLE Grade DROP CONSTRAINT fk_grade_grade_sheet; EXCEPTION WHEN OTHERS THEN NULL; END;
    
    BEGIN ALTER TABLE AcademicDebt DROP CONSTRAINT fk_academicdebt_student; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE AcademicDebt DROP CONSTRAINT fk_academicdebt_discipline; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE AcademicDebt DROP CONSTRAINT fk_academicdebt_semester; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE AcademicDebt DROP CONSTRAINT fk_academicdebt_event; EXCEPTION WHEN OTHERS THEN NULL; END;
    
    BEGIN ALTER TABLE Retake DROP CONSTRAINT fk_retake_teacher; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE Retake DROP CONSTRAINT fk_retake_event; EXCEPTION WHEN OTHERS THEN NULL; END;
    
    -- CHECK constraints
    BEGIN ALTER TABLE AssessmentType DROP CONSTRAINT chk_assessmenttype_grading_scale; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE AssessmentType DROP CONSTRAINT chk_assessmenttype_max_retakes; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE Grade DROP CONSTRAINT chk_grade_value; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE AcademicDebt DROP CONSTRAINT chk_academicdebt_debt_status; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE Retake DROP CONSTRAINT chk_retake_attempt_number; EXCEPTION WHEN OTHERS THEN NULL; END;
    
    -- UNIQUE constraints
    BEGIN ALTER TABLE AcademicDebt DROP CONSTRAINT uk_academicdebt_grade; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE Retake DROP CONSTRAINT uk_retake_result_grade; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE AssessmentType DROP CONSTRAINT uk_assessmenttype_assessment_name; EXCEPTION WHEN OTHERS THEN NULL; END;
END $$;

-- =============================================
-- ВНУТРЕННИЕ СВЯЗИ ЛП5
-- =============================================

-- Grade -> AssessmentType
ALTER TABLE Grade 
ADD CONSTRAINT fk_grade_assessment_type 
FOREIGN KEY (assessment_type_id) REFERENCES AssessmentType(assessment_type_id);

-- AcademicDebt -> Grade (1:1 связь)
ALTER TABLE AcademicDebt 
ADD CONSTRAINT fk_academicdebt_grade 
FOREIGN KEY (grade_id) REFERENCES Grade(grade_id);

-- Retake -> AcademicDebt
ALTER TABLE Retake 
ADD CONSTRAINT fk_retake_academicdebt 
FOREIGN KEY (academic_debt_id) REFERENCES AcademicDebt(debt_id);

-- Retake -> AssessmentType
ALTER TABLE Retake 
ADD CONSTRAINT fk_retake_assessment_type 
FOREIGN KEY (assessment_type_id) REFERENCES AssessmentType(assessment_type_id);

-- Retake -> Grade (1:1 связь для результата пересдачи)
ALTER TABLE Retake 
ADD CONSTRAINT fk_retake_result_grade 
FOREIGN KEY (result_grade_id) REFERENCES Grade(grade_id);

-- =============================================
-- СВЯЗИ С LP1 (СТУДЕНЧЕСКИЙ КОНТИНГЕНТ)
-- =============================================

-- Grade -> Student
ALTER TABLE Grade 
ADD CONSTRAINT fk_grade_student 
FOREIGN KEY (student_id) REFERENCES Student(student_id);

-- AcademicDebt -> Student
ALTER TABLE AcademicDebt 
ADD CONSTRAINT fk_academicdebt_student 
FOREIGN KEY (student_id) REFERENCES Student(student_id);

-- =============================================
-- СВЯЗИ С LP2 (УЧЕБНЫЙ ПРОЦЕСС)
-- =============================================

-- Grade -> Discipline
ALTER TABLE Grade 
ADD CONSTRAINT fk_grade_discipline 
FOREIGN KEY (discipline_id) REFERENCES Discipline(discipline_id);

-- Grade -> Semester
ALTER TABLE Grade 
ADD CONSTRAINT fk_grade_semester 
FOREIGN KEY (semester_id) REFERENCES Semester(semester_id);

-- AcademicDebt -> Discipline
ALTER TABLE AcademicDebt 
ADD CONSTRAINT fk_academicdebt_discipline 
FOREIGN KEY (discipline_id) REFERENCES Discipline(discipline_id);

-- AcademicDebt -> Semester
ALTER TABLE AcademicDebt 
ADD CONSTRAINT fk_academicdebt_semester 
FOREIGN KEY (semester_id) REFERENCES Semester(semester_id);

-- =============================================
-- СВЯЗИ С LP3 (ПРЕПОДАВАТЕЛИ)
-- =============================================

-- Grade -> Teacher
ALTER TABLE Grade 
ADD CONSTRAINT fk_grade_teacher 
FOREIGN KEY (teacher_id) REFERENCES Teacher(teacher_id);

-- Retake -> Teacher
ALTER TABLE Retake 
ADD CONSTRAINT fk_retake_teacher 
-- =============================================
-- ВНЕШНИЕ КЛЮЧИ СИСТЕМЫ УСПЕВАЕМОСТИ (ЛП5)
-- Только рабочие связи
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
    
    BEGIN ALTER TABLE Retake DROP CONSTRAINT fk_retake_teacher; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE Retake DROP CONSTRAINT fk_retake_event; EXCEPTION WHEN OTHERS THEN NULL; END;
    
    -- CHECK constraints
    BEGIN ALTER TABLE AssessmentType DROP CONSTRAINT chk_assessmenttype_grading_scale; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE AssessmentType DROP CONSTRAINT chk_assessmenttype_max_retakes; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE Grade DROP CONSTRAINT chk_grade_value; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE AcademicDebt DROP CONSTRAINT chk_academicdebt_debt_status; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE Retake DROP CONSTRAINT chk_retake_attempt_number; EXCEPTION WHEN OTHERS THEN NULL; END;
    
    -- UNIQUE constraints
    BEGIN ALTER TABLE AcademicDebt DROP CONSTRAINT uk_academicdebt_grade; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN ALTER TABLE Retake DROP CONSTRAINT uk_retake_result_grade; EXCEPTION WHEN OTHERS THEN NULL; END;
END $$;

-- =============================================
-- ВНУТРЕННИЕ СВЯЗИ ЛП5
-- =============================================

-- Grade -> AssessmentType
ALTER TABLE Grade 
ADD CONSTRAINT fk_grade_assessment_type 
FOREIGN KEY (assessment_type_id) REFERENCES AssessmentType(assessment_type_id);

-- AcademicDebt -> Grade (1:1 связь)
ALTER TABLE AcademicDebt 
ADD CONSTRAINT fk_academicdebt_grade 
FOREIGN KEY (grade_id) REFERENCES Grade(grade_id);

-- Retake -> AcademicDebt
ALTER TABLE Retake 
ADD CONSTRAINT fk_retake_academicdebt 
FOREIGN KEY (academic_debt_id) REFERENCES AcademicDebt(debt_id);

-- Retake -> AssessmentType
ALTER TABLE Retake 
ADD CONSTRAINT fk_retake_assessment_type 
FOREIGN KEY (assessment_type_id) REFERENCES AssessmentType(assessment_type_id);

-- Retake -> Grade (1:1 связь для результата пересдачи)
ALTER TABLE Retake 
ADD CONSTRAINT fk_retake_result_grade 
FOREIGN KEY (result_grade_id) REFERENCES Grade(grade_id);

-- =============================================
-- СВЯЗИ С LP1 (СТУДЕНЧЕСКИЙ КОНТИНГЕНТ)
-- =============================================

-- Grade -> Student
ALTER TABLE Grade 
ADD CONSTRAINT fk_grade_student 
FOREIGN KEY (student_id) REFERENCES Student(student_id);

-- AcademicDebt -> Student
ALTER TABLE AcademicDebt 
ADD CONSTRAINT fk_academicdebt_student 
FOREIGN KEY (student_id) REFERENCES Student(student_id);

-- =============================================
-- СВЯЗИ С LP2 (УЧЕБНЫЙ ПРОЦЕСС)
-- =============================================

-- Grade -> Discipline
ALTER TABLE Grade 
ADD CONSTRAINT fk_grade_discipline 
FOREIGN KEY (discipline_id) REFERENCES Discipline(discipline_id);

-- Grade -> Semester
ALTER TABLE Grade 
ADD CONSTRAINT fk_grade_semester 
FOREIGN KEY (semester_id) REFERENCES Semester(semester_id);

-- AcademicDebt -> Discipline
ALTER TABLE AcademicDebt 
ADD CONSTRAINT fk_academicdebt_discipline 
FOREIGN KEY (discipline_id) REFERENCES Discipline(discipline_id);

-- AcademicDebt -> Semester
ALTER TABLE AcademicDebt 
ADD CONSTRAINT fk_academicdebt_semester 
FOREIGN KEY (semester_id) REFERENCES Semester(semester_id);

-- =============================================
-- СВЯЗИ С LP3 (ПРЕПОДАВАТЕЛИ)
-- =============================================

-- Grade -> Teacher
ALTER TABLE Grade 
ADD CONSTRAINT fk_grade_teacher 
FOREIGN KEY (teacher_id) REFERENCES Teacher(teacher_id);

-- Retake -> Teacher
ALTER TABLE Retake 
ADD CONSTRAINT fk_retake_teacher 
FOREIGN KEY (teacher_id) REFERENCES Teacher(teacher_id);

-- =============================================
-- СВЯЗИ С LP4 (МЕРОПРИЯТИЯ И ДЕДЛАЙНЫ)
-- =============================================

-- Grade -> Event
ALTER TABLE Grade 
ADD CONSTRAINT fk_grade_event 
FOREIGN KEY (event_id) REFERENCES Event(event_id);

-- Retake -> Event (мероприятие пересдачи)
ALTER TABLE Retake 
ADD CONSTRAINT fk_retake_event 
FOREIGN KEY (scheduled_event_id) REFERENCES Event(event_id);

-- =============================================
-- CHECK CONSTRAINTS
-- =============================================

-- AssessmentType: проверка шкалы оценивания
ALTER TABLE AssessmentType 
ADD CONSTRAINT chk_assessmenttype_grading_scale 
CHECK (grading_scale IN ('5-балльная', 'Зачет/Незачет', '100-балльная'));

-- AssessmentType: проверка количества пересдач
ALTER TABLE AssessmentType 
ADD CONSTRAINT chk_assessmenttype_max_retakes 
CHECK (max_retakes >= 0);

-- Grade: проверка формата оценки
ALTER TABLE Grade 
ADD CONSTRAINT chk_grade_value 
CHECK (
    (grade_value IN ('2', '3', '4', '5', 'Зачет', 'Незачет')) OR
    (grade_value ~ '^\d+$' AND CAST(grade_value AS INTEGER) BETWEEN 0 AND 100)
);

-- AcademicDebt: проверка статуса долга
ALTER TABLE AcademicDebt 
ADD CONSTRAINT chk_academicdebt_debt_status 
CHECK (debt_status IN ('Активен', 'Погашен', 'Назначена пересдача', 'Автоматический зачет', 'Академический отпуск', NULL));

-- Retake: проверка номера попытки
ALTER TABLE Retake 
ADD CONSTRAINT chk_retake_attempt_number 
CHECK (attempt_number > 0);

-- =============================================
-- UNIQUE CONSTRAINTS
-- =============================================

-- Уникальная связь AcademicDebt -> Grade (1:1)
ALTER TABLE AcademicDebt 
ADD CONSTRAINT uk_academicdebt_grade 
UNIQUE (grade_id);

-- Уникальная связь Retake -> Grade (1:1 для результата пересдачи)
ALTER TABLE Retake 
ADD CONSTRAINT uk_retake_result_grade 
UNIQUE (result_grade_id);

-- =============================================
-- ФАЙЛ УСПЕШНО СОЗДАН
-- Все рабочие связи настроены
-- =============================================

SELECT '✓ Все constraints успешно созданы!' as status;

