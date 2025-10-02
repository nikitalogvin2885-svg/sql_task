USE master;
GO

-- Проверка и удаление базы данных, если она существует
IF DB_ID('TennisClubDB') IS NOT NULL
BEGIN
    ALTER DATABASE TennisClubDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TennisClubDB;
END
GO

-- Создание базы данных
CREATE DATABASE TennisClubDB;
GO

USE TennisClubDB;
GO

-- Проверка и удаление таблицы, если она существует
IF OBJECT_ID('TennisEvents_Denormalized', 'U') IS NOT NULL
    DROP TABLE TennisEvents_Denormalized;
GO

-- =============================================
-- 1. Денормализованная таблица "Турниры и занятия"
-- =============================================
CREATE TABLE TennisEvents_Denormalized (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    PlayerInfo NVARCHAR(200),
    CoachInfo NVARCHAR(150),
    CourtInfo NVARCHAR(100),
    TournamentInfo NVARCHAR(200),
    EventDate NVARCHAR(50),
    EventType NVARCHAR(100),
    EventDuration INT,
    EventCost DECIMAL(10, 2),
    MembershipInfo NVARCHAR(150),
    MatchesCount INT,
    PaymentInfo NVARCHAR(150),
    Comments NVARCHAR(500)
);
GO

-- Заполнение денормализованной таблицы
INSERT INTO TennisEvents_Denormalized (
    PlayerInfo, CoachInfo, CourtInfo, TournamentInfo, EventDate, EventType,
    EventDuration, EventCost, MembershipInfo, MatchesCount, PaymentInfo, Comments
)
VALUES
('Иванов Петр Сергеевич; +79123456789; ivanov@mail.ru; 1995-05-15; Профессионал',
 'Сидорова Анна Васильевна; Тренер высшей категории; 10 лет опыта',
 'Корт 1; Хард; На улице; Освещение есть',
 'Открытый чемпионат Москвы; 2025-11-10; 2025-11-20; Призовой фонд: 500000',
 '2025-11-10 18:00:00',
 'Тренировка перед турниром',
 120, 3000.00,
 'Профессионал; 2025-01-15; 2025-12-31; Безлимит',
 45,
 'Банковская карта; 2025-11-01; 3000.00',
 'Подготовка к турниру, нужна работа над подачей'),

('Петрова Мария Ивановна; +79234567890; petrova@mail.ru; 2000-08-22; Любитель',
 'Кузнецов Дмитрий Александрович; Тренер 1 категории; 5 лет опыта',
 'Корт 2; Грунт; В помещении; Освещение есть',
 'Кубок района; 2025-11-15; 2025-11-25; Призовой фонд: 50000',
 '2025-11-12 19:30:00',
 'Групповая тренировка',
 90, 1500.00,
 'Любитель; 2025-09-01; 2026-02-28; 12 занятий в месяц',
 28,
 'Наличные; 2025-10-15; 1500.00',
 'Работа над ударами с задней линии'),

('Смирнов Алексей Владимирович; +79345678901; smirnov@mail.ru; 1998-11-30; Юниор',
 'Васильева Ольга Петровна; Тренер по работе с детьми; 8 лет опыта',
 'Корт 3; Трава; На улице; Освещения нет',
 'Юниорский турнир; 2025-11-20; 2025-11-30; Призовой фонд: 10000',
 '2025-11-15 10:00:00',
 'Индивидуальный урок',
 60, 2000.00,
 'Юниор; 2025-07-01; 2026-06-30; 8 занятий в месяц',
 15,
 'Банковская карта; 2025-10-05; 2000.00',
 'Подготовка к юниорскому турниру, нужна работа над подачей и сеткой');
GO

-- Просмотр денормализованных данных
SELECT * FROM TennisEvents_Denormalized;
GO

-- Проверка и удаление таблицы, если она существует
IF OBJECT_ID('TennisEvents_1NF', 'U') IS NOT NULL
    DROP TABLE TennisEvents_1NF;
GO

-- =============================================
-- 2. Нормализация до 1НФ
-- =============================================
CREATE TABLE TennisEvents_1NF (
    RecordID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT,
    PlayerFName NVARCHAR(50),
    PlayerMName NVARCHAR(50),
    PlayerLName NVARCHAR(50),
    PlayerPhone NVARCHAR(20),
    PlayerEmail NVARCHAR(100),
    PlayerBirthDate DATE,
    PlayerLevel NVARCHAR(50),
    CoachFName NVARCHAR(50),
    CoachMName NVARCHAR(50),
    CoachLName NVARCHAR(50),
    CoachCategory NVARCHAR(100),
    CoachExperience INT,
    CourtNumber NVARCHAR(10),
    CourtSurface NVARCHAR(50),
    CourtLocation NVARCHAR(50),
    CourtLighting BIT,
    TournamentName NVARCHAR(100),
    TournamentStartDate DATE,
    TournamentEndDate DATE,
    TournamentPrize NVARCHAR(100),
    EventDate DATETIME,
    EventType NVARCHAR(100),
    EventDuration INT,
    EventCost DECIMAL(10, 2),
    MembershipType NVARCHAR(50),
    MembershipStartDate DATE,
    MembershipEndDate DATE,
    MembershipVisitsLimit NVARCHAR(50),
    MatchesCount INT,
    PaymentMethod NVARCHAR(50),
    PaymentDate DATE,
    PaymentAmount DECIMAL(10, 2),
    Comments NVARCHAR(500)
);
GO

-- Заполнение таблицы в 1НФ
INSERT INTO TennisEvents_1NF (
    EventID, PlayerFName, PlayerMName, PlayerLName, PlayerPhone, PlayerEmail, PlayerBirthDate, PlayerLevel,
    CoachFName, CoachMName, CoachLName, CoachCategory, CoachExperience, CourtNumber, CourtSurface, CourtLocation, CourtLighting,
    TournamentName, TournamentStartDate, TournamentEndDate, TournamentPrize, EventDate, EventType,
    EventDuration, EventCost, MembershipType, MembershipStartDate, MembershipEndDate, MembershipVisitsLimit,
    MatchesCount, PaymentMethod, PaymentDate, PaymentAmount, Comments
)
SELECT
    EventID,
    PARSENAME(REPLACE(PlayerInfo, '; ', '.'), 3) AS PlayerFName,
    PARSENAME(REPLACE(PlayerInfo, '; ', '.'), 2) AS PlayerMName,
    PARSENAME(REPLACE(PlayerInfo, '; ', '.'), 1) AS PlayerLName,
    PARSENAME(REPLACE(PlayerInfo, '; ', '.'), 4) AS PlayerPhone,
    PARSENAME(REPLACE(PlayerInfo, '; ', '.'), 5) AS PlayerEmail,
    CAST(PARSENAME(REPLACE(PlayerInfo, '; ', '.'), 6) AS DATE) AS PlayerBirthDate,
    PARSENAME(REPLACE(PlayerInfo, '; ', '.'), 7) AS PlayerLevel,
    PARSENAME(REPLACE(CoachInfo, '; ', '.'), 1) AS CoachFName,
    PARSENAME(REPLACE(CoachInfo, '; ', '.'), 2) AS CoachMName,
    PARSENAME(REPLACE(CoachInfo, '; ', '.'), 3) AS CoachLName,
    PARSENAME(REPLACE(CoachInfo, '; ', '.'), 4) AS CoachCategory,
    CAST(PARSENAME(REPLACE(CoachInfo, '; ', '.'), 5) AS INT) AS CoachExperience,
    PARSENAME(REPLACE(CourtInfo, '; ', '.'), 1) AS CourtNumber,
    PARSENAME(REPLACE(CourtInfo, '; ', '.'), 2) AS CourtSurface,
    PARSENAME(REPLACE(CourtInfo, '; ', '.'), 3) AS CourtLocation,
    CASE WHEN PARSENAME(REPLACE(CourtInfo, '; ', '.'), 4) = 'Освещение есть' THEN 1 ELSE 0 END AS CourtLighting,
    PARSENAME(REPLACE(TournamentInfo, '; ', '.'), 1) AS TournamentName,
    CAST(PARSENAME(REPLACE(TournamentInfo, '; ', '.'), 2) AS DATE) AS TournamentStartDate,
    CAST(PARSENAME(REPLACE(TournamentInfo, '; ', '.'), 3) AS DATE) AS TournamentEndDate,
    PARSENAME(REPLACE(TournamentInfo, '; ', '.'), 4) AS TournamentPrize,
    CAST(EventDate AS DATETIME) AS EventDate,
    PARSENAME(REPLACE(TournamentInfo, '; ', '.'), 5) AS EventType,
    EventDuration, EventCost,
    PARSENAME(REPLACE(MembershipInfo, '; ', '.'), 1) AS MembershipType,
    CAST(PARSENAME(REPLACE(MembershipInfo, '; ', '.'), 2) AS DATE) AS MembershipStartDate,
    CAST(PARSENAME(REPLACE(MembershipInfo, '; ', '.'), 3) AS DATE) AS MembershipEndDate,
    PARSENAME(REPLACE(MembershipInfo, '; ', '.'), 4) AS MembershipVisitsLimit,
    MatchesCount,
    PARSENAME(REPLACE(PaymentInfo, '; ', '.'), 1) AS PaymentMethod,
    CAST(PARSENAME(REPLACE(PaymentInfo, '; ', '.'), 2) AS DATE) AS PaymentDate,
    CAST(PARSENAME(REPLACE(PaymentInfo, '; ', '.'), 3) AS DECIMAL(10, 2)) AS PaymentAmount,
    Comments
FROM TennisEvents_Denormalized;
GO

-- Просмотр данных в 1НФ
SELECT * FROM TennisEvents_1NF;
GO

-- Проверка и удаление таблиц, если они существуют
IF OBJECT_ID('PlayerLevels', 'U') IS NOT NULL DROP TABLE PlayerLevels;
IF OBJECT_ID('Players', 'U') IS NOT NULL DROP TABLE Players;
IF OBJECT_ID('CoachCategories', 'U') IS NOT NULL DROP TABLE CoachCategories;
IF OBJECT_ID('Coaches', 'U') IS NOT NULL DROP TABLE Coaches;
IF OBJECT_ID('CourtSurfaces', 'U') IS NOT NULL DROP TABLE CourtSurfaces;
IF OBJECT_ID('Courts', 'U') IS NOT NULL DROP TABLE Courts;
IF OBJECT_ID('Tournaments', 'U') IS NOT NULL DROP TABLE Tournaments;
IF OBJECT_ID('MembershipTypes', 'U') IS NOT NULL DROP TABLE MembershipTypes;
IF OBJECT_ID('Memberships', 'U') IS NOT NULL DROP TABLE Memberships;
IF OBJECT_ID('EventTypes', 'U') IS NOT NULL DROP TABLE EventTypes;
IF OBJECT_ID('Events', 'U') IS NOT NULL DROP TABLE Events;
IF OBJECT_ID('PaymentMethods', 'U') IS NOT NULL DROP TABLE PaymentMethods;
IF OBJECT_ID('Payments', 'U') IS NOT NULL DROP TABLE Payments;
GO

-- =============================================
-- 3. Нормализация до 3НФ (создание справочных таблиц)
-- =============================================
-- 1. Уровни игроков
CREATE TABLE PlayerLevels (
    LevelID INT IDENTITY(1,1) PRIMARY KEY,
    LevelName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 2. Игроки
CREATE TABLE Players (
    PlayerID INT IDENTITY(1,1) PRIMARY KEY,
    FName NVARCHAR(50) NOT NULL,
    MName NVARCHAR(50),
    LName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    BirthDate DATE,
    LevelID INT NOT NULL,
    FOREIGN KEY (LevelID) REFERENCES PlayerLevels(LevelID)
);
GO

-- 3. Категории тренеров
CREATE TABLE CoachCategories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 4. Тренеры
CREATE TABLE Coaches (
    CoachID INT IDENTITY(1,1) PRIMARY KEY,
    FName NVARCHAR(50) NOT NULL,
    MName NVARCHAR(50),
    LName NVARCHAR(50) NOT NULL,
    CategoryID INT NOT NULL,
    ExperienceYears INT,
    FOREIGN KEY (CategoryID) REFERENCES CoachCategories(CategoryID)
);
GO

-- 5. Типы покрытия кортов
CREATE TABLE CourtSurfaces (
    SurfaceID INT IDENTITY(1,1) PRIMARY KEY,
    SurfaceName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 6. Корт
CREATE TABLE Courts (
    CourtID INT IDENTITY(1,1) PRIMARY KEY,
    CourtNumber NVARCHAR(10) NOT NULL,
    SurfaceID INT NOT NULL,
    Location NVARCHAR(50) NOT NULL,
    HasLighting BIT,
    FOREIGN KEY (SurfaceID) REFERENCES CourtSurfaces(SurfaceID)
);
GO

-- 7. Турниры
CREATE TABLE Tournaments (
    TournamentID INT IDENTITY(1,1) PRIMARY KEY,
    TournamentName NVARCHAR(100) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    PrizeFund NVARCHAR(100)
);
GO

-- 8. Типы абонементов
CREATE TABLE MembershipTypes (
    MembershipTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200),
    VisitsLimit NVARCHAR(50)
);
GO

-- 9. Абонементы игроков
CREATE TABLE Memberships (
    MembershipID INT IDENTITY(1,1) PRIMARY KEY,
    PlayerID INT NOT NULL,
    MembershipTypeID INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID),
    FOREIGN KEY (MembershipTypeID) REFERENCES MembershipTypes(MembershipTypeID)
);
GO

-- 10. Типы событий (тренировка, матч, турнир)
CREATE TABLE EventTypes (
    EventTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 11. События (тренировки, матчи, турниры)
CREATE TABLE Events (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    PlayerID INT NOT NULL,
    CoachID INT,
    CourtID INT NOT NULL,
    TournamentID INT,
    EventTypeID INT NOT NULL,
    EventDate DATETIME NOT NULL,
    Duration INT,
    Cost DECIMAL(10, 2),
    FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID),
    FOREIGN KEY (CoachID) REFERENCES Coaches(CoachID),
    FOREIGN KEY (CourtID) REFERENCES Courts(CourtID),
    FOREIGN KEY (TournamentID) REFERENCES Tournaments(TournamentID),
    FOREIGN KEY (EventTypeID) REFERENCES EventTypes(EventTypeID)
);
GO

-- 12. Способы оплаты
CREATE TABLE PaymentMethods (
    PaymentMethodID INT IDENTITY(1,1) PRIMARY KEY,
    MethodName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 13. Платежи
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    PlayerID INT NOT NULL,
    EventID INT,
    PaymentMethodID INT NOT NULL,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    Description NVARCHAR(200),
    FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID),
    FOREIGN KEY (EventID) REFERENCES Events(EventID),
    FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethods(PaymentMethodID)
);
GO

-- Заполнение справочных таблиц
INSERT INTO PlayerLevels (LevelName, Description)
VALUES
('Профессионал', 'Игроки с профессиональным уровнем'),
('Любитель', 'Игроки-любители'),
('Юниор', 'Юниоры до 18 лет');
GO

INSERT INTO CoachCategories (CategoryName, Description)
VALUES
('Тренер высшей категории', 'Тренер с высшей категорией'),
('Тренер 1 категории', 'Тренер с первой категорией'),
('Тренер по работе с детьми', 'Тренер, специализирующийся на работе с детьми');
GO

INSERT INTO CourtSurfaces (SurfaceName, Description)
VALUES
('Хард', 'Твердое покрытие'),
('Грунт', 'Грунтовое покрытие'),
('Трава', 'Травяное покрытие');
GO

INSERT INTO EventTypes (TypeName, Description)
VALUES
('Тренировка', 'Индивидуальная или групповая тренировка'),
('Матч', 'Соревновательный матч'),
('Турнир', 'Участие в турнире');
GO

INSERT INTO PaymentMethods (MethodName, Description)
VALUES
('Банковская карта', 'Оплата банковской картой'),
('Наличные', 'Оплата наличными'),
('Электронные деньги', 'Оплата через электронные платежные системы');
GO

INSERT INTO MembershipTypes (TypeName, Description, VisitsLimit)
VALUES
('Профессионал', 'Безлимитный абонемент для профессионалов', 'Безлимит'),
('Любитель', 'Абонемент на 12 занятий в месяц', '12 занятий в месяц'),
('Юниор', 'Абонемент на 8 занятий в месяц', '8 занятий в месяц');
GO

-- Заполнение основных таблиц
INSERT INTO Players (FName, MName, LName, Phone, Email, BirthDate, LevelID)
VALUES
('Петр', 'Сергеевич', 'Иванов', '+79123456789', 'ivanov@mail.ru', '1995-05-15', 1),
('Мария', 'Ивановна', 'Петрова', '+79234567890', 'petrova@mail.ru', '2000-08-22', 2),
('Алексей', 'Владимирович', 'Смирнов', '+79345678901', 'smirnov@mail.ru', '1998-11-30', 3);
GO

INSERT INTO Coaches (FName, MName, LName, CategoryID, ExperienceYears)
VALUES
('Анна', 'Васильевна', 'Сидорова', 1, 10),
('Дмитрий', 'Александрович', 'Кузнецов', 2, 5),
('Ольга', 'Петровна', 'Васильева', 3, 8);
GO

INSERT INTO Courts (CourtNumber, SurfaceID, Location, HasLighting)
VALUES
('1', 1, 'На улице', 1),
('2', 2, 'В помещении', 1),
('3', 3, 'На улице', 0);
GO

INSERT INTO Tournaments (TournamentName, StartDate, EndDate, PrizeFund)
VALUES
('Открытый чемпионат Москвы', '2025-11-10', '2025-11-20', '500000'),
('Кубок района', '2025-11-15', '2025-11-25', '50000'),
('Юниорский турнир', '2025-11-20', '2025-11-30', '10000');
GO

INSERT INTO Memberships (PlayerID, MembershipTypeID, StartDate, EndDate)
VALUES
(1, 1, '2025-01-15', '2025-12-31'),
(2, 2, '2025-09-01', '2026-02-28'),
(3, 3, '2025-07-01', '2026-06-30');
GO

INSERT INTO Events (PlayerID, CoachID, CourtID, TournamentID, EventTypeID, EventDate, Duration, Cost)
VALUES
(1, 1, 1, 1, 1, '2025-11-10 18:00:00', 120, 3000.00),
(2, 2, 2, 2, 1, '2025-11-12 19:30:00', 90, 1500.00),
(3, 3, 3, 3, 1, '2025-11-15 10:00:00', 60, 2000.00);
GO

INSERT INTO Payments (PlayerID, EventID, PaymentMethodID, PaymentDate, Amount, Description)
VALUES
(1, 1, 1, '2025-11-01', 3000.00, 'Оплата тренировки перед турниром'),
(2, 2, 2, '2025-10-15', 1500.00, 'Оплата групповой тренировки'),
(3, 3, 1, '2025-10-05', 2000.00, 'Оплата индивидуального урока');
GO

-- =============================================
-- 4. Аналитические запросы
-- =============================================
-- 1. Популярность типов покрытия кортов
PRINT '1. Популярность типов покрытия кортов:';
GO
SELECT
    cs.SurfaceName AS CourtSurface,
    COUNT(e.EventID) AS EventsCount,
    SUM(e.Cost) AS TotalRevenue
FROM Events e
JOIN Courts c ON e.CourtID = c.CourtID
JOIN CourtSurfaces cs ON c.SurfaceID = cs.SurfaceID
GROUP BY cs.SurfaceName
ORDER BY EventsCount DESC;
GO

-- 2. Статистика по тренерам
PRINT '2. Статистика по тренерам:';
GO
SELECT
    CONCAT(c.FName, ' ', c.MName, ' ', c.LName) AS CoachName,
    cc.CategoryName AS CoachCategory,
    COUNT(e.EventID) AS EventsCount,
    SUM(e.Duration) AS TotalMinutes,
    COUNT(DISTINCT p.PlayerID) AS UniquePlayers
FROM Events e
JOIN Coaches c ON e.CoachID = c.CoachID
JOIN CoachCategories cc ON c.CategoryID = cc.CategoryID
JOIN Players p ON e.PlayerID = p.PlayerID
GROUP BY CONCAT(c.FName, ' ', c.MName, ' ', c.LName), cc.CategoryName, c.CoachID
ORDER BY EventsCount DESC;
GO

-- 3. Статистика по игрокам
PRINT '3. Статистика по игрокам:';
GO
SELECT
    CONCAT(p.FName, ' ', p.MName, ' ', p.LName) AS PlayerName,
    pl.LevelName AS PlayerLevel,
    COUNT(e.EventID) AS EventsCount,
    SUM(e.Duration) AS TotalMinutes,
    SUM(pay.Amount) AS TotalPayments
FROM Players p
JOIN PlayerLevels pl ON p.LevelID = pl.LevelID
JOIN Events e ON p.PlayerID = e.PlayerID
JOIN Payments pay ON p.PlayerID = pay.PlayerID AND e.EventID = pay.EventID
GROUP BY CONCAT(p.FName, ' ', p.MName, ' ', p.LName), pl.LevelName, p.PlayerID
ORDER BY TotalPayments DESC;
GO
