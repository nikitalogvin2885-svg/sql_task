-- 1. Проверка существования базы данных и её удаление, если она существует
IF DB_ID('SportsClubDB') IS NOT NULL
BEGIN
    ALTER DATABASE SportsClubDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SportsClubDB;
END;
GO

-- 2. Создание базы данных
CREATE DATABASE SportsClubDB;
GO

USE SportsClubDB;
GO

-- 3. Проверка существования таблиц и их удаление, если они существуют
IF OBJECT_ID('WorkoutAttendance', 'U') IS NOT NULL DROP TABLE WorkoutAttendance;
IF OBJECT_ID('Workouts', 'U') IS NOT NULL DROP TABLE Workouts;
IF OBJECT_ID('Memberships', 'U') IS NOT NULL DROP TABLE Memberships;
IF OBJECT_ID('Coaches', 'U') IS NOT NULL DROP TABLE Coaches;
IF OBJECT_ID('Members', 'U') IS NOT NULL DROP TABLE Members;
GO

-- 4. Таблица "Члены клуба"
CREATE TABLE Members (
    MemberID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    BirthDate DATE,
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    RegistrationDate DATE NOT NULL
);
GO

-- 5. Таблица "Тренеры"
CREATE TABLE Coaches (
    CoachID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    HireDate DATE NOT NULL,
    Specialization NVARCHAR(100)
);
GO

-- 6. Таблица "Абонементы"
CREATE TABLE Memberships (
    MembershipID INT IDENTITY(1,1) PRIMARY KEY,
    MemberID INT FOREIGN KEY REFERENCES Members(MemberID),
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    MembershipType NVARCHAR(50) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL
);
GO

-- 7. Таблица "Тренировки"
CREATE TABLE Workouts (
    WorkoutID INT IDENTITY(1,1) PRIMARY KEY,
    CoachID INT FOREIGN KEY REFERENCES Coaches(CoachID),
    WorkoutType NVARCHAR(100) NOT NULL,
    WorkoutDate DATE NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    Location NVARCHAR(100)
);
GO

-- 8. Таблица "Посещаемость тренировок"
CREATE TABLE WorkoutAttendance (
    AttendanceID INT IDENTITY(1,1) PRIMARY KEY,
    MemberID INT FOREIGN KEY REFERENCES Members(MemberID),
    WorkoutID INT FOREIGN KEY REFERENCES Workouts(WorkoutID),
    AttendanceDate DATE NOT NULL,
    Status NVARCHAR(20) CHECK (Status IN ('Present', 'Absent', 'Late'))
);
GO

-- 9. Заполнение тестовыми данными: Члены клуба
INSERT INTO Members (FirstName, LastName, BirthDate, Email, Phone, RegistrationDate) VALUES
('Иван', 'Иванов', '1990-05-15', 'ivan.ivanov@club.ru', '+79001112233', '2020-01-10'),
('Мария', 'Петрова', '1985-08-20', 'maria.petrova@club.ru', '+79002223344', '2019-05-15'),
('Алексей', 'Сидоров', '1995-03-10', 'alexey.sidorov@club.ru', '+79003334455', '2021-09-01'),
('Елена', 'Козлова', '1988-11-25', 'elena.kozlova@club.ru', '+79004445566', '2022-01-15'),
('Дмитрий', 'Васильев', '1992-07-12', 'dmitry.vasilyev@club.ru', '+79005556677', '2021-11-20');
GO

-- 10. Заполнение тестовыми данными: Тренеры
INSERT INTO Coaches (FirstName, LastName, Email, Phone, HireDate, Specialization) VALUES
('Петр', 'Смирнов', 'petr.smirnov@club.ru', '+79006667788', '2018-01-10', 'Фитнес'),
('Ольга', 'Кузнецова', 'olga.kuznetsova@club.ru', '+79007778899', '2017-03-15', 'Йога'),
('Сергей', 'Васильев', 'sergey.vasilyev@club.ru', '+79008889900', '2019-07-20', 'Плавание'),
('Ирина', 'Новикова', 'irina.novikova@club.ru', '+79009990011', '2020-05-10', 'Бокс');
GO

-- 11. Заполнение тестовыми данными: Абонементы
INSERT INTO Memberships (MemberID, StartDate, EndDate, MembershipType, Price) VALUES
(1, '2023-01-01', '2023-12-31', 'Годовой', 12000.00),
(2, '2023-06-01', '2023-06-30', 'Месячный', 2000.00),
(3, '2023-09-01', '2024-08-31', 'Годовой', 12000.00),
(4, '2023-01-15', '2023-07-15', 'Полугодовой', 7000.00),
(5, '2023-11-20', '2023-12-20', 'Месячный', 2000.00);
GO

-- 12. Заполнение тестовыми данными: Тренировки
INSERT INTO Workouts (CoachID, WorkoutType, WorkoutDate, StartTime, EndTime, Location) VALUES
(1, 'Фитнес', '2023-10-15', '09:00:00', '10:00:00', 'Зал 1'),
(2, 'Йога', '2023-10-16', '18:00:00', '19:00:00', 'Зал 2'),
(3, 'Плавание', '2023-10-17', '20:00:00', '21:00:00', 'Бассейн'),
(1, 'Фитнес', '2023-10-18', '10:00:00', '11:00:00', 'Зал 1'),
(4, 'Бокс', '2023-10-19', '19:00:00', '20:00:00', 'Зал 3'),
(2, 'Йога', '2023-10-20', '09:00:00', '10:00:00', 'Зал 2');
GO

-- 13. Заполнение тестовыми данными: Посещаемость тренировок
INSERT INTO WorkoutAttendance (MemberID, WorkoutID, AttendanceDate, Status) VALUES
(1, 1, '2023-10-15', 'Present'),
(2, 2, '2023-10-16', 'Present'),
(3, 3, '2023-10-17', 'Present'),
(1, 2, '2023-10-16', 'Absent'),
(2, 3, '2023-10-17', 'Late'),
(3, 1, '2023-10-15', 'Present'),
(4, 4, '2023-10-18', 'Present'),
(5, 5, '2023-10-19', 'Present'),
(1, 4, '2023-10-18', 'Present'),
(2, 5, '2023-10-19', 'Absent');
GO

-- 14. Вложенные запросы
-- 14.1. Скалярный подзапрос: Члены клуба с абонементами дороже средней стоимости
SELECT
    m.FirstName,
    m.LastName,
    (SELECT AVG(Price) FROM Memberships) AS AvgMembershipPrice,
    (SELECT Price FROM Memberships WHERE MemberID = m.MemberID) AS MemberMembershipPrice
FROM Members m
WHERE (SELECT Price FROM Memberships WHERE MemberID = m.MemberID) >
      (SELECT AVG(Price) FROM Memberships)
ORDER BY MemberMembershipPrice DESC;
GO

-- 14.2. Табличный подзапрос с IN: Тренеры, которые проводят тренировки в бассейне
SELECT DISTINCT
    c.FirstName,
    c.LastName,
    c.Specialization
FROM Coaches c
WHERE c.CoachID IN (
    SELECT w.CoachID
    FROM Workouts w
    WHERE w.Location = 'Бассейн'
);
GO

-- 14.3. Коррелированный подзапрос: Члены клуба, которые посетили больше тренировок, чем среднее количество посещений
SELECT
    m.FirstName,
    m.LastName,
    (SELECT COUNT(*) FROM WorkoutAttendance wa WHERE wa.MemberID = m.MemberID) AS AttendanceCount
FROM Members m
WHERE (SELECT COUNT(*) FROM WorkoutAttendance wa WHERE wa.MemberID = m.MemberID) >
      (SELECT AVG(attendance_count) FROM (
          SELECT COUNT(*) AS attendance_count
          FROM WorkoutAttendance
          GROUP BY MemberID
      ) AS avg_attendance);
GO

-- 14.4. EXISTS: Члены клуба, которые посетили тренировки по йоге
SELECT DISTINCT
    m.FirstName,
    m.LastName,
    m.Email
FROM Members m
WHERE EXISTS (
    SELECT 1
    FROM WorkoutAttendance wa
    JOIN Workouts w ON wa.WorkoutID = w.WorkoutID
    WHERE wa.MemberID = m.MemberID
    AND w.WorkoutType = 'Йога'
);
GO

-- 15. Курсоры
-- 15.1. Курсор: Члены клуба и их абонементы
DECLARE @MemberID INT, @FirstName NVARCHAR(50), @LastName NVARCHAR(50), @MembershipType NVARCHAR(50), @Price DECIMAL(10, 2);
DECLARE member_cursor CURSOR FOR
SELECT
    m.MemberID,
    m.FirstName,
    m.LastName,
    ms.MembershipType,
    ms.Price
FROM Members m
JOIN Memberships ms ON m.MemberID = ms.MemberID
ORDER BY m.LastName;
OPEN member_cursor;
FETCH NEXT FROM member_cursor INTO @MemberID, @FirstName, @LastName, @MembershipType, @Price;
WHILE @@FETCH_STATUS = 0
BEGIN
    FETCH NEXT FROM member_cursor INTO @MemberID, @FirstName, @LastName, @MembershipType, @Price;
END;
CLOSE member_cursor;
DEALLOCATE member_cursor;
GO

-- 15.2. Вложенные курсоры: Тренировки и их посещаемость
DECLARE @WorkoutID INT, @WorkoutType NVARCHAR(100), @WorkoutDate DATE, @StartTime TIME, @EndTime TIME;
DECLARE @MemberID INT, @FirstName NVARCHAR(50), @LastName NVARCHAR(50), @Status NVARCHAR(20);
DECLARE workout_cursor CURSOR FOR
SELECT WorkoutID, WorkoutType, WorkoutDate, StartTime, EndTime
FROM Workouts
ORDER BY WorkoutDate;
OPEN workout_cursor;
FETCH NEXT FROM workout_cursor INTO @WorkoutID, @WorkoutType, @WorkoutDate, @StartTime, @EndTime;
WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE attendance_cursor CURSOR LOCAL FOR
    SELECT wa.MemberID, m.FirstName, m.LastName, wa.Status
    FROM WorkoutAttendance wa
    JOIN Members m ON wa.MemberID = m.MemberID
    WHERE wa.WorkoutID = @WorkoutID
    ORDER BY m.LastName;
    OPEN attendance_cursor;
    FETCH NEXT FROM attendance_cursor INTO @MemberID, @FirstName, @LastName, @Status;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        FETCH NEXT FROM attendance_cursor INTO @MemberID, @FirstName, @LastName, @Status;
    END;
    CLOSE attendance_cursor;
    DEALLOCATE attendance_cursor;
    FETCH NEXT FROM workout_cursor INTO @WorkoutID, @WorkoutType, @WorkoutDate, @StartTime, @EndTime;
END;
CLOSE workout_cursor;
DEALLOCATE workout_cursor;
GO

-- 16. Создание индексов для оптимизации
CREATE INDEX IX_Members_RegistrationDate ON Members(RegistrationDate);
CREATE INDEX IX_Memberships_MemberID ON Memberships(MemberID);
CREATE INDEX IX_Memberships_StartDate ON Memberships(StartDate);
CREATE INDEX IX_Workouts_CoachID ON Workouts(CoachID);
CREATE INDEX IX_Workouts_WorkoutDate ON Workouts(WorkoutDate);
CREATE INDEX IX_WorkoutAttendance_MemberID ON WorkoutAttendance(MemberID);
CREATE INDEX IX_WorkoutAttendance_WorkoutID ON WorkoutAttendance(WorkoutID);
GO
