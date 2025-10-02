USE master;
GO

-- �������� ���� ������, ���� ��� ����������
IF DB_ID('HotelDB') IS NOT NULL
    DROP DATABASE HotelDB;
GO

-- �������� ���� ������
CREATE DATABASE HotelDB;
GO

USE HotelDB;
GO

-- =============================================
-- 1. ����������������� ������� "������������ � ������"
-- =============================================
CREATE TABLE Bookings_Denormalized (
    BookingID INT IDENTITY(1,1) PRIMARY KEY,
    GuestInfo NVARCHAR(200),
    RoomInfo NVARCHAR(150),
    BookingDate DATETIME,
    CheckInDate DATETIME,
    CheckOutDate DATETIME,
    RoomType NVARCHAR(100),
    RoomPrice DECIMAL(10, 2),
    ServicesInfo NVARCHAR(500),
    TotalCost DECIMAL(10, 2),
    PaymentInfo NVARCHAR(150),
    Comments NVARCHAR(500)
);
GO

-- ���������� ����������������� �������
INSERT INTO Bookings_Denormalized (
    GuestInfo, RoomInfo, BookingDate, CheckInDate, CheckOutDate,
    RoomType, RoomPrice, ServicesInfo, TotalCost, PaymentInfo, Comments
)
VALUES
('������ ���� ��������; +79123456789; ivanov@mail.ru; 1985-05-15; VIP',
 '����� 101; 1 ����; ��� �� ����; 2 �������',
 '2025-10-01 10:00:00', '2025-10-05 14:00:00', '2025-10-10 12:00:00',
 '����', 12000.00,
 '������� � �����; �������� �� ���������; ���-���������',
 15500.00, '���������� �����; 2025-10-01; 15500.00', '����� � ������'),

('������� ����� ���������; +79234567890; petrova@mail.ru; 1990-08-22; ��������',
 '����� 205; 2 ����; ��� �� ���; 1 �������',
 '2025-10-02 11:00:00', '2025-10-06 12:00:00', '2025-10-09 10:00:00',
 '��������', 6000.00,
 '�������; ������ ������',
 6800.00, '��������; 2025-10-02; 7000.00', '������������'),

('������� ������� ��������; +79345678901; sidorov@mail.ru; 1978-11-30; �������',
 '����� 303; 3 ����; ��� �� �������; 1 �������',
 '2025-10-03 09:00:00', '2025-10-08 11:00:00', '2025-10-12 10:00:00',
 '�������', 9000.00,
 '�������; ����; ������; ��������',
 12000.00, '���������� �����; 2025-10-03; 12000.00', '������');
GO

-- �������� ����������������� ������
SELECT * FROM Bookings_Denormalized;
GO

-- =============================================
-- 2. ������������ �� 1��
-- =============================================
CREATE TABLE Bookings_1NF (
    RecordID INT IDENTITY(1,1) PRIMARY KEY,
    BookingID INT,
    GuestFName NVARCHAR(50),
    GuestMName NVARCHAR(50),
    GuestLName NVARCHAR(50),
    GuestPhone NVARCHAR(20),
    GuestEmail NVARCHAR(100),
    GuestBirthDate DATE,
    GuestStatus NVARCHAR(50),
    RoomNumber NVARCHAR(10),
    RoomFloor INT,
    RoomView NVARCHAR(50),
    RoomBeds INT,
    BookingDate DATETIME,
    CheckInDate DATETIME,
    CheckOutDate DATETIME,
    RoomType NVARCHAR(100),
    RoomPrice DECIMAL(10, 2),
    ServiceBreakfast BIT,
    ServiceTransfer BIT,
    ServiceSPA BIT,
    ServiceCleaning BIT,
    ServiceDinner BIT,
    ServiceMassage BIT,
    TotalCost DECIMAL(10, 2),
    PaymentMethod NVARCHAR(50),
    PaymentDate DATE,
    PaymentAmount DECIMAL(10, 2),
    Comments NVARCHAR(500)
);
GO

-- ���������� ������� � 1��
INSERT INTO Bookings_1NF (
    BookingID, GuestFName, GuestMName, GuestLName, GuestPhone, GuestEmail, GuestBirthDate, GuestStatus,
    RoomNumber, RoomFloor, RoomView, RoomBeds, BookingDate, CheckInDate, CheckOutDate,
    RoomType, RoomPrice, ServiceBreakfast, ServiceTransfer, ServiceSPA, ServiceCleaning, ServiceDinner, ServiceMassage,
    TotalCost, PaymentMethod, PaymentDate, PaymentAmount, Comments
)
SELECT
    BookingID,
    PARSENAME(REPLACE(GuestInfo, '; ', '.'), 3) AS GuestFName,
    PARSENAME(REPLACE(GuestInfo, '; ', '.'), 2) AS GuestMName,
    PARSENAME(REPLACE(GuestInfo, '; ', '.'), 1) AS GuestLName,
    PARSENAME(REPLACE(GuestInfo, '; ', '.'), 4) AS GuestPhone,
    PARSENAME(REPLACE(GuestInfo, '; ', '.'), 5) AS GuestEmail,
    PARSENAME(REPLACE(GuestInfo, '; ', '.'), 6) AS GuestBirthDate,
    PARSENAME(REPLACE(GuestInfo, '; ', '.'), 7) AS GuestStatus,
    PARSENAME(REPLACE(RoomInfo, '; ', '.'), 3) AS RoomNumber,
    PARSENAME(REPLACE(RoomInfo, '; ', '.'), 2) AS RoomFloor,
    PARSENAME(REPLACE(RoomInfo, '; ', '.'), 1) AS RoomView,
    PARSENAME(REPLACE(RoomInfo, '; ', '.'), 4) AS RoomBeds,
    BookingDate, CheckInDate, CheckOutDate,
    RoomType, RoomPrice,
    CASE WHEN ServicesInfo LIKE '%�������%' THEN 1 ELSE 0 END AS ServiceBreakfast,
    CASE WHEN ServicesInfo LIKE '%��������%' THEN 1 ELSE 0 END AS ServiceTransfer,
    CASE WHEN ServicesInfo LIKE '%���%' THEN 1 ELSE 0 END AS ServiceSPA,
    CASE WHEN ServicesInfo LIKE '%������%' THEN 1 ELSE 0 END AS ServiceCleaning,
    CASE WHEN ServicesInfo LIKE '%����%' THEN 1 ELSE 0 END AS ServiceDinner,
    CASE WHEN ServicesInfo LIKE '%������%' THEN 1 ELSE 0 END AS ServiceMassage,
    TotalCost,
    PARSENAME(REPLACE(PaymentInfo, '; ', '.'), 1) AS PaymentMethod,
    PARSENAME(REPLACE(PaymentInfo, '; ', '.'), 2) AS PaymentDate,
    PARSENAME(REPLACE(PaymentInfo, '; ', '.'), 3) AS PaymentAmount,
    Comments
FROM Bookings_Denormalized;
GO

-- �������� ������ � 1��
SELECT * FROM Bookings_1NF;
GO

-- =============================================
-- 3. ������������ �� 3�� (�������� ���������� ������)
-- =============================================
-- 1. ���� �������
CREATE TABLE RoomTypes (
    RoomTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(200),
    BasePrice DECIMAL(10, 2),
    MaxOccupancy INT
);
GO

-- 2. ������
CREATE TABLE Rooms (
    RoomID INT IDENTITY(1,1) PRIMARY KEY,
    RoomNumber NVARCHAR(10) NOT NULL,
    RoomTypeID INT NOT NULL,
    Floor INT,
    ViewDescription NVARCHAR(100),
    BedsCount INT,
    FOREIGN KEY (RoomTypeID) REFERENCES RoomTypes(RoomTypeID)
);
GO

-- 3. �����
CREATE TABLE Guests (
    GuestID INT IDENTITY(1,1) PRIMARY KEY,
    FName NVARCHAR(50) NOT NULL,
    MName NVARCHAR(50),
    LName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    BirthDate DATE,
    Status NVARCHAR(50)
);
GO

-- 4. ������
CREATE TABLE Services (
    ServiceID INT IDENTITY(1,1) PRIMARY KEY,
    ServiceName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(200),
    Price DECIMAL(10, 2)
);
GO

-- 5. ������� ������
CREATE TABLE PaymentMethods (
    PaymentMethodID INT IDENTITY(1,1) PRIMARY KEY,
    MethodName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 6. ������������
CREATE TABLE Bookings (
    BookingID INT IDENTITY(1,1) PRIMARY KEY,
    GuestID INT NOT NULL,
    RoomID INT NOT NULL,
    BookingDate DATETIME NOT NULL,
    CheckInDate DATETIME NOT NULL,
    CheckOutDate DATETIME NOT NULL,
    TotalCost DECIMAL(10, 2) NOT NULL,
    Comments NVARCHAR(500),
    FOREIGN KEY (GuestID) REFERENCES Guests(GuestID),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID)
);
GO

-- 7. ���������� ������
CREATE TABLE BookingServices (
    BookingServiceID INT IDENTITY(1,1) PRIMARY KEY,
    BookingID INT NOT NULL,
    ServiceID INT NOT NULL,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
    FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID)
);
GO

-- 8. �������
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    BookingID INT NOT NULL,
    PaymentMethodID INT NOT NULL,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    Description NVARCHAR(200),
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
    FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethods(PaymentMethodID)
);
GO

-- ���������� ���������� ������
INSERT INTO RoomTypes (TypeName, Description, BasePrice, MaxOccupancy)
VALUES
('����', '����� � ����� �� ����, 2 �������', 12000.00, 4),
('��������', '����� � ����� �� ���, 1 �������', 6000.00, 2),
('�������', '����� � ����� �� �������, 1 �������', 9000.00, 2);
GO

INSERT INTO Rooms (RoomNumber, RoomTypeID, Floor, ViewDescription, BedsCount)
VALUES
('101', 1, 1, '��� �� ����', 2),
('205', 2, 2, '��� �� ���', 1),
('303', 3, 3, '��� �� �������', 1);
GO

INSERT INTO Guests (FName, MName, LName, Phone, Email, BirthDate, Status)
VALUES
('����', '��������', '������', '+79123456789', 'ivanov@mail.ru', '1985-05-15', 'VIP'),
('�����', '���������', '�������', '+79234567890', 'petrova@mail.ru', '1990-08-22', '��������'),
('�������', '��������', '�������', '+79345678901', 'sidorov@mail.ru', '1978-11-30', '�������');
GO

INSERT INTO Services (ServiceName, Description, Price)
VALUES
('������� � �����', '�������, ���������� � �����', 500.00),
('�������� �� ���������', '�������� ��/� ��������', 1500.00),
('���-���������', '������ ��� ���-���������', 3000.00),
('������ ������', '���������� ������', 0.00),
('����', '���� � ��������� �����', 1500.00),
('������', '�������������� ������', 2000.00);
GO

INSERT INTO PaymentMethods (MethodName, Description)
VALUES
('���������� �����', '������ ���������� ������'),
('��������', '������ ���������'),
('����������� ������', '������ ����� ����������� ��������� �������');
GO

INSERT INTO Bookings (GuestID, RoomID, BookingDate, CheckInDate, CheckOutDate, TotalCost, Comments)
VALUES
(1, 1, '2025-10-01 10:00:00', '2025-10-05 14:00:00', '2025-10-10 12:00:00', 15500.00, '����� � ������'),
(2, 2, '2025-10-02 11:00:00', '2025-10-06 12:00:00', '2025-10-09 10:00:00', 6800.00, '������������'),
(3, 3, '2025-10-03 09:00:00', '2025-10-08 11:00:00', '2025-10-12 10:00:00', 12000.00, '������');
GO

INSERT INTO BookingServices (BookingID, ServiceID)
VALUES
(1, 1), (1, 2), (1, 3), (1, 4),
(2, 1), (2, 4),
(3, 1), (3, 2), (3, 5), (3, 6);
GO

INSERT INTO Payments (BookingID, PaymentMethodID, PaymentDate, Amount, Description)
VALUES
(1, 1, '2025-10-01', 15500.00, '������ ������������ ����'),
(2, 2, '2025-10-02', 7000.00, '������ ������������ ��������'),
(3, 1, '2025-10-03', 12000.00, '������ ������������ �������');
GO

-- =============================================
-- 4. ������������� �������
-- =============================================
-- 1. ������������ ����� �������
PRINT '1. ������������ ����� �������:';
GO
SELECT
    rt.TypeName AS RoomType,
    COUNT(b.BookingID) AS BookingsCount,
    SUM(b.TotalCost) AS TotalRevenue
FROM Bookings b
JOIN Rooms r ON b.RoomID = r.RoomID
JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID
GROUP BY rt.TypeName
ORDER BY BookingsCount DESC;
GO

-- 2. ���������� �� �������
PRINT '2. ���������� �� �������:';
GO
SELECT
    s.ServiceName,
    COUNT(bs.BookingServiceID) AS RequestsCount,
    SUM(rt.BasePrice + s.Price) AS TotalRevenue
FROM BookingServices bs
JOIN Services s ON bs.ServiceID = s.ServiceID
JOIN Bookings b ON bs.BookingID = b.BookingID
JOIN Rooms r ON b.RoomID = r.RoomID
JOIN RoomTypes rt ON r.RoomTypeID = rt.RoomTypeID
GROUP BY s.ServiceName
ORDER BY RequestsCount DESC;
GO

-- 3. ���������� �� �������� ������
PRINT '3. ���������� �� �������� ������:';
GO
SELECT
    pm.MethodName AS PaymentMethod,
    COUNT(p.PaymentID) AS PaymentsCount,
    SUM(p.Amount) AS TotalAmount
FROM Payments p
JOIN PaymentMethods pm ON p.PaymentMethodID = pm.PaymentMethodID
GROUP BY pm.MethodName
ORDER BY TotalAmount DESC;
GO
