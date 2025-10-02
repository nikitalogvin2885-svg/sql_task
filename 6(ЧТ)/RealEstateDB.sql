CREATE DATABASE RealEstateDB;
GO

USE RealEstateDB;
GO

CREATE TABLE Cities (
    CityID INT PRIMARY KEY IDENTITY(1,1),
    CityName NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE PropertyTypes (
    PropertyTypeID INT PRIMARY KEY IDENTITY(1,1),
    TypeName NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE Properties (
    PropertyID INT PRIMARY KEY IDENTITY(1,1),
    Address NVARCHAR(200) NOT NULL,
    CityID INT,
    PropertyTypeID INT,
    Area DECIMAL(10, 2) NOT NULL, 
    Price DECIMAL(18, 2) NOT NULL,
    Description NVARCHAR(500),
    FOREIGN KEY (CityID) REFERENCES Cities(CityID),
    FOREIGN KEY (PropertyTypeID) REFERENCES PropertyTypes(PropertyTypeID)
);
GO

CREATE TABLE Clients (
    ClientID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    CityID INT,
    FOREIGN KEY (CityID) REFERENCES Cities(CityID)
);
GO

CREATE TABLE Agents (
    AgentID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    HireDate DATE,
    CommissionRate DECIMAL(5, 2) 
);
GO

CREATE TABLE Viewings (
    ViewingID INT PRIMARY KEY IDENTITY(1,1),
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

CREATE TABLE Deals (
    DealID INT PRIMARY KEY IDENTITY(1,1),
    PropertyID INT NOT NULL,
    ClientID INT NOT NULL,
    AgentID INT NOT NULL,
    DealDate DATETIME NOT NULL,
    DealPrice DECIMAL(18, 2) NOT NULL,
    Status NVARCHAR(20) DEFAULT 'In Progress', 
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID),
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
    FOREIGN KEY (AgentID) REFERENCES Agents(AgentID)
);
GO

INSERT INTO Cities (CityName) VALUES
('Москва'), ('Санкт-Петербург'), ('Казань'), ('Новосибирск'), ('Екатеринбург');
GO

INSERT INTO PropertyTypes (TypeName) VALUES
('Квартира'), ('Дом'), ('Коммерческая недвижимость'), ('Земля'), ('Гараж');
GO

INSERT INTO Properties (Address, CityID, PropertyTypeID, Area, Price, Description) VALUES
('ул. Ленина, 10', 1, 1, 65.5, 8000000, 'Двухкомнатная квартира в центре'),
('ул. Пушкина, 25', 2, 1, 80.0, 12000000, 'Трехкомнатная квартира с ремонтом'),
('ул. Гагарина, 5', 3, 2, 120.0, 15000000, 'Дом с участком'),
('ул. Мира, 15', 4, 4, 500.0, 5000000, 'Земельный участок под строительство'),
('ул. Советская, 30', 5, 3, 200.0, 20000000, 'Офисное помещение');
GO

INSERT INTO Clients (FirstName, LastName, Email, Phone, CityID) VALUES
('Иван', 'Иванов', 'ivan.ivanov@example.com', '+79123456789', 1),
('Петр', 'Петров', 'petr.petrov@example.com', '+79223456789', 2),
('Сидор', 'Сидоров', 'sidor.sidorov@example.com', '+79323456789', 3),
('Мария', 'Кузнецова', 'maria.kuznetsova@example.com', '+79423456789', 4),
('Анна', 'Васильева', 'anna.vasilyeva@example.com', '+79523456789', 5);
GO

INSERT INTO Agents (FirstName, LastName, Email, Phone, HireDate, CommissionRate) VALUES
('Алексей', 'Смирнов', 'alexey.smirnov@example.com', '+79134567890', '2018-01-10', 3.0),
('Ольга', 'Кузнецова', 'olga.kuznetsova@example.com', '+79234567890', '2019-03-15', 2.5),
('Дмитрий', 'Попов', 'dmitry.popov@example.com', '+79334567890', '2017-05-20', 3.5),
('Елена', 'Иванова', 'elena.ivanova@example.com', '+79434567890', '2020-02-12', 2.0);
GO

INSERT INTO Viewings (PropertyID, ClientID, AgentID, ViewingDate, Comments) VALUES
(1, 1, 1, '2023-06-01T10:00:00', 'Клиенту понравилось'),
(2, 2, 2, '2023-06-02T11:00:00', 'Нужно подумать'),
(3, 3, 3, '2023-06-03T12:00:00', 'Интересует'),
(4, 4, 1, '2023-06-04T13:00:00', 'Не подходит'),
(5, 5, 2, '2023-06-05T14:00:00', 'Возможно');
GO

INSERT INTO Deals (PropertyID, ClientID, AgentID, DealDate, DealPrice, Status) VALUES
(1, 1, 1, '2023-06-10T15:00:00', 7900000, 'Completed'),
(2, 2, 2, '2023-06-15T16:00:00', 11800000, 'In Progress'),
(3, 3, 3, '2023-06-20T17:00:00', 14800000, 'Cancelled'),
(4, 4, 1, '2023-06-25T18:00:00', 4900000, 'In Progress');
GO

SELECT
    p.Address,
    p.Price,
    pt.TypeName
FROM
    Properties p
JOIN
    PropertyTypes pt ON p.PropertyTypeID = pt.PropertyTypeID
WHERE
    p.Price > (SELECT AVG(Price) FROM Properties);

SELECT
    c.FirstName,
    c.LastName,
    c.Email
FROM
    Clients c
WHERE
    c.ClientID IN (
        SELECT DISTINCT v.ClientID
        FROM Viewings v
        JOIN Properties p ON v.PropertyID = p.PropertyID
        JOIN PropertyTypes pt ON p.PropertyTypeID = pt.PropertyTypeID
        WHERE pt.TypeName = 'Квартира'
    );

SELECT
    a.FirstName,
    a.LastName,
    a.CommissionRate
FROM
    Agents a
WHERE
    a.CommissionRate = (
        SELECT MAX(CommissionRate)
        FROM Agents
    );

SELECT
    p.Address,
    p.Price,
    pt.TypeName
FROM
    Properties p
JOIN
    PropertyTypes pt ON p.PropertyTypeID = pt.PropertyTypeID
WHERE
    EXISTS (
        SELECT 1
        FROM Viewings v
        WHERE v.PropertyID = p.PropertyID
    );

DECLARE @ClientID INT, @FirstName NVARCHAR(50), @LastName NVARCHAR(50), @PropertyAddress NVARCHAR(200), @ViewingDate DATETIME;
DECLARE client_cursor CURSOR FOR
SELECT
    c.ClientID,
    c.FirstName,
    c.LastName,
    p.Address,
    v.ViewingDate
FROM
    Clients c
JOIN
    Viewings v ON c.ClientID = v.ClientID
JOIN
    Properties p ON v.PropertyID = p.PropertyID;
OPEN client_cursor;
FETCH NEXT FROM client_cursor INTO @ClientID, @FirstName, @LastName, @PropertyAddress, @ViewingDate;
PRINT 'ИНФОРМАЦИЯ О ПРОСМОТРАХ КЛИЕНТОВ';
PRINT '========================================';
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Клиент: ' + @FirstName + ' ' + @LastName + ', Адрес объекта: ' + @PropertyAddress + ', Дата просмотра: ' + CONVERT(NVARCHAR(20), @ViewingDate, 120);
    FETCH NEXT FROM client_cursor INTO @ClientID, @FirstName, @LastName, @PropertyAddress, @ViewingDate;
END;
CLOSE client_cursor;
DEALLOCATE client_cursor;

DECLARE @AgentID INT, @AgentName NVARCHAR(100), @DealID INT, @DealDate DATETIME, @DealPrice DECIMAL(18, 2), @Status NVARCHAR(20);
DECLARE agent_cursor CURSOR FOR
SELECT AgentID, FirstName + ' ' + LastName AS AgentName FROM Agents;
OPEN agent_cursor;
FETCH NEXT FROM agent_cursor INTO @AgentID, @AgentName;
PRINT 'СДЕЛКИ ПО АГЕНТАМ';
PRINT '============================';
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '';
    PRINT 'Агент: ' + @AgentName;
    PRINT '----------------------------------------';
    DECLARE deal_cursor CURSOR LOCAL FOR
    SELECT DealID, DealDate, DealPrice, Status FROM Deals WHERE AgentID = @AgentID;
    OPEN deal_cursor;
    FETCH NEXT FROM deal_cursor INTO @DealID, @DealDate, @DealPrice, @Status;
    IF @@FETCH_STATUS != 0
        PRINT '   Нет сделок';
    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT '   Сделка ID: ' + CAST(@DealID AS VARCHAR) + ', Дата: ' + CONVERT(NVARCHAR(20), @DealDate, 120) + ', Сумма: ' + CAST(@DealPrice AS VARCHAR) + ', Статус: ' + @Status;
        FETCH NEXT FROM deal_cursor INTO @DealID, @DealDate, @DealPrice, @Status;
    END;
    CLOSE deal_cursor;
    DEALLOCATE deal_cursor;
    FETCH NEXT FROM agent_cursor INTO @AgentID, @AgentName;
END;
CLOSE agent_cursor;
DEALLOCATE agent_cursor;

DECLARE @DealIDf INT, @DealDateg DATETIME;
DECLARE deal_cursor CURSOR FOR
SELECT DealID, DealDate FROM Deals WHERE Status = 'In Progress' AND DealDate < DATEADD(MONTH, -1, GETDATE());
OPEN deal_cursor;
FETCH NEXT FROM deal_cursor INTO @DealID, @DealDate;
PRINT 'ОБНОВЛЕНИЕ СТАТУСА СДЕЛОК';
PRINT '================================';
WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE Deals
    SET Status = 'Cancelled'
    WHERE DealID = @DealID;
    PRINT 'Сделка ID ' + CAST(@DealID AS VARCHAR) + ' - статус изменен на "Cancelled"';
    FETCH NEXT FROM deal_cursor INTO @DealID, @DealDate;
END;
CLOSE deal_cursor;
DEALLOCATE deal_cursor;
PRINT 'Обновление завершено.';

CREATE INDEX IX_Properties_CityID ON Properties(CityID);
CREATE INDEX IX_Properties_PropertyTypeID ON Properties(PropertyTypeID);
CREATE INDEX IX_Viewings_PropertyID ON Viewings(PropertyID);
CREATE INDEX IX_Viewings_ClientID ON Viewings(ClientID);
CREATE INDEX IX_Viewings_AgentID ON Viewings(AgentID);
CREATE INDEX IX_Deals_PropertyID ON Deals(PropertyID);
CREATE INDEX IX_Deals_ClientID ON Deals(ClientID);
CREATE INDEX IX_Deals_AgentID ON Deals(AgentID);
CREATE INDEX IX_Deals_Status ON Deals(Status);
