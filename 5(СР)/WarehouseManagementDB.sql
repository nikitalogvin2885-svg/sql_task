USE master;
GO

-- Создание базы данных для системы управления складом
IF DB_ID('WarehouseManagementDB') IS NULL
    CREATE DATABASE WarehouseManagementDB;
GO

USE WarehouseManagementDB;
GO

-- Удаление существующих таблиц, если они есть
IF OBJECT_ID('Movements', 'U') IS NOT NULL DROP TABLE Movements;
IF OBJECT_ID('Deliveries', 'U') IS NOT NULL DROP TABLE Deliveries;
IF OBJECT_ID('Suppliers', 'U') IS NOT NULL DROP TABLE Suppliers;
IF OBJECT_ID('Warehouses', 'U') IS NOT NULL DROP TABLE Warehouses;
IF OBJECT_ID('Products', 'U') IS NOT NULL DROP TABLE Products;
GO

-- Таблица Товары
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    Category NVARCHAR(50) NOT NULL,
    Unit NVARCHAR(20) NOT NULL, -- Единица измерения (шт., кг, л и т.д.)
    Cost DECIMAL(10,2) NOT NULL CHECK (Cost >= 0),
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0)
);
GO

-- Таблица Склады
CREATE TABLE Warehouses (
    WarehouseID INT IDENTITY(1,1) PRIMARY KEY,
    WarehouseName NVARCHAR(100) NOT NULL,
    Address NVARCHAR(255) NOT NULL,
    Capacity INT NOT NULL CHECK (Capacity > 0),
    Manager NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20) NOT NULL
);
GO

-- Таблица Поставщики
CREATE TABLE Suppliers (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName NVARCHAR(100) NOT NULL,
    Address NVARCHAR(255) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Email NVARCHAR(100),
    ContactPerson NVARCHAR(100)
);
GO

-- Таблица Поставки
CREATE TABLE Deliveries (
    DeliveryID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierID INT NOT NULL,
    WarehouseID INT NOT NULL,
    DeliveryDate DATETIME NOT NULL DEFAULT GETDATE(),
    DocumentNumber NVARCHAR(50) NOT NULL,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID)
);
GO

-- Таблица Детали поставок (промежуточная таблица для товаров в поставках)
CREATE TABLE DeliveryDetails (
    DeliveryDetailID INT IDENTITY(1,1) PRIMARY KEY,
    DeliveryID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity DECIMAL(10,2) NOT NULL CHECK (Quantity > 0),
    FOREIGN KEY (DeliveryID) REFERENCES Deliveries(DeliveryID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- Таблица Остатки товаров на складах
CREATE TABLE Inventory (
    InventoryID INT IDENTITY(1,1) PRIMARY KEY,
    WarehouseID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity DECIMAL(10,2) NOT NULL CHECK (Quantity >= 0),
    FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    UNIQUE (WarehouseID, ProductID)
);
GO

-- Таблица Перемещения
CREATE TABLE Movements (
    MovementID INT IDENTITY(1,1) PRIMARY KEY,
    SourceWarehouseID INT NOT NULL,
    DestinationWarehouseID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity DECIMAL(10,2) NOT NULL CHECK (Quantity > 0),
    MovementDate DATETIME NOT NULL DEFAULT GETDATE(),
    ResponsiblePerson NVARCHAR(100) NOT NULL,
    FOREIGN KEY (SourceWarehouseID) REFERENCES Warehouses(WarehouseID),
    FOREIGN KEY (DestinationWarehouseID) REFERENCES Warehouses(WarehouseID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- Заполнение таблиц тестовыми данными
-- Товары
INSERT INTO Products (ProductName, Description, Category, Unit, Cost, Price) VALUES
('Ноутбук ASUS', 'Ноутбук ASUS 15.6" i5 8GB 256GB', 'Электроника', 'шт.', 35000.00, 45000.00),
('Смартфон Samsung', 'Смартфон Samsung Galaxy A52', 'Электроника', 'шт.', 25000.00, 30000.00),
('Стул офисный', 'Стул офисный ErgoMax', 'Мебель', 'шт.', 5000.00, 7000.00),
('Стол письменный', 'Стол письменный 120x60 см', 'Мебель', 'шт.', 8000.00, 10000.00),
('Монитор 24"', 'Монитор AOC 24" Full HD', 'Электроника', 'шт.', 12000.00, 15000.00);
GO

-- Склады
INSERT INTO Warehouses (WarehouseName, Address, Capacity, Manager, Phone) VALUES
('Центральный склад', 'ул. Ленина, 10', 10000, 'Иванов Иван Иванович', '+79151234567'),
('Северный склад', 'пр. Мира, 25', 8000, 'Петрова Мария Александровна', '+79219876543'),
('Южный склад', 'ул. Советская, 5', 7000, 'Сидоров Алексей Владимирович', '+79165550123'),
('Восточный склад', 'ул. Пушкина, 15', 9000, 'Козлова Анна Ивановна', '+74957778888'),
('Западный склад', 'ул. Горького, 20', 6000, 'Смирнов Сергей Андреевич', '+79031112222');
GO

-- Поставщики
INSERT INTO Suppliers (SupplierName, Address, Phone, Email, ContactPerson) VALUES
('ТехноМир', 'ул. Ленина, 50', '+79152223344', 'info@technomir.ru', 'Алексеев Алексей Петрович'),
('ЭлектроТорг', 'пр. Мира, 30', '+79218887766', 'sales@electrotorg.ru', 'Петрова Елена Сергеевна'),
('МебельСтиль', 'ул. Советская, 15', '+79164445533', 'contact@mebelstil.ru', 'Сидоров Дмитрий Викторович'),
('ГаджетМаркет', 'ул. Пушкина, 20', '+74956667788', 'support@gadgetmarket.ru', 'Козлов Иван Михайлович'),
('ОфисПлюс', 'ул. Горького, 25', '+79032221133', 'office@officeplus.ru', 'Смирнова Ольга Николаевна');
GO

-- Поставки
INSERT INTO Deliveries (SupplierID, WarehouseID, DeliveryDate, DocumentNumber) VALUES
(1, 1, '2023-10-01 10:00:00', 'DOC-2023-001'),
(2, 2, '2023-10-02 11:00:00', 'DOC-2023-002'),
(3, 3, '2023-10-03 12:00:00', 'DOC-2023-003'),
(4, 4, '2023-10-04 13:00:00', 'DOC-2023-004'),
(5, 5, '2023-10-05 14:00:00', 'DOC-2023-005');
GO

-- Детали поставок
INSERT INTO DeliveryDetails (DeliveryID, ProductID, Quantity) VALUES
(1, 1, 10),
(1, 2, 15),
(2, 3, 20),
(2, 4, 5),
(3, 5, 8),
(4, 1, 5),
(5, 3, 10);
GO

-- Остатки товаров на складах
INSERT INTO Inventory (WarehouseID, ProductID, Quantity) VALUES
(1, 1, 10),
(1, 2, 15),
(2, 3, 20),
(2, 4, 5),
(3, 5, 8),
(4, 1, 5),
(5, 3, 10);
GO

-- Перемещения
INSERT INTO Movements (SourceWarehouseID, DestinationWarehouseID, ProductID, Quantity, MovementDate, ResponsiblePerson) VALUES
(1, 2, 1, 2, '2023-10-06 09:00:00', 'Иванов Иван Иванович'),
(2, 3, 3, 5, '2023-10-07 10:00:00', 'Петрова Мария Александровна'),
(3, 4, 5, 3, '2023-10-08 11:00:00', 'Сидоров Алексей Владимирович'),
(4, 5, 1, 1, '2023-10-09 12:00:00', 'Козлова Анна Ивановна'),
(5, 1, 3, 4, '2023-10-10 13:00:00', 'Смирнов Сергей Андреевич');
GO

-- Примеры запросов
-- Задание 1: Список товаров
SELECT ProductID, ProductName, Description, Category, Unit, Cost, Price
FROM Products;
GO

-- Задание 2: Список складов
SELECT WarehouseID, WarehouseName, Address, Capacity, Manager, Phone
FROM Warehouses;
GO

-- Задание 3: Список поставщиков
SELECT SupplierID, SupplierName, Address, Phone, Email, ContactPerson
FROM Suppliers;
GO

-- Задание 4: Список поставок с деталями
SELECT
    d.DeliveryID,
    s.SupplierName,
    w.WarehouseName,
    d.DeliveryDate,
    d.DocumentNumber,
    p.ProductName,
    dd.Quantity
FROM Deliveries d
INNER JOIN Suppliers s ON d.SupplierID = s.SupplierID
INNER JOIN Warehouses w ON d.WarehouseID = w.WarehouseID
INNER JOIN DeliveryDetails dd ON d.DeliveryID = dd.DeliveryID
INNER JOIN Products p ON dd.ProductID = p.ProductID;
GO

-- Задание 5: Остатки товаров на складах
SELECT
    w.WarehouseName,
    p.ProductName,
    i.Quantity
FROM Inventory i
INNER JOIN Warehouses w ON i.WarehouseID = w.WarehouseID
INNER JOIN Products p ON i.ProductID = p.ProductID;
GO

-- Задание 6: Перемещения товаров между складами
SELECT
    m.MovementID,
    ws.WarehouseName AS SourceWarehouse,
    wd.WarehouseName AS DestinationWarehouse,
    p.ProductName,
    m.Quantity,
    m.MovementDate,
    m.ResponsiblePerson
FROM Movements m
INNER JOIN Warehouses ws ON m.SourceWarehouseID = ws.WarehouseID
INNER JOIN Warehouses wd ON m.DestinationWarehouseID = wd.WarehouseID
INNER JOIN Products p ON m.ProductID = p.ProductID;
GO
