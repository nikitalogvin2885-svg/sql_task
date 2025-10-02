CREATE DATABASE RestaurantDB;
GO
USE RestaurantDB;
GO

-- Проверка существования таблиц и их удаление, если они существуют
IF OBJECT_ID('OrderDetails', 'U') IS NOT NULL DROP TABLE OrderDetails;
IF OBJECT_ID('Orders', 'U') IS NOT NULL DROP TABLE Orders;
IF OBJECT_ID('Reservations', 'U') IS NOT NULL DROP TABLE Reservations;
IF OBJECT_ID('MenuItems', 'U') IS NOT NULL DROP TABLE MenuItems;
IF OBJECT_ID('Tables', 'U') IS NOT NULL DROP TABLE Tables;
IF OBJECT_ID('Staff', 'U') IS NOT NULL DROP TABLE Staff;
IF OBJECT_ID('Customers', 'U') IS NOT NULL DROP TABLE Customers;
IF OBJECT_ID('Categories', 'U') IS NOT NULL DROP TABLE Categories;
GO

-- Таблица "Категории блюд"
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500)
);
GO

-- Таблица "Сотрудники"
CREATE TABLE Staff (
    StaffID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Position NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    HireDate DATE NOT NULL,
    Salary DECIMAL(10, 2),
    IsActive BIT NOT NULL DEFAULT 1
);
GO

-- Таблица "Клиенты"
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    RegistrationDate DATE NOT NULL,
    LoyaltyPoints INT DEFAULT 0
);
GO

-- Таблица "Столики"
CREATE TABLE Tables (
    TableID INT IDENTITY(1,1) PRIMARY KEY,
    TableNumber NVARCHAR(10) NOT NULL,
    Capacity INT NOT NULL,
    Location NVARCHAR(100),
    IsAvailable BIT NOT NULL DEFAULT 1
);
GO

-- Таблица "Блюда меню"
CREATE TABLE MenuItems (
    MenuItemID INT IDENTITY(1,1) PRIMARY KEY,
    ItemName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    CategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID),
    Price DECIMAL(10, 2) NOT NULL,
    Cost DECIMAL(10, 2) NOT NULL,
    PreparationTime INT, -- в минутах
    IsAvailable BIT NOT NULL DEFAULT 1
);
GO

-- Таблица "Бронирования"
CREATE TABLE Reservations (
    ReservationID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    TableID INT FOREIGN KEY REFERENCES Tables(TableID),
    ReservationDate DATETIME NOT NULL,
    PartySize INT NOT NULL,
    SpecialRequests NVARCHAR(500),
    Status NVARCHAR(20) DEFAULT 'Confirmed'
);
GO

-- Таблица "Заказы"
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    TableID INT FOREIGN KEY REFERENCES Tables(TableID),
    WaiterID INT FOREIGN KEY REFERENCES Staff(StaffID),
    OrderDate DATETIME NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    Status NVARCHAR(20) DEFAULT 'Pending',
    PaymentMethod NVARCHAR(50),
    PaymentStatus NVARCHAR(20) DEFAULT 'Unpaid'
);
GO

-- Таблица "Детали заказа"
CREATE TABLE OrderDetails (
    OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    MenuItemID INT FOREIGN KEY REFERENCES MenuItems(MenuItemID),
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    SpecialInstructions NVARCHAR(500),
    CookID INT FOREIGN KEY REFERENCES Staff(StaffID)
);
GO

-- Заполнение тестовыми данными: Категории
INSERT INTO Categories (CategoryName, Description) VALUES
('Закуски', 'Легкие закуски и салаты'),
('Основные блюда', 'Горячие основные блюда'),
('Супы', 'Горячие и холодные супы'),
('Десерты', 'Сладкие блюда и выпечка'),
('Напитки', 'Алкогольные и безалкогольные напитки'),
('Гарниры', 'Дополнительные гарниры к основным блюдам');
GO

-- Заполнение тестовыми данными: Сотрудники
INSERT INTO Staff (FirstName, LastName, Position, Phone, Email, HireDate, Salary) VALUES
('Анна', 'Иванова', 'Шеф-повар', '+79001112233', 'anna.ivanova@restaurant.ru', '2020-01-15', 120000.00),
('Дмитрий', 'Петров', 'Повар', '+79002223344', 'dmitry.petrov@restaurant.ru', '2021-03-20', 80000.00),
('Мария', 'Сидорова', 'Официант', '+79003334455', 'maria.sidorova@restaurant.ru', '2022-05-10', 50000.00),
('Сергей', 'Козлов', 'Официант', '+79004445566', 'sergey.kozlov@restaurant.ru', '2021-07-15', 52000.00),
('Ольга', 'Васильева', 'Менеджер', '+79005556677', 'olga.vasilyeva@restaurant.ru', '2019-11-01', 90000.00),
('Иван', 'Николаев', 'Бармен', '+79006667788', 'ivan.nikolaev@restaurant.ru', '2022-02-28', 55000.00);
GO

-- Заполнение тестовыми данными: Клиенты
INSERT INTO Customers (FirstName, LastName, Phone, Email, RegistrationDate, LoyaltyPoints) VALUES
('Алексей', 'Смирнов', '+79011112233', 'alexey.smirnov@mail.ru', '2023-01-10', 150),
('Екатерина', 'Попова', '+79022223344', 'ekaterina.popova@mail.ru', '2023-02-15', 300),
('Михаил', 'Кузнецов', '+79033334455', 'mikhail.kuznetsov@mail.ru', '2023-03-20', 75),
('Ольга', 'Лебедева', '+79044445566', 'olga.lebedeva@mail.ru', '2023-04-25', 500),
('Артем', 'Соколов', '+79055556677', 'artem.sokolov@mail.ru', '2023-05-30', 200),
('Ирина', 'Новикова', '+79066667788', 'irina.novikova@mail.ru', '2023-06-05', 450);
GO

-- Заполнение тестовыми данными: Столики
INSERT INTO Tables (TableNumber, Capacity, Location, IsAvailable) VALUES
('A1', 2, 'У окна', 1),
('A2', 2, 'У окна', 1),
('A3', 4, 'Зал', 1),
('A4', 4, 'Зал', 1),
('B1', 6, 'Центр зала', 1),
('B2', 6, 'Центр зала', 1),
('V1', 8, 'VIP зона', 1),
('V2', 10, 'VIP зона', 1);
GO

-- Заполнение тестовыми данными: Блюда меню
INSERT INTO MenuItems (ItemName, Description, CategoryID, Price, Cost, PreparationTime, IsAvailable) VALUES
('Цезарь с курицей', 'Салат с куриной грудкой, пармезаном и соусом цезарь', 1, 450.00, 180.00, 15, 1),
('Брускетта с томатами', 'Хрустящий хлеб с помидорами и базиликом', 1, 280.00, 90.00, 10, 1),
('Стейк рибай', 'Говяжий стейк с овощами гриль', 2, 1200.00, 400.00, 25, 1),
('Лосось на гриле', 'Филе лосося с лимонным соусом', 2, 950.00, 320.00, 20, 1),
('Том Ям', 'Острый тайский суп с креветками', 3, 480.00, 150.00, 15, 1),
('Борщ', 'Традиционный украинский борщ', 3, 350.00, 100.00, 12, 1),
('Тирамису', 'Итальянский десерт с кофе и маскарпоне', 4, 380.00, 120.00, 5, 1),
('Чизкейк', 'Классический нью-йоркский чизкейк', 4, 320.00, 95.00, 5, 1),
('Мохито', 'Классический коктейль с мятой и лаймом', 5, 450.00, 80.00, 5, 1),
('Капучино', 'Кофе с молочной пенкой', 5, 280.00, 50.00, 3, 1),
('Картофель фри', 'Хрустящий картофель с соусом', 6, 220.00, 60.00, 10, 1),
('Овощи гриль', 'Сезонные овощи на гриле', 6, 300.00, 90.00, 12, 1);
GO

-- Заполнение тестовыми данными: Бронирования
INSERT INTO Reservations (CustomerID, TableID, ReservationDate, PartySize, SpecialRequests, Status) VALUES
(1, 3, '2023-10-15 19:00:00', 4, 'Столик у окна', 'Confirmed'),
(2, 5, '2023-10-16 20:00:00', 6, 'День рождения', 'Confirmed'),
(3, 1, '2023-10-17 18:30:00', 2, NULL, 'Confirmed'),
(4, 7, '2023-10-18 21:00:00', 8, 'Бизнес-ужин', 'Confirmed'),
(5, 2, '2023-10-19 19:30:00', 2, 'Романтический ужин', 'Confirmed');
GO

-- Заполнение тестовыми данными: Заказы
INSERT INTO Orders (CustomerID, TableID, WaiterID, OrderDate, TotalAmount, Status, PaymentMethod, PaymentStatus) VALUES
(1, 3, 3, '2023-10-15 19:15:00', 2530.00, 'Completed', 'Карта', 'Paid'),
(2, 5, 4, '2023-10-16 20:10:00', 4180.00, 'Completed', 'Наличные', 'Paid'),
(3, 1, 3, '2023-10-17 18:45:00', 1560.00, 'In Progress', NULL, 'Unpaid'),
(4, 7, 4, '2023-10-18 21:15:00', 6250.00, 'Completed', 'Карта', 'Paid'),
(5, 2, 3, '2023-10-19 19:40:00', 1950.00, 'Pending', NULL, 'Unpaid');
GO

-- Заполнение тестовыми данными: Детали заказа
INSERT INTO OrderDetails (OrderID, MenuItemID, Quantity, UnitPrice, SpecialInstructions, CookID) VALUES
(1, 1, 2, 450.00, 'Без гренок', 2),
(1, 3, 1, 1200.00, 'Средней прожарки', 1),
(1, 11, 1, 220.00, NULL, 2),
(1, 9, 2, 450.00, 'Без алкоголя', 6),
(2, 2, 1, 280.00, NULL, 2),
(2, 4, 3, 950.00, 'С лимоном', 1),
(2, 5, 2, 480.00, 'Очень острый', 2),
(2, 10, 4, 280.00, NULL, 6),
(3, 1, 1, 450.00, NULL, 2),
(3, 6, 2, 350.00, 'Со сметаной', 2),
(3, 8, 1, 320.00, NULL, 2),
(4, 3, 4, 1200.00, 'Разная прожарка', 1),
(4, 4, 2, 950.00, NULL, 1),
(4, 7, 4, 380.00, NULL, 2),
(4, 9, 6, 450.00, NULL, 6),
(5, 2, 2, 280.00, NULL, 2),
(5, 4, 1, 950.00, NULL, 1),
(5, 10, 2, 280.00, NULL, 6);
GO

-- Вложенные запросы

-- 1. Скалярный подзапрос: Клиенты, чьи заказы превышают среднюю сумму чека
SELECT
    c.FirstName,
    c.LastName,
    c.Phone,
    (SELECT AVG(TotalAmount) FROM Orders) AS AvgOrderAmount,
    (SELECT SUM(o.TotalAmount) FROM Orders o WHERE o.CustomerID = c.CustomerID) AS CustomerTotalAmount
FROM Customers c
WHERE (SELECT SUM(o.TotalAmount) FROM Orders o WHERE o.CustomerID = c.CustomerID) >
      (SELECT AVG(TotalAmount) FROM Orders)
ORDER BY CustomerTotalAmount DESC;
GO

-- 2. Табличный подзапрос с IN: Официанты, которые обслуживали заказы на сумму больше 3000
SELECT DISTINCT
    s.FirstName,
    s.LastName,
    s.Position
FROM Staff s
WHERE s.StaffID IN (
    SELECT o.WaiterID
    FROM Orders o
    WHERE o.TotalAmount > 3000
) AND s.Position = 'Официант';
GO

-- 3. Коррелированный подзапрос: Блюда, которые заказываются чаще среднего
SELECT
    m.ItemName,
    m.Price,
    (SELECT COUNT(*) FROM OrderDetails od WHERE od.MenuItemID = m.MenuItemID) AS OrderCount
FROM MenuItems m
WHERE (SELECT COUNT(*) FROM OrderDetails od WHERE od.MenuItemID = m.MenuItemID) >
      (SELECT AVG(order_count) FROM (
          SELECT COUNT(*) AS order_count
          FROM OrderDetails
          GROUP BY MenuItemID
      ) AS avg_order_count)
ORDER BY OrderCount DESC;
GO

-- 4. EXISTS: Клиенты, которые делали бронирования
SELECT DISTINCT
    c.FirstName,
    c.LastName,
    c.Phone
FROM Customers c
WHERE EXISTS (
    SELECT 1
    FROM Reservations r
    WHERE r.CustomerID = c.CustomerID
);
GO

-- Курсоры

-- 1. Курсор: Детали заказов с информацией о клиентах и блюдах
DECLARE @OrderID INT, @CustomerName NVARCHAR(100), @ItemName NVARCHAR(100), @Quantity INT, @UnitPrice DECIMAL(10,2), @TotalPrice DECIMAL(10,2);
DECLARE order_cursor CURSOR FOR
SELECT
    o.OrderID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    m.ItemName,
    od.Quantity,
    od.UnitPrice,
    od.Quantity * od.UnitPrice AS TotalPrice
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN MenuItems m ON od.MenuItemID = m.MenuItemID
ORDER BY o.OrderID;

OPEN order_cursor;
FETCH NEXT FROM order_cursor INTO @OrderID, @CustomerName, @ItemName, @Quantity, @UnitPrice, @TotalPrice;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Заказ №' + CAST(@OrderID AS NVARCHAR(10)) + ', Клиент: ' + @CustomerName + ', Блюдо: ' + @ItemName + 
          ', Количество: ' + CAST(@Quantity AS NVARCHAR(10)) + ', Сумма: ' + CAST(@TotalPrice AS NVARCHAR(20));
    FETCH NEXT FROM order_cursor INTO @OrderID, @CustomerName, @ItemName, @Quantity, @UnitPrice, @TotalPrice;
END;

CLOSE order_cursor;
DEALLOCATE order_cursor;
GO

-- 2. Вложенные курсоры: Официанты и их заказы
DECLARE @WaiterID INT, @WaiterFirstName NVARCHAR(50), @WaiterLastName NVARCHAR(50);
DECLARE @OrderID INT, @OrderDate DATETIME, @OrderTotal DECIMAL(10,2), @CustomerName NVARCHAR(100);

DECLARE waiter_cursor CURSOR FOR
SELECT StaffID, FirstName, LastName
FROM Staff
WHERE Position = 'Официант'
ORDER BY LastName;

OPEN waiter_cursor;
FETCH NEXT FROM waiter_cursor INTO @WaiterID, @WaiterFirstName, @WaiterLastName;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Официант: ' + @WaiterFirstName + ' ' + @WaiterLastName;
    
    DECLARE waiter_order_cursor CURSOR LOCAL FOR
    SELECT 
        o.OrderID,
        o.OrderDate,
        o.TotalAmount,
        c.FirstName + ' ' + c.LastName AS CustomerName
    FROM Orders o
    JOIN Customers c ON o.CustomerID = c.CustomerID
    WHERE o.WaiterID = @WaiterID
    ORDER BY o.OrderDate DESC;
    
    OPEN waiter_order_cursor;
    FETCH NEXT FROM waiter_order_cursor INTO @OrderID, @OrderDate, @OrderTotal, @CustomerName;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT '  Заказ №' + CAST(@OrderID AS NVARCHAR(10)) + ', Дата: ' + CONVERT(NVARCHAR(20), @OrderDate) + 
              ', Клиент: ' + @CustomerName + ', Сумма: ' + CAST(@OrderTotal AS NVARCHAR(20));
        FETCH NEXT FROM waiter_order_cursor INTO @OrderID, @OrderDate, @OrderTotal, @CustomerName;
    END;
    
    CLOSE waiter_order_cursor;
    DEALLOCATE waiter_order_cursor;
    
    FETCH NEXT FROM waiter_cursor INTO @WaiterID, @WaiterFirstName, @WaiterLastName;
END;

CLOSE waiter_cursor;
DEALLOCATE waiter_cursor;
GO

-- Создание индексов для оптимизации
CREATE INDEX IX_Customers_Phone ON Customers(Phone);
CREATE INDEX IX_Staff_Position ON Staff(Position);
CREATE INDEX IX_MenuItems_CategoryID ON MenuItems(CategoryID);
CREATE INDEX IX_MenuItems_Price ON MenuItems(Price);
CREATE INDEX IX_Orders_CustomerID ON Orders(CustomerID);
CREATE INDEX IX_Orders_WaiterID ON Orders(WaiterID);
CREATE INDEX IX_Orders_OrderDate ON Orders(OrderDate);
CREATE INDEX IX_OrderDetails_OrderID ON OrderDetails(OrderID);
CREATE INDEX IX_OrderDetails_MenuItemID ON OrderDetails(MenuItemID);
CREATE INDEX IX_Reservations_CustomerID ON Reservations(CustomerID);
CREATE INDEX IX_Reservations_TableID ON Reservations(TableID);
CREATE INDEX IX_Tables_Capacity ON Tables(Capacity);
GO

-- Дополнительные аналитические запросы

-- Статистика по продажам блюд по категориям
SELECT 
    c.CategoryName,
    COUNT(od.OrderDetailID) AS TotalOrders,
    SUM(od.Quantity) AS TotalQuantity,
    SUM(od.Quantity * od.UnitPrice) AS TotalRevenue,
    AVG(od.UnitPrice) AS AvgPrice
FROM Categories c
LEFT JOIN MenuItems m ON c.CategoryID = m.CategoryID
LEFT JOIN OrderDetails od ON m.MenuItemID = od.MenuItemID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY TotalRevenue DESC;
GO

-- Рейтинг официантов по сумме продаж
SELECT 
    s.FirstName + ' ' + s.LastName AS WaiterName,
    COUNT(o.OrderID) AS TotalOrders,
    SUM(o.TotalAmount) AS TotalSales,
    AVG(o.TotalAmount) AS AvgOrderAmount
FROM Staff s
JOIN Orders o ON s.StaffID = o.WaiterID
WHERE s.Position = 'Официант'
GROUP BY s.StaffID, s.FirstName, s.LastName
ORDER BY TotalSales DESC;
GO

-- Популярность столиков
SELECT 
    t.TableNumber,
    t.Location,
    t.Capacity,
    COUNT(o.OrderID) AS TotalOrders,
    SUM(o.TotalAmount) AS TotalRevenue
FROM Tables t
LEFT JOIN Orders o ON t.TableID = o.TableID
GROUP BY t.TableID, t.TableNumber, t.Location, t.Capacity
ORDER BY TotalRevenue DESC;
GO

-- Клиенты с наибольшим количеством бонусных баллов
SELECT 
    FirstName + ' ' + LastName AS CustomerName,
    Phone,
    RegistrationDate,
    LoyaltyPoints,
    (SELECT COUNT(*) FROM Orders o WHERE o.CustomerID = c.CustomerID) AS TotalOrders,
    (SELECT SUM(TotalAmount) FROM Orders o WHERE o.CustomerID = c.CustomerID) AS TotalSpent
FROM Customers c
ORDER BY LoyaltyPoints DESC;
GO

-- Маржинальность блюд
SELECT 
    ItemName,
    Price,
    Cost,
    Price - Cost AS Profit,
    CAST((Price - Cost) / Price * 100 AS DECIMAL(5,2)) AS ProfitMarginPercent,
    (SELECT COUNT(*) FROM OrderDetails od WHERE od.MenuItemID = m.MenuItemID) AS TimesOrdered
FROM MenuItems m
ORDER BY ProfitMarginPercent DESC;
GO