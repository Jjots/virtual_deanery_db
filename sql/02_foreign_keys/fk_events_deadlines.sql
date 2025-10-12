-- =============================================
-- FOREIGN KEYS для системы мероприятий
-- =============================================

-- Связь: Мероприятие → Тип мероприятия
ALTER TABLE Event ADD CONSTRAINT fk_event_event_type FOREIGN KEY (event_type_id) REFERENCES EventType(event_type_id);

-- Связь: Создатель мероприятия → Мероприятие
ALTER TABLE EventCreator ADD CONSTRAINT fk_creator_event FOREIGN KEY (event_id) REFERENCES Event(event_id);

-- Связь: Уведомление → Мероприятие
ALTER TABLE Notification ADD CONSTRAINT fk_notification_event FOREIGN KEY (event_id) REFERENCES Event(event_id);

-- Связь: Дедлайн → Мероприятие
ALTER TABLE Deadline ADD CONSTRAINT fk_deadline_event FOREIGN KEY (event_id) REFERENCES Event(event_id);

-- =============================================
-- ЗАКОММЕНТИРОВАННЫЕ внешние ключи (раскомментировать после создания таблиц)
-- =============================================

-- Связь: Создатель мероприятия → Преподаватель (таблица Teacher будет создана позже)
-- ALTER TABLE EventCreator ADD CONSTRAINT fk_creator_teacher FOREIGN KEY (teacher_id) REFERENCES Teacher(teacher_id);

-- Связь: Уведомление → Студент (таблица Student будет создана позже)
-- ALTER TABLE Notification ADD CONSTRAINT fk_notification_student FOREIGN KEY (student_id) REFERENCES Student(student_id);

-- Связь: Дедлайн → Студент (таблица Student будет создана позже)
-- ALTER TABLE Deadline ADD CONSTRAINT fk_deadline_student FOREIGN KEY (student_id) REFERENCES Student(student_id);

-- =============================================
-- Ограничения для целостности данных
-- =============================================

-- Проверка уровня важности типа мероприятия
ALTER TABLE EventType ADD CONSTRAINT chk_event_type_importance CHECK (importance_level >= 1 AND importance_level <= 10);

-- Проверка даты мероприятия (не в прошлом при создании)
ALTER TABLE Event ADD CONSTRAINT chk_event_date CHECK (event_date >= CURRENT_DATE);

-- Проверка типа уведомления
ALTER TABLE Notification ADD CONSTRAINT chk_notification_type CHECK (notification_type IN ('напоминание', 'результат', 'изменение', 'отмена'));

-- Проверка приоритета дедлайна
ALTER TABLE Deadline ADD CONSTRAINT chk_deadline_priority CHECK (deadline_priority IN ('низкий', 'средний', 'высокий', 'критический'));

-- Проверка статуса дедлайна
ALTER TABLE Deadline ADD CONSTRAINT chk_deadline_status CHECK (deadline_status IN ('активный', 'просрочен', 'выполнен', 'отменен'));

-- Проверка статуса посещаемости
ALTER TABLE EventResult ADD CONSTRAINT chk_attendance_status CHECK (attendance_status IN ('присутствовал', 'отсутствовал', 'опоздал', 'уважительная причина'));

-- Проверка даты дедлайна
ALTER TABLE Deadline ADD CONSTRAINT chk_deadline_date CHECK (deadline_date >= CURRENT_DATE);

-- Проверка даты отправки уведомления
ALTER TABLE Notification ADD CONSTRAINT chk_notification_date CHECK (sent_date <= CURRENT_TIMESTAMP);

-- =============================================
-- Индексы
-- =============================================

-- Основные индексы для мероприятий
CREATE INDEX idx_event_type_id ON Event(event_type_id);
CREATE INDEX idx_event_date ON Event(event_date);

-- Индексы для создателей мероприятий
CREATE INDEX idx_creator_event_id ON EventCreator(event_id);

-- Индексы для уведомлений
CREATE INDEX idx_notification_event_id ON Notification(event_id);
CREATE INDEX idx_notification_type ON Notification(notification_type);
CREATE INDEX idx_notification_date ON Notification(sent_date);

-- Индексы для дедлайнов
CREATE INDEX idx_deadline_event_id ON Deadline(event_id);
CREATE INDEX idx_deadline_date ON Deadline(deadline_date);
CREATE INDEX idx_deadline_status ON Deadline(deadline_status);

-- Индексы для результатов мероприятий
CREATE INDEX idx_result_event_id ON EventResult(event_id);
CREATE INDEX idx_result_attendance ON EventResult(attendance_status);

-- Уникальность названия типа мероприятия
CREATE UNIQUE INDEX uk_event_type_name ON EventType(type_name);

-- =============================================
-- ЗАКОММЕНТИРОВАННЫЕ индексы (раскомментировать после создания внешних ключей)
-- =============================================

-- CREATE INDEX idx_creator_teacher_id ON EventCreator(teacher_id);
-- CREATE INDEX idx_notification_student_id ON Notification(student_id);
-- CREATE INDEX idx_deadline_student_id ON Deadline(student_id);

-- =============================================
-- Сообщение об успешном выполнении
-- =============================================

