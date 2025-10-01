USE master;
GO

-- Создание базы данных для системы аренды автомобилей
IF DB_ID('CarRentalDB') IS NULL
    CREATE DATABASE CarRentalDB;
GO

USE CarRentalDB;
GO

-- Удаление существующих таблиц, если они есть
IF OBJECT_ID('Insurance', 'U') IS NOT NULL DROP TABLE Insurance;
IF OBJECT_ID('Rentals', 'U') IS NOT NULL DROP TABLE Rentals;
IF OBJECT_ID('Clients', 'U') IS NOT NULL DROP TABLE Clients;
IF OBJECT_ID('Cars', 'U') IS NOT NULL DROP TABLE Cars;
IF OBJECT_ID('Offices', 'U') IS NOT NULL DROP TABLE Offices;
GO

-- Таблица Офисы
CREATE TABLE Offices (
    OfficeID INT IDENTITY(1,1) PRIMARY KEY,
    OfficeName NVARCHAR(100) NOT NULL,
    Address NVARCHAR(255) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Email NVARCHAR(100) UNIQUE,
    WorkingHours NVARCHAR(100)
);
GO

-- Таблица Автомобили
CREATE TABLE Cars (
    CarID INT IDENTITY(1,1) PRIMARY KEY,
    LicensePlate NVARCHAR(20) NOT NULL UNIQUE,
    Brand NVARCHAR(50) NOT NULL,
    Model NVARCHAR(50) NOT NULL,
    Year INT NOT NULL CHECK (Year > 1990),
    Color NVARCHAR(30),
    OfficeID INT NOT NULL,
    IsAvailable BIT DEFAULT 1,
    DailyRate DECIMAL(10,2) NOT NULL CHECK (DailyRate > 0),
    FOREIGN KEY (OfficeID) REFERENCES Offices(OfficeID)
);
GO

-- Таблица Клиенты
CREATE TABLE Clients (
    ClientID INT IDENTITY(1,1) PRIMARY KEY,
    LastName NVARCHAR(50) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    MiddleName NVARCHAR(50),
    BirthDate DATE NOT NULL,
    Gender NVARCHAR(1) CHECK (Gender IN ('М', 'Ж')),
    Phone NVARCHAR(20) NOT NULL UNIQUE,
    Email NVARCHAR(100) UNIQUE,
    Address NVARCHAR(255),
    DriverLicenseNumber NVARCHAR(20) NOT NULL UNIQUE
);
GO

-- Таблица Аренды
CREATE TABLE Rentals (
    RentalID INT IDENTITY(1,1) PRIMARY KEY,
    ClientID INT NOT NULL,
    CarID INT NOT NULL,
    OfficeID INT NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NOT NULL,
    TotalCost DECIMAL(10,2) NOT NULL CHECK (TotalCost > 0),
    IsActive BIT DEFAULT 1,
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
    FOREIGN KEY (CarID) REFERENCES Cars(CarID),
    FOREIGN KEY (OfficeID) REFERENCES Offices(OfficeID)
);
GO

-- Таблица Страховки
CREATE TABLE Insurance (
    InsuranceID INT IDENTITY(1,1) PRIMARY KEY,
    RentalID INT NOT NULL,
    InsuranceType NVARCHAR(100) NOT NULL,
    Cost DECIMAL(10,2) NOT NULL CHECK (Cost > 0),
    CoverageDetails NVARCHAR(255),
    FOREIGN KEY (RentalID) REFERENCES Rentals(RentalID)
);
GO

-- Заполнение таблиц тестовыми данными
-- Офисы
INSERT INTO Offices (OfficeName, Address, Phone, Email, WorkingHours) VALUES
('Central Office', '123 Main St, City Center', '+79111111111', 'central@carrental.com', '9:00-21:00'),
('North Office', '456 North Ave, North District', '+79222222222', 'north@carrental.com', '8:00-20:00'),
('South Office', '789 South Blvd, South District', '+79333333333', 'south@carrental.com', '9:00-22:00');
GO

-- Автомобили
INSERT INTO Cars (LicensePlate, Brand, Model, Year, Color, OfficeID, DailyRate) VALUES
('A123BC', 'Toyota', 'Camry', 2020, 'Silver', 1, 2500),
('B456CD', 'Honda', 'Accord', 2019, 'Black', 1, 2300),
('C789DE', 'Nissan', 'Qashqai', 2021, 'White', 2, 2700),
('D321EF', 'Ford', 'Focus', 2018, 'Blue', 2, 2000),
('E654FG', 'Volkswagen', 'Golf', 2022, 'Red', 3, 3000);
GO

-- Клиенты
INSERT INTO Clients (LastName, FirstName, MiddleName, BirthDate, Gender, Phone, Email, Address, DriverLicenseNumber) VALUES
('Иванов', 'Алексей', 'Сергеевич', '1990-05-15', 'М', '+79151234567', 'alexey.ivanov@email.com', 'ул. Ленина, 15, кв. 20', '1234567890'),
('Петрова', 'Мария', 'Александровна', '1985-08-22', 'Ж', '+79219876543', 'maria.petrova@email.com', 'пр. Мира, 30, кв. 55', '0987654321'),
('Сидоров', 'Дмитрий', 'Владимирович', '1992-03-10', 'М', '+79165550123', 'dmitry.sidorov@email.com', 'ул. Советская, 8, кв. 12', '1122334455'),
('Козлова', 'Анна', 'Ивановна', '1988-11-30', 'Ж', '+74957778888', 'anna.kozlova@email.com', 'ул. Пушкина, 10, кв. 3', '2233445566'),
('Смирнов', 'Сергей', 'Андреевич', '1980-07-18', 'М', '+79031112222', 'sergey.smirnov@email.com', 'ул. Горького, 12, кв. 7', '3344556677');
GO

-- Аренды
INSERT INTO Rentals (ClientID, CarID, OfficeID, StartDate, EndDate, TotalCost) VALUES
(1, 1, 1, '2023-10-01 10:00:00', '2023-10-05 18:00:00', 10000),
(2, 2, 1, '2023-10-02 12:00:00', '2023-10-07 10:00:00', 11500),
(3, 3, 2, '2023-10-03 14:00:00', '2023-10-10 12:00:00', 16200),
(4, 4, 2, '2023-10-05 16:00:00', '2023-10-12 14:00:00', 14000),
(5, 5, 3, '2023-10-06 09:00:00', '2023-10-13 17:00:00', 21000);
GO

-- Страховки
INSERT INTO Insurance (RentalID, InsuranceType, Cost, CoverageDetails) VALUES
(1, 'Full Coverage', 2000, 'Covers all damages and theft'),
(2, 'Basic Coverage', 1000, 'Covers damages only'),
(3, 'Full Coverage', 2500, 'Covers all damages and theft'),
(4, 'Basic Coverage', 1200, 'Covers damages only'),
(5, 'Premium Coverage', 3000, 'Covers all damages, theft, and personal injuries');
GO

-- Примеры запросов
-- Задание 1: Список автомобилей с указанием офиса
SELECT c.LicensePlate, c.Brand, c.Model, c.Year, o.OfficeName, c.DailyRate
FROM Cars c
INNER JOIN Offices o ON c.OfficeID = o.OfficeID;
GO

-- Задание 2: Список аренд с информацией о клиенте и автомобиле
SELECT
    cl.LastName + ' ' + LEFT(cl.FirstName, 1) + '. ' + LEFT(cl.MiddleName, 1) + '.' AS Client,
    c.Brand + ' ' + c.Model AS Car,
    o.OfficeName,
    r.StartDate,
    r.EndDate,
    r.TotalCost
FROM Rentals r
INNER JOIN Clients cl ON r.ClientID = cl.ClientID
INNER JOIN Cars c ON r.CarID = c.CarID
INNER JOIN Offices o ON r.OfficeID = o.OfficeID;
GO

-- Задание 3: Статистика по арендам по офисам
SELECT
    o.OfficeName,
    COUNT(r.RentalID) AS RentalCount,
    SUM(r.TotalCost) AS TotalRevenue
FROM Rentals r
INNER JOIN Offices o ON r.OfficeID = o.OfficeID
GROUP BY o.OfficeName;
GO
