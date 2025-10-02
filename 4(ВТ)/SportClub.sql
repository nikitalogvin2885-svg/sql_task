USE master;
GO

-- Удаление базы данных, если она существует
IF DB_ID('SportsClubDB') IS NOT NULL
    DROP DATABASE SportsClubDB;
GO

-- Создание базы данных
CREATE DATABASE SportsClubDB;
GO

USE SportsClubDB;
GO

-- Создание денормализованной таблицы занятий в спортивном клубе
CREATE TABLE ClubActivities_Denormalized (
    ActivityID INT IDENTITY(1,1) PRIMARY KEY,
    MemberInfo NVARCHAR(200),
    TrainerInfo NVARCHAR(150),
    ActivityDate DATETIME,
    ActivityType NVARCHAR(100),
    ActivityDuration INT,
    ActivityCost DECIMAL(10, 2),
    MembershipInfo NVARCHAR(150),
    VisitsCount INT,
    PaymentInfo NVARCHAR(150),
    Comments NVARCHAR(500)
);
GO

-- Заполнение денормализованной таблицы данными
INSERT INTO ClubActivities_Denormalized (
    MemberInfo, TrainerInfo, ActivityDate, ActivityType,
    ActivityDuration, ActivityCost, MembershipInfo, VisitsCount, PaymentInfo, Comments
)
VALUES
('Иванов Петр Сергеевич; +79123456789; ivanov@mail.ru; 1985-05-15; Премиум',
 'Сидорова Анна Васильевна; Йога, Пилатес',
 '2023-11-10 18:00:00',
 'Йога для начинающих',
 90, 800.00,
 'Премиум; 2023-01-15; 2023-12-31; Безлимит',
 45,
 'Банковская карта; 2023-11-01; 5000.00',
 'Первое занятие после болезни, нужна индивидуальная программа'),

('Петрова Мария Ивановна; +79234567890; petrova@mail.ru; 1990-08-22; Стандарт',
 'Кузнецов Дмитрий Александрович; Фитнес, Силовая подготовка',
 '2023-11-10 19:30:00',
 'Силовая тренировка',
 60, 600.00,
 'Стандарт; 2023-09-01; 2024-02-28; 12 посещений в месяц',
 28,
 'Наличные; 2023-10-15; 3000.00',
 'Проработать ноги, проблемы с коленями'),

('Смирнов Алексей Владимирович; +79345678901; smirnov@mail.ru; 1978-11-30; Семейный',
 'Васильева Ольга Петровна; Плавание, Аквааэробика',
 '2023-11-11 10:00:00',
 'Аквааэробика',
 45, 500.00,
 'Семейный; 2023-07-01; 2024-06-30; Безлимит для 2 человек',
 78,
 'Банковская карта; 2023-10-05; 8000.00',
 'Занимается с женой, нужны упражнения для спины'),

('Козлова Елена Сергеевна; +79456789012; kozlova@mail.ru; 1995-03-12; Студенческий',
 'Новиков Иван Михайлович; Танцы, Стретчинг',
 '2023-11-11 17:00:00',
 'Латиноамериканские танцы',
 60, 550.00,
 'Студенческий; 2023-09-01; 2024-08-31; 8 посещений в месяц',
 15,
 'Электронные деньги; 2023-09-20; 2500.00',
 'Новичок, нужна базовая программа'),

('Михайлов Андрей Дмитриевич; +79567890123; mihailov@mail.ru; 1982-07-18; Премиум',
 'Петрова Светлана Ивановна; Бокс, Боевые искусства',
 '2023-11-12 20:00:00',
 'Бокс для начинающих',
 90, 900.00,
 'Премиум; 2023-03-01; 2024-02-29; Безлимит + персональный тренер',
 120,
 'Банковская карта; 2023-10-10; 12000.00',
 'Занимается с персональным тренером 2 раза в неделю');
GO

-- Просмотр денормализованных данных
SELECT * FROM ClubActivities_Denormalized;
GO

-- Создание таблицы в 1НФ
CREATE TABLE ClubActivities_1NF (
    RecordID INT IDENTITY(1,1) PRIMARY KEY,
    ActivityID INT,
    MemberFName NVARCHAR(50),
    MemberMName NVARCHAR(50),
    MemberLName NVARCHAR(50),
    MemberPhone NVARCHAR(20),
    MemberEmail NVARCHAR(100),
    MemberBirthDate DATE,
    MembershipType NVARCHAR(50),
    TrainerFName NVARCHAR(50),
    TrainerMName NVARCHAR(50),
    TrainerLName NVARCHAR(50),
    TrainerSpecialization NVARCHAR(100),
    ActivityDate DATETIME,
    ActivityType NVARCHAR(100),
    ActivityDuration INT,
    ActivityCost DECIMAL(10, 2),
    MembershipStartDate DATE,
    MembershipEndDate DATE,
    MembershipVisitsLimit NVARCHAR(50),
    VisitsCount INT,
    PaymentMethod NVARCHAR(50),
    PaymentDate DATE,
    PaymentAmount DECIMAL(10, 2),
    Comments NVARCHAR(500)
);
GO

-- Заполнение таблицы в 1НФ (разбиваем составные значения)
INSERT INTO ClubActivities_1NF (
    ActivityID, MemberFName, MemberMName, MemberLName, MemberPhone, MemberEmail, MemberBirthDate, MembershipType,
    TrainerFName, TrainerMName, TrainerLName, TrainerSpecialization, ActivityDate, ActivityType,
    ActivityDuration, ActivityCost, MembershipStartDate, MembershipEndDate, MembershipVisitsLimit,
    VisitsCount, PaymentMethod, PaymentDate, PaymentAmount, Comments
)
-- Занятие 1
SELECT 1, 'Петр', 'Сергеевич', 'Иванов', '+79123456789', 'ivanov@mail.ru', '1985-05-15', 'Премиум',
       'Анна', 'Васильевна', 'Сидорова', 'Йога, Пилатес', '2023-11-10 18:00:00', 'Йога для начинающих',
       90, 800.00, '2023-01-15', '2023-12-31', 'Безлимит',
       45, 'Банковская карта', '2023-11-01', 5000.00, 'Первое занятие после болезни, нужна индивидуальная программа'

-- Занятие 2
UNION ALL
SELECT 2, 'Мария', 'Ивановна', 'Петрова', '+79234567890', 'petrova@mail.ru', '1990-08-22', 'Стандарт',
       'Дмитрий', 'Александрович', 'Кузнецов', 'Фитнес, Силовая подготовка', '2023-11-10 19:30:00', 'Силовая тренировка',
       60, 600.00, '2023-09-01', '2024-02-28', '12 посещений в месяц',
       28, 'Наличные', '2023-10-15', 3000.00, 'Проработать ноги, проблемы с коленями'

-- Занятие 3
UNION ALL
SELECT 3, 'Алексей', 'Владимирович', 'Смирнов', '+79345678901', 'smirnov@mail.ru', '1978-11-30', 'Семейный',
       'Ольга', 'Петровна', 'Васильева', 'Плавание, Аквааэробика', '2023-11-11 10:00:00', 'Аквааэробика',
       45, 500.00, '2023-07-01', '2024-06-30', 'Безлимит для 2 человек',
       78, 'Банковская карта', '2023-10-05', 8000.00, 'Занимается с женой, нужны упражнения для спины'

-- Занятие 4
UNION ALL
SELECT 4, 'Елена', 'Сергеевна', 'Козлова', '+79456789012', 'kozlova@mail.ru', '1995-03-12', 'Студенческий',
       'Иван', 'Михайлович', 'Новиков', 'Танцы, Стретчинг', '2023-11-11 17:00:00', 'Латиноамериканские танцы',
       60, 550.00, '2023-09-01', '2024-08-31', '8 посещений в месяц',
       15, 'Электронные деньги', '2023-09-20', 2500.00, 'Новичок, нужна базовая программа'

-- Занятие 5
UNION ALL
SELECT 5, 'Андрей', 'Дмитриевич', 'Михайлов', '+79567890123', 'mihailov@mail.ru', '1982-07-18', 'Премиум',
       'Светлана', 'Ивановна', 'Петрова', 'Бокс, Боевые искусства', '2023-11-12 20:00:00', 'Бокс для начинающих',
       90, 900.00, '2023-03-01', '2024-02-29', 'Безлимит + персональный тренер',
       120, 'Банковская карта', '2023-10-10', 12000.00, 'Занимается с персональным тренером 2 раза в неделю';
GO

-- Просмотр данных в 1НФ
SELECT * FROM ClubActivities_1NF;
GO

-- Создание справочных таблиц

-- 1. Типы абонементов
CREATE TABLE MembershipTypes (
    MembershipTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200),
    BasePrice DECIMAL(10, 2),
    DurationMonths INT,
    VisitsLimit NVARCHAR(50)
);
GO

-- 2. Члены клуба
CREATE TABLE Members (
    MemberID INT IDENTITY(1,1) PRIMARY KEY,
    FName NVARCHAR(50) NOT NULL,
    MName NVARCHAR(50),
    LName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    BirthDate DATE,
    RegistrationDate DATETIME DEFAULT GETDATE(),
    MembershipTypeID INT,
    FOREIGN KEY (MembershipTypeID) REFERENCES MembershipTypes(MembershipTypeID)
);
GO

-- 3. Тренеры
CREATE TABLE Trainers (
    TrainerID INT IDENTITY(1,1) PRIMARY KEY,
    FName NVARCHAR(50) NOT NULL,
    MName NVARCHAR(50),
    LName NVARCHAR(50) NOT NULL,
    Specialization NVARCHAR(200),
    HireDate DATE,
    Salary DECIMAL(10, 2)
);
GO

-- 4. Типы занятий
CREATE TABLE ActivityTypes (
    ActivityTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    StandardDuration INT,  -- в минутах
    BasePrice DECIMAL(10, 2)
);
GO

-- 5. Абонементы
CREATE TABLE Memberships (
    MembershipID INT IDENTITY(1,1) PRIMARY KEY,
    MemberID INT NOT NULL,
    MembershipTypeID INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    VisitsLimit NVARCHAR(50),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (MembershipTypeID) REFERENCES MembershipTypes(MembershipTypeID)
);
GO

-- 6. Занятия
CREATE TABLE Activities (
    ActivityID INT IDENTITY(1,1) PRIMARY KEY,
    ActivityTypeID INT NOT NULL,
    TrainerID INT,
    ScheduledDate DATETIME NOT NULL,
    Duration INT,
    Price DECIMAL(10, 2),
    MaxParticipants INT,
    FOREIGN KEY (ActivityTypeID) REFERENCES ActivityTypes(ActivityTypeID),
    FOREIGN KEY (TrainerID) REFERENCES Trainers(TrainerID)
);
GO

-- 7. Посещения
CREATE TABLE Visits (
    VisitID INT IDENTITY(1,1) PRIMARY KEY,
    ActivityID INT NOT NULL,
    MemberID INT NOT NULL,
    MembershipID INT,
    ActualDate DATETIME NOT NULL,
    Comments NVARCHAR(500),
    FOREIGN KEY (ActivityID) REFERENCES Activities(ActivityID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (MembershipID) REFERENCES Memberships(MembershipID)
);
GO

-- 8. Способы оплаты
CREATE TABLE PaymentMethods (
    PaymentMethodID INT IDENTITY(1,1) PRIMARY KEY,
    MethodName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 9. Платежи
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    MemberID INT NOT NULL,
    MembershipID INT,
    PaymentMethodID INT NOT NULL,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    Description NVARCHAR(200),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (MembershipID) REFERENCES Memberships(MembershipID),
    FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethods(PaymentMethodID)
);
GO

-- Заполнение справочных таблиц

-- 1. Типы абонементов
INSERT INTO MembershipTypes (TypeName, Description, BasePrice, DurationMonths, VisitsLimit)
VALUES
('Премиум', 'Безлимитный абонемент с персональным тренером', 5000.00, 12, 'Безлимит'),
('Стандарт', 'Абонемент на 12 посещений в месяц', 3000.00, 6, '12 посещений в месяц'),
('Студенческий', 'Абонемент для студентов с ограничением по посещениям', 2500.00, 12, '8 посещений в месяц'),
('Семейный', 'Абонемент для семьи из 2 человек', 8000.00, 12, 'Безлимит для 2 человек');
GO

-- Вывод данных из MembershipTypes
SELECT * FROM MembershipTypes;
GO

-- 2. Типы занятий
INSERT INTO ActivityTypes (TypeName, Description, StandardDuration, BasePrice)
VALUES
('Йога для начинающих', 'Занятия йогой для новичков', 90, 800.00),
('Силовая тренировка', 'Тренировки с отягощениями', 60, 600.00),
('Аквааэробика', 'Аэробика в воде', 45, 500.00),
('Латиноамериканские танцы', 'Занятия латиноамериканскими танцами', 60, 550.00),
('Бокс для начинающих', 'Занятия боксом для новичков', 90, 900.00);
GO

-- Вывод данных из ActivityTypes
SELECT * FROM ActivityTypes;
GO

-- 3. Способы оплаты
INSERT INTO PaymentMethods (MethodName, Description)
VALUES
('Банковская карта', 'Оплата банковской картой через терминал'),
('Наличные', 'Оплата наличными в кассе клуба'),
('Электронные деньги', 'Оплата через электронные платежные системы');
GO

-- Вывод данных из PaymentMethods
SELECT * FROM PaymentMethods;
GO

-- 4. Члены клуба
INSERT INTO Members (FName, MName, LName, Phone, Email, BirthDate, MembershipTypeID)
VALUES
('Петр', 'Сергеевич', 'Иванов', '+79123456789', 'ivanov@mail.ru', '1985-05-15', 1),
('Мария', 'Ивановна', 'Петрова', '+79234567890', 'petrova@mail.ru', '1990-08-22', 2),
('Алексей', 'Владимирович', 'Смирнов', '+79345678901', 'smirnov@mail.ru', '1978-11-30', 4),
('Елена', 'Сергеевна', 'Козлова', '+79456789012', 'kozlova@mail.ru', '1995-03-12', 3),
('Андрей', 'Дмитриевич', 'Михайлов', '+79567890123', 'mihailov@mail.ru', '1982-07-18', 1);
GO

-- Вывод данных из Members
SELECT * FROM Members;
GO

-- 5. Тренеры
INSERT INTO Trainers (FName, MName, LName, Specialization, HireDate, Salary)
VALUES
('Анна', 'Васильевна', 'Сидорова', 'Йога, Пилатес', '2018-05-10', 45000.00),
('Дмитрий', 'Александрович', 'Кузнецов', 'Фитнес, Силовая подготовка', '2019-03-15', 50000.00),
('Ольга', 'Петровна', 'Васильева', 'Плавание, Аквааэробика', '2017-11-20', 48000.00),
('Иван', 'Михайлович', 'Новиков', 'Танцы, Стретчинг', '2020-01-05', 42000.00),
('Светлана', 'Ивановна', 'Петрова', 'Бокс, Боевые искусства', '2016-09-12', 55000.00);
GO

-- Вывод данных из Trainers
SELECT * FROM Trainers;
GO

-- 6. Абонементы
INSERT INTO Memberships (MemberID, MembershipTypeID, StartDate, EndDate, VisitsLimit)
VALUES
(1, 1, '2023-01-15', '2023-12-31', 'Безлимит'),
(2, 2, '2023-09-01', '2024-02-28', '12 посещений в месяц'),
(3, 4, '2023-07-01', '2024-06-30', 'Безлимит для 2 человек'),
(4, 3, '2023-09-01', '2024-08-31', '8 посещений в месяц'),
(5, 1, '2023-03-01', '2024-02-29', 'Безлимит + персональный тренер');
GO

-- Вывод данных из Memberships
SELECT * FROM Memberships;
GO

-- 7. Занятия
INSERT INTO Activities (ActivityTypeID, TrainerID, ScheduledDate, Duration, Price, MaxParticipants)
VALUES
(1, 1, '2023-11-10 18:00:00', 90, 800.00, 15),
(2, 2, '2023-11-10 19:30:00', 60, 600.00, 10),
(3, 3, '2023-11-11 10:00:00', 45, 500.00, 20),
(4, 4, '2023-11-11 17:00:00', 60, 550.00, 12),
(5, 5, '2023-11-12 20:00:00', 90, 900.00, 8);
GO

-- Вывод данных из Activities
SELECT * FROM Activities;
GO

-- 8. Посещения
INSERT INTO Visits (ActivityID, MemberID, MembershipID, ActualDate, Comments)
VALUES
(1, 1, 1, '2023-11-10 18:00:00', 'Первое занятие после болезни, нужна индивидуальная программа'),
(2, 2, 2, '2023-11-10 19:30:00', 'Проработать ноги, проблемы с коленями'),
(3, 3, 3, '2023-11-11 10:00:00', 'Занимается с женой, нужны упражнения для спины'),
(4, 4, 4, '2023-11-11 17:00:00', 'Новичок, нужна базовая программа'),
(5, 5, 5, '2023-11-12 20:00:00', 'Занимается с персональным тренером 2 раза в неделю');
GO

-- Вывод данных из Visits
SELECT * FROM Visits;
GO

-- 9. Платежи
INSERT INTO Payments (MemberID, MembershipID, PaymentMethodID, PaymentDate, Amount, Description)
VALUES
(1, 1, 1, '2023-11-01', 5000.00, 'Оплата абонемента Премиум на год'),
(2, 2, 3, '2023-10-15', 3000.00, 'Оплата абонемента Стандарт на 6 месяцев'),
(3, 3, 1, '2023-10-05', 8000.00, 'Оплата семейного абонемента на год'),
(4, 4, 3, '2023-09-20', 2500.00, 'Оплата студенческого абонемента на год'),
(5, 5, 1, '2023-10-10', 12000.00, 'Оплата абонемента Премиум с персональным тренером');
GO

-- Вывод данных из Payments
SELECT * FROM Payments;
GO

-- 1. Восстановление исходного представления (JOIN всех таблиц)
PRINT '1. Восстановление исходного представления:';
GO

SELECT
    v.VisitID AS ActivityID,
    CONCAT(m.FName, ' ', m.MName, ' ', m.LName, '; ', m.Phone, '; ', m.Email, '; ', m.BirthDate, '; ', mt.TypeName) AS MemberInfo,
    CONCAT(t.FName, ' ', t.MName, ' ', t.LName, '; ', t.Specialization) AS TrainerInfo,
    a.ScheduledDate AS ActivityDate,
    at.TypeName AS ActivityType,
    a.Duration AS ActivityDuration,
    a.Price AS ActivityCost,
    CONCAT(mt.TypeName, '; ', ms.StartDate, '; ', ms.EndDate, '; ', ms.VisitsLimit) AS MembershipInfo,
    (SELECT COUNT(*) FROM Visits WHERE MemberID = v.MemberID) AS VisitsCount,
    CONCAT(pm.MethodName, '; ', p.PaymentDate, '; ', p.Amount) AS PaymentInfo,
    v.Comments
FROM Visits v
JOIN Members m ON v.MemberID = m.MemberID
JOIN Trainers t ON a.TrainerID = t.TrainerID
JOIN Activities a ON v.ActivityID = a.ActivityID
JOIN ActivityTypes at ON a.ActivityTypeID = at.ActivityTypeID
JOIN Memberships ms ON v.MembershipID = ms.MembershipID
JOIN MembershipTypes mt ON ms.MembershipTypeID = mt.MembershipTypeID
JOIN Payments p ON v.MemberID = p.MemberID AND v.MembershipID = p.MembershipID
JOIN PaymentMethods pm ON p.PaymentMethodID = pm.PaymentMethodID;
GO

-- Исправленный запрос 1 с правильными JOIN
PRINT '1. Восстановление исходного представления (исправленный):';
GO

SELECT
    v.VisitID AS ActivityID,
    CONCAT(m.FName, ' ', m.MName, ' ', m.LName, '; ', m.Phone, '; ', m.Email, '; ', CONVERT(VARCHAR, m.BirthDate, 104), '; ', mt.TypeName) AS MemberInfo,
    CONCAT(t.FName, ' ', t.MName, ' ', t.LName, '; ', t.Specialization) AS TrainerInfo,
    a.ScheduledDate AS ActivityDate,
    at.TypeName AS ActivityType,
    a.Duration AS ActivityDuration,
    a.Price AS ActivityCost,
    CONCAT(mt.TypeName, '; ', CONVERT(VARCHAR, ms.StartDate, 104), '; ', CONVERT(VARCHAR, ms.EndDate, 104), '; ', ms.VisitsLimit) AS MembershipInfo,
    (SELECT COUNT(*) FROM Visits WHERE MemberID = v.MemberID) AS VisitsCount,
    (SELECT TOP 1 CONCAT(pm.MethodName, '; ', CONVERT(VARCHAR, p.PaymentDate, 104), '; ', p.Amount)
     FROM Payments p
     JOIN PaymentMethods pm ON p.PaymentMethodID = pm.PaymentMethodID
     WHERE p.MemberID = v.MemberID AND p.MembershipID = v.MembershipID
     ORDER BY p.PaymentDate DESC) AS PaymentInfo,
    v.Comments
FROM Visits v
JOIN Members m ON v.MemberID = m.MemberID
JOIN Activities a ON v.ActivityID = a.ActivityID
JOIN Trainers t ON a.TrainerID = t.TrainerID
JOIN ActivityTypes at ON a.ActivityTypeID = at.ActivityTypeID
JOIN Memberships ms ON v.MembershipID = ms.MembershipID
JOIN MembershipTypes mt ON ms.MembershipTypeID = mt.MembershipTypeID;
GO

-- 2. Аналитический запрос: Популярность типов занятий
PRINT '2. Популярность типов занятий:';
GO

SELECT
    at.TypeName AS ActivityType,
    COUNT(v.VisitID) AS VisitsCount,
    SUM(a.Price) AS TotalRevenue
FROM Visits v
JOIN Activities a ON v.ActivityID = a.ActivityID
JOIN ActivityTypes at ON a.ActivityTypeID = at.ActivityTypeID
GROUP BY at.TypeName
ORDER BY VisitsCount DESC;
GO

-- 3. Аналитический запрос: Статистика по абонементам
PRINT '3. Статистика по абонементам:';
GO

SELECT
    mt.TypeName AS MembershipType,
    COUNT(ms.MembershipID) AS MembershipsCount,
    SUM(p.Amount) AS TotalRevenue,
    AVG(p.Amount) AS AvgPayment
FROM Memberships ms
JOIN MembershipTypes mt ON ms.MembershipTypeID = mt.MembershipTypeID
JOIN Payments p ON ms.MembershipID = p.MembershipID
GROUP BY mt.TypeName
ORDER BY TotalRevenue DESC;
GO

-- 4. Аналитический запрос: Загруженность тренеров
PRINT '4. Загруженность тренеров:';
GO

SELECT
    CONCAT(t.FName, ' ', t.MName, ' ', t.LName) AS TrainerName,
    t.Specialization,
    COUNT(v.VisitID) AS ActivitiesCount,
    SUM(a.Duration) AS TotalMinutes,
    COUNT(DISTINCT m.MemberID) AS UniqueMembers
FROM Visits v
JOIN Activities a ON v.ActivityID = a.ActivityID
JOIN Trainers t ON a.TrainerID = t.TrainerID
JOIN Members m ON v.MemberID = m.MemberID
GROUP BY CONCAT(t.FName, ' ', t.MName, ' ', t.LName), t.Specialization, t.TrainerID
ORDER BY ActivitiesCount DESC;
GO

-- 5. Аналитический запрос: Демографический анализ членов клуба
PRINT '5. Демографический анализ членов клуба:';
GO

SELECT
    mt.TypeName AS MembershipType,
    COUNT(m.MemberID) AS MembersCount,
    AVG(DATEDIFF(YEAR, m.BirthDate, GETDATE())) AS AvgAge,
    MIN(DATEDIFF(YEAR, m.BirthDate, GETDATE())) AS MinAge,
    MAX(DATEDIFF(YEAR, m.BirthDate, GETDATE())) AS MaxAge
FROM Members m
JOIN Memberships ms ON m.MemberID = ms.MemberID
JOIN MembershipTypes mt ON ms.MembershipTypeID = mt.MembershipTypeID
GROUP BY mt.TypeName
ORDER BY MembersCount DESC;
GO
