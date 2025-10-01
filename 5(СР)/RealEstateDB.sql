USE master;
GO

-- Создание базы данных для агентства недвижимости
IF DB_ID('RealEstateDB') IS NULL
    CREATE DATABASE RealEstateDB;
GO

USE RealEstateDB;
GO

-- Удаление существующих таблиц, если они есть
IF OBJECT_ID('Deals', 'U') IS NOT NULL DROP TABLE Deals;
IF OBJECT_ID('Viewings', 'U') IS NOT NULL DROP TABLE Viewings;
IF OBJECT_ID('Agents', 'U') IS NOT NULL DROP TABLE Agents;
IF OBJECT_ID('Clients', 'U') IS NOT NULL DROP TABLE Clients;
IF OBJECT_ID('Properties', 'U') IS NOT NULL DROP TABLE Properties;
GO

-- Таблица Объекты
CREATE TABLE Properties (
    PropertyID INT IDENTITY(1,1) PRIMARY KEY,
    Address NVARCHAR(255) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    Area FLOAT NOT NULL CHECK (Area > 0),
    NumberOfRooms INT NOT NULL CHECK (NumberOfRooms > 0),
    PropertyType NVARCHAR(50) NOT NULL,
    Price DECIMAL(18,2) NOT NULL CHECK (Price > 0),
    Description NVARCHAR(500),
    Available BIT DEFAULT 1,
    RegistrationDate DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Таблица Клиенты
CREATE TABLE Clients (
    ClientID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    MiddleName NVARCHAR(50),
    Phone NVARCHAR(20) NOT NULL UNIQUE,
    Email NVARCHAR(100) UNIQUE,
    Address NVARCHAR(255),
    RegistrationDate DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Таблица Агенты
CREATE TABLE Agents (
    AgentID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    MiddleName NVARCHAR(50),
    Phone NVARCHAR(20) NOT NULL UNIQUE,
    Email NVARCHAR(100) UNIQUE,
    LicenseNumber NVARCHAR(20) NOT NULL UNIQUE,
    HireDate DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Таблица Просмотры
CREATE TABLE Viewings (
    ViewingID INT IDENTITY(1,1) PRIMARY KEY,
    PropertyID INT NOT NULL,
    ClientID INT NOT NULL,
    AgentID INT NOT NULL,
    ViewingDate DATETIME NOT NULL,
    Comments NVARCHAR(500),
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID),
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
    FOREIGN KEY (AgentID) REFERENCES Agents(AgentID)
);
GO

-- Таблица Сделки
CREATE TABLE Deals (
    DealID INT IDENTITY(1,1) PRIMARY KEY,
    PropertyID INT NOT NULL,
    ClientID INT NOT NULL,
    AgentID INT NOT NULL,
    DealDate DATETIME NOT NULL DEFAULT GETDATE(),
    DealAmount DECIMAL(18,2) NOT NULL CHECK (DealAmount > 0),
    Status NVARCHAR(50) NOT NULL,
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID),
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
    FOREIGN KEY (AgentID) REFERENCES Agents(AgentID)
);
GO

-- Заполнение таблиц тестовыми данными
-- Клиенты
INSERT INTO Clients (FirstName, LastName, MiddleName, Phone, Email, Address, RegistrationDate) VALUES
('Иван', 'Иванов', 'Сергеевич', '+79151234567', 'ivan.ivanov@email.com', 'ул. Ленина, 10, кв. 5', '2023-01-15 10:00:00'),
('Мария', 'Петрова', 'Александровна', '+79219876543', 'maria.petrova@email.com', 'пр. Мира, 15, кв. 30', '2023-02-20 11:00:00'),
('Алексей', 'Сидоров', 'Владимирович', '+79165550123', 'alexey.sidorov@email.com', 'ул. Советская, 5, кв. 12', '2023-03-10 12:00:00'),
('Анна', 'Козлова', 'Ивановна', '+74957778888', 'anna.kozlova@email.com', 'ул. Пушкина, 20, кв. 3', '2023-04-05 13:00:00'),
('Сергей', 'Смирнов', 'Андреевич', '+79031112222', 'sergey.smirnov@email.com', 'ул. Горького, 25, кв. 7', '2023-05-18 14:00:00');
GO

-- Агенты
INSERT INTO Agents (FirstName, LastName, MiddleName, Phone, Email, LicenseNumber, HireDate) VALUES
('Ольга', 'Васильева', 'Петровна', '+79112223344', 'olga.vasilyeva@realestate.com', 'АГ123456', '2022-01-10 09:00:00'),
('Дмитрий', 'Новиков', 'Викторович', '+79265556677', 'dmitry.novikov@realestate.com', 'АГ654321', '2021-05-15 10:00:00'),
('Екатерина', 'Соколова', 'Алексеевна', '+79037778899', 'ekaterina.sokolova@realestate.com', 'АГ789012', '2020-09-20 11:00:00'),
('Андрей', 'Морозов', 'Сергеевич', '+79163334455', 'andrey.morozov@realestate.com', 'АГ321654', '2023-01-05 12:00:00'),
('Наталья', 'Кузнецова', 'Игоревна', '+79214445566', 'natalya.kuznetsova@realestate.com', 'АГ987654', '2022-11-18 13:00:00');
GO

-- Объекты
INSERT INTO Properties (Address, City, Area, NumberOfRooms, PropertyType, Price, Description, Available) VALUES
('ул. Ленина, 15, кв. 20', 'Москва', 65.5, 2, 'Квартира', 8000000.00, 'Двухкомнатная квартира в центре города', 1),
('пр. Мира, 30', 'Санкт-Петербург', 120.0, 4, 'Квартира', 12000000.00, 'Четырехкомнатная квартира с ремонтом', 1),
('ул. Советская, 8', 'Казань', 180.0, 6, 'Дом', 25000000.00, 'Дом с участком в престижном районе', 1),
('ул. Пушкина, 10', 'Сочи', 90.0, 3, 'Квартира', 10000000.00, 'Трехкомнатная квартира с видом на море', 1),
('ул. Горького, 12', 'Новосибирск', 200.0, 5, 'Дом', 20000000.00, 'Дом с большим участком', 1);
GO

-- Просмотры
INSERT INTO Viewings (PropertyID, ClientID, AgentID, ViewingDate, Comments) VALUES
(1, 1, 1, '2023-06-15 10:00:00', 'Клиенту понравилась квартира, рассматривает покупку'),
(2, 2, 2, '2023-07-20 11:00:00', 'Клиент интересуется, но хочет посмотреть еще варианты'),
(3, 3, 3, '2023-08-10 12:00:00', 'Клиент готов к покупке'),
(4, 4, 4, '2023-09-05 13:00:00', 'Клиенту не подходит район'),
(5, 5, 5, '2023-10-18 14:00:00', 'Клиент рассматривает покупку');
GO

-- Сделки
INSERT INTO Deals (PropertyID, ClientID, AgentID, DealDate, DealAmount, Status) VALUES
(1, 1, 1, '2023-07-01 15:00:00', 7900000.00, 'Заключена'),
(2, 2, 2, '2023-08-10 16:00:00', 11900000.00, 'Предварительный договор'),
(3, 3, 3, '2023-09-15 17:00:00', 24500000.00, 'Заключена'),
(4, 4, 4, '2023-10-20 18:00:00', 9900000.00, 'Отменена'),
(5, 5, 5, '2023-11-25 19:00:00', 19800000.00, 'Предварительный договор');
GO

-- Примеры запросов
-- Задание 1: Список объектов недвижимости
SELECT PropertyID, Address, City, Area, NumberOfRooms, PropertyType, Price, Available
FROM Properties;
GO

-- Задание 2: Список клиентов
SELECT ClientID, FirstName, LastName, MiddleName, Phone, Email, Address, RegistrationDate
FROM Clients;
GO

-- Задание 3: Список агентов
SELECT AgentID, FirstName, LastName, MiddleName, Phone, Email, LicenseNumber, HireDate
FROM Agents;
GO

-- Задание 4: Список просмотров с информацией об объекте, клиенте и агенте
SELECT
    v.ViewingID,
    p.Address AS PropertyAddress,
    c.FirstName + ' ' + c.LastName AS ClientName,
    a.FirstName + ' ' + a.LastName AS AgentName,
    v.ViewingDate,
    v.Comments
FROM Viewings v
INNER JOIN Properties p ON v.PropertyID = p.PropertyID
INNER JOIN Clients c ON v.ClientID = c.ClientID
INNER JOIN Agents a ON v.AgentID = a.AgentID;
GO

-- Задание 5: Список сделок с информацией об объекте, клиенте и агенте
SELECT
    d.DealID,
    p.Address AS PropertyAddress,
    c.FirstName + ' ' + c.LastName AS ClientName,
    a.FirstName + ' ' + a.LastName AS AgentName,
    d.DealDate,
    d.DealAmount,
    d.Status
FROM Deals d
INNER JOIN Properties p ON d.PropertyID = p.PropertyID
INNER JOIN Clients c ON d.ClientID = c.ClientID
INNER JOIN Agents a ON d.AgentID = a.AgentID;
GO

-- Задание 6: Статистика по сделкам агентов
SELECT
    a.AgentID,
    a.FirstName + ' ' + a.LastName AS AgentName,
    COUNT(d.DealID) AS DealCount,
    SUM(d.DealAmount) AS TotalDealAmount
FROM Agents a
LEFT JOIN Deals d ON a.AgentID = d.AgentID
GROUP BY a.AgentID, a.FirstName, a.LastName;
GO
