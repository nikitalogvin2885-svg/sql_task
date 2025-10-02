CREATE DATABASE AutoServiceDB;
GO

USE AutoServiceDB;
GO

CREATE TABLE Cities (
    CityID INT PRIMARY KEY IDENTITY(1,1),
    CityName NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE CarBrands (
    BrandID INT PRIMARY KEY IDENTITY(1,1),
    BrandName NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE CarModels (
    ModelID INT PRIMARY KEY IDENTITY(1,1),
    BrandID INT NOT NULL,
    ModelName NVARCHAR(50) NOT NULL,
    FOREIGN KEY (BrandID) REFERENCES CarBrands(BrandID)
);
GO

CREATE TABLE Cars (
    CarID INT PRIMARY KEY IDENTITY(1,1),
    ModelID INT NOT NULL,
    LicensePlate NVARCHAR(20) NOT NULL,
    Year INT NOT NULL,
    Vin NVARCHAR(50) UNIQUE,
    FOREIGN KEY (ModelID) REFERENCES CarModels(ModelID)
);
GO

CREATE TABLE Clients (
    ClientID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20) NOT NULL,
    CityID INT,
    RegistrationDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CityID) REFERENCES Cities(CityID)
);
GO

CREATE TABLE ServiceTypes (
    ServiceTypeID INT PRIMARY KEY IDENTITY(1,1),
    TypeName NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE Services (
    ServiceID INT PRIMARY KEY IDENTITY(1,1),
    ServiceName NVARCHAR(100) NOT NULL,
    ServiceTypeID INT NOT NULL,
    Duration INT NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Description NVARCHAR(500),
    FOREIGN KEY (ServiceTypeID) REFERENCES ServiceTypes(ServiceTypeID)
);
GO

CREATE TABLE Mechanics (
    MechanicID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20) NOT NULL,
    ServiceTypeID INT NOT NULL,
    Experience INT, 
    FOREIGN KEY (ServiceTypeID) REFERENCES ServiceTypes(ServiceTypeID)
);
GO

CREATE TABLE SpareParts (
    PartID INT PRIMARY KEY IDENTITY(1,1),
    PartName NVARCHAR(100) NOT NULL,
    BrandID INT,
    Price DECIMAL(10, 2) NOT NULL,
    QuantityInStock INT NOT NULL,
    Description NVARCHAR(500),
    FOREIGN KEY (BrandID) REFERENCES CarBrands(BrandID)
);
GO

CREATE TABLE RepairOrders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CarID INT NOT NULL,
    ClientID INT NOT NULL,
    OrderDate DATETIME NOT NULL,
    Status NVARCHAR(20) DEFAULT 'In Progress', 
    TotalCost DECIMAL(10, 2),
    FOREIGN KEY (CarID) REFERENCES Cars(CarID),
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID)
);
GO

CREATE TABLE OrderServices (
    OrderServiceID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    ServiceID INT NOT NULL,
    MechanicID INT NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES RepairOrders(OrderID),
    FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID),
    FOREIGN KEY (MechanicID) REFERENCES Mechanics(MechanicID)
);
GO

CREATE TABLE UsedParts (
    UsedPartID INT PRIMARY KEY IDENTITY(1,1),
    OrderServiceID INT NOT NULL,
    PartID INT NOT NULL,
    Quantity INT NOT NULL,
    FOREIGN KEY (OrderServiceID) REFERENCES OrderServices(OrderServiceID),
    FOREIGN KEY (PartID) REFERENCES SpareParts(PartID)
);
GO

-- ������
INSERT INTO Cities (CityName) VALUES
('������'), ('�����-���������'), ('������'), ('�����������'), ('������������');
GO

-- ����� �����������
INSERT INTO CarBrands (BrandName) VALUES
('Toyota'), ('Honda'), ('Ford'), ('Volkswagen'), ('BMW');
GO

-- ������ �����������
INSERT INTO CarModels (BrandID, ModelName) VALUES
(1, 'Camry'), (1, 'Corolla'), (2, 'Civic'), (2, 'Accord'), (3, 'Focus'), (3, 'Fiesta'), (4, 'Golf'), (4, 'Passat'), (5, 'X5'), (5, '3 Series');
GO

INSERT INTO Cars (ModelID, LicensePlate, Year, Vin) VALUES
(2, '�456��178', 2019, '2T1BU4EE0WC567890'),
(3, '�789��77', 2020, '1HGCM82633A123456'),
(4, '�234��199', 2017, '1HGCR2F34GA654321'),
(5, '�567��777', 2016, '3VWLL7AJ0BM123456'),
(6, '�890��178', 2021, 'WVWZZZAUZGW123456'),
(7, '�123��77', 2015, 'WBA3A5C58FD987654'),
(8, '�456��199', 2022, '5UXKR0C56ML123456');

INSERT INTO Clients (FirstName, LastName, Email, Phone, CityID) VALUES
('����', '������', 'ivan.ivanov@example.com', '+79123456789', 1),
('����', '������', 'petr.petrov@example.com', '+79223456789', 2),
('�����', '�������', 'sidor.sidorov@example.com', '+79323456789', 3),
('�����', '���������', 'maria.kuznetsova@example.com', '+79423456789', 4),
('����', '���������', 'anna.vasilyeva@example.com', '+79523456789', 5);
GO

INSERT INTO ServiceTypes (TypeName) VALUES
('�����������'), ('����������� ������������'), ('������ ���������'), ('������ ��������'), ('�������� ������');
GO

INSERT INTO Services (ServiceName, ServiceTypeID, Duration, Price, Description) VALUES
('������������ �����������', 1, 60, 1500.00, '������ ������������ ����������� ����������'),
('������ �����', 2, 30, 2000.00, '������ ����� � ��������� �������'),
('������ ��������� �������', 2, 60, 3500.00, '������ �������� � ������ ��������� �������'),
('������ ���������', 3, 360, 25000.00, '����������� ������ ���������'),
('������ ����� ���', 3, 120, 8000.00, '������ ����� ���������������������� ���������'),
('������ �������������', 4, 120, 12000.00, '������ �������� � ������ �������������'),
('�������� ������', 5, 480, 30000.00, '������ �������� ������ ����������'),
('��������', 5, 240, 15000.00, '�������� ������ ����������');
GO

INSERT INTO Mechanics (FirstName, LastName, Email, Phone, ServiceTypeID, Experience) VALUES
('�������', '�������', 'alexey.smirnov@example.com', '+79134567890', 1, 5),
('�����', '���������', 'olga.kuznetsova@example.com', '+79234567890', 2, 3),
('�������', '�����', 'dmitry.popov@example.com', '+79334567890', 3, 7),
('�����', '�������', 'elena.ivanova@example.com', '+79434567890', 4, 4),
('�������', '��������', 'natalya.sokolova@example.com', '+79534567890', 5, 6);
GO

INSERT INTO SpareParts (PartName, BrandID, Price, QuantityInStock, Description) VALUES
('�������� ������', NULL, 500.00, 100, '������ ��� �����'),
('��������� �������', 1, 3000.00, 50, '�������� ��������� ������� ��� Toyota'),
('������ ���', 2, 4000.00, 30, '������ ��� ��� Honda'),
('������������', NULL, 6000.00, 20, '������ ������������'),
('������', NULL, 5000.00, 10, '������������� ������, ������ ����');
GO

INSERT INTO RepairOrders (CarID, ClientID, OrderDate, Status, TotalCost) VALUES
(1, 1, '2023-06-01T09:00:00', 'Completed', 1500.00),
(2, 2, '2023-06-02T10:00:00', 'Completed', 2000.00),
(3, 3, '2023-06-03T11:00:00', 'In Progress', NULL),
(4, 4, '2023-06-04T12:00:00', 'In Progress', NULL),
(5, 5, '2023-06-05T13:00:00', 'Scheduled', NULL);
GO

INSERT INTO OrderServices (OrderID, ServiceID, MechanicID) VALUES
(1, 1, 1),
(2, 2, 2),
(2, 3, 2),
(3, 4, 3),
(4, 5, 3),
(5, 6, 4);
GO

INSERT INTO UsedParts (OrderServiceID, PartID, Quantity) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 1),
(4, 4, 2);
GO

SELECT
    c.LicensePlate,
    cb.BrandName,
    cm.ModelName,
    ro.TotalCost
FROM
    Cars c
JOIN
    CarModels cm ON c.ModelID = cm.ModelID
JOIN
    CarBrands cb ON cm.BrandID = cb.BrandID
JOIN
    RepairOrders ro ON c.CarID = ro.CarID
WHERE
    ro.TotalCost > (SELECT AVG(TotalCost) FROM RepairOrders WHERE TotalCost IS NOT NULL AND Status = 'Completed');

SELECT
    m.FirstName,
    m.LastName,
    st.TypeName AS Specialization
FROM
    Mechanics m
JOIN
    ServiceTypes st ON m.ServiceTypeID = st.ServiceTypeID
WHERE
    m.MechanicID IN (
        SELECT DISTINCT os.MechanicID
        FROM OrderServices os
        JOIN RepairOrders ro ON os.OrderID = ro.OrderID
        JOIN Cars c ON ro.CarID = c.CarID
        JOIN CarModels cm ON c.ModelID = cm.ModelID
        JOIN CarBrands cb ON cm.BrandID = cb.BrandID
        WHERE cb.BrandName = 'BMW'
    );

SELECT
    m.FirstName,
    m.LastName,
    st.TypeName AS Specialization
FROM
    Mechanics m
JOIN
    ServiceTypes st ON m.ServiceTypeID = st.ServiceTypeID
WHERE
    m.MechanicID IN (
        SELECT DISTINCT os.MechanicID
        FROM OrderServices os
        JOIN RepairOrders ro ON os.OrderID = ro.OrderID
        JOIN Cars c ON ro.CarID = c.CarID
        JOIN CarModels cm ON c.ModelID = cm.ModelID
        JOIN CarBrands cb ON cm.BrandID = cb.BrandID
        WHERE cb.BrandName = 'BMW'
    );

SELECT
    ro.OrderID,
    c.FirstName + ' ' + c.LastName AS ClientName,
    ro.TotalCost
FROM
    RepairOrders ro
JOIN
    Clients c ON ro.ClientID = c.ClientID
WHERE
    ro.TotalCost > (
        SELECT AVG(TotalCost)
        FROM RepairOrders
        WHERE ClientID = ro.ClientID AND TotalCost IS NOT NULL
    )
    AND ro.TotalCost IS NOT NULL;

SELECT
    c.FirstName,
    c.LastName,
    c.Phone
FROM
    Clients c
WHERE
    EXISTS (
        SELECT 1
        FROM RepairOrders ro
        WHERE ro.ClientID = c.ClientID
        GROUP BY ro.ClientID
        HAVING COUNT(*) > 1
    );

DECLARE @OrderID INT, @LicensePlate NVARCHAR(20), @ClientName NVARCHAR(100), @OrderDate DATETIME, @TotalCost DECIMAL(10, 2), @Status NVARCHAR(20);
DECLARE order_cursor CURSOR FOR
SELECT
    ro.OrderID,
    c.LicensePlate,
    cl.FirstName + ' ' + cl.LastName AS ClientName,
    ro.OrderDate,
    ro.TotalCost,
    ro.Status
FROM
    RepairOrders ro
JOIN
    Cars c ON ro.CarID = c.CarID
JOIN
    Clients cl ON ro.ClientID = cl.ClientID;
OPEN order_cursor;
FETCH NEXT FROM order_cursor INTO @OrderID, @LicensePlate, @ClientName, @OrderDate, @TotalCost, @Status;
PRINT '���������� � �������';
PRINT '========================================';
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '����� ID: ' + CAST(@OrderID AS VARCHAR) + ', ����������: ' + @LicensePlate + ', ������: ' + @ClientName +
          ', ����: ' + CONVERT(NVARCHAR(20), @OrderDate, 120) +
          ', ���������: ' + ISNULL(CAST(@TotalCost AS VARCHAR), '�� �������') +
          ', ������: ' + @Status;
    FETCH NEXT FROM order_cursor INTO @OrderID, @LicensePlate, @ClientName, @OrderDate, @TotalCost, @Status;
END;
CLOSE order_cursor;
DEALLOCATE order_cursor;

DECLARE @ClientID INT, @ClientNamef NVARCHAR(100), @OrderIDf INT, @LicensePlatef NVARCHAR(20), @OrderDatef DATETIME, @TotalCostf DECIMAL(10, 2), @Statusf NVARCHAR(20);
DECLARE client_cursor CURSOR FOR
SELECT ClientID, FirstName + ' ' + LastName AS ClientName FROM Clients;
OPEN client_cursor;
FETCH NEXT FROM client_cursor INTO @ClientID, @ClientName;
PRINT '������ �� ��������';
PRINT '============================';
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '';
    PRINT '������: ' + @ClientName;
    PRINT '----------------------------------------';
    DECLARE order_cursor CURSOR LOCAL FOR
    SELECT ro.OrderID, c.LicensePlate, ro.OrderDate, ro.TotalCost, ro.Status
    FROM RepairOrders ro
    JOIN Cars c ON ro.CarID = c.CarID
    WHERE ro.ClientID = @ClientID;
    OPEN order_cursor;
    FETCH NEXT FROM order_cursor INTO @OrderID, @LicensePlate, @OrderDate, @TotalCost, @Status;
    IF @@FETCH_STATUS != 0
        PRINT '   ��� �������';
    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT '   ����� ID: ' + CAST(@OrderID AS VARCHAR) + ', ����������: ' + @LicensePlate +
              ', ����: ' + CONVERT(NVARCHAR(20), @OrderDate, 120) +
              ', ���������: ' + ISNULL(CAST(@TotalCost AS VARCHAR), '�� �������') +
              ', ������: ' + @Status;
        FETCH NEXT FROM order_cursor INTO @OrderID, @LicensePlate, @OrderDate, @TotalCost, @Status;
    END;
    CLOSE order_cursor;
    DEALLOCATE order_cursor;
    FETCH NEXT FROM client_cursor INTO @ClientID, @ClientName;
END;
CLOSE client_cursor;
DEALLOCATE client_cursor;

CREATE INDEX IX_Cars_ModelID ON Cars(ModelID);
CREATE INDEX IX_Cars_LicensePlate ON Cars(LicensePlate);
CREATE INDEX IX_Clients_CityID ON Clients(CityID);
CREATE INDEX IX_Mechanics_ServiceTypeID ON Mechanics(ServiceTypeID);
CREATE INDEX IX_Services_ServiceTypeID ON Services(ServiceTypeID);
CREATE INDEX IX_RepairOrders_CarID ON RepairOrders(CarID);
CREATE INDEX IX_RepairOrders_ClientID ON RepairOrders(ClientID);
CREATE INDEX IX_RepairOrders_Status ON RepairOrders(Status);
CREATE INDEX IX_OrderServices_OrderID ON OrderServices(OrderID);
CREATE INDEX IX_OrderServices_ServiceID ON OrderServices(ServiceID);
CREATE INDEX IX_OrderServices_MechanicID ON OrderServices(MechanicID);
CREATE INDEX IX_UsedParts_OrderServiceID ON UsedParts(OrderServiceID);
CREATE INDEX IX_UsedParts_PartID ON UsedParts(PartID);
