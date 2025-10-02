CREATE DATABASE VeterinaryClinicDB;
GO

USE VeterinaryClinicDB;
GO

-- 3. �������� ������������� ������ � �� ��������, ���� ��� ����������
IF OBJECT_ID('Treatments', 'U') IS NOT NULL DROP TABLE Treatments;
IF OBJECT_ID('Animals', 'U') IS NOT NULL DROP TABLE Animals;
IF OBJECT_ID('Owners', 'U') IS NOT NULL DROP TABLE Owners;
IF OBJECT_ID('Doctors', 'U') IS NOT NULL DROP TABLE Doctors;
GO

-- 4. ������� "���������"
CREATE TABLE Owners (
    OwnerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Email NVARCHAR(100),
    Address NVARCHAR(200),
    RegistrationDate DATE NOT NULL
);
GO

-- 5. ������� "�����"
CREATE TABLE Doctors (
    DoctorID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    Specialization NVARCHAR(100) NOT NULL,
    HireDate DATE NOT NULL
);
GO

-- 6. ������� "��������"
CREATE TABLE Animals (
    AnimalID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    Species NVARCHAR(50) NOT NULL, -- ��� ��������� (��������, "������", "�����")
    Breed NVARCHAR(50), -- ������
    BirthDate DATE,
    OwnerID INT FOREIGN KEY REFERENCES Owners(OwnerID),
    RegistrationDate DATE NOT NULL
);
GO

-- 7. ������� "�������"
CREATE TABLE Treatments (
    TreatmentID INT IDENTITY(1,1) PRIMARY KEY,
    AnimalID INT FOREIGN KEY REFERENCES Animals(AnimalID),
    DoctorID INT FOREIGN KEY REFERENCES Doctors(DoctorID),
    TreatmentDate DATE NOT NULL,
    Diagnosis NVARCHAR(200) NOT NULL,
    TreatmentDescription NVARCHAR(500),
    Cost DECIMAL(10, 2) NOT NULL,
    Status NVARCHAR(20) CHECK (Status IN ('Completed', 'In Progress', 'Scheduled'))
);
GO

-- 8. ���������� ��������� �������: ���������
INSERT INTO Owners (FirstName, LastName, Phone, Email, Address, RegistrationDate) VALUES
('����', '������', '+79001112233', 'ivan.ivanov@mail.ru', '��. ������, �. 10', '2020-01-10'),
('�����', '�������', '+79002223344', 'maria.petrova@mail.ru', '��. �������, �. 20', '2019-05-15'),
('�������', '�������', '+79003334455', 'alexey.sidorov@mail.ru', '��. ��������, �. 30', '2021-09-01'),
('�����', '�������', '+79004445566', 'elena.kozlova@mail.ru', '��. ������, �. 40', '2022-01-15'),
('�������', '��������', '+79005556677', 'dmitry.vasilyev@mail.ru', '��. ��������, �. 50', '2021-11-20');
GO

-- 9. ���������� ��������� �������: �����
INSERT INTO Doctors (FirstName, LastName, Phone, Email, Specialization, HireDate) VALUES
('����', '�������', '+79006667788', 'petr.smirnov@clinic.ru', '��������', '2018-01-10'),
('�����', '���������', '+79007778899', 'olga.kuznetsova@clinic.ru', '������', '2017-03-15'),
('������', '��������', '+79008889900', 'sergey.vasilyev@clinic.ru', '����������', '2019-07-20'),
('�����', '��������', '+79009990011', 'irina.novikova@clinic.ru', '���������', '2020-05-10');
GO

-- 10. ���������� ��������� �������: ��������
INSERT INTO Animals (Name, Species, Breed, BirthDate, OwnerID, RegistrationDate) VALUES
('������', '�����', '����������', '2018-05-15', 1, '2020-01-10'),
('����', '������', '��������', '2017-08-20', 2, '2019-05-15'),
('�����', '�����', '���������', '2019-03-10', 3, '2021-09-01'),
('�����', '������', '���� ������ ������', '2020-11-25', 4, '2022-01-15'),
('�����', '������', '�������', '2019-07-12', 5, '2021-11-20');
GO

-- 11. ���������� ��������� �������: �������
INSERT INTO Treatments (AnimalID, DoctorID, TreatmentDate, Diagnosis, TreatmentDescription, Cost, Status) VALUES
(1, 1, '2023-10-15', '��������', '��������� ����������� � ��������', 1500.00, 'Completed'),
(2, 2, '2023-10-16', '������� ����', '�������� �������� �������', 3500.00, 'Completed'),
(3, 3, '2023-10-17', '��������', '��������� ���� � �����', 2000.00, 'In Progress'),
(4, 1, '2023-10-18', '����������', '��������� ���������� � ��������', 2500.00, 'Completed'),
(5, 4, '2023-10-19', '��������� ���������������', '��������� ��������� ���������', 3000.00, 'In Progress'),
(1, 2, '2023-10-20', '������������', '��������� ��������', 4000.00, 'Scheduled');
GO

-- 12. ��������� �������
-- 12.1. ��������� ���������: ��������, ��������� ������� ������� ���� �������
SELECT
    a.Name,
    a.Species,
    o.FirstName AS OwnerFirstName,
    o.LastName AS OwnerLastName,
    (SELECT AVG(Cost) FROM Treatments) AS AvgTreatmentCost,
    (SELECT SUM(Cost) FROM Treatments WHERE AnimalID = a.AnimalID) AS TotalTreatmentCost
FROM Animals a
JOIN Owners o ON a.OwnerID = o.OwnerID
WHERE (SELECT SUM(Cost) FROM Treatments WHERE AnimalID = a.AnimalID) >
      (SELECT AVG(Cost) FROM Treatments)
ORDER BY TotalTreatmentCost DESC;
GO

-- 12.2. ��������� ��������� � IN: �����, ������� ������ �����
SELECT DISTINCT
    d.FirstName,
    d.LastName,
    d.Specialization
FROM Doctors d
WHERE d.DoctorID IN (
    SELECT t.DoctorID
    FROM Treatments t
    JOIN Animals a ON t.AnimalID = a.AnimalID
    WHERE a.Species = '������'
);
GO

-- 12.3. ��������������� ���������: ���������, �������� ������� ��������� ������� ������ ��������
SELECT
    o.FirstName,
    o.LastName,
    o.Phone,
    (SELECT SUM(t.Cost) FROM Treatments t JOIN Animals a ON t.AnimalID = a.AnimalID WHERE a.OwnerID = o.OwnerID) AS TotalCost
FROM Owners o
WHERE (SELECT SUM(t.Cost) FROM Treatments t JOIN Animals a ON t.AnimalID = a.AnimalID WHERE a.OwnerID = o.OwnerID) >
      (SELECT AVG(total_cost) FROM (
          SELECT SUM(t.Cost) AS total_cost
          FROM Treatments t
          JOIN Animals a ON t.AnimalID = a.AnimalID
          GROUP BY a.OwnerID
      ) AS avg_cost);
GO

-- 12.4. EXISTS: ��������, ������� ��������� ������� � �������
SELECT DISTINCT
    a.Name,
    a.Species,
    o.FirstName AS OwnerFirstName,
    o.LastName AS OwnerLastName
FROM Animals a
JOIN Owners o ON a.OwnerID = o.OwnerID
WHERE EXISTS (
    SELECT 1
    FROM Treatments t
    JOIN Doctors d ON t.DoctorID = d.DoctorID
    WHERE t.AnimalID = a.AnimalID
    AND d.Specialization = '������'
);
GO

-- 13. �������
-- 13.1. ������: �������� � �� ���������
DECLARE @AnimalID INT, @AnimalName NVARCHAR(50), @Species NVARCHAR(50), @OwnerFirstName NVARCHAR(50), @OwnerLastName NVARCHAR(50);
DECLARE animal_owner_cursor CURSOR FOR
SELECT
    a.AnimalID,
    a.Name,
    a.Species,
    o.FirstName,
    o.LastName
FROM Animals a
JOIN Owners o ON a.OwnerID = o.OwnerID
ORDER BY a.Name;
OPEN animal_owner_cursor;
FETCH NEXT FROM animal_owner_cursor INTO @AnimalID, @AnimalName, @Species, @OwnerFirstName, @OwnerLastName;
WHILE @@FETCH_STATUS = 0
BEGIN
    FETCH NEXT FROM animal_owner_cursor INTO @AnimalID, @AnimalName, @Species, @OwnerFirstName, @OwnerLastName;
END;
CLOSE animal_owner_cursor;
DEALLOCATE animal_owner_cursor;
GO

-- 13.2. ��������� �������: ������� � �����
DECLARE @TreatmentID INT, @AnimalName NVARCHAR(50), @Diagnosis NVARCHAR(200), @TreatmentDate DATE;
DECLARE @DoctorFirstName NVARCHAR(50), @DoctorLastName NVARCHAR(50), @Specialization NVARCHAR(100);
DECLARE treatment_cursor CURSOR FOR
SELECT t.TreatmentID, a.Name, t.Diagnosis, t.TreatmentDate
FROM Treatments t
JOIN Animals a ON t.AnimalID = a.AnimalID
ORDER BY t.TreatmentDate;
OPEN treatment_cursor;
FETCH NEXT FROM treatment_cursor INTO @TreatmentID, @AnimalName, @Diagnosis, @TreatmentDate;
WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE doctor_cursor CURSOR LOCAL FOR
    SELECT d.FirstName, d.LastName, d.Specialization
    FROM Doctors d
    JOIN Treatments t ON d.DoctorID = t.DoctorID
    WHERE t.TreatmentID = @TreatmentID;
    OPEN doctor_cursor;
    FETCH NEXT FROM doctor_cursor INTO @DoctorFirstName, @DoctorLastName, @Specialization;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        FETCH NEXT FROM doctor_cursor INTO @DoctorFirstName, @DoctorLastName, @Specialization;
    END;
    CLOSE doctor_cursor;
    DEALLOCATE doctor_cursor;
    FETCH NEXT FROM treatment_cursor INTO @TreatmentID, @AnimalName, @Diagnosis, @TreatmentDate;
END;
CLOSE treatment_cursor;
DEALLOCATE treatment_cursor;
GO

-- 14. �������� �������� ��� �����������
CREATE INDEX IX_Owners_RegistrationDate ON Owners(RegistrationDate);
CREATE INDEX IX_Doctors_Specialization ON Doctors(Specialization);
CREATE INDEX IX_Animals_OwnerID ON Animals(OwnerID);
CREATE INDEX IX_Treatments_AnimalID ON Treatments(AnimalID);
CREATE INDEX IX_Treatments_DoctorID ON Treatments(DoctorID);
CREATE INDEX IX_Treatments_TreatmentDate ON Treatments(TreatmentDate);
GO
