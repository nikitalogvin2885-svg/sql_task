USE master;
GO

-- Проверка и удаление базы данных, если она существует
IF DB_ID('ToyStoreDB') IS NOT NULL
BEGIN
    ALTER DATABASE ToyStoreDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE ToyStoreDB;
END
GO

-- Создание базы данных
CREATE DATABASE ToyStoreDB;
GO

USE ToyStoreDB;
GO

-- Проверка и удаление таблицы, если она существует
IF OBJECT_ID('Sales_Denormalized', 'U') IS NOT NULL
    DROP TABLE Sales_Denormalized;
GO

-- =============================================
-- 1. Денормализованная таблица "Продажи игрушек"
-- =============================================
CREATE TABLE Sales_Denormalized (
    SaleID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerInfo NVARCHAR(200),
    ToyInfo NVARCHAR(200),
    CategoryInfo NVARCHAR(100),
    AgeGroupInfo NVARCHAR(50),
    SaleDateTime NVARCHAR(50),
    Price DECIMAL(10, 2),
    Quantity INT,
    TotalCost DECIMAL(10, 2),
    PaymentInfo NVARCHAR(150),
    Comments NVARCHAR(500)
);
GO

-- Заполнение денормализованной таблицы
INSERT INTO Sales_Denormalized (
    CustomerInfo, ToyInfo, CategoryInfo, AgeGroupInfo, SaleDateTime,
    Price, Quantity, TotalCost, PaymentInfo, Comments
)
VALUES
('Иванова Анна Петровна; +79123456789; ivanova@mail.ru; 1985-05-15',
 'Лего Техник; Набор "Грузовик"; 42128; 2000; 10+',
 'Конструкторы; Для развития логики и моторики',
 '3-7',
 '2025-10-01 12:30:00',
 3499.00, 1, 3499.00,
 'Банковская карта; 2025-10-01 12:35:00; Успешно',
 'Подарок на день рождения'),

('Петров Сергей Иванович; +79234567890; petrov@mail.ru; 1990-08-22',
 'Барби; Дом мечты; 30054; 5000; 3+',
 'Куклы; Для ролевых игр',
 '3-7',
 '2025-10-02 15:45:00',
 8999.00, 1, 8999.00,
 'Наличные; 2025-10-02 15:50:00; Успешно',
 'Подарок дочери'),

('Сидорова Мария Александровна; +79345678901; sidorova@mail.ru; 1988-11-30',
 'Нерф; Бластер "Элит 2.0"; E5756; 1500; 8+',
 'Игровое оружие; Для активных игр',
 '8-12',
 '2025-10-03 10:10:00',
 2499.00, 2, 4998.00,
 'Банковская карта; 2025-10-03 10:15:00; Успешно',
 'Чек нужен, скидка по карте лояльности');
GO

-- Просмотр денормализованных данных
SELECT * FROM Sales_Denormalized;
GO

-- Проверка и удаление таблицы, если она существует
IF OBJECT_ID('Sales_1NF', 'U') IS NOT NULL
    DROP TABLE Sales_1NF;
GO

-- =============================================
-- 2. Нормализация до 1НФ
-- =============================================
CREATE TABLE Sales_1NF (
    RecordID INT IDENTITY(1,1) PRIMARY KEY,
    SaleID INT,
    CustomerFName NVARCHAR(50),
    CustomerMName NVARCHAR(50),
    CustomerLName NVARCHAR(50),
    CustomerPhone NVARCHAR(20),
    CustomerEmail NVARCHAR(100),
    CustomerBirthDate DATE,
    ToyName NVARCHAR(100),
    ToyModel NVARCHAR(100),
    ToyArticle NVARCHAR(50),
    ToyPrice DECIMAL(10, 2),
    ToyWeight INT,
    ToyAgeRestriction NVARCHAR(20),
    CategoryName NVARCHAR(100),
    CategoryDescription NVARCHAR(200),
    AgeGroupName NVARCHAR(50),
    SaleDateTime DATETIME,
    Price DECIMAL(10, 2),
    Quantity INT,
    TotalCost DECIMAL(10, 2),
    PaymentMethod NVARCHAR(50),
    PaymentDateTime DATETIME,
    PaymentStatus NVARCHAR(50),
    Comments NVARCHAR(500)
);
GO

-- Заполнение таблицы в 1НФ
INSERT INTO Sales_1NF (
    SaleID, CustomerFName, CustomerMName, CustomerLName, CustomerPhone, CustomerEmail, CustomerBirthDate,
    ToyName, ToyModel, ToyArticle, ToyPrice, ToyWeight, ToyAgeRestriction,
    CategoryName, CategoryDescription, AgeGroupName, SaleDateTime,
    Price, Quantity, TotalCost, PaymentMethod, PaymentDateTime, PaymentStatus, Comments
)
SELECT
    SaleID,
    PARSENAME(REPLACE(CustomerInfo, '; ', '.'), 3) AS CustomerFName,
    PARSENAME(REPLACE(CustomerInfo, '; ', '.'), 2) AS CustomerMName,
    PARSENAME(REPLACE(CustomerInfo, '; ', '.'), 1) AS CustomerLName,
    PARSENAME(REPLACE(CustomerInfo, '; ', '.'), 4) AS CustomerPhone,
    PARSENAME(REPLACE(CustomerInfo, '; ', '.'), 5) AS CustomerEmail,
    CAST(PARSENAME(REPLACE(CustomerInfo, '; ', '.'), 6) AS DATE) AS CustomerBirthDate,
    PARSENAME(REPLACE(ToyInfo, '; ', '.'), 1) AS ToyName,
    PARSENAME(REPLACE(ToyInfo, '; ', '.'), 2) AS ToyModel,
    PARSENAME(REPLACE(ToyInfo, '; ', '.'), 3) AS ToyArticle,
    CAST(PARSENAME(REPLACE(ToyInfo, '; ', '.'), 4) AS DECIMAL(10, 2)) AS ToyPrice,
    CAST(PARSENAME(REPLACE(ToyInfo, '; ', '.'), 5) AS INT) AS ToyWeight,
    PARSENAME(REPLACE(ToyInfo, '; ', '.'), 6) AS ToyAgeRestriction,
    PARSENAME(REPLACE(CategoryInfo, '; ', '.'), 1) AS CategoryName,
    PARSENAME(REPLACE(CategoryInfo, '; ', '.'), 2) AS CategoryDescription,
    AgeGroupInfo AS AgeGroupName,
    CAST(SaleDateTime AS DATETIME) AS SaleDateTime,
    Price, Quantity, TotalCost,
    PARSENAME(REPLACE(PaymentInfo, '; ', '.'), 1) AS PaymentMethod,
    CAST(PARSENAME(REPLACE(PaymentInfo, '; ', '.'), 2) + ' ' + PARSENAME(REPLACE(PaymentInfo, '; ', '.'), 3) AS DATETIME) AS PaymentDateTime,
    PARSENAME(REPLACE(PaymentInfo, '; ', '.'), 4) AS PaymentStatus,
    Comments
FROM Sales_Denormalized;
GO

-- Просмотр данных в 1НФ
SELECT * FROM Sales_1NF;
GO

-- Проверка и удаление таблиц, если они существуют
IF OBJECT_ID('AgeGroups', 'U') IS NOT NULL DROP TABLE AgeGroups;
IF OBJECT_ID('Categories', 'U') IS NOT NULL DROP TABLE Categories;
IF OBJECT_ID('Toys', 'U') IS NOT NULL DROP TABLE Toys;
IF OBJECT_ID('Customers', 'U') IS NOT NULL DROP TABLE Customers;
IF OBJECT_ID('PaymentMethods', 'U') IS NOT NULL DROP TABLE PaymentMethods;
IF OBJECT_ID('Sales', 'U') IS NOT NULL DROP TABLE Sales;
IF OBJECT_ID('Payments', 'U') IS NOT NULL DROP TABLE Payments;
GO

-- =============================================
-- 3. Нормализация до 3НФ (создание справочных таблиц)
-- =============================================
-- 1. Возрастные группы
CREATE TABLE AgeGroups (
    AgeGroupID INT IDENTITY(1,1) PRIMARY KEY,
    AgeGroupName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 2. Категории игрушек
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 3. Игрушки
CREATE TABLE Toys (
    ToyID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID INT NOT NULL,
    AgeGroupID INT NOT NULL,
    ToyName NVARCHAR(100) NOT NULL,
    ToyModel NVARCHAR(100),
    ToyArticle NVARCHAR(50) NOT NULL,
    ToyPrice DECIMAL(10, 2) NOT NULL,
    ToyWeight INT,
    ToyAgeRestriction NVARCHAR(20),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (AgeGroupID) REFERENCES AgeGroups(AgeGroupID)
);
GO

-- 4. Покупатели
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FName NVARCHAR(50) NOT NULL,
    MName NVARCHAR(50),
    LName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Email NVARCHAR(100),
    BirthDate DATE
);
GO

-- 5. Способы оплаты
CREATE TABLE PaymentMethods (
    PaymentMethodID INT IDENTITY(1,1) PRIMARY KEY,
    MethodName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 6. Продажи
CREATE TABLE Sales (
    SaleID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    ToyID INT NOT NULL,
    SaleDateTime DATETIME NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Quantity INT NOT NULL,
    TotalCost DECIMAL(10, 2) NOT NULL,
    Comments NVARCHAR(500),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ToyID) REFERENCES Toys(ToyID)
);
GO

-- 7. Платежи
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    SaleID INT NOT NULL,
    PaymentMethodID INT NOT NULL,
    PaymentDateTime DATETIME NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    Status NVARCHAR(50),
    FOREIGN KEY (SaleID) REFERENCES Sales(SaleID),
    FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethods(PaymentMethodID)
);
GO

-- Заполнение справочных таблиц
INSERT INTO AgeGroups (AgeGroupName, Description)
VALUES
('0-3', 'Игрушки для детей от 0 до 3 лет'),
('3-7', 'Игрушки для детей от 3 до 7 лет'),
('8-12', 'Игрушки для детей от 8 до 12 лет'),
('12+', 'Игрушки для детей старше 12 лет');
GO

INSERT INTO Categories (CategoryName, Description)
VALUES
('Конструкторы', 'Конструкторы для развития логики и моторики'),
('Куклы', 'Куклы для ролевых игр'),
('Игровое оружие', 'Игрушечное оружие для активных игр'),
('Настольные игры', 'Настольные игры для семейного досуга');
GO

INSERT INTO Toys (CategoryID, AgeGroupID, ToyName, ToyModel, ToyArticle, ToyPrice, ToyWeight, ToyAgeRestriction)
VALUES
(1, 2, 'Лего', 'Техник Набор "Грузовик"', '42128', 3499.00, 2000, '10+'),
(2, 1, 'Барби', 'Дом мечты', '30054', 8999.00, 5000, '3+'),
(3, 3, 'Нерф', 'Бластер "Элит 2.0"', 'E5756', 2499.00, 1500, '8+');
GO

INSERT INTO PaymentMethods (MethodName, Description)
VALUES
('Банковская карта', 'Оплата банковской картой'),
('Наличные', 'Оплата наличными'),
('Электронные деньги', 'Оплата через электронные платежные системы');
GO

-- Заполнение основных таблиц
INSERT INTO Customers (FName, MName, LName, Phone, Email, BirthDate)
VALUES
('Анна', 'Петровна', 'Иванова', '+79123456789', 'ivanova@mail.ru', '1985-05-15'),
('Сергей', 'Иванович', 'Петров', '+79234567890', 'petrov@mail.ru', '1990-08-22'),
('Мария', 'Александровна', 'Сидорова', '+79345678901', 'sidorova@mail.ru', '1988-11-30');
GO

INSERT INTO Sales (CustomerID, ToyID, SaleDateTime, Price, Quantity, TotalCost, Comments)
VALUES
(1, 1, '2025-10-01 12:30:00', 3499.00, 1, 3499.00, 'Подарок на день рождения'),
(2, 2, '2025-10-02 15:45:00', 8999.00, 1, 8999.00, 'Подарок дочери'),
(3, 3, '2025-10-03 10:10:00', 2499.00, 2, 4998.00, 'Чек нужен, скидка по карте лояльности');
GO

INSERT INTO Payments (SaleID, PaymentMethodID, PaymentDateTime, Amount, Status)
VALUES
(1, 1, '2025-10-01 12:35:00', 3499.00, 'Успешно'),
(2, 2, '2025-10-02 15:50:00', 8999.00, 'Успешно'),
(3, 1, '2025-10-03 10:15:00', 4998.00, 'Успешно');
GO

-- =============================================
-- 4. Аналитические запросы
-- =============================================
-- 1. Популярность категорий игрушек
PRINT '1. Популярность категорий игрушек:';
GO
SELECT
    c.CategoryName,
    t.ToyName,
    t.ToyModel,
    COUNT(s.SaleID) AS SalesCount,
    SUM(s.TotalCost) AS TotalRevenue
FROM Sales s
JOIN Toys t ON s.ToyID = t.ToyID
JOIN Categories c ON t.CategoryID = c.CategoryID
GROUP BY c.CategoryName, t.ToyName, t.ToyModel
ORDER BY SalesCount DESC;
GO

-- 2. Статистика по возрастным группам
PRINT '2. Статистика по возрастным группам:';
GO
SELECT
    ag.AgeGroupName,
    COUNT(s.SaleID) AS SalesCount,
    SUM(s.TotalCost) AS TotalRevenue
FROM Sales s
JOIN Toys t ON s.ToyID = t.ToyID
JOIN AgeGroups ag ON t.AgeGroupID = ag.AgeGroupID
GROUP BY ag.AgeGroupName
ORDER BY SalesCount DESC;
GO

-- 3. Статистика по покупателям
PRINT '3. Статистика по покупателям:';
GO
SELECT
    CONCAT(c.FName, ' ', c.MName, ' ', c.LName) AS CustomerName,
    COUNT(s.SaleID) AS SalesCount,
    SUM(s.TotalCost) AS TotalPayments
FROM Customers c
JOIN Sales s ON c.CustomerID = s.CustomerID
GROUP BY CONCAT(c.FName, ' ', c.MName, ' ', c.LName), c.CustomerID
ORDER BY TotalPayments DESC;
GO
