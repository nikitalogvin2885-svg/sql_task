USE VashDom;
GO

CREATE TABLE Clients (
    ClientID int PRIMARY KEY IDENTITY(1,1),
    FullName nvarchar(100) NOT NULL,
    Phone nvarchar(15) NOT NULL,
    Email nvarchar(100),
    ClientType nvarchar(10) NOT NULL CHECK (ClientType IN ('����������', '���������')),
    RegistrationDate date NOT NULL DEFAULT CAST(GETDATE() AS date)
);
GO

CREATE TABLE Realtors (
    RealtorID int PRIMARY KEY IDENTITY(1,1),
    FullName nvarchar(100) NOT NULL,
    Phone nvarchar(15) NOT NULL,
    Email nvarchar(100),
    ExperienceYears int NOT NULL CHECK (ExperienceYears >= 0),
    LicenseNumber nvarchar(20) NOT NULL
);
GO

CREATE TABLE Properties (
    PropertyID int PRIMARY KEY IDENTITY(1,1),
    Address nvarchar(200) NOT NULL,
    Type nvarchar(50) NOT NULL CHECK (Type IN ('��������', '���', '������������', '�����')),
    Area decimal(10, 2) NOT NULL CHECK (Area > 0),
    Price decimal(18, 2) NOT NULL CHECK (Price > 0),
    Rooms int CHECK (Rooms > 0),
    Description nvarchar(500),
    Status nvarchar(20) NOT NULL CHECK (Status IN ('�������', '������', '�������', '����� � �������')),
    RealtorID int NOT NULL,
    FOREIGN KEY (RealtorID) REFERENCES Realtors(RealtorID)
);
GO

CREATE TABLE Viewings (
    ViewingID int PRIMARY KEY IDENTITY(1,1),
    PropertyID int NOT NULL,
    ClientID int NOT NULL,
    RealtorID int NOT NULL,
    ViewingDate date NOT NULL DEFAULT CAST(GETDATE() AS date),
    ViewingTime time NOT NULL,
    Comments nvarchar(500),
    FOREIGN KEY (PropertyID) REFERENCES Properties(PropertyID),
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
    FOREIGN KEY (RealtorID) REFERENCES Realtors(RealtorID)
);
GO

INSERT INTO Clients (FullName, Phone, Email, ClientType, RegistrationDate)
VALUES
('������ ���� ��������', '+79123456789', 'ivanov.ii@example.com', '����������', '2023-01-10'),
('������� ����� ���������', '+79221112233', 'petrova.ms@example.com', '���������', '2023-02-15'),
('������� ������� ��������', '+79334445566', 'sidorov.ap@example.com', '����������', '2023-03-20'),
('��������� ����� ��������', '+79445556677', 'kuznecova.oi@example.com', '���������', '2023-04-05'),
('�������� ������� ������������', '+79556667788', 'vasiliev.dv@example.com', '����������', '2023-05-12'),
('�������� ���� �������������', '+79667778899', 'novikova.aa@example.com', '���������', '2023-06-18'),
('������� ������ ����������', '+79778889900', 'smirnov.sn@example.com', '����������', '2023-07-22'),
('��������� ����� ����������', '+79889990011', 'alekseeva.ev@example.com', '���������', '2023-08-05'),
('������ ������ ����������', '+79991112233', 'kozlov.am@example.com', '����������', '2023-09-10'),
('�������� ����� ��������', '+79102223344', 'morozova.ip@example.com', '���������', '2023-10-15');
GO

INSERT INTO Realtors (FullName, Phone, Email, ExperienceYears, LicenseNumber)
VALUES
('�������� ������� ����������', '+79111112233', 'alekseev.aa@example.com', 5, '�001000001'),
('�������� ����� ��������', '+79222223344', 'borisova.op@example.com', 7, '�001000002'),
('�������� ������ ����������', '+79333334455', 'viktorov.vv@example.com', 3, '�001000003'),
('������ ��������� �������', '+79444445566', 'petrova.gs@example.com', 10, '�001000004'),
('�������� ������� ����������', '+79555556677', 'dmitriev.dd@example.com', 4, '�001000005');
GO

INSERT INTO Properties (Address, Type, Area, Price, Rooms, Description, Status, RealtorID)
VALUES
('������, ��. ������, �. 10, ��. 5', '��������', 65.50, 8500000.00, 2, '������������� �������� � ������ ������', '�������', 1),
('������, ��. ��������, �. 25, ��. 12', '��������', 85.30, 12000000.00, 3, '������������� �������� � ��������', '�������', 2),
('�����������, �. ���������, ��. ������, �. 5', '���', 150.00, 25000000.00, 5, '���������� ��� � �������� 10 �����', '�������', 3),
('������, ��. ��������, �. 15, ���� 305', '������������', 120.00, 15000000.00, 1, '������� ��������� � ������', '������', 4),
('������, ��. �������, �. 3, ��. 7', '��������', 50.00, 6500000.00, 1, '������������� ��������', '�������', 5),
('������, ����, 25 ��, ������� 12', '�����', 1000.00, 5000000.00, 0, '��������� ������� ��� ���', '�������', 1),
('������, ��. ����� �����, �. 30, ��. 15', '��������', 100.00, 20000000.00, 4, '������� ���������������� ��������', '�������', 2),
('������, ��. �����������, �. 10, ��. 8', '��������', 75.00, 10000000.00, 3, '������������� ��������, ����������', '������', 3),
('������, ��. �����������, �. 50, ��. 18', '��������', 60.00, 7500000.00, 2, '������������� ��������', '�������', 4),
('������, ��. �������������, �. 20, ��. 25', '��������', 55.00, 7000000.00, 1, '������������� ��������, ������� ���������', '������', 5);
GO

INSERT INTO Viewings (PropertyID, ClientID, RealtorID, ViewingDate, ViewingTime, Comments)
VALUES
(1, 1, 1, '2023-10-01', '10:00:00', '������� ����������� ��������, ������������� �������'),
(2, 2, 2, '2023-10-01', '12:00:00', '������ �������������, �� ����� ���������� ��� ��������'),
(3, 3, 3, '2023-10-02', '11:00:00', '������ ����� ������������� �������'),
(4, 4, 4, '2023-10-02', '14:00:00', '������� �������� ��������� ��� �����'),
(5, 5, 5, '2023-10-03', '10:30:00', '������ ������������� �������'),
(6, 6, 1, '2023-10-03', '15:00:00', '������ ������������� � �������'),
(7, 7, 2, '2023-10-04', '11:30:00', '������� ����������� ��������, �� ������� ����'),
(8, 8, 3, '2023-10-04', '13:00:00', '������ ������������� ������'),
(9, 9, 4, '2023-10-05', '10:00:00', '������ ������������� � �������'),
(10, 10, 5, '2023-10-05', '12:30:00', '������ ������������� ������'),
(1, 2, 1, '2023-10-06', '11:00:00', '��������� ��������'),
(3, 5, 3, '2023-10-06', '14:30:00', '������ ����� ��� ��� ���������� ���'),
(5, 7, 5, '2023-10-07', '10:00:00', '������ ����� ������� �����������'),
(7, 1, 2, '2023-10-07', '15:00:00', '������ ������������� �������'),
(9, 3, 4, '2023-10-08', '12:00:00', '������� ����������� ��������');
GO

SELECT * FROM Clients;
SELECT * FROM Realtors;
SELECT * FROM Properties;
SELECT * FROM Viewings;