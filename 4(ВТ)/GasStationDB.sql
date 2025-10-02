USE master;
GO

-- Проверка и удаление базы данных, если она существует
IF DB_ID('GasStationDB') IS NOT NULL
BEGIN
    ALTER DATABASE GasStationDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE GasStationDB;
END
GO

-- Создание базы данных
CREATE DATABASE GasStationDB;
GO

USE GasStationDB;
GO

-- Проверка и удаление таблицы, если она существует
IF OBJECT_ID('Fuelings_Denormalized', 'U') IS NOT NULL
    DROP TABLE Fuelings_Denormalized;
GO

-- =============================================
-- 1. Денормализованная таблица "Заправки"
-- =============================================
CREATE TABLE Fuelings_Denormalized (
    FuelingID INT IDENTITY(1,1) PRIMARY KEY,
    ClientInfo NVARCHAR(200),
    FuelInfo NVARCHAR(150),
    PumpInfo NVARCHAR(100),
    FuelingDateTime NVARCHAR(50),
    FuelingType NVARCHAR(100),
    Liters DECIMAL(10, 2),
    PricePerLiter DECIMAL(10, 2),
    TotalCost DECIMAL(10, 2),
    PaymentInfo NVARCHAR(150),
    Comments NVARCHAR(500)
);
GO

-- Заполнение денормализованной таблицы
INSERT INTO Fuelings_Denormalized (
    ClientInfo, FuelInfo, PumpInfo, FuelingDateTime, FuelingType,
    Liters, PricePerLiter, TotalCost, PaymentInfo, Comments
)
VALUES
('Иванов Иван Иванович; +79123456789; ivanov@mail.ru; A123BC77; 2010; Toyota Camry; 60',
 'АИ-95; Стандарт; 48.50',
 'Колонка 1; Бензин; Работает',
 '2025-10-01 10:30:00',
 'Заправка автомобиля',
 45.5, 48.50, 2207.75,
 'Банковская карта; 2025-10-01 10:35:00; 2207.75; Успешно',
 'Полный бак, чек не нужен'),

('Петрова Мария Сергеевна; +79234567890; petrova@mail.ru; B456CD177; 2015; Honda CR-V; 70',
 'ДТ; Премиум; 52.30',
 'Колонка 2; Дизель; Работает',
 '2025-10-01 11:45:00',
 'Заправка автомобиля',
 40.0, 52.30, 2092.00,
 'Наличные; 2025-10-01 11:50:00; 2100.00; Успешно',
 'Чек нужен, скидка по карте лояльности'),

('Сидоров Алексей Петрович; +79345678901; sidorov@mail.ru; C789EF777; 2018; Kia Rio; 50',
 'АИ-92; Эконом; 45.10',
 'Колонка 3; Бензин; Неисправна',
 '2025-10-01 12:10:00',
 'Заправка автомобиля',
 30.0, 45.10, 1353.00,
 'Банковская карта; 2025-10-01 12:15:00; 1353.00; Успешно',
 'Чек нужен, заправка на 1000 рублей');
GO

-- Просмотр денормализованных данных
SELECT * FROM Fuelings_Denormalized;
GO

-- Проверка и удаление таблицы, если она существует
IF OBJECT_ID('Fuelings_1NF', 'U') IS NOT NULL
    DROP TABLE Fuelings_1NF;
GO

-- =============================================
-- 2. Нормализация до 1НФ
-- =============================================
CREATE TABLE Fuelings_1NF (
    RecordID INT IDENTITY(1,1) PRIMARY KEY,
    FuelingID INT,
    ClientFName NVARCHAR(50),
    ClientMName NVARCHAR(50),
    ClientLName NVARCHAR(50),
    ClientPhone NVARCHAR(20),
    ClientEmail NVARCHAR(100),
    CarNumber NVARCHAR(20),
    CarYear INT,
    CarModel NVARCHAR(50),
    CarMileage INT,
    FuelType NVARCHAR(50),
    FuelGrade NVARCHAR(50),
    FuelPricePerLiter DECIMAL(10, 2),
    PumpNumber NVARCHAR(20),
    PumpFuelType NVARCHAR(50),
    PumpStatus NVARCHAR(50),
    FuelingDateTime DATETIME,
    FuelingType NVARCHAR(100),
    Liters DECIMAL(10, 2),
    PricePerLiter DECIMAL(10, 2),
    TotalCost DECIMAL(10, 2),
    PaymentMethod NVARCHAR(50),
    PaymentDateTime DATETIME,
    PaymentAmount DECIMAL(10, 2),
    PaymentStatus NVARCHAR(50),
    Comments NVARCHAR(500)
);
GO

-- Заполнение таблицы в 1НФ
INSERT INTO Fuelings_1NF (
    FuelingID, ClientFName, ClientMName, ClientLName, ClientPhone, ClientEmail,
    CarNumber, CarYear, CarModel, CarMileage, FuelType, FuelGrade, FuelPricePerLiter,
    PumpNumber, PumpFuelType, PumpStatus, FuelingDateTime, FuelingType,
    Liters, PricePerLiter, TotalCost, PaymentMethod, PaymentDateTime, PaymentAmount, PaymentStatus, Comments
)
SELECT
    FuelingID,
    PARSENAME(REPLACE(ClientInfo, '; ', '.'), 3) AS ClientFName,
    PARSENAME(REPLACE(ClientInfo, '; ', '.'), 2) AS ClientMName,
    PARSENAME(REPLACE(ClientInfo, '; ', '.'), 1) AS ClientLName,
    PARSENAME(REPLACE(ClientInfo, '; ', '.'), 4) AS ClientPhone,
    PARSENAME(REPLACE(ClientInfo, '; ', '.'), 5) AS ClientEmail,
    PARSENAME(REPLACE(ClientInfo, '; ', '.'), 6) AS CarNumber,
    CAST(PARSENAME(REPLACE(ClientInfo, '; ', '.'), 7) AS INT) AS CarYear,
    PARSENAME(REPLACE(ClientInfo, '; ', '.'), 8) AS CarModel,
    CAST(PARSENAME(REPLACE(ClientInfo, '; ', '.'), 9) AS INT) AS CarMileage,
    PARSENAME(REPLACE(FuelInfo, '; ', '.'), 1) AS FuelType,
    PARSENAME(REPLACE(FuelInfo, '; ', '.'), 2) AS FuelGrade,
    CAST(PARSENAME(REPLACE(FuelInfo, '; ', '.'), 3) AS DECIMAL(10, 2)) AS FuelPricePerLiter,
    PARSENAME(REPLACE(PumpInfo, '; ', '.'), 1) AS PumpNumber,
    PARSENAME(REPLACE(PumpInfo, '; ', '.'), 2) AS PumpFuelType,
    PARSENAME(REPLACE(PumpInfo, '; ', '.'), 3) AS PumpStatus,
    CAST(FuelingDateTime AS DATETIME) AS FuelingDateTime,
    FuelingType,
    Liters, PricePerLiter, TotalCost,
    PARSENAME(REPLACE(PaymentInfo, '; ', '.'), 1) AS PaymentMethod,
    CAST(PARSENAME(REPLACE(PaymentInfo, '; ', '.'), 2) + ' ' + PARSENAME(REPLACE(PaymentInfo, '; ', '.'), 3) AS DATETIME) AS PaymentDateTime,
    CAST(PARSENAME(REPLACE(PaymentInfo, '; ', '.'), 4) AS DECIMAL(10, 2)) AS PaymentAmount,
    PARSENAME(REPLACE(PaymentInfo, '; ', '.'), 5) AS PaymentStatus,
    Comments
FROM Fuelings_Denormalized;
GO

-- Просмотр данных в 1НФ
SELECT * FROM Fuelings_1NF;
GO

-- Проверка и удаление таблиц, если они существуют
IF OBJECT_ID('FuelTypes', 'U') IS NOT NULL DROP TABLE FuelTypes;
IF OBJECT_ID('FuelGrades', 'U') IS NOT NULL DROP TABLE FuelGrades;
IF OBJECT_ID('Pumps', 'U') IS NOT NULL DROP TABLE Pumps;
IF OBJECT_ID('Clients', 'U') IS NOT NULL DROP TABLE Clients;
IF OBJECT_ID('Cars', 'U') IS NOT NULL DROP TABLE Cars;
IF OBJECT_ID('PaymentMethods', 'U') IS NOT NULL DROP TABLE PaymentMethods;
IF OBJECT_ID('Fuelings', 'U') IS NOT NULL DROP TABLE Fuelings;
IF OBJECT_ID('Payments', 'U') IS NOT NULL DROP TABLE Payments;
GO

-- =============================================
-- 3. Нормализация до 3НФ (создание справочных таблиц)
-- =============================================
-- 1. Типы топлива
CREATE TABLE FuelTypes (
    FuelTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 2. Марки топлива
CREATE TABLE FuelGrades (
    FuelGradeID INT IDENTITY(1,1) PRIMARY KEY,
    GradeName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200),
    FuelTypeID INT NOT NULL,
    FOREIGN KEY (FuelTypeID) REFERENCES FuelTypes(FuelTypeID)
);
GO

-- 3. Колонки
CREATE TABLE Pumps (
    PumpID INT IDENTITY(1,1) PRIMARY KEY,
    PumpNumber NVARCHAR(20) NOT NULL,
    FuelTypeID INT NOT NULL,
    Status NVARCHAR(50),
    FOREIGN KEY (FuelTypeID) REFERENCES FuelTypes(FuelTypeID)
);
GO

-- 4. Клиенты
CREATE TABLE Clients (
    ClientID INT IDENTITY(1,1) PRIMARY KEY,
    FName NVARCHAR(50) NOT NULL,
    MName NVARCHAR(50),
    LName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Email NVARCHAR(100)
);
GO

-- 5. Автомобили
CREATE TABLE Cars (
    CarID INT IDENTITY(1,1) PRIMARY KEY,
    ClientID INT NOT NULL,
    CarNumber NVARCHAR(20) NOT NULL,
    CarYear INT,
    CarModel NVARCHAR(50),
    CarMileage INT,
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID)
);
GO

-- 6. Способы оплаты
CREATE TABLE PaymentMethods (
    PaymentMethodID INT IDENTITY(1,1) PRIMARY KEY,
    MethodName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 7. Заправки
CREATE TABLE Fuelings (
    FuelingID INT IDENTITY(1,1) PRIMARY KEY,
    CarID INT NOT NULL,
    PumpID INT NOT NULL,
    FuelGradeID INT NOT NULL,
    FuelingDateTime DATETIME NOT NULL,
    FuelingType NVARCHAR(100),
    Liters DECIMAL(10, 2),
    PricePerLiter DECIMAL(10, 2),
    TotalCost DECIMAL(10, 2),
    Comments NVARCHAR(500),
    FOREIGN KEY (CarID) REFERENCES Cars(CarID),
    FOREIGN KEY (PumpID) REFERENCES Pumps(PumpID),
    FOREIGN KEY (FuelGradeID) REFERENCES FuelGrades(FuelGradeID)
);
GO

-- 8. Платежи
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    FuelingID INT NOT NULL,
    PaymentMethodID INT NOT NULL,
    PaymentDateTime DATETIME NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    Status NVARCHAR(50),
    FOREIGN KEY (FuelingID) REFERENCES Fuelings(FuelingID),
    FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethods(PaymentMethodID)
);
GO

-- Заполнение справочных таблиц
INSERT INTO FuelTypes (TypeName, Description)
VALUES
('Бензин', 'Бензин различных марок'),
('Дизель', 'Дизельное топливо');
GO

INSERT INTO FuelGrades (GradeName, Description, FuelTypeID)
VALUES
('АИ-92', 'Бензин АИ-92', 1),
('АИ-95', 'Бензин АИ-95', 1),
('ДТ', 'Дизельное топливо', 2),
('ДТ Премиум', 'Премиальное дизельное топливо', 2);
GO

INSERT INTO Pumps (PumpNumber, FuelTypeID, Status)
VALUES
('Колонка 1', 1, 'Работает'),
('Колонка 2', 2, 'Работает'),
('Колонка 3', 1, 'Неисправна');
GO

INSERT INTO PaymentMethods (MethodName, Description)
VALUES
('Банковская карта', 'Оплата банковской картой'),
('Наличные', 'Оплата наличными'),
('Электронные деньги', 'Оплата через электронные платежные системы');
GO

-- Заполнение основных таблиц
INSERT INTO Clients (FName, MName, LName, Phone, Email)
VALUES
('Иван', 'Иванович', 'Иванов', '+79123456789', 'ivanov@mail.ru'),
('Мария', 'Сергеевна', 'Петрова', '+79234567890', 'petrova@mail.ru'),
('Алексей', 'Петрович', 'Сидоров', '+79345678901', 'sidorov@mail.ru');
GO

INSERT INTO Cars (ClientID, CarNumber, CarYear, CarModel, CarMileage)
VALUES
(1, 'A123BC77', 2010, 'Toyota Camry', 60000),
(2, 'B456CD177', 2015, 'Honda CR-V', 70000),
(3, 'C789EF777', 2018, 'Kia Rio', 50000);
GO

INSERT INTO Fuelings (CarID, PumpID, FuelGradeID, FuelingDateTime, FuelingType, Liters, PricePerLiter, TotalCost, Comments)
VALUES
(1, 1, 2, '2025-10-01 10:30:00', 'Заправка автомобиля', 45.5, 48.50, 2207.75, 'Полный бак, чек не нужен'),
(2, 2, 3, '2025-10-01 11:45:00', 'Заправка автомобиля', 40.0, 52.30, 2092.00, 'Чек нужен, скидка по карте лояльности'),
(3, 3, 1, '2025-10-01 12:10:00', 'Заправка автомобиля', 30.0, 45.10, 1353.00, 'Чек нужен, заправка на 1000 рублей');
GO

INSERT INTO Payments (FuelingID, PaymentMethodID, PaymentDateTime, Amount, Status)
VALUES
(1, 1, '2025-10-01 10:35:00', 2207.75, 'Успешно'),
(2, 2, '2025-10-01 11:50:00', 2100.00, 'Успешно'),
(3, 1, '2025-10-01 12:15:00', 1353.00, 'Успешно');
GO

-- =============================================
-- 4. Аналитические запросы
-- =============================================
-- 1. Популярность типов топлива
PRINT '1. Популярность типов топлива:';
GO
SELECT
    ft.TypeName AS FuelType,
    fg.GradeName AS FuelGrade,
    COUNT(f.FuelingID) AS FuelingsCount,
    SUM(f.Liters) AS TotalLiters,
    SUM(f.TotalCost) AS TotalRevenue
FROM Fuelings f
JOIN FuelGrades fg ON f.FuelGradeID = fg.FuelGradeID
JOIN FuelTypes ft ON fg.FuelTypeID = ft.FuelTypeID
GROUP BY ft.TypeName, fg.GradeName
ORDER BY FuelingsCount DESC;
GO

-- 2. Статистика по колонкам
PRINT '2. Статистика по колонкам:';
GO
SELECT
    p.PumpNumber,
    ft.TypeName AS FuelType,
    COUNT(f.FuelingID) AS FuelingsCount,
    SUM(f.Liters) AS TotalLiters,
    SUM(f.TotalCost) AS TotalRevenue
FROM Fuelings f
JOIN Pumps p ON f.PumpID = p.PumpID
JOIN FuelGrades fg ON f.FuelGradeID = fg.FuelGradeID
JOIN FuelTypes ft ON fg.FuelTypeID = ft.FuelTypeID
GROUP BY p.PumpNumber, ft.TypeName
ORDER BY FuelingsCount DESC;
GO

-- 3. Статистика по клиентам
PRINT '3. Статистика по клиентам:';
GO
SELECT
    CONCAT(c.FName, ' ', c.MName, ' ', c.LName) AS ClientName,
    car.CarModel,
    COUNT(f.FuelingID) AS FuelingsCount,
    SUM(f.Liters) AS TotalLiters,
    SUM(p.Amount) AS TotalPayments
FROM Clients c
JOIN Cars car ON c.ClientID = car.ClientID
JOIN Fuelings f ON car.CarID = f.CarID
JOIN Payments p ON f.FuelingID = p.FuelingID
GROUP BY CONCAT(c.FName, ' ', c.MName, ' ', c.LName), car.CarModel, c.ClientID
ORDER BY TotalPayments DESC;
GO
