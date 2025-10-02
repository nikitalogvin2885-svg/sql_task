USE master;
GO

-- Проверка и удаление базы данных, если она существует
IF DB_ID('SportsSectionDB') IS NOT NULL
BEGIN
    ALTER DATABASE SportsSectionDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SportsSectionDB;
END
GO

-- Создание базы данных
CREATE DATABASE SportsSectionDB;
GO

USE SportsSectionDB;
GO

-- Проверка и удаление таблицы, если она существует
IF OBJECT_ID('Achievements_Denormalized', 'U') IS NOT NULL
    DROP TABLE Achievements_Denormalized;
GO

-- =============================================
-- 1. Денормализованная таблица "Достижения спортсменов"
-- =============================================
CREATE TABLE Achievements_Denormalized (
    AchievementID INT IDENTITY(1,1) PRIMARY KEY,
    AthleteInfo NVARCHAR(200),
    CoachInfo NVARCHAR(150),
    CompetitionInfo NVARCHAR(200),
    AchievementDate NVARCHAR(50),
    AchievementType NVARCHAR(100),
    AchievementPlace INT,
    TrainingInfo NVARCHAR(150),
    Comments NVARCHAR(500)
);
GO

-- Заполнение денормализованной таблицы
INSERT INTO Achievements_Denormalized (
    AthleteInfo, CoachInfo, CompetitionInfo, AchievementDate, AchievementType,
    AchievementPlace, TrainingInfo, Comments
)
VALUES
('Иванов Петр Сергеевич; 1995-05-15; М; 180; 75; Плавание; Разряд: КМС',
 'Сидорова Анна Васильевна; Плавание; 15 лет опыта; Тренер высшей категории',
 'Чемпионат России; Москва; 2025-10-10; 2025-10-15; Бассейн "Олимпийский"',
 '2025-10-12',
 '1 место; 50м вольный стиль',
 1,
 'Тренировки: 5 раз в неделю; Индивидуальная программа',
 'Личный рекорд улучшен на 0.5 секунды'),

('Петрова Мария Ивановна; 2000-08-22; Ж; 170; 60; Лёгкая атлетика; Разряд: МС',
 'Кузнецов Дмитрий Александрович; Лёгкая атлетика; 10 лет опыта; Тренер 1 категории',
 'Кубок Москвы; Москва; 2025-10-18; 2025-10-20; Стадион "Лужники"',
 '2025-10-19',
 '2 место; 100м',
 2,
 'Тренировки: 6 раз в неделю; Групповые занятия',
 'Улучшение техники бега'),

('Смирнов Алексей Владимирович; 1998-11-30; М; 175; 70; Бокс; Разряд: ЗМС',
 'Васильева Ольга Петровна; Бокс; 20 лет опыта; Заслуженный тренер России',
 'Первенство мира; Екатеринбург; 2025-11-05; 2025-11-10; Дворец спорта "Урал"',
 '2025-11-08',
 '3 место; Весовая категория до 70 кг',
 3,
 'Тренировки: 6 раз в неделю; Спарринги 3 раза в неделю',
 'Подготовка к профессиональным боям');
GO

-- Просмотр денормализованных данных
SELECT * FROM Achievements_Denormalized;
GO

-- Проверка и удаление таблицы, если она существует
IF OBJECT_ID('Achievements_1NF', 'U') IS NOT NULL
    DROP TABLE Achievements_1NF;
GO

-- =============================================
-- 2. Нормализация до 1НФ
-- =============================================
CREATE TABLE Achievements_1NF (
    RecordID INT IDENTITY(1,1) PRIMARY KEY,
    AchievementID INT,
    AthleteFName NVARCHAR(50),
    AthleteMName NVARCHAR(50),
    AthleteLName NVARCHAR(50),
    AthleteBirthDate DATE,
    AthleteGender NVARCHAR(1),
    AthleteHeight INT,
    AthleteWeight INT,
    AthleteSport NVARCHAR(50),
    AthleteRank NVARCHAR(50),
    CoachFName NVARCHAR(50),
    CoachMName NVARCHAR(50),
    CoachLName NVARCHAR(50),
    CoachSport NVARCHAR(50),
    CoachExperience INT,
    CoachCategory NVARCHAR(100),
    CompetitionName NVARCHAR(100),
    CompetitionCity NVARCHAR(100),
    CompetitionStartDate DATE,
    CompetitionEndDate DATE,
    CompetitionVenue NVARCHAR(100),
    AchievementDate DATE,
    AchievementType NVARCHAR(100),
    AchievementPlace INT,
    TrainingFrequency NVARCHAR(50),
    TrainingProgram NVARCHAR(100),
    Comments NVARCHAR(500)
);
GO

-- Заполнение таблицы в 1НФ
INSERT INTO Achievements_1NF (
    AchievementID, AthleteFName, AthleteMName, AthleteLName, AthleteBirthDate, AthleteGender,
    AthleteHeight, AthleteWeight, AthleteSport, AthleteRank, CoachFName, CoachMName, CoachLName,
    CoachSport, CoachExperience, CoachCategory, CompetitionName, CompetitionCity,
    CompetitionStartDate, CompetitionEndDate, CompetitionVenue, AchievementDate,
    AchievementType, AchievementPlace, TrainingFrequency, TrainingProgram, Comments
)
SELECT
    AchievementID,
    PARSENAME(REPLACE(AthleteInfo, '; ', '.'), 3) AS AthleteFName,
    PARSENAME(REPLACE(AthleteInfo, '; ', '.'), 2) AS AthleteMName,
    PARSENAME(REPLACE(AthleteInfo, '; ', '.'), 1) AS AthleteLName,
    CAST(PARSENAME(REPLACE(AthleteInfo, '; ', '.'), 4) AS DATE) AS AthleteBirthDate,
    PARSENAME(REPLACE(AthleteInfo, '; ', '.'), 5) AS AthleteGender,
    CAST(PARSENAME(REPLACE(AthleteInfo, '; ', '.'), 6) AS INT) AS AthleteHeight,
    CAST(PARSENAME(REPLACE(AthleteInfo, '; ', '.'), 7) AS INT) AS AthleteWeight,
    PARSENAME(REPLACE(AthleteInfo, '; ', '.'), 8) AS AthleteSport,
    PARSENAME(REPLACE(AthleteInfo, '; ', '.'), 9) AS AthleteRank,
    PARSENAME(REPLACE(CoachInfo, '; ', '.'), 1) AS CoachFName,
    PARSENAME(REPLACE(CoachInfo, '; ', '.'), 2) AS CoachMName,
    PARSENAME(REPLACE(CoachInfo, '; ', '.'), 3) AS CoachLName,
    PARSENAME(REPLACE(CoachInfo, '; ', '.'), 4) AS CoachSport,
    CAST(PARSENAME(REPLACE(CoachInfo, '; ', '.'), 5) AS INT) AS CoachExperience,
    PARSENAME(REPLACE(CoachInfo, '; ', '.'), 6) AS CoachCategory,
    PARSENAME(REPLACE(CompetitionInfo, '; ', '.'), 1) AS CompetitionName,
    PARSENAME(REPLACE(CompetitionInfo, '; ', '.'), 2) AS CompetitionCity,
    CAST(PARSENAME(REPLACE(CompetitionInfo, '; ', '.'), 3) AS DATE) AS CompetitionStartDate,
    CAST(PARSENAME(REPLACE(CompetitionInfo, '; ', '.'), 4) AS DATE) AS CompetitionEndDate,
    PARSENAME(REPLACE(CompetitionInfo, '; ', '.'), 5) AS CompetitionVenue,
    CAST(AchievementDate AS DATE) AS AchievementDate,
    PARSENAME(REPLACE(AchievementType, '; ', '.'), 1) AS AchievementType,
    CAST(PARSENAME(REPLACE(AchievementType, '; ', '.'), 2) AS INT) AS AchievementPlace,
    PARSENAME(REPLACE(TrainingInfo, '; ', '.'), 1) AS TrainingFrequency,
    PARSENAME(REPLACE(TrainingInfo, '; ', '.'), 2) AS TrainingProgram,
    Comments
FROM Achievements_Denormalized;
GO

-- Просмотр данных в 1НФ
SELECT * FROM Achievements_1NF;
GO

-- Проверка и удаление таблиц, если они существуют
IF OBJECT_ID('Sports', 'U') IS NOT NULL DROP TABLE Sports;
IF OBJECT_ID('Ranks', 'U') IS NOT NULL DROP TABLE Ranks;
IF OBJECT_ID('CoachCategories', 'U') IS NOT NULL DROP TABLE CoachCategories;
IF OBJECT_ID('Athletes', 'U') IS NOT NULL DROP TABLE Athletes;
IF OBJECT_ID('Coaches', 'U') IS NOT NULL DROP TABLE Coaches;
IF OBJECT_ID('Competitions', 'U') IS NOT NULL DROP TABLE Competitions;
IF OBJECT_ID('Achievements', 'U') IS NOT NULL DROP TABLE Achievements;
GO

-- =============================================
-- 3. Нормализация до 3НФ (создание справочных таблиц)
-- =============================================
-- 1. Виды спорта
CREATE TABLE Sports (
    SportID INT IDENTITY(1,1) PRIMARY KEY,
    SportName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 2. Разряды спортсменов
CREATE TABLE Ranks (
    RankID INT IDENTITY(1,1) PRIMARY KEY,
    RankName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 3. Категории тренеров
CREATE TABLE CoachCategories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 4. Спортсмены
CREATE TABLE Athletes (
    AthleteID INT IDENTITY(1,1) PRIMARY KEY,
    FName NVARCHAR(50) NOT NULL,
    MName NVARCHAR(50),
    LName NVARCHAR(50) NOT NULL,
    BirthDate DATE,
    Gender NVARCHAR(1),
    Height INT,
    Weight INT,
    SportID INT NOT NULL,
    RankID INT NOT NULL,
    FOREIGN KEY (SportID) REFERENCES Sports(SportID),
    FOREIGN KEY (RankID) REFERENCES Ranks(RankID)
);
GO

-- 5. Тренеры
CREATE TABLE Coaches (
    CoachID INT IDENTITY(1,1) PRIMARY KEY,
    FName NVARCHAR(50) NOT NULL,
    MName NVARCHAR(50),
    LName NVARCHAR(50) NOT NULL,
    SportID INT NOT NULL,
    ExperienceYears INT,
    CategoryID INT NOT NULL,
    FOREIGN KEY (SportID) REFERENCES Sports(SportID),
    FOREIGN KEY (CategoryID) REFERENCES CoachCategories(CategoryID)
);
GO

-- 6. Соревнования
CREATE TABLE Competitions (
    CompetitionID INT IDENTITY(1,1) PRIMARY KEY,
    CompetitionName NVARCHAR(100) NOT NULL,
    City NVARCHAR(100),
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    Venue NVARCHAR(100)
);
GO

-- 7. Достижения
CREATE TABLE Achievements (
    AchievementID INT IDENTITY(1,1) PRIMARY KEY,
    AthleteID INT NOT NULL,
    CoachID INT NOT NULL,
    CompetitionID INT NOT NULL,
    AchievementDate DATE NOT NULL,
    AchievementType NVARCHAR(100) NOT NULL,
    AchievementPlace INT,
    Comments NVARCHAR(500),
    FOREIGN KEY (AthleteID) REFERENCES Athletes(AthleteID),
    FOREIGN KEY (CoachID) REFERENCES Coaches(CoachID),
    FOREIGN KEY (CompetitionID) REFERENCES Competitions(CompetitionID)
);
GO

-- Заполнение справочных таблиц
INSERT INTO Sports (SportName, Description)
VALUES
('Плавание', 'Плавательные виды спорта'),
('Лёгкая атлетика', 'Бег, прыжки и метания'),
('Бокс', 'Боевые единоборства');
GO

INSERT INTO Ranks (RankName, Description)
VALUES
('КМС', 'Кандидат в мастера спорта'),
('МС', 'Мастер спорта'),
('ЗМС', 'Заслуженный мастер спорта');
GO

INSERT INTO CoachCategories (CategoryName, Description)
VALUES
('Тренер высшей категории', 'Высшая квалификационная категория'),
('Тренер 1 категории', 'Первая квалификационная категория'),
('Заслуженный тренер России', 'Почетное звание');
GO

-- Заполнение основных таблиц
INSERT INTO Athletes (FName, MName, LName, BirthDate, Gender, Height, Weight, SportID, RankID)
VALUES
('Петр', 'Сергеевич', 'Иванов', '1995-05-15', 'М', 180, 75, 1, 1),
('Мария', 'Ивановна', 'Петрова', '2000-08-22', 'Ж', 170, 60, 2, 2),
('Алексей', 'Владимирович', 'Смирнов', '1998-11-30', 'М', 175, 70, 3, 3);
GO

INSERT INTO Coaches (FName, MName, LName, SportID, ExperienceYears, CategoryID)
VALUES
('Анна', 'Васильевна', 'Сидорова', 1, 15, 1),
('Дмитрий', 'Александрович', 'Кузнецов', 2, 10, 2),
('Ольга', 'Петровна', 'Васильева', 3, 20, 3);
GO

INSERT INTO Competitions (CompetitionName, City, StartDate, EndDate, Venue)
VALUES
('Чемпионат России', 'Москва', '2025-10-10', '2025-10-15', 'Бассейн "Олимпийский"'),
('Кубок Москвы', 'Москва', '2025-10-18', '2025-10-20', 'Стадион "Лужники"'),
('Первенство мира', 'Екатеринбург', '2025-11-05', '2025-11-10', 'Дворец спорта "Урал"');
GO

INSERT INTO Achievements (AthleteID, CoachID, CompetitionID, AchievementDate, AchievementType, AchievementPlace, Comments)
VALUES
(1, 1, 1, '2025-10-12', '1 место; 50м вольный стиль', 1, 'Личный рекорд улучшен на 0.5 секунды'),
(2, 2, 2, '2025-10-19', '2 место; 100м', 2, 'Улучшение техники бега'),
(3, 3, 3, '2025-11-08', '3 место; Весовая категория до 70 кг', 3, 'Подготовка к профессиональным боям');
GO

-- =============================================
-- 4. Аналитические запросы
-- =============================================
-- 1. Популярность видов спорта
PRINT '1. Популярность видов спорта:';
GO
SELECT
    s.SportName,
    COUNT(a.AchievementID) AS AchievementsCount,
    COUNT(DISTINCT a.AthleteID) AS AthletesCount
FROM Achievements a
JOIN Athletes ath ON a.AthleteID = ath.AthleteID
JOIN Sports s ON ath.SportID = s.SportID
GROUP BY s.SportName
ORDER BY AchievementsCount DESC;
GO

-- 2. Статистика по тренерам
PRINT '2. Статистика по тренерам:';
GO
SELECT
    CONCAT(c.FName, ' ', c.MName, ' ', c.LName) AS CoachName,
    s.SportName,
    cc.CategoryName,
    COUNT(a.AchievementID) AS AchievementsCount,
    COUNT(DISTINCT a.AthleteID) AS AthletesCount
FROM Achievements a
JOIN Coaches c ON a.CoachID = c.CoachID
JOIN Sports s ON c.SportID = s.SportID
JOIN CoachCategories cc ON c.CategoryID = cc.CategoryID
GROUP BY CONCAT(c.FName, ' ', c.MName, ' ', c.LName), s.SportName, cc.CategoryName, c.CoachID
ORDER BY AchievementsCount DESC;
GO

-- 3. Статистика по соревнованиям
PRINT '3. Статистика по соревнованиям:';
GO
SELECT
    comp.CompetitionName,
    comp.City,
    COUNT(a.AchievementID) AS AchievementsCount,
    COUNT(DISTINCT a.AthleteID) AS AthletesCount
FROM Achievements a
JOIN Competitions comp ON a.CompetitionID = comp.CompetitionID
GROUP BY comp.CompetitionName, comp.City
ORDER BY AchievementsCount DESC;
GO
ц