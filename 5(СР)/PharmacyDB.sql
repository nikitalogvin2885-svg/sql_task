USE master;
GO

-- �������� ���� ������ ��� ������
IF DB_ID('PharmacyDB') IS NULL
    CREATE DATABASE PharmacyDB;
GO

USE PharmacyDB;
GO

-- �������� ������������ ������, ���� ��� ����
IF OBJECT_ID('Sales', 'U') IS NOT NULL DROP TABLE Sales;
IF OBJECT_ID('Prescriptions', 'U') IS NOT NULL DROP TABLE Prescriptions;
IF OBJECT_ID('Clients', 'U') IS NOT NULL DROP TABLE Clients;
IF OBJECT_ID('Doctors', 'U') IS NOT NULL DROP TABLE Doctors;
IF OBJECT_ID('Medicines', 'U') IS NOT NULL DROP TABLE Medicines;
GO

-- ������� ���������
CREATE TABLE Medicines (
    MedicineID INT IDENTITY(1,1) PRIMARY KEY,
    MedicineName NVARCHAR(100) NOT NULL,
    Manufacturer NVARCHAR(100) NOT NULL,
    Form NVARCHAR(50) NOT NULL, -- ����� ������� (��������, �����, ���� � �.�.)
    Dosage NVARCHAR(50),
    Price DECIMAL(10,2) NOT NULL CHECK (Price > 0),
    QuantityInStock INT NOT NULL CHECK (QuantityInStock >= 0),
    ExpirationDate DATE NOT NULL,
    RequiresPrescription BIT DEFAULT 1 -- ��������� �� ������
);
GO

-- ������� �����
CREATE TABLE Doctors (
    DoctorID INT IDENTITY(1,1) PRIMARY KEY,
    LastName NVARCHAR(50) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    MiddleName NVARCHAR(50),
    Specialization NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20) NOT NULL UNIQUE,
    Email NVARCHAR(100) UNIQUE,
    LicenseNumber NVARCHAR(20) NOT NULL UNIQUE
);
GO

-- ������� �������
CREATE TABLE Clients (
    ClientID INT IDENTITY(1,1) PRIMARY KEY,
    LastName NVARCHAR(50) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    MiddleName NVARCHAR(50),
    BirthDate DATE NOT NULL,
    Gender NVARCHAR(1) CHECK (Gender IN ('�', '�')),
    Phone NVARCHAR(20) NOT NULL UNIQUE,
    Email NVARCHAR(100) UNIQUE,
    Address NVARCHAR(255)
);
GO

-- ������� �������
CREATE TABLE Prescriptions (
    PrescriptionID INT IDENTITY(1,1) PRIMARY KEY,
    DoctorID INT NOT NULL,
    ClientID INT NOT NULL,
    MedicineID INT NOT NULL,
    PrescriptionDate DATETIME NOT NULL DEFAULT GETDATE(),
    ExpirationDate DATETIME NOT NULL,
    DosageInstructions NVARCHAR(255),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
    FOREIGN KEY (MedicineID) REFERENCES Medicines(MedicineID)
);
GO

-- ������� �������
CREATE TABLE Sales (
    SaleID INT IDENTITY(1,1) PRIMARY KEY,
    ClientID INT NOT NULL,
    MedicineID INT NOT NULL,
    PrescriptionID INT,
    SaleDate DATETIME NOT NULL DEFAULT GETDATE(),
    Quantity INT NOT NULL CHECK (Quantity > 0),
    TotalCost DECIMAL(10,2) NOT NULL CHECK (TotalCost > 0),
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
    FOREIGN KEY (MedicineID) REFERENCES Medicines(MedicineID),
    FOREIGN KEY (PrescriptionID) REFERENCES Prescriptions(PrescriptionID)
);
GO

-- ���������� ������ ��������� �������
-- ���������
INSERT INTO Medicines (MedicineName, Manufacturer, Form, Dosage, Price, QuantityInStock, ExpirationDate, RequiresPrescription) VALUES
('�������', '�����', '��������', '500 ��', 150.50, 100, '2025-12-31', 0),
('������������', '��������', '�������', '500 ��', 350.75, 50, '2024-11-30', 1),
('�����������', '������������', '��������', '200 ��', 80.00, 200, '2025-06-30', 0),
('���������', '������ ��������', '���������', '100 ��/5 ��', 220.30, 75, '2024-10-31', 0),
('���������', '�������', '��������', '5 ��', 450.00, 30, '2025-03-31', 1);
GO

-- �����
INSERT INTO Doctors (LastName, FirstName, MiddleName, Specialization, Phone, Email, LicenseNumber) VALUES
('������', '�������', '���������', '��������', '+79151234567', 'alexey.ivanov@clinic.com', '���123456'),
('�������', '�����', '�������������', '�������', '+79219876543', 'maria.petrova@clinic.com', '���789012'),
('�������', '�������', '������������', '���������', '+79165550123', 'dmitry.sidorov@clinic.com', '���345678'),
('�������', '����', '��������', '��������', '+74957778888', 'anna.kozlova@clinic.com', '���901234'),
('�������', '������', '���������', '������', '+79031112222', 'sergey.smirnov@clinic.com', '���567890');
GO

-- �������
INSERT INTO Clients (LastName, FirstName, MiddleName, BirthDate, Gender, Phone, Email, Address) VALUES
('��������', '����', '��������', '1995-07-20', '�', '+79112223344', 'ivan.vasilyev@email.com', '��. ������, 15, ��. 20'),
('��������', '���������', '����������', '1992-04-12', '�', '+79265556677', 'ekaterina.sokolova@email.com', '��. ����, 30, ��. 55'),
('�������', '������', '����������', '1988-11-05', '�', '+79037778899', 'andrey.novikov@email.com', '��. ���������, 8, ��. 12'),
('��������', '�����', '���������', '1990-09-18', '�', '+79163334455', 'olga.morozova@email.com', '��. �������, 10, ��. 3'),
('��������', '�������', '���������', '1985-02-25', '�', '+79214445566', 'dmitry.kuznetsov@email.com', '��. ��������, 12, ��. 7');
GO

-- �������
INSERT INTO Prescriptions (DoctorID, ClientID, MedicineID, PrescriptionDate, ExpirationDate, DosageInstructions) VALUES
(1, 1, 2, '2023-10-01 10:00:00', '2023-11-01 23:59:59', '1 ������� 3 ���� � ����'),
(2, 2, 5, '2023-10-02 12:00:00', '2023-11-02 23:59:59', '1 �������� 1 ��� � ����'),
(3, 3, 2, '2023-10-03 14:00:00', '2023-11-03 23:59:59', '1 ������� 2 ���� � ����'),
(4, 4, 4, '2023-10-05 16:00:00', '2023-11-05 23:59:59', '10 �� 3 ���� � ����'),
(5, 5, 5, '2023-10-06 09:00:00', '2023-11-06 23:59:59', '1 �������� 1 ��� � ����');
GO

-- �������
INSERT INTO Sales (ClientID, MedicineID, PrescriptionID, SaleDate, Quantity, TotalCost) VALUES
(1, 1, NULL, '2023-10-01 10:30:00', 2, 301.00),
(2, 4, NULL, '2023-10-02 12:45:00', 1, 220.30),
(3, 2, 1, '2023-10-03 15:00:00', 1, 350.75),
(4, 3, NULL, '2023-10-05 16:30:00', 3, 240.00),
(5, 5, 5, '2023-10-06 10:00:00', 2, 900.00);
GO

-- ������� ��������
-- ������� 1: ������ �������� � ��������� ������������� � ����
SELECT MedicineName, Manufacturer, Form, Dosage, Price, QuantityInStock
FROM Medicines;
GO

-- ������� 2: ������ �������� � ����������� � �����, ������� � ���������
SELECT
    p.PrescriptionID,
    d.LastName + ' ' + LEFT(d.FirstName, 1) + '. ' + LEFT(d.MiddleName, 1) + '.' AS Doctor,
    c.LastName + ' ' + LEFT(c.FirstName, 1) + '. ' + LEFT(c.MiddleName, 1) + '.' AS Client,
    m.MedicineName,
    p.PrescriptionDate,
    p.ExpirationDate,
    p.DosageInstructions
FROM Prescriptions p
INNER JOIN Doctors d ON p.DoctorID = d.DoctorID
INNER JOIN Clients c ON p.ClientID = c.ClientID
INNER JOIN Medicines m ON p.MedicineID = m.MedicineID;
GO

-- ������� 3: ���������� ������ �� ����������
SELECT
    m.MedicineName,
    COUNT(s.SaleID) AS SaleCount,
    SUM(s.Quantity) AS TotalQuantity,
    SUM(s.TotalCost) AS TotalRevenue
FROM Sales s
INNER JOIN Medicines m ON s.MedicineID = m.MedicineID
GROUP BY m.MedicineName
ORDER BY TotalRevenue DESC;
GO

-- ������� 4: ������ ������ � ����������� � ������� � ���������
SELECT
    c.LastName + ' ' + LEFT(c.FirstName, 1) + '. ' + LEFT(c.MiddleName, 1) + '.' AS Client,
    m.MedicineName,
    s.SaleDate,
    s.Quantity,
    s.TotalCost
FROM Sales s
INNER JOIN Clients c ON s.ClientID = c.ClientID
INNER JOIN Medicines m ON s.MedicineID = m.MedicineID;
GO
