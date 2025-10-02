USE master;
GO

-- �������� � �������� ���� ������, ���� ��� ����������
IF DB_ID('GasStationDB') IS NOT NULL
BEGIN
    ALTER DATABASE GasStationDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE GasStationDB;
END
GO

-- �������� ���� ������
CREATE DATABASE GasStationDB;
GO

USE GasStationDB;
GO

-- �������� � �������� �������, ���� ��� ����������
IF OBJECT_ID('Fuelings_Denormalized', 'U') IS NOT NULL
    DROP TABLE Fuelings_Denormalized;
GO

-- =============================================
-- 1. ����������������� ������� "��������"
-- =============================================
CREATE TABLE Fuelings_Denormalized (
    FuelingID INT IDENTITY(1,1) PRIMARY KEY,
    ClientInfo NVARCHAR(200),
    FuelInfo NVARCHAR(150),
    PumpInfo NVARCHAR(100),
    FuelingDateTime NVARCHAR(50),
    FuelingType NVARCHAR(100),
    Liters DECIMAL(10, 2),
    PricePerLiter DECIMAL(10, 2),
    TotalCost DECIMAL(10, 2),
    PaymentInfo NVARCHAR(150),
    Comments NVARCHAR(500)
);
GO

-- ���������� ����������������� �������
INSERT INTO Fuelings_Denormalized (
    ClientInfo, FuelInfo, PumpInfo, FuelingDateTime, FuelingType,
    Liters, PricePerLiter, TotalCost, PaymentInfo, Comments
)
VALUES
('������ ���� ��������; +79123456789; ivanov@mail.ru; A123BC77; 2010; Toyota Camry; 60',
 '��-95; ��������; 48.50',
 '������� 1; ������; ��������',
 '2025-10-01 10:30:00',
 '�������� ����������',
 45.5, 48.50, 2207.75,
 '���������� �����; 2025-10-01 10:35:00; 2207.75; �������',
 '������ ���, ��� �� �����'),

('������� ����� ���������; +79234567890; petrova@mail.ru; B456CD177; 2015; Honda CR-V; 70',
 '��; �������; 52.30',
 '������� 2; ������; ��������',
 '2025-10-01 11:45:00',
 '�������� ����������',
 40.0, 52.30, 2092.00,
 '��������; 2025-10-01 11:50:00; 2100.00; �������',
 '��� �����, ������ �� ����� ����������'),

('������� ������� ��������; +79345678901; sidorov@mail.ru; C789EF777; 2018; Kia Rio; 50',
 '��-92; ������; 45.10',
 '������� 3; ������; ����������',
 '2025-10-01 12:10:00',
 '�������� ����������',
 30.0, 45.10, 1353.00,
 '���������� �����; 2025-10-01 12:15:00; 1353.00; �������',
 '��� �����, �������� �� 1000 ������');
GO

-- �������� ����������������� ������
SELECT * FROM Fuelings_Denormalized;
GO

-- �������� � �������� �������, ���� ��� ����������
IF OBJECT_ID('Fuelings_1NF', 'U') IS NOT NULL
    DROP TABLE Fuelings_1NF;
GO

-- =============================================
-- 2. ������������ �� 1��
-- =============================================
CREATE TABLE Fuelings_1NF (
    RecordID INT IDENTITY(1,1) PRIMARY KEY,
    FuelingID INT,
    ClientFName NVARCHAR(50),
    ClientMName NVARCHAR(50),
    ClientLName NVARCHAR(50),
    ClientPhone NVARCHAR(20),
    ClientEmail NVARCHAR(100),
    CarNumber NVARCHAR(20),
    CarYear INT,
    CarModel NVARCHAR(50),
    CarMileage INT,
    FuelType NVARCHAR(50),
    FuelGrade NVARCHAR(50),
    FuelPricePerLiter DECIMAL(10, 2),
    PumpNumber NVARCHAR(20),
    PumpFuelType NVARCHAR(50),
    PumpStatus NVARCHAR(50),
    FuelingDateTime DATETIME,
    FuelingType NVARCHAR(100),
    Liters DECIMAL(10, 2),
    PricePerLiter DECIMAL(10, 2),
    TotalCost DECIMAL(10, 2),
    PaymentMethod NVARCHAR(50),
    PaymentDateTime DATETIME,
    PaymentAmount DECIMAL(10, 2),
    PaymentStatus NVARCHAR(50),
    Comments NVARCHAR(500)
);
GO

-- ���������� ������� � 1��
INSERT INTO Fuelings_1NF (
    FuelingID, ClientFName, ClientMName, ClientLName, ClientPhone, ClientEmail,
    CarNumber, CarYear, CarModel, CarMileage, FuelType, FuelGrade, FuelPricePerLiter,
    PumpNumber, PumpFuelType, PumpStatus, FuelingDateTime, FuelingType,
    Liters, PricePerLiter, TotalCost, PaymentMethod, PaymentDateTime, PaymentAmount, PaymentStatus, Comments
)
SELECT
    FuelingID,
    PARSENAME(REPLACE(ClientInfo, '; ', '.'), 3) AS ClientFName,
    PARSENAME(REPLACE(ClientInfo, '; ', '.'), 2) AS ClientMName,
    PARSENAME(REPLACE(ClientInfo, '; ', '.'), 1) AS ClientLName,
    PARSENAME(REPLACE(ClientInfo, '; ', '.'), 4) AS ClientPhone,
    PARSENAME(REPLACE(ClientInfo, '; ', '.'), 5) AS ClientEmail,
    PARSENAME(REPLACE(ClientInfo, '; ', '.'), 6) AS CarNumber,
    CAST(PARSENAME(REPLACE(ClientInfo, '; ', '.'), 7) AS INT) AS CarYear,
    PARSENAME(REPLACE(ClientInfo, '; ', '.'), 8) AS CarModel,
    CAST(PARSENAME(REPLACE(ClientInfo, '; ', '.'), 9) AS INT) AS CarMileage,
    PARSENAME(REPLACE(FuelInfo, '; ', '.'), 1) AS FuelType,
    PARSENAME(REPLACE(FuelInfo, '; ', '.'), 2) AS FuelGrade,
    CAST(PARSENAME(REPLACE(FuelInfo, '; ', '.'), 3) AS DECIMAL(10, 2)) AS FuelPricePerLiter,
    PARSENAME(REPLACE(PumpInfo, '; ', '.'), 1) AS PumpNumber,
    PARSENAME(REPLACE(PumpInfo, '; ', '.'), 2) AS PumpFuelType,
    PARSENAME(REPLACE(PumpInfo, '; ', '.'), 3) AS PumpStatus,
    CAST(FuelingDateTime AS DATETIME) AS FuelingDateTime,
    FuelingType,
    Liters, PricePerLiter, TotalCost,
    PARSENAME(REPLACE(PaymentInfo, '; ', '.'), 1) AS PaymentMethod,
    CAST(PARSENAME(REPLACE(PaymentInfo, '; ', '.'), 2) + ' ' + PARSENAME(REPLACE(PaymentInfo, '; ', '.'), 3) AS DATETIME) AS PaymentDateTime,
    CAST(PARSENAME(REPLACE(PaymentInfo, '; ', '.'), 4) AS DECIMAL(10, 2)) AS PaymentAmount,
    PARSENAME(REPLACE(PaymentInfo, '; ', '.'), 5) AS PaymentStatus,
    Comments
FROM Fuelings_Denormalized;
GO

-- �������� ������ � 1��
SELECT * FROM Fuelings_1NF;
GO

-- �������� � �������� ������, ���� ��� ����������
IF OBJECT_ID('FuelTypes', 'U') IS NOT NULL DROP TABLE FuelTypes;
IF OBJECT_ID('FuelGrades', 'U') IS NOT NULL DROP TABLE FuelGrades;
IF OBJECT_ID('Pumps', 'U') IS NOT NULL DROP TABLE Pumps;
IF OBJECT_ID('Clients', 'U') IS NOT NULL DROP TABLE Clients;
IF OBJECT_ID('Cars', 'U') IS NOT NULL DROP TABLE Cars;
IF OBJECT_ID('PaymentMethods', 'U') IS NOT NULL DROP TABLE PaymentMethods;
IF OBJECT_ID('Fuelings', 'U') IS NOT NULL DROP TABLE Fuelings;
IF OBJECT_ID('Payments', 'U') IS NOT NULL DROP TABLE Payments;
GO

-- =============================================
-- 3. ������������ �� 3�� (�������� ���������� ������)
-- =============================================
-- 1. ���� �������
CREATE TABLE FuelTypes (
    FuelTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 2. ����� �������
CREATE TABLE FuelGrades (
    FuelGradeID INT IDENTITY(1,1) PRIMARY KEY,
    GradeName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200),
    FuelTypeID INT NOT NULL,
    FOREIGN KEY (FuelTypeID) REFERENCES FuelTypes(FuelTypeID)
);
GO

-- 3. �������
CREATE TABLE Pumps (
    PumpID INT IDENTITY(1,1) PRIMARY KEY,
    PumpNumber NVARCHAR(20) NOT NULL,
    FuelTypeID INT NOT NULL,
    Status NVARCHAR(50),
    FOREIGN KEY (FuelTypeID) REFERENCES FuelTypes(FuelTypeID)
);
GO

-- 4. �������
CREATE TABLE Clients (
    ClientID INT IDENTITY(1,1) PRIMARY KEY,
    FName NVARCHAR(50) NOT NULL,
    MName NVARCHAR(50),
    LName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Email NVARCHAR(100)
);
GO

-- 5. ����������
CREATE TABLE Cars (
    CarID INT IDENTITY(1,1) PRIMARY KEY,
    ClientID INT NOT NULL,
    CarNumber NVARCHAR(20) NOT NULL,
    CarYear INT,
    CarModel NVARCHAR(50),
    CarMileage INT,
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID)
);
GO

-- 6. ������� ������
CREATE TABLE PaymentMethods (
    PaymentMethodID INT IDENTITY(1,1) PRIMARY KEY,
    MethodName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 7. ��������
CREATE TABLE Fuelings (
    FuelingID INT IDENTITY(1,1) PRIMARY KEY,
    CarID INT NOT NULL,
    PumpID INT NOT NULL,
    FuelGradeID INT NOT NULL,
    FuelingDateTime DATETIME NOT NULL,
    FuelingType NVARCHAR(100),
    Liters DECIMAL(10, 2),
    PricePerLiter DECIMAL(10, 2),
    TotalCost DECIMAL(10, 2),
    Comments NVARCHAR(500),
    FOREIGN KEY (CarID) REFERENCES Cars(CarID),
    FOREIGN KEY (PumpID) REFERENCES Pumps(PumpID),
    FOREIGN KEY (FuelGradeID) REFERENCES FuelGrades(FuelGradeID)
);
GO

-- 8. �������
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    FuelingID INT NOT NULL,
    PaymentMethodID INT NOT NULL,
    PaymentDateTime DATETIME NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    Status NVARCHAR(50),
    FOREIGN KEY (FuelingID) REFERENCES Fuelings(FuelingID),
    FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethods(PaymentMethodID)
);
GO

-- ���������� ���������� ������
INSERT INTO FuelTypes (TypeName, Description)
VALUES
('������', '������ ��������� �����'),
('������', '��������� �������');
GO

INSERT INTO FuelGrades (GradeName, Description, FuelTypeID)
VALUES
('��-92', '������ ��-92', 1),
('��-95', '������ ��-95', 1),
('��', '��������� �������', 2),
('�� �������', '����������� ��������� �������', 2);
GO

INSERT INTO Pumps (PumpNumber, FuelTypeID, Status)
VALUES
('������� 1', 1, '��������'),
('������� 2', 2, '��������'),
('������� 3', 1, '����������');
GO

INSERT INTO PaymentMethods (MethodName, Description)
VALUES
('���������� �����', '������ ���������� ������'),
('��������', '������ ���������'),
('����������� ������', '������ ����� ����������� ��������� �������');
GO

-- ���������� �������� ������
INSERT INTO Clients (FName, MName, LName, Phone, Email)
VALUES
('����', '��������', '������', '+79123456789', 'ivanov@mail.ru'),
('�����', '���������', '�������', '+79234567890', 'petrova@mail.ru'),
('�������', '��������', '�������', '+79345678901', 'sidorov@mail.ru');
GO

INSERT INTO Cars (ClientID, CarNumber, CarYear, CarModel, CarMileage)
VALUES
(1, 'A123BC77', 2010, 'Toyota Camry', 60000),
(2, 'B456CD177', 2015, 'Honda CR-V', 70000),
(3, 'C789EF777', 2018, 'Kia Rio', 50000);
GO

INSERT INTO Fuelings (CarID, PumpID, FuelGradeID, FuelingDateTime, FuelingType, Liters, PricePerLiter, TotalCost, Comments)
VALUES
(1, 1, 2, '2025-10-01 10:30:00', '�������� ����������', 45.5, 48.50, 2207.75, '������ ���, ��� �� �����'),
(2, 2, 3, '2025-10-01 11:45:00', '�������� ����������', 40.0, 52.30, 2092.00, '��� �����, ������ �� ����� ����������'),
(3, 3, 1, '2025-10-01 12:10:00', '�������� ����������', 30.0, 45.10, 1353.00, '��� �����, �������� �� 1000 ������');
GO

INSERT INTO Payments (FuelingID, PaymentMethodID, PaymentDateTime, Amount, Status)
VALUES
(1, 1, '2025-10-01 10:35:00', 2207.75, '�������'),
(2, 2, '2025-10-01 11:50:00', 2100.00, '�������'),
(3, 1, '2025-10-01 12:15:00', 1353.00, '�������');
GO

-- =============================================
-- 4. ������������� �������
-- =============================================
-- 1. ������������ ����� �������
PRINT '1. ������������ ����� �������:';
GO
SELECT
    ft.TypeName AS FuelType,
    fg.GradeName AS FuelGrade,
    COUNT(f.FuelingID) AS FuelingsCount,
    SUM(f.Liters) AS TotalLiters,
    SUM(f.TotalCost) AS TotalRevenue
FROM Fuelings f
JOIN FuelGrades fg ON f.FuelGradeID = fg.FuelGradeID
JOIN FuelTypes ft ON fg.FuelTypeID = ft.FuelTypeID
GROUP BY ft.TypeName, fg.GradeName
ORDER BY FuelingsCount DESC;
GO

-- 2. ���������� �� ��������
PRINT '2. ���������� �� ��������:';
GO
SELECT
    p.PumpNumber,
    ft.TypeName AS FuelType,
    COUNT(f.FuelingID) AS FuelingsCount,
    SUM(f.Liters) AS TotalLiters,
    SUM(f.TotalCost) AS TotalRevenue
FROM Fuelings f
JOIN Pumps p ON f.PumpID = p.PumpID
JOIN FuelGrades fg ON f.FuelGradeID = fg.FuelGradeID
JOIN FuelTypes ft ON fg.FuelTypeID = ft.FuelTypeID
GROUP BY p.PumpNumber, ft.TypeName
ORDER BY FuelingsCount DESC;
GO

-- 3. ���������� �� ��������
PRINT '3. ���������� �� ��������:';
GO
SELECT
    CONCAT(c.FName, ' ', c.MName, ' ', c.LName) AS ClientName,
    car.CarModel,
    COUNT(f.FuelingID) AS FuelingsCount,
    SUM(f.Liters) AS TotalLiters,
    SUM(p.Amount) AS TotalPayments
FROM Clients c
JOIN Cars car ON c.ClientID = car.ClientID
JOIN Fuelings f ON car.CarID = f.CarID
JOIN Payments p ON f.FuelingID = p.FuelingID
GROUP BY CONCAT(c.FName, ' ', c.MName, ' ', c.LName), car.CarModel, c.ClientID
ORDER BY TotalPayments DESC;
GO
