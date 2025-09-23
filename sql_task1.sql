USE DoctorAibolit;
GO

CREATE TABLE Owners (
    OwnerID int PRIMARY KEY IDENTITY(1,1),
    FullName nvarchar(100) NOT NULL,
    Phone nvarchar(15) NOT NULL,
    Address nvarchar(200),
    Email nvarchar(100)
);
GO

CREATE TABLE Pets (
    PetID int PRIMARY KEY IDENTITY(1,1),
    Name nvarchar(50) NOT NULL,
    Type nvarchar(50) NOT NULL,
    Breed nvarchar(50),
    BirthDate date,
    OwnerID int NOT NULL,
    FOREIGN KEY (OwnerID) REFERENCES Owners(OwnerID)
);
GO

CREATE TABLE Doctors (
    DoctorID int PRIMARY KEY IDENTITY(1,1),
    FullName nvarchar(100) NOT NULL,
    Specialization nvarchar(50) NOT NULL,
    Phone nvarchar(15)
);
GO

CREATE TABLE Visits (
    VisitID int PRIMARY KEY IDENTITY(1,1),
    PetID int NOT NULL,
    DoctorID int NOT NULL,
    VisitDate date NOT NULL DEFAULT CAST(GETDATE() AS date),
    Diagnosis nvarchar(200),
    Treatment nvarchar(200),
    FOREIGN KEY (PetID) REFERENCES Pets(PetID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);
GO

SELECT * FROM Owners;
SELECT * FROM Pets;
SELECT * FROM Doctors;
SELECT * FROM Visits;

INSERT INTO Owners (FullName, Phone, Address, Email)
VALUES
('������ ���� ��������', '+79123456789', '������, ��. ������, �. 1, ��. 10', 'ivanov.ii@example.com'),
('������� ����� ���������', '+79221112233', '������, ��. ��������, �. 5, ��. 25', 'petrova.ms@example.com'),
('������� ������� ��������', '+79334445566', '�����-���������, ������� ��., �. 10, ��. 15', 'sidorov.ap@example.com'),
('��������� ����� ��������', '+79445556677', '������, ��. �������, �. 15, ��. 30', 'kuznecova.oi@example.com'),
('�������� ������� ������������', '+79556667788', '�����������, ������� ��., �. 20, ��. 5', 'vasiliev.dv@example.com'),
('��������� ����� �������������', '+79667778899', '������������, ��. ������-��������, �. 100, ��. 12', 'nikolaeva.ea@example.com'),
('������� ������ ����������', '+79778889900', '������, ��. ��������� �����, �. 200, ��. 7', 'smirnov.sn@example.com');
GO

INSERT INTO Pets (Name, Type, Breed, BirthDate, OwnerID)
VALUES
('������', '���', '���������� ���������������', '2019-05-10', 1),
('����', '������', '��������', '2018-07-15', 1),
('�����', '���', '���������', '2020-03-20', 2),
('�����', '������', '����-������-������', '2021-01-05', 3),
('�����', '������', '�������', '2017-11-12', 4),
('���', '���', '����-���', '2019-09-18', 5),
('���', '������', '�����', '2020-07-22', 2),
('�����', '���', '������', '2021-08-05', 3),
('���������', '���', '����������', '2018-06-14', 6),
('����', '������', '�������', '2019-12-25', 7);
GO

INSERT INTO Doctors (FullName, Specialization, Phone)
VALUES
('�������� ������� ����������', '��������', '+79111112233'),
('�������� ����� ��������', '������', '+79222223344'),
('�������� ������ ����������', '����������', '+79333334455'),
('������ ��������� �������', '���������', '+79444445566'),
('�������� ������� ����������', '����������', '+79555556677'),
('������� ����� ������������', '�����������', '+79666667788'),
('����� ������ ��������', '��������', '+79777778899');
GO

INSERT INTO Visits (PetID, DoctorID, VisitDate, Diagnosis, Treatment)
VALUES
(1, 1, '2023-09-01', '���������������� ������', '��������'),
(2, 2, '2023-09-02', '������� ����', '����'),
(3, 1, '2023-09-03', '��������', '��������������� ���������'),
(4, 3, '2023-09-04', '��������', '���� � �������'),
(5, 4, '2023-09-05', '��������� ���������������', '��������� ���������'),
(6, 1, '2023-09-06', '���������������� ������', '��������'),
(7, 5, '2023-09-07', '������ ������', '������ �����'),
(8, 2, '2023-09-08', '����', '�������������� ���������'),
(9, 6, '2023-09-09', '������������', '������� �����'),
(10, 7, '2023-09-10', '��������������� ���������', '���������� ���������'),
(1, 1, '2023-10-01', '����������', '��������'),
(3, 3, '2023-10-02', '��������� ������', '���������� �������'),
(5, 4, '2023-10-03', '��������� ������', '�������� ���������'),
(7, 5, '2023-10-04', '��������� ������ �����', '������������'),
(9, 1, '2023-10-05', '���������������� ������', '��������');
GO
