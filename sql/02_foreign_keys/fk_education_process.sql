-- Связь: Department → Faculty
ALTER TABLE department ADD CONSTRAINT fk_department_faculty FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id);

-- Связь: Discipline → Department
ALTER TABLE discipline ADD CONSTRAINT fk_discipline_department FOREIGN KEY (department_id) REFERENCES department(department_id);

-- Связь: Curriculum → Faculty
ALTER TABLE curriculum ADD CONSTRAINT fk_curriculum_faculty FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id);

-- Связь: Curriculum → EducationForm
ALTER TABLE curriculum ADD CONSTRAINT fk_curriculum_education_form FOREIGN KEY (education_form_id) REFERENCES educationform(education_form_id);

-- Связь: Curriculum → Department
ALTER TABLE curriculum ADD CONSTRAINT fk_curriculum_department FOREIGN KEY (departament_id) REFERENCES department(department_id);

-- Связь: Semester → Curriculum
ALTER TABLE semester ADD CONSTRAINT fk_semester_curriculum FOREIGN KEY (curriculum_id) REFERENCES curriculum(curriculum_id);

-- Связь: CurriculumDiscipline → Curriculum
ALTER TABLE curriculum_discipline ADD CONSTRAINT fk_cd_curriculum FOREIGN KEY (curriculum_id) REFERENCES curriculum(curriculum_id);

-- Связь: CurriculumDiscipline → Discipline
ALTER TABLE curriculum_discipline ADD CONSTRAINT fk_cd_discipline FOREIGN KEY (discipline_id) REFERENCES discipline(discipline_id);

-- Связь: CurriculumDiscipline → Semester
ALTER TABLE curriculum_discipline ADD CONSTRAINT fk_cd_semester FOREIGN KEY (semester_id) REFERENCES semester(semester_id);



-- Проверка типа дисциплины
ALTER TABLE discipline ADD CONSTRAINT chk_discipline_type CHECK (discipline_type IN ('Обязательная', 'Элективная'));

-- Проверка года утверждения учебного плана
ALTER TABLE curriculum ADD CONSTRAINT chk_approve_year CHECK (approve_year >= 2000);

-- Проверка номера семестра
ALTER TABLE semester ADD CONSTRAINT chk_semester_number CHECK (semester_number BETWEEN 1 AND 12);

-- Уникальность кода дисциплины
ALTER TABLE discipline ADD CONSTRAINT uk_discipline_code UNIQUE (discipline_code);


CREATE INDEX idx_discipline_department_id ON discipline(department_id);
CREATE INDEX idx_curriculum_faculty_id ON curriculum(faculty_id);
CREATE INDEX idx_curriculum_department_id ON curriculum(departament_id);
CREATE INDEX idx_semester_curriculum_id ON semester(curriculum_id);
CREATE INDEX idx_cd_curriculum_id ON curriculum_discipline(curriculum_id);
CREATE INDEX idx_cd_discipline_id ON curriculum_discipline(discipline_id);
CREATE INDEX idx_cd_semester_id ON curriculum_discipline(semester_id);


DO $$ BEGIN
    RAISE NOTICE 'Foreign keys for education process created successfully';
END $$;
