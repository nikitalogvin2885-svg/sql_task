USE master;
GO

-- Create database for sports club
IF DB_ID('SportsClubDB') IS NULL
    CREATE DATABASE SportClubDB;
GO

USE SportClubDB;
GO

-- Drop existing tables if they exist
IF OBJECT_ID('ClassVisits', 'U') IS NOT NULL DROP TABLE ClassVisits;
IF OBJECT_ID('Classes', 'U') IS NOT NULL DROP TABLE Classes;
IF OBJECT_ID('Subscriptions', 'U') IS NOT NULL DROP TABLE Subscriptions;
IF OBJECT_ID('Members', 'U') IS NOT NULL DROP TABLE Members;
IF OBJECT_ID('Trainers', 'U') IS NOT NULL DROP TABLE Trainers;
IF OBJECT_ID('Halls', 'U') IS NOT NULL DROP TABLE Halls;
GO

-- Create Halls table
CREATE TABLE Halls (
    HallID INT IDENTITY(1,1) PRIMARY KEY,
    HallName NVARCHAR(50) NOT NULL,
    Capacity INT NOT NULL CHECK (Capacity > 0),
    Equipment NVARCHAR(255),
    Floor NVARCHAR(20) NOT NULL
);
GO

-- Create Trainers table
CREATE TABLE Trainers (
    TrainerID INT IDENTITY(1,1) PRIMARY KEY,
    LastName NVARCHAR(50) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    MiddleName NVARCHAR(50),
    BirthDate DATE NOT NULL,
    Gender NVARCHAR(1) CHECK (Gender IN ('М', 'Ж')),
    Phone NVARCHAR(20) NOT NULL UNIQUE,
    Email NVARCHAR(100) UNIQUE,
    Specialization NVARCHAR(100) NOT NULL,
    Experience INT NOT NULL CHECK (Experience >= 0),
    Salary DECIMAL(10,2) NOT NULL CHECK (Salary > 0),
    HireDate DATETIME DEFAULT GETDATE()
);
GO

-- Create Members table
CREATE TABLE Members (
    MemberID INT IDENTITY(1,1) PRIMARY KEY,
    LastName NVARCHAR(50) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    MiddleName NVARCHAR(50),
    BirthDate DATE NOT NULL,
    Gender NVARCHAR(1) CHECK (Gender IN ('М', 'Ж')),
    Phone NVARCHAR(20) NOT NULL UNIQUE,
    Email NVARCHAR(100) UNIQUE,
    Address NVARCHAR(255),
    RegistrationDate DATETIME DEFAULT GETDATE(),
    Height DECIMAL(5,2),
    Weight DECIMAL(5,2)
);
GO

-- Create Subscriptions table
CREATE TABLE Subscriptions (
    SubscriptionID INT IDENTITY(1,1) PRIMARY KEY,
    MemberID INT NOT NULL,
    SubscriptionType NVARCHAR(50) NOT NULL,
    StartDate DATETIME NOT NULL DEFAULT GETDATE(),
    EndDate DATETIME NOT NULL,
    Price DECIMAL(10,2) NOT NULL CHECK (Price > 0),
    IsActive BIT DEFAULT 1,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);
GO

-- Create Classes table
CREATE TABLE Classes (
    ClassID INT IDENTITY(1,1) PRIMARY KEY,
    ClassName NVARCHAR(100) NOT NULL,
    TrainerID INT NOT NULL,
    HallID INT NOT NULL,
    ClassType NVARCHAR(50) NOT NULL,
    Schedule NVARCHAR(100) NOT NULL,
    Duration INT NOT NULL CHECK (Duration > 0),
    MaxParticipants INT NOT NULL CHECK (MaxParticipants > 0),
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
    FOREIGN KEY (TrainerID) REFERENCES Trainers(TrainerID),
    FOREIGN KEY (HallID) REFERENCES Halls(HallID)
);
GO

-- Create ClassVisits table (junction table for Members and Classes)
CREATE TABLE ClassVisits (
    VisitID INT IDENTITY(1,1) PRIMARY KEY,
    MemberID INT NOT NULL,
    ClassID INT NOT NULL,
    VisitDate DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (ClassID) REFERENCES Classes(ClassID)
);
GO

-- =============================================
-- POPULATE WITH TEST DATA
-- =============================================

-- Populate Halls table
INSERT INTO Halls (HallName, Capacity, Equipment, Floor) VALUES
('Основной зал', 30, 'Беговые дорожки, велотренажеры, силовые тренажеры, свободные веса', '1 этаж'),
('Зал йоги', 15, 'Коврики для йоги, фитболлы, реквизит для пилатеса', '2 этаж'),
('Зал групповых занятий', 25, 'Степ-платформы, гантели, фитнес-мячи', '1 этаж'),
('Кардио-зона', 20, 'Беговые дорожки, эллиптические тренажеры, велотренажеры', '1 этаж'),
('Зал боевых искусств', 10, 'Боксерские мешки, татами, перчатки', '2 этаж');
GO

-- Populate Trainers table
INSERT INTO Trainers (LastName, FirstName, MiddleName, BirthDate, Gender, Phone, Email, Specialization, Experience, Salary) VALUES
('Иванов', 'Алексей', 'Сергеевич', '1985-05-15', 'М', '+79151234567', 'alexey.ivanov@fitness.com', 'Персональные тренировки', 8, 60000),
('Петрова', 'Мария', 'Александровна', '1990-08-22', 'Ж', '+79219876543', 'maria.petrova@fitness.com', 'Йога и пилатес', 5, 50000),
('Сидоров', 'Дмитрий', 'Владимирович', '1988-03-10', 'М', '+79165550123', 'dmitry.sidorov@fitness.com', 'Функциональный тренинг', 6, 55000),
('Козлова', 'Анна', 'Ивановна', '1992-11-30', 'Ж', '+74957778888', 'anna.kozlova@fitness.com', 'Групповые программы', 4, 45000),
('Смирнов', 'Сергей', 'Андреевич', '1980-07-18', 'М', '+79031112222', 'sergey.smirnov@fitness.com', 'Бокс и боевые искусства', 10, 70000);
GO

-- Populate Members table
INSERT INTO Members (LastName, FirstName, MiddleName, BirthDate, Gender, Phone, Email, Address, Height, Weight) VALUES
('Васильев', 'Иван', 'Петрович', '1995-07-20', 'М', '+79112223344', 'ivan.vasilyev@email.com', 'ул. Ленина, 15, кв. 20', 180.5, 85.0),
('Соколова', 'Екатерина', 'Алексеевна', '1992-04-12', 'Ж', '+79265556677', 'ekaterina.sokolova@email.com', 'пр. Мира, 30, кв. 55', 165.0, 55.0),
('Новиков', 'Андрей', 'Викторович', '1988-11-05', 'М', '+79037778899', 'andrey.novikov@email.com', 'ул. Советская, 8, кв. 12', 178.0, 78.0),
('Морозова', 'Ольга', 'Сергеевна', '1990-09-18', 'Ж', '+79163334455', 'olga.morozova@email.com', 'ул. Пушкина, 10, кв. 3', 170.0, 62.0),
('Кузнецов', 'Дмитрий', 'Андреевич', '1985-02-25', 'М', '+79214445566', 'dmitry.kuznetsov@email.com', 'ул. Горького, 12, кв. 7', 185.0, 90.0),
('Попова', 'Наталья', 'Игоревна', '1993-06-30', 'Ж', '+79056667788', 'natalya.popova@email.com', 'ул. Чехова, 5, кв. 15', 168.0, 58.0);
GO

-- Populate Subscriptions table
INSERT INTO Subscriptions (MemberID, SubscriptionType, StartDate, EndDate, Price) VALUES
(1, 'Базовый', '2023-01-10', '2023-12-31', 25000),
(2, 'Премиум', '2023-02-15', '2024-02-14', 45000),
(3, 'Студенческий', '2023-03-01', '2023-08-31', 18000),
(4, 'Базовый', '2023-04-05', '2024-04-04', 25000),
(5, 'VIP', '2023-05-20', '2024-05-19', 60000),
(6, 'Премиум', '2023-06-10', '2024-06-09', 45000);
GO

-- Populate Classes table
INSERT INTO Classes (ClassName, TrainerID, HallID, ClassType, Schedule, Duration, MaxParticipants, Price) VALUES
('Йога для начинающих', 2, 2, 'Йога', 'Пн, Ср, Пт 18:00-19:00', 60, 15, 500),
('Функциональный тренинг', 3, 3, 'Фитнес', 'Вт, Чт 19:00-20:00', 60, 20, 600),
('Бокс', 5, 5, 'Боевые искусства', 'Пн, Ср, Пт 20:00-21:30', 90, 10, 700),
('Пилатес', 2, 2, 'Йога', 'Вт, Чт, Сб 10:00-11:00', 60, 12, 550),
('Зумба', 4, 3, 'Танцы', 'Ср, Пт 19:00-20:00', 60, 25, 450),
('Силовая тренировка', 1, 1, 'Фитнес', 'Пн, Ср, Пт 17:00-18:00', 60, 15, 650);
GO

-- Populate ClassVisits table
INSERT INTO ClassVisits (MemberID, ClassID, VisitDate) VALUES
(1, 1, '2023-10-15 18:00:00'),
(1, 6, '2023-10-17 17:00:00'),
(2, 1, '2023-10-15 18:00:00'),
(2, 4, '2023-10-17 10:00:00'),
(3, 2, '2023-10-16 19:00:00'),
(3, 5, '2023-10-18 19:00:00'),
(4, 1, '2023-10-17 18:00:00'),
(4, 4, '2023-10-19 10:00:00'),
(5, 2, '2023-10-18 19:00:00'),
(5, 6, '2023-10-20 17:00:00'),
(6, 3, '2023-10-19 20:00:00'),
(6, 5, '2023-10-20 19:00:00');
GO

-- =============================================
-- STAGE 1: BASIC TASKS (INNER JOIN)
-- =============================================
-- Task 1.1: Show list of classes with trainer names
SELECT c.ClassName, t.LastName + ' ' + LEFT(t.FirstName, 1) + '. ' + LEFT(t.MiddleName, 1) + '.' AS Trainer,
       c.ClassType, c.Schedule
FROM Classes c
INNER JOIN Trainers t ON c.TrainerID = t.TrainerID;
GO

-- Task 1.2: Show members with their subscriptions
SELECT m.LastName + ' ' + LEFT(m.FirstName, 1) + '. ' + LEFT(m.MiddleName, 1) + '.' AS Member,
       s.SubscriptionType, s.StartDate, s.EndDate, s.Price
FROM Members m
INNER JOIN Subscriptions s ON m.MemberID = s.MemberID;
GO

-- Task 1.3: Show class visits with member and class information
SELECT m.LastName + ' ' + LEFT(m.FirstName, 1) + '. ' + LEFT(m.MiddleName, 1) + '.' AS Member,
       c.ClassName, t.LastName + ' ' + LEFT(t.FirstName, 1) + '. ' + LEFT(t.MiddleName, 1) + '.' AS Trainer,
       cv.VisitDate
FROM ClassVisits cv
INNER JOIN Members m ON cv.MemberID = m.MemberID
INNER JOIN Classes c ON cv.ClassID = c.ClassID
INNER JOIN Trainers t ON c.TrainerID = t.TrainerID;
GO

-- =============================================
-- STAGE 2: LEFT JOIN TASKS
-- =============================================
-- Task 2.1: Show all trainers and their classes (including trainers without classes)
SELECT t.LastName + ' ' + LEFT(t.FirstName, 1) + '. ' + LEFT(t.MiddleName, 1) + '.' AS Trainer,
       t.Specialization, c.ClassName, c.Schedule
FROM Trainers t
LEFT JOIN Classes c ON t.TrainerID = c.TrainerID
ORDER BY t.LastName;
GO

-- Task 2.2: Show all members and their class visits (including members without visits)
SELECT m.LastName + ' ' + LEFT(m.FirstName, 1) + '. ' + LEFT(m.MiddleName, 1) + '.' AS Member,
       c.ClassName, cv.VisitDate
FROM Members m
LEFT JOIN ClassVisits cv ON m.MemberID = cv.MemberID
LEFT JOIN Classes c ON cv.ClassID = c.ClassID
ORDER BY m.LastName;
GO

-- =============================================
-- STAGE 3: RIGHT JOIN TASKS
-- =============================================
-- Task 3.1: Show all classes and their visits (including classes without visits)
SELECT c.ClassName, t.LastName + ' ' + LEFT(t.FirstName, 1) + '. ' + LEFT(t.MiddleName, 1) + '.' AS Trainer,
       cv.VisitDate, COUNT(cv.VisitID) AS VisitCount
FROM ClassVisits cv
RIGHT JOIN Classes c ON cv.ClassID = c.ClassID
LEFT JOIN Trainers t ON c.TrainerID = t.TrainerID
GROUP BY c.ClassID, c.ClassName, t.LastName, t.FirstName, t.MiddleName, cv.VisitDate
ORDER BY c.ClassName;
GO

-- =============================================
-- STAGE 4: FULL OUTER JOIN TASKS
-- =============================================
-- Task 4.1: Full join of members and subscriptions
SELECT COALESCE(m.LastName + ' ' + LEFT(m.FirstName, 1) + '.', 'No member') AS Member,
       COALESCE(s.SubscriptionType, 'No subscription') AS Subscription
FROM Members m
FULL OUTER JOIN Subscriptions s ON m.MemberID = s.MemberID
ORDER BY Member;
GO

-- =============================================
-- STAGE 5: MULTIPLE JOINS
-- =============================================
-- Task 5.1: Full information about class visits
SELECT
    m.LastName + ' ' + LEFT(m.FirstName, 1) + '. ' + LEFT(m.MiddleName, 1) + '.' AS Member,
    s.SubscriptionType,
    c.ClassName,
    t.LastName + ' ' + LEFT(t.FirstName, 1) + '. ' + LEFT(t.MiddleName, 1) + '.' AS Trainer,
    h.HallName,
    cv.VisitDate
FROM ClassVisits cv
INNER JOIN Members m ON cv.MemberID = m.MemberID
INNER JOIN Subscriptions s ON m.MemberID = s.MemberID AND s.IsActive = 1
INNER JOIN Classes c ON cv.ClassID = c.ClassID
INNER JOIN Trainers t ON c.TrainerID = t.TrainerID
INNER JOIN Halls h ON c.HallID = h.HallID
ORDER BY cv.VisitDate DESC;
GO

-- Task 5.2: Top 5 most popular classes
SELECT TOP 5
    c.ClassName,
    t.LastName + ' ' + LEFT(t.FirstName, 1) + '. ' + LEFT(t.MiddleName, 1) + '.' AS Trainer,
    COUNT(cv.VisitID) AS VisitCount,
    c.Schedule
FROM Classes c
INNER JOIN Trainers t ON c.TrainerID = t.TrainerID
INNER JOIN ClassVisits cv ON c.ClassID = cv.ClassID
GROUP BY c.ClassID, c.ClassName, t.LastName, t.FirstName, t.MiddleName, c.Schedule
ORDER BY VisitCount DESC;
GO

-- =============================================
-- STAGE 6: SELF JOIN
-- =============================================
-- Task 6.1: Find members with similar subscriptions
SELECT
    m1.LastName + ' ' + LEFT(m1.FirstName, 1) + '. ' + LEFT(m1.MiddleName, 1) + '.' AS Member1,
    m2.LastName + ' ' + LEFT(m2.FirstName, 1) + '. ' + LEFT(m2.MiddleName, 1) + '.' AS Member2,
    s1.SubscriptionType
FROM Members m1
INNER JOIN Subscriptions s1 ON m1.MemberID = s1.MemberID AND s1.IsActive = 1
INNER JOIN Subscriptions s2 ON s1.SubscriptionType = s2.SubscriptionType AND s2.IsActive = 1
INNER JOIN Members m2 ON s2.MemberID = m2.MemberID
WHERE m1.MemberID < m2.MemberID
ORDER BY s1.SubscriptionType, m1.LastName;
GO

-- =============================================
-- STAGE 7: AGGREGATE FUNCTIONS WITH JOIN
-- =============================================
-- Task 7.1: Statistics by subscription types
SELECT
    s.SubscriptionType,
    COUNT(DISTINCT m.MemberID) AS MemberCount,
    AVG(DATEDIFF(DAY, s.StartDate, s.EndDate)) AS AvgDurationDays,
    SUM(s.Price) AS TotalRevenue
FROM Subscriptions s
INNER JOIN Members m ON s.MemberID = m.MemberID
GROUP BY s.SubscriptionType
ORDER BY TotalRevenue DESC;
GO

-- Task 7.2: Class attendance analysis by day of week
SELECT
    DATENAME(WEEKDAY, cv.VisitDate) AS DayOfWeek,
    COUNT(cv.VisitID) AS VisitCount,
    COUNT(DISTINCT m.MemberID) AS UniqueMembers,
    COUNT(DISTINCT c.ClassID) AS UniqueClasses
FROM ClassVisits cv
INNER JOIN Members m ON cv.MemberID = m.MemberID
INNER JOIN Classes c ON cv.ClassID = c.ClassID
GROUP BY DATENAME(WEEKDAY, cv.VisitDate)
ORDER BY VisitCount DESC;
GO
