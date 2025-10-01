USE master;
GO

-- Создание базы данных для автосалона
IF DB_ID('CarDealershipDB') IS NULL
    CREATE DATABASE CarDealershipDB;
GO

USE CarDealershipDB;
GO

-- Удаление существующих таблиц, если они есть
IF OBJECT_ID('Sales', 'U') IS NOT NULL DROP TABLE Sales;
IF OBJECT_ID('Cars', 'U') IS NOT NULL DROP TABLE Cars;
IF OBJECT_ID('Brands', 'U') IS NOT NULL DROP TABLE Brands;
IF OBJECT_ID('Clients', 'U') IS NOT NULL DROP TABLE Clients;
IF OBJECT_ID('Employees', 'U') IS NOT NULL DROP TABLE Employees;
GO

-- Создание таблицы Марки
CREATE TABLE Brands (
    BrandID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    Country NVARCHAR(50) NOT NULL,
    FoundingYear INT,
    Logo NVARCHAR(255)
);
GO

-- Создание таблицы Автомобили
CREATE TABLE Cars (
    CarID INT IDENTITY(1,1) PRIMARY KEY,
    BrandID INT NOT NULL,
    Model NVARCHAR(50) NOT NULL,
    Year INT NOT NULL CHECK (Year BETWEEN 1990 AND YEAR(GETDATE())),
    Color NVARCHAR(30) NOT NULL,
    BodyType NVARCHAR(30) NOT NULL,
    EngineVolume DECIMAL(4,1) NOT NULL,
    Horsepower INT NOT NULL,
    Transmission NVARCHAR(20) NOT NULL,
    Drive NVARCHAR(20) NOT NULL,
    Mileage INT NOT NULL CHECK (Mileage >= 0),
    Price DECIMAL(12,2) NOT NULL CHECK (Price > 0),
    InStock BIT DEFAULT 1,
    ArrivalDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (BrandID) REFERENCES Brands(BrandID)
);
GO

-- Создание таблицы Клиенты
CREATE TABLE Clients (
    ClientID INT IDENTITY(1,1) PRIMARY KEY,
    LastName NVARCHAR(50) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    MiddleName NVARCHAR(50),
    BirthDate DATE,
    PassportSeries NVARCHAR(10),
    PassportNumber NVARCHAR(10),
    Phone NVARCHAR(20) NOT NULL UNIQUE,
    Email NVARCHAR(100) UNIQUE,
    Address NVARCHAR(255) NOT NULL,
    RegistrationDate DATETIME DEFAULT GETDATE()
);
GO

-- Создание таблицы Сотрудники
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    LastName NVARCHAR(50) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    MiddleName NVARCHAR(50),
    Position NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20) NOT NULL UNIQUE,
    Email NVARCHAR(100) UNIQUE,
    HireDate DATETIME DEFAULT GETDATE(),
    Salary DECIMAL(10,2) NOT NULL CHECK (Salary > 0),
    ManagerID INT NULL,
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);
GO

-- Создание таблицы Продажи
CREATE TABLE Sales (
    SaleID INT IDENTITY(1,1) PRIMARY KEY,
    CarID INT NOT NULL,
    ClientID INT NOT NULL,
    EmployeeID INT NOT NULL,
    SaleDate DATETIME DEFAULT GETDATE(),
    SalePrice DECIMAL(12,2) NOT NULL CHECK (SalePrice > 0),
    PaymentType NVARCHAR(30) NOT NULL,
    FOREIGN KEY (CarID) REFERENCES Cars(CarID),
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
GO

-- =============================================
-- ЗАПОЛНЕНИЕ ТЕСТОВЫМИ ДАННЫМИ
-- =============================================

-- Заполнение таблицы Марки
INSERT INTO Brands (Name, Country, FoundingYear, Logo) VALUES
('Toyota', 'Япония', 1937, 'toyota_logo.png'),
('Volkswagen', 'Германия', 1937, 'vw_logo.png'),
('BMW', 'Германия', 1916, 'bmw_logo.png'),
('Mercedes-Benz', 'Германия', 1926, 'mercedes_logo.png'),
('Ford', 'США', 1903, 'ford_logo.png'),
('Hyundai', 'Южная Корея', 1967, 'hyundai_logo.png'),
('Kia', 'Южная Корея', 1944, 'kia_logo.png'),
('Nissan', 'Япония', 1933, 'nissan_logo.png');
GO

-- Заполнение таблицы Автомобили
INSERT INTO Cars (BrandID, Model, Year, Color, BodyType, EngineVolume, Horsepower, Transmission, Drive, Mileage, Price, InStock) VALUES
(1, 'Camry', 2020, 'Серебристый', 'Седан', 2.5, 203, 'Автомат', 'Передний', 35000, 1850000, 1),
(1, 'RAV4', 2021, 'Черный', 'Кроссовер', 2.5, 199, 'Автомат', 'Полный', 15000, 2200000, 1),
(2, 'Golf', 2019, 'Белый', 'Хэтчбек', 1.4, 150, 'Автомат', 'Передний', 45000, 1450000, 1),
(2, 'Passat', 2020, 'Синий', 'Седан', 2.0, 190, 'Автомат', 'Передний', 25000, 1750000, 1),
(3, 'X5', 2021, 'Черный', 'Кроссовер', 3.0, 340, 'Автомат', 'Полный', 10000, 4500000, 1),
(3, '3 Series', 2020, 'Белый', 'Седан', 2.0, 258, 'Автомат', 'Задний', 20000, 3200000, 1),
(4, 'E-Class', 2021, 'Серебристый', 'Седан', 2.0, 245, 'Автомат', 'Задний', 15000, 4000000, 1),
(5, 'Focus', 2019, 'Красный', 'Хэтчбек', 1.5, 150, 'Механика', 'Передний', 50000, 1050000, 1),
(6, 'Tucson', 2021, 'Синий', 'Кроссовер', 2.0, 150, 'Автомат', 'Полный', 12000, 1950000, 1),
(7, 'Sportage', 2020, 'Серый', 'Кроссовер', 2.4, 185, 'Автомат', 'Полный', 20000, 1850000, 1);
GO

-- Заполнение таблицы Клиенты
INSERT INTO Clients (LastName, FirstName, MiddleName, BirthDate, PassportSeries, PassportNumber, Phone, Email, Address) VALUES
('Иванов', 'Алексей', 'Сергеевич', '1985-05-15', '4501', '123456', '+79151234567', 'alexey.ivanov@email.com', 'ул. Ленина, 10, кв. 5'),
('Петрова', 'Мария', 'Александровна', '1990-08-22', '4602', '654321', '+79219876543', 'maria.petrova@email.com', 'пр. Мира, 25, кв. 12'),
('Сидоров', 'Дмитрий', 'Владимирович', '1988-03-10', '4703', '789012', '+79165550123', 'dmitry.sidorov@email.com', 'ул. Советская, 5, кв. 8'),
('Козлова', 'Анна', 'Ивановна', '1992-11-30', '4804', '321654', '+74957778888', 'anna.kozlova@email.com', 'ул. Кирова, 15, кв. 3'),
('Смирнов', 'Сергей', 'Андреевич', '1980-07-18', '4905', '987654', '+79031112222', 'sergey.smirnov@email.com', 'ул. Пушкина, 7, кв. 14'),
('Васильева', 'Ольга', 'Петровна', '1987-02-14', '5006', '456123', '+79263334444', 'olga.vasilyeva@email.com', 'ул. Горького, 12, кв. 7');
GO

-- Заполнение таблицы Сотрудники
INSERT INTO Employees (LastName, FirstName, MiddleName, Position, Phone, Email, Salary, ManagerID) VALUES
('Смирнов', 'Андрей', 'Иванович', 'Директор', '+79151112233', 'andrey.smirnov@cardealership.com', 150000, NULL),
('Кузнецова', 'Елена', 'Петровна', 'Менеджер по продажам', '+79213334455', 'elena.kuznetsova@cardealership.com', 80000, 1),
('Иванова', 'Мария', 'Сергеевна', 'Менеджер по продажам', '+79167778899', 'maria.ivanova@cardealership.com', 75000, 1),
('Петров', 'Иван', 'Андреевич', 'Финансовый менеджер', '+74959990011', 'ivan.petrov@cardealership.com', 90000, 1),
('Васильев', 'Сергей', 'Викторович', 'Старший продавец', '+79032223344', 'sergey.vasilyev@cardealership.com', 65000, 2),
('Новикова', 'Анна', 'Алексеевна', 'Продавец', '+79115556666', 'anna.novikova@cardealership.com', 55000, 5);
GO

-- Заполнение таблицы Продажи
INSERT INTO Sales (CarID, ClientID, EmployeeID, SaleDate, SalePrice, PaymentType) VALUES
(1, 1, 2, '2023-10-15', 1850000, 'Наличные'),
(2, 2, 3, '2023-10-16', 2200000, 'Кредит'),
(3, 3, 2, '2023-10-17', 1450000, 'Безналичный расчет'),
(4, 4, 5, '2023-10-18', 1750000, 'Наличные'),
(5, 5, 3, '2023-10-19', 4500000, 'Кредит'),
(6, 1, 6, '2023-10-20', 3200000, 'Безналичный расчет'),
(7, 6, 2, '2023-10-21', 4000000, 'Наличные'),
(8, 2, 5, '2023-10-22', 1050000, 'Кредит');
GO

-- =============================================
-- ЭТАП 1: БАЗОВЫЕ ЗАДАНИЯ (INNER JOIN)
-- =============================================
-- Задание 1.1: Вывести список автомобилей с названиями марок
SELECT c.Model, b.Name AS Brand, c.Year, c.Price
FROM Cars c
INNER JOIN Brands b ON c.BrandID = b.BrandID;
GO

-- Задание 1.2: Показать продажи с информацией о клиентах
SELECT s.SaleID, cl.LastName + ' ' + LEFT(cl.FirstName, 1) + '. ' + LEFT(cl.MiddleName, 1) + '.' AS Client, s.SaleDate, s.SalePrice
FROM Sales s
INNER JOIN Clients cl ON s.ClientID = cl.ClientID;
GO

-- Задание 1.3: Вывести продажи с информацией о сотрудниках
SELECT s.SaleID, e.LastName + ' ' + LEFT(e.FirstName, 1) + '. ' + LEFT(e.MiddleName, 1) + '.' AS Employee, s.SaleDate, s.SalePrice
FROM Sales s
INNER JOIN Employees e ON s.EmployeeID = e.EmployeeID;
GO

-- =============================================
-- ЭТАП 2: LEFT JOIN ЗАДАНИЯ
-- =============================================
-- Задание 2.1: Показать все марки и количество автомобилей в каждой
SELECT b.Name AS Brand, COUNT(c.CarID) AS CarCount
FROM Brands b
LEFT JOIN Cars c ON b.BrandID = c.BrandID
GROUP BY b.BrandID, b.Name;
GO

-- Задание 2.2: Вывести всех сотрудников и их продажи (включая сотрудников без продаж)
SELECT e.LastName + ' ' + LEFT(e.FirstName, 1) + '. ' + LEFT(e.MiddleName, 1) + '.' AS Employee, e.Position, COUNT(s.SaleID) AS SaleCount
FROM Employees e
LEFT JOIN Sales s ON e.EmployeeID = s.EmployeeID
GROUP BY e.EmployeeID, e.LastName, e.FirstName, e.MiddleName, e.Position;
GO

-- =============================================
-- ЭТАП 3: RIGHT JOIN ЗАДАНИЯ
-- =============================================
-- Задание 3.1: Показать все автомобили и их продажи (включая автомобили, которые не проданы)
SELECT c.Model, b.Name AS Brand, s.SaleID, s.SaleDate
FROM Sales s
RIGHT JOIN Cars c ON s.CarID = c.CarID
LEFT JOIN Brands b ON c.BrandID = b.BrandID
ORDER BY c.Model;
GO

-- =============================================
-- ЭТАП 4: FULL OUTER JOIN ЗАДАНИЯ
-- =============================================
-- Задание 4.1: Полное соединение автомобилей и продаж
SELECT COALESCE(c.Model, 'No car') AS Car, COALESCE(s.SaleID, 0) AS SaleID
FROM Cars c
FULL OUTER JOIN Sales s ON c.CarID = s.CarID;
GO

-- =============================================
-- ЭТАП 5: МНОЖЕСТВЕННЫЕ JOIN
-- =============================================
-- Задание 5.1: Полная информация о продажах
SELECT
    s.SaleID,
    cl.LastName + ' ' + LEFT(cl.FirstName, 1) + '. ' + LEFT(cl.MiddleName, 1) + '.' AS Client,
    e.LastName + ' ' + LEFT(e.FirstName, 1) + '. ' + LEFT(e.MiddleName, 1) + '.' AS Employee,
    b.Name AS Brand,
    c.Model,
    c.Year,
    s.SaleDate,
    s.SalePrice,
    s.PaymentType
FROM Sales s
INNER JOIN Clients cl ON s.ClientID = cl.ClientID
INNER JOIN Employees e ON s.EmployeeID = e.EmployeeID
INNER JOIN Cars c ON s.CarID = c.CarID
INNER JOIN Brands b ON c.BrandID = b.BrandID
ORDER BY s.SaleID;
GO

-- Задание 5.2: Топ-5 самых дорогих проданных автомобилей
SELECT TOP 5
    b.Name AS Brand,
    c.Model,
    c.Year,
    s.SalePrice,
    cl.LastName + ' ' + LEFT(cl.FirstName, 1) + '. ' + LEFT(cl.MiddleName, 1) + '.' AS Client,
    s.SaleDate
FROM Sales s
INNER JOIN Cars c ON s.CarID = c.CarID
INNER JOIN Brands b ON c.BrandID = b.BrandID
INNER JOIN Clients cl ON s.ClientID = cl.ClientID
ORDER BY s.SalePrice DESC;
GO

-- =============================================
-- ЭТАП 6: САМОСОЕДИНЕНИЕ (SELF JOIN)
-- =============================================
-- Задание 6.1: Найти сотрудников и их руководителей
SELECT
    e1.LastName + ' ' + LEFT(e1.FirstName, 1) + '. ' + LEFT(e1.MiddleName, 1) + '.' AS Employee,
    e2.LastName + ' ' + LEFT(e2.FirstName, 1) + '. ' + LEFT(e2.MiddleName, 1) + '.' AS Manager,
    e1.Position
FROM Employees e1
LEFT JOIN Employees e2 ON e1.ManagerID = e2.EmployeeID
ORDER BY COALESCE(e2.LastName, ''), e1.LastName;
GO

-- =============================================
-- ЭТАП 7: АГРЕГАТНЫЕ ФУНКЦИИ С JOIN
-- =============================================
-- Задание 7.1: Статистика по продажам автомобилей по маркам
SELECT
    b.Name AS Brand,
    COUNT(s.SaleID) AS SaleCount,
    SUM(s.SalePrice) AS TotalRevenue,
    AVG(s.SalePrice) AS AveragePrice
FROM Brands b
LEFT JOIN Cars c ON b.BrandID = c.BrandID
LEFT JOIN Sales s ON c.CarID = s.CarID
GROUP BY b.BrandID, b.Name
ORDER BY TotalRevenue DESC;
GO

-- Задание 7.2: Анализ продаж по месяцам
SELECT
    YEAR(s.SaleDate) AS Year,
    MONTH(s.SaleDate) AS Month,
    COUNT(s.SaleID) AS SaleCount,
    SUM(s.SalePrice) AS TotalRevenue,
    AVG(s.SalePrice) AS AveragePrice
FROM Sales s
GROUP BY YEAR(s.SaleDate), MONTH(s.SaleDate)
ORDER BY Year, Month;
GO
