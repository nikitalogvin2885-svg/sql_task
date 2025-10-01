USE master;
GO

-- �������� ���� ������ ��� ����������
IF DB_ID('CarDealershipDB') IS NULL
    CREATE DATABASE CarDealershipDB;
GO

USE CarDealershipDB;
GO

-- �������� ������������ ������, ���� ��� ����
IF OBJECT_ID('Sales', 'U') IS NOT NULL DROP TABLE Sales;
IF OBJECT_ID('Cars', 'U') IS NOT NULL DROP TABLE Cars;
IF OBJECT_ID('Brands', 'U') IS NOT NULL DROP TABLE Brands;
IF OBJECT_ID('Clients', 'U') IS NOT NULL DROP TABLE Clients;
IF OBJECT_ID('Employees', 'U') IS NOT NULL DROP TABLE Employees;
GO

-- �������� ������� �����
CREATE TABLE Brands (
    BrandID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    Country NVARCHAR(50) NOT NULL,
    FoundingYear INT,
    Logo NVARCHAR(255)
);
GO

-- �������� ������� ����������
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

-- �������� ������� �������
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

-- �������� ������� ����������
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

-- �������� ������� �������
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
-- ���������� ��������� �������
-- =============================================

-- ���������� ������� �����
INSERT INTO Brands (Name, Country, FoundingYear, Logo) VALUES
('Toyota', '������', 1937, 'toyota_logo.png'),
('Volkswagen', '��������', 1937, 'vw_logo.png'),
('BMW', '��������', 1916, 'bmw_logo.png'),
('Mercedes-Benz', '��������', 1926, 'mercedes_logo.png'),
('Ford', '���', 1903, 'ford_logo.png'),
('Hyundai', '����� �����', 1967, 'hyundai_logo.png'),
('Kia', '����� �����', 1944, 'kia_logo.png'),
('Nissan', '������', 1933, 'nissan_logo.png');
GO

-- ���������� ������� ����������
INSERT INTO Cars (BrandID, Model, Year, Color, BodyType, EngineVolume, Horsepower, Transmission, Drive, Mileage, Price, InStock) VALUES
(1, 'Camry', 2020, '�����������', '�����', 2.5, 203, '�������', '��������', 35000, 1850000, 1),
(1, 'RAV4', 2021, '������', '���������', 2.5, 199, '�������', '������', 15000, 2200000, 1),
(2, 'Golf', 2019, '�����', '�������', 1.4, 150, '�������', '��������', 45000, 1450000, 1),
(2, 'Passat', 2020, '�����', '�����', 2.0, 190, '�������', '��������', 25000, 1750000, 1),
(3, 'X5', 2021, '������', '���������', 3.0, 340, '�������', '������', 10000, 4500000, 1),
(3, '3 Series', 2020, '�����', '�����', 2.0, 258, '�������', '������', 20000, 3200000, 1),
(4, 'E-Class', 2021, '�����������', '�����', 2.0, 245, '�������', '������', 15000, 4000000, 1),
(5, 'Focus', 2019, '�������', '�������', 1.5, 150, '��������', '��������', 50000, 1050000, 1),
(6, 'Tucson', 2021, '�����', '���������', 2.0, 150, '�������', '������', 12000, 1950000, 1),
(7, 'Sportage', 2020, '�����', '���������', 2.4, 185, '�������', '������', 20000, 1850000, 1);
GO

-- ���������� ������� �������
INSERT INTO Clients (LastName, FirstName, MiddleName, BirthDate, PassportSeries, PassportNumber, Phone, Email, Address) VALUES
('������', '�������', '���������', '1985-05-15', '4501', '123456', '+79151234567', 'alexey.ivanov@email.com', '��. ������, 10, ��. 5'),
('�������', '�����', '�������������', '1990-08-22', '4602', '654321', '+79219876543', 'maria.petrova@email.com', '��. ����, 25, ��. 12'),
('�������', '�������', '������������', '1988-03-10', '4703', '789012', '+79165550123', 'dmitry.sidorov@email.com', '��. ���������, 5, ��. 8'),
('�������', '����', '��������', '1992-11-30', '4804', '321654', '+74957778888', 'anna.kozlova@email.com', '��. ������, 15, ��. 3'),
('�������', '������', '���������', '1980-07-18', '4905', '987654', '+79031112222', 'sergey.smirnov@email.com', '��. �������, 7, ��. 14'),
('���������', '�����', '��������', '1987-02-14', '5006', '456123', '+79263334444', 'olga.vasilyeva@email.com', '��. ��������, 12, ��. 7');
GO

-- ���������� ������� ����������
INSERT INTO Employees (LastName, FirstName, MiddleName, Position, Phone, Email, Salary, ManagerID) VALUES
('�������', '������', '��������', '��������', '+79151112233', 'andrey.smirnov@cardealership.com', 150000, NULL),
('���������', '�����', '��������', '�������� �� ��������', '+79213334455', 'elena.kuznetsova@cardealership.com', 80000, 1),
('�������', '�����', '���������', '�������� �� ��������', '+79167778899', 'maria.ivanova@cardealership.com', 75000, 1),
('������', '����', '���������', '���������� ��������', '+74959990011', 'ivan.petrov@cardealership.com', 90000, 1),
('��������', '������', '����������', '������� ��������', '+79032223344', 'sergey.vasilyev@cardealership.com', 65000, 2),
('��������', '����', '����������', '��������', '+79115556666', 'anna.novikova@cardealership.com', 55000, 5);
GO

-- ���������� ������� �������
INSERT INTO Sales (CarID, ClientID, EmployeeID, SaleDate, SalePrice, PaymentType) VALUES
(1, 1, 2, '2023-10-15', 1850000, '��������'),
(2, 2, 3, '2023-10-16', 2200000, '������'),
(3, 3, 2, '2023-10-17', 1450000, '����������� ������'),
(4, 4, 5, '2023-10-18', 1750000, '��������'),
(5, 5, 3, '2023-10-19', 4500000, '������'),
(6, 1, 6, '2023-10-20', 3200000, '����������� ������'),
(7, 6, 2, '2023-10-21', 4000000, '��������'),
(8, 2, 5, '2023-10-22', 1050000, '������');
GO

-- =============================================
-- ���� 1: ������� ������� (INNER JOIN)
-- =============================================
-- ������� 1.1: ������� ������ ����������� � ���������� �����
SELECT c.Model, b.Name AS Brand, c.Year, c.Price
FROM Cars c
INNER JOIN Brands b ON c.BrandID = b.BrandID;
GO

-- ������� 1.2: �������� ������� � ����������� � ��������
SELECT s.SaleID, cl.LastName + ' ' + LEFT(cl.FirstName, 1) + '. ' + LEFT(cl.MiddleName, 1) + '.' AS Client, s.SaleDate, s.SalePrice
FROM Sales s
INNER JOIN Clients cl ON s.ClientID = cl.ClientID;
GO

-- ������� 1.3: ������� ������� � ����������� � �����������
SELECT s.SaleID, e.LastName + ' ' + LEFT(e.FirstName, 1) + '. ' + LEFT(e.MiddleName, 1) + '.' AS Employee, s.SaleDate, s.SalePrice
FROM Sales s
INNER JOIN Employees e ON s.EmployeeID = e.EmployeeID;
GO

-- =============================================
-- ���� 2: LEFT JOIN �������
-- =============================================
-- ������� 2.1: �������� ��� ����� � ���������� ����������� � ������
SELECT b.Name AS Brand, COUNT(c.CarID) AS CarCount
FROM Brands b
LEFT JOIN Cars c ON b.BrandID = c.BrandID
GROUP BY b.BrandID, b.Name;
GO

-- ������� 2.2: ������� ���� ����������� � �� ������� (������� ����������� ��� ������)
SELECT e.LastName + ' ' + LEFT(e.FirstName, 1) + '. ' + LEFT(e.MiddleName, 1) + '.' AS Employee, e.Position, COUNT(s.SaleID) AS SaleCount
FROM Employees e
LEFT JOIN Sales s ON e.EmployeeID = s.EmployeeID
GROUP BY e.EmployeeID, e.LastName, e.FirstName, e.MiddleName, e.Position;
GO

-- =============================================
-- ���� 3: RIGHT JOIN �������
-- =============================================
-- ������� 3.1: �������� ��� ���������� � �� ������� (������� ����������, ������� �� �������)
SELECT c.Model, b.Name AS Brand, s.SaleID, s.SaleDate
FROM Sales s
RIGHT JOIN Cars c ON s.CarID = c.CarID
LEFT JOIN Brands b ON c.BrandID = b.BrandID
ORDER BY c.Model;
GO

-- =============================================
-- ���� 4: FULL OUTER JOIN �������
-- =============================================
-- ������� 4.1: ������ ���������� ����������� � ������
SELECT COALESCE(c.Model, 'No car') AS Car, COALESCE(s.SaleID, 0) AS SaleID
FROM Cars c
FULL OUTER JOIN Sales s ON c.CarID = s.CarID;
GO

-- =============================================
-- ���� 5: ������������� JOIN
-- =============================================
-- ������� 5.1: ������ ���������� � ��������
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

-- ������� 5.2: ���-5 ����� ������� ��������� �����������
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
-- ���� 6: �������������� (SELF JOIN)
-- =============================================
-- ������� 6.1: ����� ����������� � �� �������������
SELECT
    e1.LastName + ' ' + LEFT(e1.FirstName, 1) + '. ' + LEFT(e1.MiddleName, 1) + '.' AS Employee,
    e2.LastName + ' ' + LEFT(e2.FirstName, 1) + '. ' + LEFT(e2.MiddleName, 1) + '.' AS Manager,
    e1.Position
FROM Employees e1
LEFT JOIN Employees e2 ON e1.ManagerID = e2.EmployeeID
ORDER BY COALESCE(e2.LastName, ''), e1.LastName;
GO

-- =============================================
-- ���� 7: ���������� ������� � JOIN
-- =============================================
-- ������� 7.1: ���������� �� �������� ����������� �� ������
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

-- ������� 7.2: ������ ������ �� �������
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
