CREATE DATABASE FitnessCenterDB;
GO

USE FitnessCenterDB;
GO

CREATE TABLE Cities (
    CityID INT PRIMARY KEY IDENTITY(1,1),
    CityName NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE Members (
    MemberID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    BirthDate DATE,
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    CityID INT,
    RegistrationDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CityID) REFERENCES Cities(CityID)
);
GO

CREATE TABLE Trainers (
    TrainerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    HireDate DATE,
    Specialization NVARCHAR(100)
);
GO

CREATE TABLE Subscriptions (
    SubscriptionID INT PRIMARY KEY IDENTITY(1,1),
    MemberID INT NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NOT NULL,
    SubscriptionType NVARCHAR(50) NOT NULL,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);
GO

CREATE TABLE Equipment (
    EquipmentID INT PRIMARY KEY IDENTITY(1,1),
    EquipmentName NVARCHAR(100) NOT NULL,
    PurchaseDate DATE,
    MaintenanceDate DATE,
    Status NVARCHAR(20) DEFAULT 'Working'
);
GO

CREATE TABLE GroupClasses (
    ClassID INT PRIMARY KEY IDENTITY(1,1),
    ClassName NVARCHAR(100) NOT NULL,
    TrainerID INT,
    Schedule DATETIME NOT NULL,
    Duration INT, 
    FOREIGN KEY (TrainerID) REFERENCES Trainers(TrainerID)
);
GO

CREATE TABLE Visits (
    VisitID INT PRIMARY KEY IDENTITY(1,1),
    MemberID INT NOT NULL,
    VisitDate DATETIME NOT NULL,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);
GO

CREATE TABLE ClassVisits (
    ClassVisitID INT PRIMARY KEY IDENTITY(1,1),
    ClassID INT NOT NULL,
    MemberID INT NOT NULL,
    VisitDate DATETIME NOT NULL,
    FOREIGN KEY (ClassID) REFERENCES GroupClasses(ClassID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);
GO

INSERT INTO Cities (CityName) VALUES
('Москва'), ('Санкт-Петербург'), ('Казань'), ('Новосибирск'), ('Екатеринбург');
GO

INSERT INTO Members (FirstName, LastName, BirthDate, Email, Phone, CityID) VALUES
('Иван', 'Иванов', '1990-05-15', 'ivan.ivanov@example.com', '+79123456789', 1),
('Петр', 'Петров', '1985-08-20', 'petr.petrov@example.com', '+79223456789', 2),
('Сидор', 'Сидоров', '1995-11-10', 'sidor.sidorov@example.com', '+79323456789', 3),
('Мария', 'Кузнецова', '1988-03-25', 'maria.kuznetsova@example.com', '+79423456789', 4),
('Анна', 'Васильева', '1992-07-18', 'anna.vasilyeva@example.com', '+79523456789', 5);
GO

INSERT INTO Trainers (FirstName, LastName, Email, Phone, HireDate, Specialization) VALUES
('Алексей', 'Смирнов', 'alexey.smirnov@example.com', '+79134567890', '2018-01-10', 'Фитнес'),
('Ольга', 'Кузнецова', 'olga.kuznetsova@example.com', '+79234567890', '2019-03-15', 'Йога'),
('Дмитрий', 'Попов', 'dmitry.popov@example.com', '+79334567890', '2017-05-20', 'Бокс'),
('Елена', 'Иванова', 'elena.ivanova@example.com', '+79434567890', '2020-02-12', 'Пилатес');
GO

ALTER TABLE Subscriptions ALTER COLUMN StartDate DATE;
ALTER TABLE Subscriptions ALTER COLUMN EndDate DATE;
GO

INSERT INTO Subscriptions (MemberID, StartDate, EndDate, SubscriptionType) VALUES
(1, '2023-01-01', '2023-12-31', 'Годовой'),
(2, '2023-02-01', '2024-01-31', 'Годовой'),
(3, '2023-03-01', '2023-08-31', 'Полугодовой'),
(4, '2023-04-01', '2023-09-30', 'Полугодовой'),
(5, '2023-05-01', '2023-10-31', 'Полугодовой');
GO

INSERT INTO Equipment (EquipmentName, PurchaseDate, MaintenanceDate, Status) VALUES
('Беговая дорожка', '2020-01-15', '2023-01-10', 'Working'),
('Велотренажер', '2020-02-20', '2023-02-15', 'Working'),
('Силовой тренажер', '2020-03-10', '2023-03-05', 'Maintenance'),
('Гребной тренажер', '2020-04-25', '2023-04-20', 'Working'),
('Эллиптический тренажер', '2020-05-30', '2023-05-25', 'Working');
GO

INSERT INTO GroupClasses (ClassName, TrainerID, Schedule, Duration) VALUES
('Фитнес', 1, '2023-06-01T18:00:00', 60),
('Йога', 2, '2023-06-02T19:00:00', 75),
('Бокс', 3, '2023-06-03T20:00:00', 90),
('Пилатес', 4, '2023-06-04T18:30:00', 60);
GO

INSERT INTO ClassVisits (ClassID, MemberID, VisitDate) VALUES
(1, 1, '2023-06-01T18:00:00'),
(2, 2, '2023-06-02T19:00:00'),
(3, 3, '2023-06-03T20:00:00'),
(4, 4, '2023-06-04T18:30:00'),
(1, 5, '2023-06-01T18:00:00');
GO

INSERT INTO ClassVisits (ClassID, MemberID, VisitDate) VALUES
(1, 1, '2023-06-01 18:00:00'),
(2, 2, '2023-06-02 19:00:00'),
(3, 3, '2023-06-03 20:00:00'),
(4, 4, '2023-06-04 18:30:00'),
(1, 5, '2023-06-01 18:00:00');
GO

SELECT
    m.FirstName,
    m.LastName,
    DATEDIFF(DAY, s.StartDate, s.EndDate) AS SubscriptionDuration
FROM
    Members m
JOIN
    Subscriptions s ON m.MemberID = s.MemberID
WHERE
    DATEDIFF(DAY, s.StartDate, s.EndDate) > (SELECT AVG(DATEDIFF(DAY, StartDate, EndDate)) FROM Subscriptions);

SELECT
    t.FirstName,
    t.LastName,
    t.Specialization
FROM
    Trainers t
WHERE
    t.TrainerID IN (SELECT DISTINCT TrainerID FROM GroupClasses);

SELECT
    m.FirstName,
    m.LastName,
    (SELECT COUNT(*) FROM Visits v WHERE v.MemberID = m.MemberID) AS VisitCount
FROM
    Members m
WHERE
    (SELECT COUNT(*) FROM Visits v WHERE v.MemberID = m.MemberID) >
    (SELECT AVG(VisitCount) FROM (SELECT COUNT(*) AS VisitCount FROM Visits GROUP BY MemberID) AS AvgVisits);

SELECT
    m.FirstName,
    m.LastName,
    m.Email
FROM
    Members m
WHERE
    EXISTS (SELECT 1 FROM ClassVisits cv WHERE cv.MemberID = m.MemberID);

DECLARE @MemberID INT, @FirstName NVARCHAR(50), @LastName NVARCHAR(50), @SubscriptionType NVARCHAR(50);
DECLARE member_cursor CURSOR FOR
SELECT
    m.MemberID,
    m.FirstName,
    m.LastName,
    s.SubscriptionType
FROM
    Members m
JOIN
    Subscriptions s ON m.MemberID = s.MemberID;
OPEN member_cursor;
FETCH NEXT FROM member_cursor INTO @MemberID, @FirstName, @LastName, @SubscriptionType;
PRINT 'ИНФОРМАЦИЯ О ЧЛЕНАХ КЛУБА И ИХ АБОНЕМЕНТАХ';
PRINT '========================================';
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'ID: ' + CAST(@MemberID AS VARCHAR) + ', ' + @FirstName + ' ' + @LastName + ', Абонемент: ' + @SubscriptionType;
    FETCH NEXT FROM member_cursor INTO @MemberID, @FirstName, @LastName, @SubscriptionType;
END;
CLOSE member_cursor;
DEALLOCATE member_cursor;

DECLARE @TrainerID INT, @TrainerName NVARCHAR(100), @ClassName NVARCHAR(100), @Schedule DATETIME;
DECLARE trainer_cursor CURSOR FOR
SELECT TrainerID, FirstName + ' ' + LastName AS TrainerName FROM Trainers;
OPEN trainer_cursor;
FETCH NEXT FROM trainer_cursor INTO @TrainerID, @TrainerName;
PRINT 'ГРУППОВЫЕ ЗАНЯТИЯ ПО ТРЕНЕРАМ';
PRINT '============================';
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '';
    PRINT 'Тренер: ' + @TrainerName;
    PRINT '----------------------------------------';
    DECLARE class_cursor CURSOR LOCAL FOR
    SELECT ClassName, Schedule FROM GroupClasses WHERE TrainerID = @TrainerID;
    OPEN class_cursor;
    FETCH NEXT FROM class_cursor INTO @ClassName, @Schedule;
    IF @@FETCH_STATUS != 0
        PRINT '   Нет занятий';
    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT '   Занятие: ' + @ClassName + ', Время: ' + CONVERT(NVARCHAR(20), @Schedule, 120);
        FETCH NEXT FROM class_cursor INTO @ClassName, @Schedule;
    END;
    CLOSE class_cursor;
    DEALLOCATE class_cursor;
    FETCH NEXT FROM trainer_cursor INTO @TrainerID, @TrainerName;
END;
CLOSE trainer_cursor;
DEALLOCATE trainer_cursor;

DECLARE @EquipmentID INT, @EquipmentName NVARCHAR(100);
DECLARE equipment_cursor CURSOR FOR
SELECT EquipmentID, EquipmentName FROM Equipment WHERE Status = 'Maintenance' AND MaintenanceDate < GETDATE();
OPEN equipment_cursor;
FETCH NEXT FROM equipment_cursor INTO @EquipmentID, @EquipmentName;
PRINT 'ОБНОВЛЕНИЕ СТАТУСА ТРЕНАЖЕРОВ';
PRINT '==============================';
WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE Equipment
    SET Status = 'Working'
    WHERE EquipmentID = @EquipmentID;
    PRINT 'Тренажер: ' + @EquipmentName + ' - статус изменен на "Working"';
    FETCH NEXT FROM equipment_cursor INTO @EquipmentID, @EquipmentName;
END;
CLOSE equipment_cursor;
DEALLOCATE equipment_cursor;
PRINT 'Обновление завершено.';

CREATE INDEX IX_Members_CityID ON Members(CityID);
CREATE INDEX IX_Subscriptions_MemberID ON Subscriptions(MemberID);
CREATE INDEX IX_Visits_MemberID ON Visits(MemberID);
CREATE INDEX IX_GroupClasses_TrainerID ON GroupClasses(TrainerID);
CREATE INDEX IX_ClassVisits_ClassID ON ClassVisits(ClassID);
CREATE INDEX IX_ClassVisits_MemberID ON ClassVisits(MemberID);
