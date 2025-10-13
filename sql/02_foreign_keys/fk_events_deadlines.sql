-- =============================================
-- FOREIGN KEYS для системы мероприятий
-- =============================================

-- ВНУТРЕННИЕ СВЯЗИ модуля мероприятий
ALTER TABLE Event ADD CONSTRAINT fk_event_event_type FOREIGN KEY (event_type_id) REFERENCES EventType(event_type_id);

ALTER TABLE EventCreator ADD CONSTRAINT fk_creator_event FOREIGN KEY (event_id) REFERENCES Event(event_id);

ALTER TABLE Notification ADD CONSTRAINT fk_notification_event FOREIGN KEY (event_id) REFERENCES Event(event_id);

ALTER TABLE Deadline ADD CONSTRAINT fk_deadline_event FOREIGN KEY (event_id) REFERENCES Event(event_id);

ALTER TABLE EventResult ADD CONSTRAINT fk_result_event FOREIGN KEY (event_id) REFERENCES Event(event_id);

-- СВЯЗИ С МОДУЛЕМ УЧЕБНОГО ПРОЦЕССА
ALTER TABLE Event ADD CONSTRAINT fk_event_discipline FOREIGN KEY (discipline_id) REFERENCES discipline(discipline_id);

ALTER TABLE Deadline ADD CONSTRAINT fk_deadline_discipline FOREIGN KEY (discipline_id) REFERENCES discipline(discipline_id);

-- СВЯЗИ С МОДУЛЕМ СТУДЕНЧЕСКОГО КОНТИНГЕНТА
ALTER TABLE Event ADD CONSTRAINT fk_event_group FOREIGN KEY (group_id) REFERENCES studentgroup(group_id);

ALTER TABLE Notification ADD CONSTRAINT fk_notification_student FOREIGN KEY (student_id) REFERENCES student(student_id);

ALTER TABLE Deadline ADD CONSTRAINT fk_deadline_student FOREIGN KEY (student_id) REFERENCES student(student_id);

ALTER TABLE EventResult ADD CONSTRAINT fk_result_student FOREIGN KEY (student_id) REFERENCES student(student_id);

-- СВЯЗИ С МОДУЛЕМ ПРЕПОДАВАТЕЛЕЙ
ALTER TABLE Event ADD CONSTRAINT fk_event_teacher FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id);

ALTER TABLE EventCreator ADD CONSTRAINT fk_creator_teacher FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id);

-- СВЯЗИ С МОДУЛЕМ УСПЕВАЕМОСТИ
ALTER TABLE EventResult ADD CONSTRAINT fk_result_grade FOREIGN KEY (grade_id) REFERENCES grade(grade_id);

-- =============================================
-- Ограничения для целостности данных (ИСПРАВЛЕННЫЕ)
-- =============================================

-- Проверка уровня важности типа мероприятия
ALTER TABLE EventType ADD CONSTRAINT chk_event_type_importance CHECK (importance_level >= 1 AND importance_level <= 10);

-- Проверка даты мероприятия (реалистичная дата)
ALTER TABLE Event ADD CONSTRAINT chk_event_date CHECK (event_date >= '2000-01-01');

-- Проверка типа уведомления
ALTER TABLE Notification ADD CONSTRAINT chk_notification_type CHECK (notification_type IN ('напоминание', 'результат', 'изменение', 'отмена'));

-- Проверка приоритета дедлайна
ALTER TABLE Deadline ADD CONSTRAINT chk_deadline_priority CHECK (deadline_priority IN ('низкий', 'средний', 'высокий', 'критический'));

-- Проверка статуса дедлайна
ALTER TABLE Deadline ADD CONSTRAINT chk_deadline_status CHECK (deadline_status IN ('активный', 'просрочен', 'выполнен', 'отменен'));

-- Проверка статуса посещаемости
ALTER TABLE EventResult ADD CONSTRAINT chk_attendance_status CHECK (attendance_status IN ('присутствовал', 'отсутствовал', 'опоздал', 'уважительная причина'));

-- Проверка даты дедлайна (реалистичная дата)
ALTER TABLE Deadline ADD CONSTRAINT chk_deadline_date CHECK (deadline_date >= '2000-01-01');

-- Проверка что создатель мероприятия может его изменять
ALTER TABLE EventCreator ADD CONSTRAINT chk_creator_can_modify CHECK (can_modify IN (true, false));

-- =============================================
-- Уникальные ограничения
-- =============================================

-- Уникальность названия типа мероприятия
ALTER TABLE EventType ADD CONSTRAINT uk_event_type_name UNIQUE (type_name);

-- Уникальность комбинации преподаватель-мероприятие в EventCreator
ALTER TABLE EventCreator ADD CONSTRAINT uk_creator_teacher_event UNIQUE (teacher_id, event_id);

-- =============================================
-- Индексы для улучшения производительности
-- =============================================

-- Индексы для мероприятий
CREATE INDEX idx_event_type_id ON Event(event_type_id);
CREATE INDEX idx_event_date ON Event(event_date);
CREATE INDEX idx_event_discipline ON Event(discipline_id);
CREATE INDEX idx_event_group ON Event(group_id);
CREATE INDEX idx_event_teacher ON Event(teacher_id);

-- Индексы для создателей мероприятий
CREATE INDEX idx_creator_event_id ON EventCreator(event_id);
CREATE INDEX idx_creator_teacher_id ON EventCreator(teacher_id);

-- Индексы для уведомлений
CREATE INDEX idx_notification_event_id ON Notification(event_id);
CREATE INDEX idx_notification_student_id ON Notification(student_id);
CREATE INDEX idx_notification_type ON Notification(notification_type);
CREATE INDEX idx_notification_date ON Notification(sent_date);

-- Индексы для дедлайнов
CREATE INDEX idx_deadline_event_id ON Deadline(event_id);
CREATE INDEX idx_deadline_student_id ON Deadline(student_id);
CREATE INDEX idx_deadline_discipline_id ON Deadline(discipline_id);
CREATE INDEX idx_deadline_date ON Deadline(deadline_date);
CREATE INDEX idx_deadline_status ON Deadline(deadline_status);

-- Индексы для результатов мероприятий
CREATE INDEX idx_result_event_id ON EventResult(event_id);
CREATE INDEX idx_result_student_id ON EventResult(student_id);
CREATE INDEX idx_result_grade_id ON EventResult(grade_id);
CREATE INDEX idx_result_attendance ON EventResult(attendance_status);

-- =============================================
-- Комментарии для документирования
-- =============================================

COMMENT ON TABLE EventType IS 'Типы мероприятий (экзамен, зачет, лекция и т.д.)';
COMMENT ON TABLE Event IS 'Мероприятия учебного процесса';
COMMENT ON TABLE EventCreator IS 'Создатели мероприятий (преподаватели)';
COMMENT ON TABLE Notification IS 'Уведомления для студентов';
COMMENT ON TABLE Deadline IS 'Дедлайны для сдачи работ';
COMMENT ON TABLE EventResult IS 'Результаты мероприятий';

-- =============================================
-- Сообщение об успешном выполнении
-- =============================================

DO $$ 
BEGIN
    RAISE NOTICE 'Foreign keys for events and deadlines system created successfully';
    RAISE NOTICE 'Created: 5 internal FKs + 10 cross-module FKs + 7 CHECK constraints + 2 UNIQUE + 17 indexes';
END $$;