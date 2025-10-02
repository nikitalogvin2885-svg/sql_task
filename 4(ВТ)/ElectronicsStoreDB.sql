USE master;
GO

-- �������� � �������� ���� ������, ���� ��� ����������
IF DB_ID('ElectronicsStoreDB') IS NOT NULL
BEGIN
    ALTER DATABASE ElectronicsStoreDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE ElectronicsStoreDB;
END
GO

-- �������� ���� ������
CREATE DATABASE ElectronicsStoreDB;
GO

USE ElectronicsStoreDB;
GO

-- �������� � �������� �������, ���� ��� ����������
IF OBJECT_ID('Purchases_Denormalized', 'U') IS NOT NULL
    DROP TABLE Purchases_Denormalized;
GO

-- =============================================
-- 1. ����������������� ������� "�������"
-- =============================================
CREATE TABLE Purchases_Denormalized (
    PurchaseID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerInfo NVARCHAR(200),
    DeviceInfo NVARCHAR(200),
    SpecificationsInfo NVARCHAR(200),
    PurchaseDateTime NVARCHAR(50),
    WarrantyInfo NVARCHAR(100),
    Price DECIMAL(10, 2),
    Quantity INT,
    TotalCost DECIMAL(10, 2),
    PaymentInfo NVARCHAR(150),
    Comments NVARCHAR(500)
);
GO

-- ���������� ����������������� �������
INSERT INTO Purchases_Denormalized (
    CustomerInfo, DeviceInfo, SpecificationsInfo, PurchaseDateTime, WarrantyInfo,
    Price, Quantity, TotalCost, PaymentInfo, Comments
)
VALUES
('������ ���� ��������; +79123456789; ivanov@mail.ru; 1985-05-15',
 '�������� Apple iPhone 13; 128 ��; ������; 2021',
 '�����: 6.1 ����; ���������: A15 Bionic; ������: 4 ��; �����������: 3240 ���',
 '2025-10-01 12:30:00',
 '24 ������; �� 2027-10-01',
 79990.00, 1, 79990.00,
 '���������� �����; 2025-10-01 12:35:00; �������',
 '���������� ��������, ��� �� �����'),

('������� ����� ���������; +79234567890; petrova@mail.ru; 1990-08-22',
 '������� ASUS ROG Zephyrus G14; 16 ��; �����; 2023',
 '�����: 14 ����; ���������: AMD Ryzen 9; ������: 16 ��; �����������: 76 ���',
 '2025-10-02 15:45:00',
 '36 �������; �� 2028-10-02',
 129990.00, 1, 129990.00,
 '��������; 2025-10-02 15:50:00; �������',
 '��������� ��������� Windows, ��� �����'),

('������� ������� ��������; +79345678901; sidorov@mail.ru; 1988-11-30',
 '�������� Sony WH-1000XM4; ������; 2020',
 '���: ������������; �����������: 30 �����; ���: 255 �; ��������: ��',
 '2025-10-03 10:10:00',
 '12 �������; �� 2026-10-03',
 24990.00, 2, 49980.00,
 '���������� �����; 2025-10-03 10:15:00; �������',
 '��� �����, ������ �� ����� ����������');
GO

-- �������� ����������������� ������
SELECT * FROM Purchases_Denormalized;
GO

-- �������� � �������� �������, ���� ��� ����������
IF OBJECT_ID('Purchases_1NF', 'U') IS NOT NULL
    DROP TABLE Purchases_1NF;
GO

-- =============================================
-- 2. ������������ �� 1��
-- =============================================
CREATE TABLE Purchases_1NF (
    RecordID INT IDENTITY(1,1) PRIMARY KEY,
    PurchaseID INT,
    CustomerFName NVARCHAR(50),
    CustomerMName NVARCHAR(50),
    CustomerLName NVARCHAR(50),
    CustomerPhone NVARCHAR(20),
    CustomerEmail NVARCHAR(100),
    CustomerBirthDate DATE,
    DeviceName NVARCHAR(100),
    DeviceModel NVARCHAR(100),
    DeviceStorage NVARCHAR(50),
    DeviceColor NVARCHAR(50),
    DeviceYear INT,
    ScreenSize DECIMAL(5, 2),
    Processor NVARCHAR(100),
    RAM NVARCHAR(50),
    Battery NVARCHAR(50),
    DeviceType NVARCHAR(100),
    BatteryLife NVARCHAR(50),
    DeviceWeight NVARCHAR(50),
    HasMicrophone BIT,
    PurchaseDateTime DATETIME,
    WarrantyPeriod INT,
    WarrantyEndDate DATE,
    Price DECIMAL(10, 2),
    Quantity INT,
    TotalCost DECIMAL(10, 2),
    PaymentMethod NVARCHAR(50),
    PaymentDateTime DATETIME,
    PaymentStatus NVARCHAR(50),
    Comments NVARCHAR(500)
);
GO

-- ���������� ������� � 1��
INSERT INTO Purchases_1NF (
    PurchaseID, CustomerFName, CustomerMName, CustomerLName, CustomerPhone, CustomerEmail, CustomerBirthDate,
    DeviceName, DeviceModel, DeviceStorage, DeviceColor, DeviceYear,
    ScreenSize, Processor, RAM, Battery, DeviceType, BatteryLife, DeviceWeight, HasMicrophone,
    PurchaseDateTime, WarrantyPeriod, WarrantyEndDate, Price, Quantity, TotalCost,
    PaymentMethod, PaymentDateTime, PaymentStatus, Comments
)
SELECT
    PurchaseID,
    PARSENAME(REPLACE(CustomerInfo, '; ', '.'), 3) AS CustomerFName,
    PARSENAME(REPLACE(CustomerInfo, '; ', '.'), 2) AS CustomerMName,
    PARSENAME(REPLACE(CustomerInfo, '; ', '.'), 1) AS CustomerLName,
    PARSENAME(REPLACE(CustomerInfo, '; ', '.'), 4) AS CustomerPhone,
    PARSENAME(REPLACE(CustomerInfo, '; ', '.'), 5) AS CustomerEmail,
    CAST(PARSENAME(REPLACE(CustomerInfo, '; ', '.'), 6) AS DATE) AS CustomerBirthDate,
    PARSENAME(REPLACE(DeviceInfo, '; ', '.'), 1) AS DeviceName,
    PARSENAME(REPLACE(DeviceInfo, '; ', '.'), 2) AS DeviceModel,
    PARSENAME(REPLACE(DeviceInfo, '; ', '.'), 3) AS DeviceStorage,
    PARSENAME(REPLACE(DeviceInfo, '; ', '.'), 4) AS DeviceColor,
    CAST(PARSENAME(REPLACE(DeviceInfo, '; ', '.'), 5) AS INT) AS DeviceYear,
    CAST(LEFT(PARSENAME(REPLACE(SpecificationsInfo, '; ', '.'), 1), CHARINDEX(' ', PARSENAME(REPLACE(SpecificationsInfo, '; ', '.'), 1)) - 1) AS DECIMAL(5, 2)) AS ScreenSize,
    PARSENAME(REPLACE(SpecificationsInfo, '; ', '.'), 2) AS Processor,
    PARSENAME(REPLACE(SpecificationsInfo, '; ', '.'), 3) AS RAM,
    PARSENAME(REPLACE(SpecificationsInfo, '; ', '.'), 4) AS Battery,
    PARSENAME(REPLACE(SpecificationsInfo, '; ', '.'), 5) AS DeviceType,
    PARSENAME(REPLACE(SpecificationsInfo, '; ', '.'), 6) AS BatteryLife,
    PARSENAME(REPLACE(SpecificationsInfo, '; ', '.'), 7) AS DeviceWeight,
    CASE WHEN PARSENAME(REPLACE(SpecificationsInfo, '; ', '.'), 8) = '��' THEN 1 ELSE 0 END AS HasMicrophone,
    CAST(PurchaseDateTime AS DATETIME) AS PurchaseDateTime,
    CAST(LEFT(WarrantyInfo, CHARINDEX(';', WarrantyInfo) - 1) AS INT) AS WarrantyPeriod,
    CAST(SUBSTRING(WarrantyInfo, CHARINDEX('�� ', WarrantyInfo) + 3, LEN(WarrantyInfo)) AS DATE) AS WarrantyEndDate,
    Price, Quantity, TotalCost,
    PARSENAME(REPLACE(PaymentInfo, '; ', '.'), 1) AS PaymentMethod,
    CAST(PARSENAME(REPLACE(PaymentInfo, '; ', '.'), 2) + ' ' + PARSENAME(REPLACE(PaymentInfo, '; ', '.'), 3) AS DATETIME) AS PaymentDateTime,
    PARSENAME(REPLACE(PaymentInfo, '; ', '.'), 4) AS PaymentStatus,
    Comments
FROM Purchases_Denormalized;
GO

-- �������� ������ � 1��
SELECT * FROM Purchases_1NF;
GO

-- �������� � �������� ������, ���� ��� ����������
IF OBJECT_ID('DeviceTypes', 'U') IS NOT NULL DROP TABLE DeviceTypes;
IF OBJECT_ID('DeviceModels', 'U') IS NOT NULL DROP TABLE DeviceModels;
IF OBJECT_ID('Specifications', 'U') IS NOT NULL DROP TABLE Specifications;
IF OBJECT_ID('Customers', 'U') IS NOT NULL DROP TABLE Customers;
IF OBJECT_ID('WarrantyPeriods', 'U') IS NOT NULL DROP TABLE WarrantyPeriods;
IF OBJECT_ID('PaymentMethods', 'U') IS NOT NULL DROP TABLE PaymentMethods;
IF OBJECT_ID('Purchases', 'U') IS NOT NULL DROP TABLE Purchases;
IF OBJECT_ID('Payments', 'U') IS NOT NULL DROP TABLE Payments;
GO

-- =============================================
-- 3. ������������ �� 3�� (�������� ���������� ������)
-- =============================================
-- 1. ���� ���������
CREATE TABLE DeviceTypes (
    DeviceTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 2. ������ ���������
CREATE TABLE DeviceModels (
    DeviceModelID INT IDENTITY(1,1) PRIMARY KEY,
    DeviceTypeID INT NOT NULL,
    ModelName NVARCHAR(100) NOT NULL,
    Storage NVARCHAR(50),
    Color NVARCHAR(50),
    Year INT,
    FOREIGN KEY (DeviceTypeID) REFERENCES DeviceTypes(DeviceTypeID)
);
GO

-- 3. �������������� ���������
CREATE TABLE Specifications (
    SpecificationID INT IDENTITY(1,1) PRIMARY KEY,
    DeviceModelID INT NOT NULL,
    ScreenSize DECIMAL(5, 2),
    Processor NVARCHAR(100),
    RAM NVARCHAR(50),
    Battery NVARCHAR(50),
    BatteryLife NVARCHAR(50),
    DeviceWeight NVARCHAR(50),
    HasMicrophone BIT,
    FOREIGN KEY (DeviceModelID) REFERENCES DeviceModels(DeviceModelID)
);
GO

-- 4. ����������
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

-- 5. ������� ��������
CREATE TABLE WarrantyPeriods (
    WarrantyPeriodID INT IDENTITY(1,1) PRIMARY KEY,
    PeriodMonths INT NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 6. ������� ������
CREATE TABLE PaymentMethods (
    PaymentMethodID INT IDENTITY(1,1) PRIMARY KEY,
    MethodName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 7. �������
CREATE TABLE Purchases (
    PurchaseID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    DeviceModelID INT NOT NULL,
    PurchaseDateTime DATETIME NOT NULL,
    WarrantyPeriodID INT NOT NULL,
    WarrantyEndDate DATE NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Quantity INT NOT NULL,
    TotalCost DECIMAL(10, 2) NOT NULL,
    Comments NVARCHAR(500),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (DeviceModelID) REFERENCES DeviceModels(DeviceModelID),
    FOREIGN KEY (WarrantyPeriodID) REFERENCES WarrantyPeriods(WarrantyPeriodID)
);
GO

-- 8. �������
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    PurchaseID INT NOT NULL,
    PaymentMethodID INT NOT NULL,
    PaymentDateTime DATETIME NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    Status NVARCHAR(50),
    FOREIGN KEY (PurchaseID) REFERENCES Purchases(PurchaseID),
    FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethods(PaymentMethodID)
);
GO

-- ���������� ���������� ������
INSERT INTO DeviceTypes (TypeName, Description)
VALUES
('��������', '��������� ��������'),
('�������', '����������� ����������'),
('��������', '������������ � ��������� ��������');
GO

INSERT INTO DeviceModels (DeviceTypeID, ModelName, Storage, Color, Year)
VALUES
(1, 'Apple iPhone 13', '128 ��', '������', 2021),
(2, 'ASUS ROG Zephyrus G14', '16 ��', '�����', 2023),
(3, 'Sony WH-1000XM4', NULL, '������', 2020);
GO

INSERT INTO Specifications (DeviceModelID, ScreenSize, Processor, RAM, Battery, BatteryLife, DeviceWeight, HasMicrophone)
VALUES
(1, 6.1, 'A15 Bionic', '4 ��', '3240 ���', NULL, NULL, 0),
(2, 14.0, 'AMD Ryzen 9', '16 ��', '76 ���', NULL, NULL, 0),
(3, NULL, NULL, NULL, NULL, '30 �����', '255 �', 1);
GO

INSERT INTO WarrantyPeriods (PeriodMonths, Description)
VALUES
(12, '����������� �������� �� 1 ���'),
(24, '����������� �������� �� 2 ����'),
(36, '������������ �������� �� 3 ����');
GO

INSERT INTO PaymentMethods (MethodName, Description)
VALUES
('���������� �����', '������ ���������� ������'),
('��������', '������ ���������'),
('����������� ������', '������ ����� ����������� ��������� �������');
GO

-- ���������� �������� ������
INSERT INTO Customers (FName, MName, LName, Phone, Email, BirthDate)
VALUES
('����', '��������', '������', '+79123456789', 'ivanov@mail.ru', '1985-05-15'),
('�����', '���������', '�������', '+79234567890', 'petrova@mail.ru', '1990-08-22'),
('�������', '��������', '�������', '+79345678901', 'sidorov@mail.ru', '1988-11-30');
GO

INSERT INTO Purchases (CustomerID, DeviceModelID, PurchaseDateTime, WarrantyPeriodID, WarrantyEndDate, Price, Quantity, TotalCost, Comments)
VALUES
(1, 1, '2025-10-01 12:30:00', 2, '2027-10-01', 79990.00, 1, 79990.00, '���������� ��������, ��� �� �����'),
(2, 2, '2025-10-02 15:45:00', 3, '2028-10-02', 129990.00, 1, 129990.00, '��������� ��������� Windows, ��� �����'),
(3, 3, '2025-10-03 10:10:00', 1, '2026-10-03', 24990.00, 2, 49980.00, '��� �����, ������ �� ����� ����������');
GO

INSERT INTO Payments (PurchaseID, PaymentMethodID, PaymentDateTime, Amount, Status)
VALUES
(1, 1, '2025-10-01 12:35:00', 79990.00, '�������'),
(2, 2, '2025-10-02 15:50:00', 129990.00, '�������'),
(3, 1, '2025-10-03 10:15:00', 49980.00, '�������');
GO

-- =============================================
-- 4. ������������� �������
-- =============================================
-- 1. ������������ ����� ���������
PRINT '1. ������������ ����� ���������:';
GO
SELECT
    dt.TypeName AS DeviceType,
    dm.ModelName AS DeviceModel,
    COUNT(p.PurchaseID) AS PurchasesCount,
    SUM(p.TotalCost) AS TotalRevenue
FROM Purchases p
JOIN DeviceModels dm ON p.DeviceModelID = dm.DeviceModelID
JOIN DeviceTypes dt ON dm.DeviceTypeID = dt.DeviceTypeID
GROUP BY dt.TypeName, dm.ModelName
ORDER BY PurchasesCount DESC;
GO

-- 2. ���������� �� ����������� ��������
PRINT '2. ���������� �� ����������� ��������:';
GO
SELECT
    wp.PeriodMonths AS WarrantyPeriodMonths,
    COUNT(p.PurchaseID) AS PurchasesCount,
    SUM(p.TotalCost) AS TotalRevenue
FROM Purchases p
JOIN WarrantyPeriods wp ON p.WarrantyPeriodID = wp.WarrantyPeriodID
GROUP BY wp.PeriodMonths
ORDER BY PurchasesCount DESC;
GO

-- 3. ���������� �� �����������
PRINT '3. ���������� �� �����������:';
GO
SELECT
    CONCAT(c.FName, ' ', c.MName, ' ', c.LName) AS CustomerName,
    COUNT(p.PurchaseID) AS PurchasesCount,
    SUM(p.TotalCost) AS TotalPayments
FROM Customers c
JOIN Purchases p ON c.CustomerID = p.CustomerID
GROUP BY CONCAT(c.FName, ' ', c.MName, ' ', c.LName), c.CustomerID
ORDER BY TotalPayments DESC;
GO
