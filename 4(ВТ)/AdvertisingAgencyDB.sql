USE master;
GO

-- Проверка и удаление базы данных, если она существует
IF DB_ID('AdvertisingAgencyDB') IS NOT NULL
BEGIN
    ALTER DATABASE AdvertisingAgencyDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE AdvertisingAgencyDB;
END
GO

-- Создание базы данных
CREATE DATABASE AdvertisingAgencyDB;
GO

USE AdvertisingAgencyDB;
GO

-- Проверка и удаление таблицы, если она существует
IF OBJECT_ID('Campaigns_Denormalized', 'U') IS NOT NULL
    DROP TABLE Campaigns_Denormalized;
GO

-- =============================================
-- 1. Денормализованная таблица "Рекламные кампании"
-- =============================================
CREATE TABLE Campaigns_Denormalized (
    CampaignID INT IDENTITY(1,1) PRIMARY KEY,
    ClientInfo NVARCHAR(200),
    CampaignInfo NVARCHAR(200),
    CreativeInfo NVARCHAR(200),
    MediaPlanInfo NVARCHAR(200),
    Budget DECIMAL(12, 2),
    Comments NVARCHAR(500)
);
GO

-- Заполнение денормализованной таблицы
INSERT INTO Campaigns_Denormalized (
    ClientInfo, CampaignInfo, CreativeInfo, MediaPlanInfo, Budget, Comments
)
VALUES
('ООО "ТехноМир"; ИТ-решения; Иванов Иван Иванович; +79123456789; ivanov@techomir.ru',
 'Летняя распродажа; 2025-06-01; 2025-08-31; Продвижение новых ноутбуков; 5000000',
 'Баннеры; Видеоролики; Социальные сети; Instagram, Facebook, VK; 30 секунд; 15 секунд',
 'Телевидение: Первый канал, ТНТ; Радио: Авторадио, Европа Плюс; Онлайн: Яндекс, Google; 2025-06-01; 2025-08-31; 1000000; 2000000; 2000000',
 5000000.00,
 'Целевая аудитория: 18-35 лет; География: Москва, Санкт-Петербург'),

('АО "Здоровье"; Фармацевтика; Петрова Мария Сергеевна; +79234567890; petrova@zdorovie.ru',
 'Новый витаминный комплекс; 2025-09-01; 2025-11-30; Продвижение БАДов; 3000000',
 'Постеры; Видеоролики; Телевидение; 15 секунд; 30 секунд',
 'Телевидение: Россия 1, НТВ; Онлайн: Яндекс, Mail.ru; Социальные сети: Instagram, VK; 2025-09-01; 2025-11-30; 1500000; 1000000; 500000',
 3000000.00,
 'Целевая аудитория: 25-50 лет; География: Россия'),

('ИП Сидоров; Мебель; Сидоров Алексей Петрович; +79345678901; sidorov@mebel.ru',
 'Скидки на кухни; 2025-07-15; 2025-09-15; Продвижение кухонной мебели; 2000000',
 'Баннеры; Постеры; Онлайн; Яндекс, Google; 15 секунд',
 'Онлайн: Яндекс, Google; Социальные сети: Instagram, VK; Печатные СМИ: Аргументы и Факты; 2025-07-15; 2025-09-15; 1000000; 500000; 500000',
 2000000.00,
 'Целевая аудитория: 25-55 лет; География: Москва, область');
GO

-- Просмотр денормализованных данных
SELECT * FROM Campaigns_Denormalized;
GO

-- Проверка и удаление таблицы, если она существует
IF OBJECT_ID('Campaigns_1NF', 'U') IS NOT NULL
    DROP TABLE Campaigns_1NF;
GO

-- =============================================
-- 2. Нормализация до 1НФ
-- =============================================
CREATE TABLE Campaigns_1NF (
    RecordID INT IDENTITY(1,1) PRIMARY KEY,
    CampaignID INT,
    ClientName NVARCHAR(100),
    ClientIndustry NVARCHAR(100),
    ClientContactFName NVARCHAR(50),
    ClientContactMName NVARCHAR(50),
    ClientContactLName NVARCHAR(50),
    ClientPhone NVARCHAR(20),
    ClientEmail NVARCHAR(100),
    CampaignName NVARCHAR(100),
    CampaignStartDate DATE,
    CampaignEndDate DATE,
    CampaignGoal NVARCHAR(200),
    Budget DECIMAL(12, 2),
    CreativeType1 NVARCHAR(100),
    CreativeType2 NVARCHAR(100),
    CreativePlatform1 NVARCHAR(100),
    CreativePlatform2 NVARCHAR(100),
    CreativePlatform3 NVARCHAR(100),
    CreativeDuration1 INT,
    CreativeDuration2 INT,
    MediaChannel1 NVARCHAR(100),
    MediaChannel2 NVARCHAR(100),
    MediaChannel3 NVARCHAR(100),
    MediaChannel4 NVARCHAR(100),
    MediaStartDate DATE,
    MediaEndDate DATE,
    MediaBudgetTV DECIMAL(12, 2),
    MediaBudgetRadio DECIMAL(12, 2),
    MediaBudgetOnline DECIMAL(12, 2),
    TargetAudience NVARCHAR(100),
    TargetGeography NVARCHAR(200),
    Comments NVARCHAR(500)
);
GO

-- Заполнение таблицы в 1НФ
INSERT INTO Campaigns_1NF (
    CampaignID, ClientName, ClientIndustry, ClientContactFName, ClientContactMName, ClientContactLName,
    ClientPhone, ClientEmail, CampaignName, CampaignStartDate, CampaignEndDate, CampaignGoal, Budget,
    CreativeType1, CreativeType2, CreativePlatform1, CreativePlatform2, CreativePlatform3,
    CreativeDuration1, CreativeDuration2, MediaChannel1, MediaChannel2, MediaChannel3, MediaChannel4,
    MediaStartDate, MediaEndDate, MediaBudgetTV, MediaBudgetRadio, MediaBudgetOnline,
    TargetAudience, TargetGeography, Comments
)
SELECT
    CampaignID,
    PARSENAME(REPLACE(ClientInfo, '; ', '.'), 1) AS ClientName,
    PARSENAME(REPLACE(ClientInfo, '; ', '.'), 2) AS ClientIndustry,
    PARSENAME(REPLACE(ClientInfo, '; ', '.'), 3) AS ClientContactFName,
    PARSENAME(REPLACE(ClientInfo, '; ', '.'), 4) AS ClientContactMName,
    PARSENAME(REPLACE(ClientInfo, '; ', '.'), 5) AS ClientContactLName,
    PARSENAME(REPLACE(ClientInfo, '; ', '.'), 6) AS ClientPhone,
    PARSENAME(REPLACE(ClientInfo, '; ', '.'), 7) AS ClientEmail,
    PARSENAME(REPLACE(CampaignInfo, '; ', '.'), 1) AS CampaignName,
    CAST(PARSENAME(REPLACE(CampaignInfo, '; ', '.'), 2) AS DATE) AS CampaignStartDate,
    CAST(PARSENAME(REPLACE(CampaignInfo, '; ', '.'), 3) AS DATE) AS CampaignEndDate,
    PARSENAME(REPLACE(CampaignInfo, '; ', '.'), 4) AS CampaignGoal,
    Budget,
    PARSENAME(REPLACE(CreativeInfo, '; ', '.'), 1) AS CreativeType1,
    PARSENAME(REPLACE(CreativeInfo, '; ', '.'), 2) AS CreativeType2,
    PARSENAME(REPLACE(CreativeInfo, '; ', '.'), 3) AS CreativePlatform1,
    PARSENAME(REPLACE(CreativeInfo, '; ', '.'), 4) AS CreativePlatform2,
    PARSENAME(REPLACE(CreativeInfo, '; ', '.'), 5) AS CreativePlatform3,
    CAST(PARSENAME(REPLACE(CreativeInfo, '; ', '.'), 6) AS INT) AS CreativeDuration1,
    CAST(PARSENAME(REPLACE(CreativeInfo, '; ', '.'), 7) AS INT) AS CreativeDuration2,
    PARSENAME(REPLACE(MediaPlanInfo, '; ', '.'), 1) AS MediaChannel1,
    PARSENAME(REPLACE(MediaPlanInfo, '; ', '.'), 2) AS MediaChannel2,
    PARSENAME(REPLACE(MediaPlanInfo, '; ', '.'), 3) AS MediaChannel3,
    PARSENAME(REPLACE(MediaPlanInfo, '; ', '.'), 4) AS MediaChannel4,
    CAST(PARSENAME(REPLACE(MediaPlanInfo, '; ', '.'), 5) AS DATE) AS MediaStartDate,
    CAST(PARSENAME(REPLACE(MediaPlanInfo, '; ', '.'), 6) AS DATE) AS MediaEndDate,
    CAST(PARSENAME(REPLACE(MediaPlanInfo, '; ', '.'), 7) AS DECIMAL(12, 2)) AS MediaBudgetTV,
    CAST(PARSENAME(REPLACE(MediaPlanInfo, '; ', '.'), 8) AS DECIMAL(12, 2)) AS MediaBudgetRadio,
    CAST(PARSENAME(REPLACE(MediaPlanInfo, '; ', '.'), 9) AS DECIMAL(12, 2)) AS MediaBudgetOnline,
    PARSENAME(REPLACE(Comments, '; ', '.'), 1) AS TargetAudience,
    PARSENAME(REPLACE(Comments, '; ', '.'), 2) AS TargetGeography,
    Comments
FROM Campaigns_Denormalized;
GO

-- Просмотр данных в 1НФ
SELECT * FROM Campaigns_1NF;
GO

-- Проверка и удаление таблиц, если они существуют
IF OBJECT_ID('Clients', 'U') IS NOT NULL DROP TABLE Clients;
IF OBJECT_ID('Industries', 'U') IS NOT NULL DROP TABLE Industries;
IF OBJECT_ID('Campaigns', 'U') IS NOT NULL DROP TABLE Campaigns;
IF OBJECT_ID('CreativeTypes', 'U') IS NOT NULL DROP TABLE CreativeTypes;
IF OBJECT_ID('CreativePlatforms', 'U') IS NOT NULL DROP TABLE CreativePlatforms;
IF OBJECT_ID('MediaChannels', 'U') IS NOT NULL DROP TABLE MediaChannels;
IF OBJECT_ID('Creatives', 'U') IS NOT NULL DROP TABLE Creatives;
IF OBJECT_ID('MediaPlans', 'U') IS NOT NULL DROP TABLE MediaPlans;
GO

-- =============================================
-- 3. Нормализация до 3НФ (создание справочных таблиц)
-- =============================================
-- 1. Клиенты
CREATE TABLE Clients (
    ClientID INT IDENTITY(1,1) PRIMARY KEY,
    ClientName NVARCHAR(100) NOT NULL,
    IndustryID INT NOT NULL,
    ContactFName NVARCHAR(50),
    ContactMName NVARCHAR(50),
    ContactLName NVARCHAR(50),
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    FOREIGN KEY (IndustryID) REFERENCES Industries(IndustryID)
);
GO

-- 2. Отрасли
CREATE TABLE Industries (
    IndustryID INT IDENTITY(1,1) PRIMARY KEY,
    IndustryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 3. Рекламные кампании
CREATE TABLE Campaigns (
    CampaignID INT IDENTITY(1,1) PRIMARY KEY,
    ClientID INT NOT NULL,
    CampaignName NVARCHAR(100) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    Goal NVARCHAR(200),
    Budget DECIMAL(12, 2) NOT NULL,
    TargetAudience NVARCHAR(100),
    TargetGeography NVARCHAR(200),
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID)
);
GO

-- 4. Типы креативов
CREATE TABLE CreativeTypes (
    CreativeTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 5. Платформы для креативов
CREATE TABLE CreativePlatforms (
    PlatformID INT IDENTITY(1,1) PRIMARY KEY,
    PlatformName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 6. Креативы
CREATE TABLE Creatives (
    CreativeID INT IDENTITY(1,1) PRIMARY KEY,
    CampaignID INT NOT NULL,
    CreativeTypeID INT NOT NULL,
    PlatformID INT NOT NULL,
    Duration INT,
    FOREIGN KEY (CampaignID) REFERENCES Campaigns(CampaignID),
    FOREIGN KEY (CreativeTypeID) REFERENCES CreativeTypes(CreativeTypeID),
    FOREIGN KEY (PlatformID) REFERENCES CreativePlatforms(PlatformID)
);
GO

-- 7. Медиаканалы
CREATE TABLE MediaChannels (
    ChannelID INT IDENTITY(1,1) PRIMARY KEY,
    ChannelName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 8. Медиапланы
CREATE TABLE MediaPlans (
    MediaPlanID INT IDENTITY(1,1) PRIMARY KEY,
    CampaignID INT NOT NULL,
    ChannelID INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    Budget DECIMAL(12, 2) NOT NULL,
    FOREIGN KEY (CampaignID) REFERENCES Campaigns(CampaignID),
    FOREIGN KEY (ChannelID) REFERENCES MediaChannels(ChannelID)
);
GO

-- Заполнение справочных таблиц
INSERT INTO Industries (IndustryName, Description)
VALUES
('ИТ-решения', 'Информационные технологии и программное обеспечение'),
('Фармацевтика', 'Лекарственные препараты и БАДы'),
('Мебель', 'Производство и продажа мебели');
GO

INSERT INTO Clients (ClientName, IndustryID, ContactFName, ContactMName, ContactLName, Phone, Email)
VALUES
('ООО "ТехноМир"', 1, 'Иван', 'Иванович', 'Иванов', '+79123456789', 'ivanov@techomir.ru'),
('АО "Здоровье"', 2, 'Мария', 'Сергеевна', 'Петрова', '+79234567890', 'petrova@zdorovie.ru'),
('ИП Сидоров', 3, 'Алексей', 'Петрович', 'Сидоров', '+79345678901', 'sidorov@mebel.ru');
GO

INSERT INTO CreativeTypes (TypeName, Description)
VALUES
('Баннеры', 'Графические баннеры для онлайн-платформ'),
('Видеоролики', 'Видеореклама для телевидения и онлайн-платформ'),
('Постеры', 'Печатные постеры для наружной рекламы');
GO

INSERT INTO CreativePlatforms (PlatformName, Description)
VALUES
('Социальные сети', 'Платформы: Instagram, Facebook, VK'),
('Телевидение', 'Телеканалы: Первый, ТНТ, Россия 1'),
('Онлайн', 'Поисковые системы: Яндекс, Google');
GO

INSERT INTO MediaChannels (ChannelName, Description)
VALUES
('Телевидение', 'Телеканалы: Первый канал, ТНТ, Россия 1'),
('Радио', 'Радиостанции: Авторадио, Европа Плюс'),
('Онлайн', 'Поисковые системы: Яндекс, Google'),
('Социальные сети', 'Платформы: Instagram, Facebook, VK'),
('Печатные СМИ', 'Газеты и журналы: Аргументы и Факты');
GO

-- Заполнение основных таблиц
INSERT INTO Campaigns (ClientID, CampaignName, StartDate, EndDate, Goal, Budget, TargetAudience, TargetGeography)
VALUES
(1, 'Летняя распродажа', '2025-06-01', '2025-08-31', 'Продвижение новых ноутбуков', 5000000.00, '18-35 лет', 'Москва, Санкт-Петербург'),
(2, 'Новый витаминный комплекс', '2025-09-01', '2025-11-30', 'Продвижение БАДов', 3000000.00, '25-50 лет', 'Россия'),
(3, 'Скидки на кухни', '2025-07-15', '2025-09-15', 'Продвижение кухонной мебели', 2000000.00, '25-55 лет', 'Москва, область');
GO

INSERT INTO Creatives (CampaignID, CreativeTypeID, PlatformID, Duration)
VALUES
(1, 1, 1, 15),
(1, 2, 1, 30),
(1, 2, 2, 15),
(2, 1, 3, NULL),
(2, 2, 2, 15),
(2, 2, 1, 30),
(3, 1, 3, NULL),
(3, 3, 4, NULL);
GO

INSERT INTO MediaPlans (CampaignID, ChannelID, StartDate, EndDate, Budget)
VALUES
(1, 1, '2025-06-01', '2025-08-31', 1000000.00),
(1, 2, '2025-06-01', '2025-08-31', 2000000.00),
(1, 3, '2025-06-01', '2025-08-31', 2000000.00),
(2, 1, '2025-09-01', '2025-11-30', 1500000.00),
(2, 3, '2025-09-01', '2025-11-30', 1000000.00),
(2, 4, '2025-09-01', '2025-11-30', 500000.00),
(3, 3, '2025-07-15', '2025-09-15', 1000000.00),
(3, 4, '2025-07-15', '2025-09-15', 500000.00),
(3, 5, '2025-07-15', '2025-09-15', 500000.00);
GO

-- =============================================
-- 4. Аналитические запросы
-- =============================================
-- 1. Популярность типов креативов
PRINT '1. Популярность типов креативов:';
GO
SELECT
    ct.TypeName AS CreativeType,
    COUNT(c.CreativeID) AS CreativesCount,
    SUM(mp.Budget) AS TotalBudget
FROM Creatives c
JOIN Campaigns camp ON c.CampaignID = camp.CampaignID
JOIN CreativeTypes ct ON c.CreativeTypeID = ct.CreativeTypeID
JOIN MediaPlans mp ON camp.CampaignID = mp.CampaignID
GROUP BY ct.TypeName
ORDER BY CreativesCount DESC;
GO

-- 2. Статистика по клиентам
PRINT '2. Статистика по клиентам:';
GO
SELECT
    cl.ClientName,
    i.IndustryName,
    COUNT(c.CampaignID) AS CampaignsCount,
    SUM(c.Budget) AS TotalBudget
FROM Clients cl
JOIN Industries i ON cl.IndustryID = i.IndustryID
JOIN Campaigns c ON cl.ClientID = c.ClientID
GROUP BY cl.ClientName, i.IndustryName
ORDER BY TotalBudget DESC;
GO

-- 3. Статистика по медиаканалам
PRINT '3. Статистика по медиаканалам:';
GO
SELECT
    mc.ChannelName,
    COUNT(mp.MediaPlanID) AS MediaPlansCount,
    SUM(mp.Budget) AS TotalBudget
FROM MediaPlans mp
JOIN MediaChannels mc ON mp.ChannelID = mc.ChannelID
GROUP BY mc.ChannelName
ORDER BY TotalBudget DESC;
GO
