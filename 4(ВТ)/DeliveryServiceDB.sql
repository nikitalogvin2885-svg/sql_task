USE master;
GO

-- Проверка и удаление базы данных, если она существует
IF DB_ID('DeliveryServiceDB') IS NOT NULL
BEGIN
    ALTER DATABASE DeliveryServiceDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DeliveryServiceDB;
END
GO

-- Создание базы данных
CREATE DATABASE DeliveryServiceDB;
GO

USE DeliveryServiceDB;
GO

-- Проверка и удаление таблицы, если она существует
IF OBJECT_ID('Deliveries_Denormalized', 'U') IS NOT NULL
    DROP TABLE Deliveries_Denormalized;
GO

-- =============================================
-- 1. Денормализованная таблица "Доставки"
-- =============================================
CREATE TABLE Deliveries_Denormalized (
    DeliveryID INT IDENTITY(1,1) PRIMARY KEY,
    OrderInfo NVARCHAR(200),
    CourierInfo NVARCHAR(150),
    RecipientInfo NVARCHAR(200),
    RouteInfo NVARCHAR(200),
    DeliveryDateTime NVARCHAR(50),
    Status NVARCHAR(50),
    Cost DECIMAL(10, 2),
    Comments NVARCHAR(500)
);
GO

-- Заполнение денормализованной таблицы
INSERT INTO Deliveries_Denormalized (
    OrderInfo, CourierInfo, RecipientInfo, RouteInfo, DeliveryDateTime, Status, Cost, Comments
)
VALUES
('Заказ 1001; Пицца "Маргарита"; Ресторан "Италия"; 2025-10-01 12:00:00; 1500.00',
 'Иванов Иван Иванович; +79123456789; Велосипед; 2 года опыта',
 'Петров Петр Петрович; +79234567890; ул. Ленина, 10, кв. 5; Наличные',
 'Маршрут 1; 5 км; 20 минут; Центр; ул. Ленина, ул. Пушкина, ул. Горького',
 '2025-10-01 12:30:00',
 'Доставлено',
 150.00,
 'Без сдачи, позвонить перед доставкой'),

('Заказ 1002; Суши "Калифорния"; Ресторан "Япония"; 2025-10-01 13:00:00; 1200.00',
 'Сидорова Мария Сергеевна; +79345678901; Автомобиль; 3 года опыта',
 'Кузнецова Анна Ивановна; +79456789012; пр. Мира, 25, кв. 12; Карта',
 'Маршрут 2; 10 км; 30 минут; Север; пр. Мира, ул. Советская, ул. Лесная',
 '2025-10-01 13:45:00',
 'Доставлено',
 200.00,
 'Оставить у двери'),

('Заказ 1003; Бургер "Чизбургер"; Ресторан "Америка"; 2025-10-01 14:00:00; 800.00',
 'Петров Алексей Александрович; +79567890123; Самокат; 1 год опыта',
 'Смирнова Ольга Владимировна; +79678901234; ул. Садовая, 15, кв. 8; Наличные',
 'Маршрут 3; 3 км; 15 минут; Юг; ул. Садовая, ул. Октябрьская, ул. Школьная',
 '2025-10-01 14:20:00',
 'Отменено',
 100.00,
 'Клиент передумал');
GO

-- Просмотр денормализованных данных
SELECT * FROM Deliveries_Denormalized;
GO

-- Проверка и удаление таблицы, если она существует
IF OBJECT_ID('Deliveries_1NF', 'U') IS NOT NULL
    DROP TABLE Deliveries_1NF;
GO

-- =============================================
-- 2. Нормализация до 1НФ
-- =============================================
CREATE TABLE Deliveries_1NF (
    RecordID INT IDENTITY(1,1) PRIMARY KEY,
    DeliveryID INT,
    OrderID NVARCHAR(20),
    OrderProduct NVARCHAR(100),
    OrderRestaurant NVARCHAR(100),
    OrderDateTime DATETIME,
    OrderCost DECIMAL(10, 2),
    CourierFName NVARCHAR(50),
    CourierMName NVARCHAR(50),
    CourierLName NVARCHAR(50),
    CourierPhone NVARCHAR(20),
    CourierTransport NVARCHAR(50),
    CourierExperience INT,
    RecipientFName NVARCHAR(50),
    RecipientMName NVARCHAR(50),
    RecipientLName NVARCHAR(50),
    RecipientPhone NVARCHAR(20),
    RecipientAddress NVARCHAR(100),
    RecipientPaymentMethod NVARCHAR(50),
    RouteID NVARCHAR(20),
    RouteDistance DECIMAL(10, 2),
    RouteTime INT,
    RouteDistrict NVARCHAR(100),
    RouteStreets NVARCHAR(200),
    DeliveryDateTime DATETIME,
    Status NVARCHAR(50),
    Cost DECIMAL(10, 2),
    Comments NVARCHAR(500)
);
GO

-- Заполнение таблицы в 1НФ
INSERT INTO Deliveries_1NF (
    DeliveryID, OrderID, OrderProduct, OrderRestaurant, OrderDateTime, OrderCost,
    CourierFName, CourierMName, CourierLName, CourierPhone, CourierTransport, CourierExperience,
    RecipientFName, RecipientMName, RecipientLName, RecipientPhone, RecipientAddress, RecipientPaymentMethod,
    RouteID, RouteDistance, RouteTime, RouteDistrict, RouteStreets, DeliveryDateTime, Status, Cost, Comments
)
SELECT
    DeliveryID,
    PARSENAME(REPLACE(OrderInfo, '; ', '.'), 4) AS OrderID,
    PARSENAME(REPLACE(OrderInfo, '; ', '.'), 3) AS OrderProduct,
    PARSENAME(REPLACE(OrderInfo, '; ', '.'), 2) AS OrderRestaurant,
    CAST(PARSENAME(REPLACE(OrderInfo, '; ', '.'), 1) AS DATETIME) AS OrderDateTime,
    CAST(PARSENAME(REPLACE(OrderInfo, '; ', '.'), 5) AS DECIMAL(10, 2)) AS OrderCost,
    PARSENAME(REPLACE(CourierInfo, '; ', '.'), 1) AS CourierFName,
    PARSENAME(REPLACE(CourierInfo, '; ', '.'), 2) AS CourierMName,
    PARSENAME(REPLACE(CourierInfo, '; ', '.'), 3) AS CourierLName,
    PARSENAME(REPLACE(CourierInfo, '; ', '.'), 4) AS CourierPhone,
    PARSENAME(REPLACE(CourierInfo, '; ', '.'), 5) AS CourierTransport,
    CAST(PARSENAME(REPLACE(CourierInfo, '; ', '.'), 6) AS INT) AS CourierExperience,
    PARSENAME(REPLACE(RecipientInfo, '; ', '.'), 1) AS RecipientFName,
    PARSENAME(REPLACE(RecipientInfo, '; ', '.'), 2) AS RecipientMName,
    PARSENAME(REPLACE(RecipientInfo, '; ', '.'), 3) AS RecipientLName,
    PARSENAME(REPLACE(RecipientInfo, '; ', '.'), 4) AS RecipientPhone,
    PARSENAME(REPLACE(RecipientInfo, '; ', '.'), 5) AS RecipientAddress,
    PARSENAME(REPLACE(RecipientInfo, '; ', '.'), 6) AS RecipientPaymentMethod,
    PARSENAME(REPLACE(RouteInfo, '; ', '.'), 1) AS RouteID,
    CAST(PARSENAME(REPLACE(RouteInfo, '; ', '.'), 2) AS DECIMAL(10, 2)) AS RouteDistance,
    CAST(PARSENAME(REPLACE(RouteInfo, '; ', '.'), 3) AS INT) AS RouteTime,
    PARSENAME(REPLACE(RouteInfo, '; ', '.'), 4) AS RouteDistrict,
    PARSENAME(REPLACE(RouteInfo, '; ', '.'), 5) AS RouteStreets,
    CAST(DeliveryDateTime AS DATETIME) AS DeliveryDateTime,
    Status,
    Cost,
    Comments
FROM Deliveries_Denormalized;
GO

-- Просмотр данных в 1НФ
SELECT * FROM Deliveries_1NF;
GO

-- Проверка и удаление таблиц, если они существуют
IF OBJECT_ID('Restaurants', 'U') IS NOT NULL DROP TABLE Restaurants;
IF OBJECT_ID('Products', 'U') IS NOT NULL DROP TABLE Products;
IF OBJECT_ID('Orders', 'U') IS NOT NULL DROP TABLE Orders;
IF OBJECT_ID('Couriers', 'U') IS NOT NULL DROP TABLE Couriers;
IF OBJECT_ID('Recipients', 'U') IS NOT NULL DROP TABLE Recipients;
IF OBJECT_ID('Districts', 'U') IS NOT NULL DROP TABLE Districts;
IF OBJECT_ID('Routes', 'U') IS NOT NULL DROP TABLE Routes;
IF OBJECT_ID('Deliveries', 'U') IS NOT NULL DROP TABLE Deliveries;
GO

-- =============================================
-- 3. Нормализация до 3НФ (создание справочных таблиц)
-- =============================================
-- 1. Рестораны
CREATE TABLE Restaurants (
    RestaurantID INT IDENTITY(1,1) PRIMARY KEY,
    RestaurantName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 2. Продукты
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    RestaurantID INT NOT NULL,
    ProductName NVARCHAR(100) NOT NULL,
    Price DECIMAL(10, 2),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);
GO

-- 3. Заказы
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    OrderDateTime DATETIME NOT NULL,
    OrderCost DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- 4. Курьеры
CREATE TABLE Couriers (
    CourierID INT IDENTITY(1,1) PRIMARY KEY,
    FName NVARCHAR(50) NOT NULL,
    MName NVARCHAR(50),
    LName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Transport NVARCHAR(50),
    Experience INT
);
GO

-- 5. Получатели
CREATE TABLE Recipients (
    RecipientID INT IDENTITY(1,1) PRIMARY KEY,
    FName NVARCHAR(50) NOT NULL,
    MName NVARCHAR(50),
    LName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Address NVARCHAR(100) NOT NULL,
    PaymentMethod NVARCHAR(50)
);
GO

-- 6. Районы
CREATE TABLE Districts (
    DistrictID INT IDENTITY(1,1) PRIMARY KEY,
    DistrictName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 7. Маршруты
CREATE TABLE Routes (
    RouteID INT IDENTITY(1,1) PRIMARY KEY,
    DistrictID INT NOT NULL,
    Distance DECIMAL(10, 2) NOT NULL,
    Time INT NOT NULL,
    Streets NVARCHAR(200),
    FOREIGN KEY (DistrictID) REFERENCES Districts(DistrictID)
);
GO

-- 8. Доставки
CREATE TABLE Deliveries (
    DeliveryID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    CourierID INT NOT NULL,
    RecipientID INT NOT NULL,
    RouteID INT NOT NULL,
    DeliveryDateTime DATETIME NOT NULL,
    Status NVARCHAR(50) NOT NULL,
    Cost DECIMAL(10, 2) NOT NULL,
    Comments NVARCHAR(500),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (CourierID) REFERENCES Couriers(CourierID),
    FOREIGN KEY (RecipientID) REFERENCES Recipients(RecipientID),
    FOREIGN KEY (RouteID) REFERENCES Routes(RouteID)
);
GO

-- Заполнение справочных таблиц
INSERT INTO Restaurants (RestaurantName, Description)
VALUES
('Ресторан "Италия"', 'Итальянская кухня'),
('Ресторан "Япония"', 'Японская кухня'),
('Ресторан "Америка"', 'Американская кухня');
GO

INSERT INTO Products (RestaurantID, ProductName, Price)
VALUES
(1, 'Пицца "Маргарита"', 1500.00),
(2, 'Суши "Калифорния"', 1200.00),
(3, 'Бургер "Чизбургер"', 800.00);
GO

INSERT INTO Orders (ProductID, OrderDateTime, OrderCost)
VALUES
(1, '2025-10-01 12:00:00', 1500.00),
(2, '2025-10-01 13:00:00', 1200.00),
(3, '2025-10-01 14:00:00', 800.00);
GO

INSERT INTO Couriers (FName, MName, LName, Phone, Transport, Experience)
VALUES
('Иван', 'Иванович', 'Иванов', '+79123456789', 'Велосипед', 2),
('Мария', 'Сергеевна', 'Сидорова', '+79345678901', 'Автомобиль', 3),
('Алексей', 'Александрович', 'Петров', '+79567890123', 'Самокат', 1);
GO

INSERT INTO Recipients (FName, MName, LName, Phone, Address, PaymentMethod)
VALUES
('Петр', 'Петрович', 'Петров', '+79234567890', 'ул. Ленина, 10, кв. 5', 'Наличные'),
('Анна', 'Ивановна', 'Кузнецова', '+79456789012', 'пр. Мира, 25, кв. 12', 'Карта'),
('Ольга', 'Владимировна', 'Смирнова', '+79678901234', 'ул. Садовая, 15, кв. 8', 'Наличные');
GO

INSERT INTO Districts (DistrictName, Description)
VALUES
('Центр', 'Центральный район города'),
('Север', 'Северный район города'),
('Юг', 'Южный район города');
GO

INSERT INTO Routes (DistrictID, Distance, Time, Streets)
VALUES
(1, 5.00, 20, 'ул. Ленина, ул. Пушкина, ул. Горького'),
(2, 10.00, 30, 'пр. Мира, ул. Советская, ул. Лесная'),
(3, 3.00, 15, 'ул. Садовая, ул. Октябрьская, ул. Школьная');
GO

INSERT INTO Deliveries (OrderID, CourierID, RecipientID, RouteID, DeliveryDateTime, Status, Cost, Comments)
VALUES
(1, 1, 1, 1, '2025-10-01 12:30:00', 'Доставлено', 150.00, 'Без сдачи, позвонить перед доставкой'),
(2, 2, 2, 2, '2025-10-01 13:45:00', 'Доставлено', 200.00, 'Оставить у двери'),
(3, 3, 3, 3, '2025-10-01 14:20:00', 'Отменено', 100.00, 'Клиент передумал');
GO

-- =============================================
-- 4. Аналитические запросы
-- =============================================
-- 1. Статистика по курьерам
PRINT '1. Статистика по курьерам:';
GO
SELECT
    CONCAT(c.FName, ' ', c.MName, ' ', c.LName) AS CourierName,
    c.Transport,
    COUNT(d.DeliveryID) AS DeliveriesCount,
    SUM(CASE WHEN d.Status = 'Доставлено' THEN 1 ELSE 0 END) AS SuccessfulDeliveries,
    SUM(d.Cost) AS TotalEarnings
FROM Deliveries d
JOIN Couriers c ON d.CourierID = c.CourierID
GROUP BY CONCAT(c.FName, ' ', c.MName, ' ', c.LName), c.Transport, c.CourierID
ORDER BY TotalEarnings DESC;
GO

-- 2. Популярность ресторанов
PRINT '2. Популярность ресторанов:';
GO
SELECT
    r.RestaurantName,
    COUNT(o.OrderID) AS OrdersCount,
    SUM(o.OrderCost) AS TotalRevenue
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
JOIN Restaurants r ON p.RestaurantID = r.RestaurantID
GROUP BY r.RestaurantName
ORDER BY OrdersCount DESC;
GO

-- 3. Статистика по районам
PRINT '3. Статистика по районам:';
GO
SELECT
    dist.DistrictName,
    COUNT(d.DeliveryID) AS DeliveriesCount,
    SUM(d.Cost) AS TotalCost
FROM Deliveries d
JOIN Routes rt ON d.RouteID = rt.RouteID
JOIN Districts dist ON rt.DistrictID = dist.DistrictID
GROUP BY dist.DistrictName
ORDER BY DeliveriesCount DESC;
GO
