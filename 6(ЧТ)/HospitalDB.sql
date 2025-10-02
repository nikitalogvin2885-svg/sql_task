CREATE DATABASE HospitalDB;
GO
USE HospitalDB;
GO

-- �������� ������������� ������ � �� ��������, ���� ��� ����������
IF OBJECT_ID('Treatments', 'U') IS NOT NULL DROP TABLE Treatments;
IF OBJECT_ID('Diagnoses', 'U') IS NOT NULL DROP TABLE Diagnoses;
IF OBJECT_ID('Patients', 'U') IS NOT NULL DROP TABLE Patients;
IF OBJECT_ID('Doctors', 'U') IS NOT NULL DROP TABLE Doctors;
IF OBJECT_ID('Wards', 'U') IS NOT NULL DROP TABLE Wards;
IF OBJECT_ID('Departments', 'U') IS NOT NULL DROP TABLE Departments;
GO

-- ������� "���������"
CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(100) NOT NULL,
    HeadDoctorID INT NULL, -- ����� ��������� ����� �������� ������� Doctors
    Phone NVARCHAR(20),
    Floor INT
);
GO

-- ������� "������"
CREATE TABLE Wards (
    WardID INT IDENTITY(1,1) PRIMARY KEY,
    WardNumber NVARCHAR(10) NOT NULL,
    DepartmentID INT FOREIGN KEY REFERENCES Departments(DepartmentID),
    Capacity INT NOT NULL,
    CurrentOccupancy INT NOT NULL DEFAULT 0
);
GO

-- ������� "�����"
CREATE TABLE Doctors (
    DoctorID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Specialization NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    HireDate DATE NOT NULL,
    DepartmentID INT FOREIGN KEY REFERENCES Departments(DepartmentID),
    Salary DECIMAL(10, 2)
);
GO

-- ���������� ������� Departments ��� ���������� ����� � ������� ������
ALTER TABLE Departments ADD CONSTRAINT FK_Departments_HeadDoctor 
FOREIGN KEY (HeadDoctorID) REFERENCES Doctors(DoctorID);
GO

-- ������� "��������"
CREATE TABLE Patients (
    PatientID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    BirthDate DATE NOT NULL,
    Gender NVARCHAR(10) NOT NULL,
    Phone NVARCHAR(20),
    Address NVARCHAR(200),
    InsurancePolicy NVARCHAR(50),
    AdmissionDate DATE NOT NULL,
    DischargeDate DATE NULL,
    WardID INT FOREIGN KEY REFERENCES Wards(WardID),
    AttendingDoctorID INT FOREIGN KEY REFERENCES Doctors(DoctorID)
);
GO

-- ������� "��������"
CREATE TABLE Diagnoses (
    DiagnosisID INT IDENTITY(1,1) PRIMARY KEY,
    PatientID INT FOREIGN KEY REFERENCES Patients(PatientID),
    DoctorID INT FOREIGN KEY REFERENCES Doctors(DoctorID),
    DiagnosisName NVARCHAR(200) NOT NULL,
    DiagnosisDate DATE NOT NULL,
    Severity NVARCHAR(20),
    Description NVARCHAR(500)
);
GO

-- ������� "�������"
CREATE TABLE Treatments (
    TreatmentID INT IDENTITY(1,1) PRIMARY KEY,
    PatientID INT FOREIGN KEY REFERENCES Patients(PatientID),
    DoctorID INT FOREIGN KEY REFERENCES Doctors(DoctorID),
    DiagnosisID INT FOREIGN KEY REFERENCES Diagnoses(DiagnosisID),
    TreatmentName NVARCHAR(200) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NULL,
    Dosage NVARCHAR(100),
    Frequency NVARCHAR(100),
    Cost DECIMAL(10, 2),
    Status NVARCHAR(20) DEFAULT 'Active'
);
GO

-- ���������� ��������� �������: ���������
INSERT INTO Departments (DepartmentName, Phone, Floor) VALUES
('�������', '+79001112233', 1),
('��������', '+79002223344', 2),
('�����������', '+79003334455', 1),
('����������', '+79004445566', 3),
('���������', '+79005556677', 2);
GO

-- ���������� ��������� �������: ������
INSERT INTO Wards (WardNumber, DepartmentID, Capacity, CurrentOccupancy) VALUES
('101', 1, 4, 2),
('102', 1, 4, 3),
('201', 2, 3, 1),
('202', 2, 3, 2),
('103', 3, 2, 1),
('301', 4, 3, 2),
('203', 5, 4, 3);
GO

-- ���������� ��������� �������: �����
INSERT INTO Doctors (FirstName, LastName, Specialization, Phone, Email, HireDate, DepartmentID, Salary) VALUES
('����', '������', '��������', '+79006667788', 'ivan.petrov@hospital.ru', '2015-03-15', 1, 80000.00),
('�����', '��������', '������', '+79007778899', 'maria.sidorova@hospital.ru', '2018-07-20', 2, 95000.00),
('�������', '������', '���������', '+79008889900', 'alexey.kozlov@hospital.ru', '2016-11-10', 3, 90000.00),
('�����', '���������', '��������', '+79009990011', 'olga.vasilyeva@hospital.ru', '2019-05-25', 4, 85000.00),
('������', '��������', '�������', '+79001112299', 'sergey.nikolaev@hospital.ru', '2017-09-30', 5, 82000.00),
('�����', 'Ը������', '��������', '+79002223388', 'elena.fedorova@hospital.ru', '2020-01-15', 1, 75000.00);
GO

-- ���������� ������� ������ ���������
UPDATE Departments SET HeadDoctorID = 1 WHERE DepartmentID = 1;
UPDATE Departments SET HeadDoctorID = 2 WHERE DepartmentID = 2;
UPDATE Departments SET HeadDoctorID = 3 WHERE DepartmentID = 3;
UPDATE Departments SET HeadDoctorID = 4 WHERE DepartmentID = 4;
UPDATE Departments SET HeadDoctorID = 5 WHERE DepartmentID = 5;
GO

-- ���������� ��������� �������: ��������
INSERT INTO Patients (FirstName, LastName, BirthDate, Gender, Phone, Address, InsurancePolicy, AdmissionDate, DischargeDate, WardID, AttendingDoctorID) VALUES
('�������', '������', '1980-05-15', '�������', '+79011112233', '��. ������, �. 10', 'POL123456', '2023-10-01', NULL, 1, 1),
('����', '��������', '1975-12-20', '�������', '+79022223344', '��. �������, �. 25', 'POL123457', '2023-10-05', NULL, 1, 6),
('����', '��������', '1965-08-10', '�������', '+79033334455', '��. ��������, �. 15', 'POL123458', '2023-10-10', '2023-10-25', 2, 1),
('���������', '������', '1990-03-30', '�������', '+79044445566', '��. �������, �. 8', 'POL123459', '2023-10-12', NULL, 3, 2),
('������', '�������', '1988-11-05', '�������', '+79055556677', '��. �����������, �. 30', 'POL123460', '2023-10-15', NULL, 4, 2),
('�����', '��������', '1972-07-18', '�������', '+79066667788', '��. ����, �. 12', 'POL123461', '2023-10-18', NULL, 5, 3),
('�����', '��������', '1995-01-25', '�������', '+79077778899', '��. ��������, �. 5', 'POL123462', '2023-10-20', NULL, 6, 4),
('���������', '�������', '1983-09-14', '�������', '+79088889900', '��. ������, �. 18', 'POL123463', '2023-10-22', NULL, 7, 5);
GO

-- ���������� ��������� �������: ��������
INSERT INTO Diagnoses (PatientID, DoctorID, DiagnosisName, DiagnosisDate, Severity, Description) VALUES
(1, 1, '�����', '2023-10-01', '�������', '������ ������������� �������� ��������'),
(2, 6, '�������', '2023-10-05', '������', '���������� �������'),
(3, 1, '���������', '2023-10-10', '�������', '���������� ������'),
(4, 2, '����������', '2023-10-12', '�������', '���������� ����������'),
(5, 2, '����������', '2023-10-15', '�������', '���������� �������� ������'),
(6, 3, '����������', '2023-10-18', '�����������', '���������� ������������ ��������'),
(7, 4, '�������', '2023-10-20', '�����������', '������� �������� ����'),
(8, 5, '����', '2023-10-22', '������', '������ ������������� �������� �������� � �������');
GO

-- ���������� ��������� �������: �������
INSERT INTO Treatments (PatientID, DoctorID, DiagnosisID, TreatmentName, StartDate, EndDate, Dosage, Frequency, Cost, Status) VALUES
(1, 1, 1, '��������������� �������', '2023-10-01', '2023-10-10', '200 ��', '2 ���� � ����', 5000.00, 'Completed'),
(1, 1, 1, '��������������', '2023-10-01', '2023-10-05', '500 ��', '3 ���� � ����', 1500.00, 'Completed'),
(2, 6, 2, '�����������', '2023-10-05', NULL, '250 ��', '3 ���� � ����', 3000.00, 'Active'),
(3, 1, 3, '����������� �������� �������', '2023-10-10', '2023-10-25', '500 ��', '2 ���� � ����', 8000.00, 'Completed'),
(4, 2, 4, '������������� ��������', '2023-10-12', NULL, NULL, '�����������', 25000.00, 'Active'),
(5, 2, 5, '��������������������� �������', '2023-10-15', NULL, '400 ��', '2 ���� � ����', 4500.00, 'Active'),
(6, 3, 6, '������������� ���������', '2023-10-18', NULL, '50 ��', '1 ��� � ����', 2000.00, 'Active'),
(7, 4, 7, '��������������', '2023-10-20', NULL, '100 ��', '�� �������������', 1200.00, 'Active'),
(8, 5, 8, '���������������� �������', '2023-10-22', NULL, '10 ��', '3 ���� � ����', 800.00, 'Active');
GO

-- ��������� �������

-- 1. ��������� ���������: ��������, ��� ������� ������ ������� ��������� �������
SELECT
    p.FirstName,
    p.LastName,
    d.DiagnosisName,
    (SELECT AVG(Cost) FROM Treatments) AS AvgTreatmentCost,
    (SELECT SUM(t.Cost) FROM Treatments t WHERE t.PatientID = p.PatientID) AS PatientTotalCost
FROM Patients p
JOIN Diagnoses d ON p.PatientID = d.PatientID
WHERE (SELECT SUM(t.Cost) FROM Treatments t WHERE t.PatientID = p.PatientID) >
      (SELECT AVG(Cost) FROM Treatments)
ORDER BY PatientTotalCost DESC;
GO

-- 2. ��������� ��������� � IN: �����, ������� ������ ��������� � �������� ����������
SELECT DISTINCT
    d.FirstName,
    d.LastName,
    d.Specialization
FROM Doctors d
WHERE d.DoctorID IN (
    SELECT di.DoctorID
    FROM Diagnoses di
    WHERE di.Severity = '�������'
);
GO

-- 3. ��������������� ���������: ��������, ������� ��������� � �������� ������ �������� �����
SELECT
    p.FirstName,
    p.LastName,
    p.AdmissionDate,
    DATEDIFF(day, p.AdmissionDate, ISNULL(p.DischargeDate, GETDATE())) AS DaysInHospital
FROM Patients p
WHERE DATEDIFF(day, p.AdmissionDate, ISNULL(p.DischargeDate, GETDATE())) >
      (SELECT AVG(DATEDIFF(day, AdmissionDate, ISNULL(DischargeDate, GETDATE()))) 
       FROM Patients)
ORDER BY DaysInHospital DESC;
GO

-- 4. EXISTS: �����, ������� �������� �������� ������� ���������
SELECT
    d.FirstName,
    d.LastName,
    d.Specialization,
    dep.DepartmentName
FROM Doctors d
JOIN Departments dep ON d.DoctorID = dep.HeadDoctorID
WHERE EXISTS (
    SELECT 1
    FROM Departments
    WHERE HeadDoctorID = d.DoctorID
);
GO

-- �������

-- 1. ������: ���������� � ��������� � �� �������
DECLARE @PatientID INT, @FirstName NVARCHAR(50), @LastName NVARCHAR(50), @DiagnosisName NVARCHAR(200), @TreatmentName NVARCHAR(200), @Cost DECIMAL(10,2);
DECLARE patient_cursor CURSOR FOR
SELECT
    p.PatientID,
    p.FirstName,
    p.LastName,
    d.DiagnosisName,
    t.TreatmentName,
    t.Cost
FROM Patients p
JOIN Diagnoses d ON p.PatientID = d.PatientID
JOIN Treatments t ON p.PatientID = t.PatientID
ORDER BY p.LastName, p.FirstName;

OPEN patient_cursor;
FETCH NEXT FROM patient_cursor INTO @PatientID, @FirstName, @LastName, @DiagnosisName, @TreatmentName, @Cost;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '�������: ' + @FirstName + ' ' + @LastName + ', �������: ' + @DiagnosisName + ', �������: ' + @TreatmentName + ', ���������: ' + CAST(@Cost AS NVARCHAR(20));
    FETCH NEXT FROM patient_cursor INTO @PatientID, @FirstName, @LastName, @DiagnosisName, @TreatmentName, @Cost;
END;

CLOSE patient_cursor;
DEALLOCATE patient_cursor;
GO

-- 2. ��������� �������: ����� � �� ��������
DECLARE @DoctorID INT, @DoctorFirstName NVARCHAR(50), @DoctorLastName NVARCHAR(50), @Specialization NVARCHAR(100);
DECLARE @PatientFirstName NVARCHAR(50), @PatientLastName NVARCHAR(50), @DiagnosisName NVARCHAR(200);

DECLARE doctor_cursor CURSOR FOR
SELECT DoctorID, FirstName, LastName, Specialization
FROM Doctors
ORDER BY LastName, FirstName;

OPEN doctor_cursor;
FETCH NEXT FROM doctor_cursor INTO @DoctorID, @DoctorFirstName, @DoctorLastName, @Specialization;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '����: ' + @DoctorFirstName + ' ' + @DoctorLastName + ', �������������: ' + @Specialization;
    
    DECLARE patient_doctor_cursor CURSOR LOCAL FOR
    SELECT 
        p.FirstName,
        p.LastName,
        d.DiagnosisName
    FROM Patients p
    JOIN Diagnoses d ON p.PatientID = d.PatientID
    WHERE d.DoctorID = @DoctorID
    ORDER BY p.LastName, p.FirstName;
    
    OPEN patient_doctor_cursor;
    FETCH NEXT FROM patient_doctor_cursor INTO @PatientFirstName, @PatientLastName, @DiagnosisName;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT '  �������: ' + @PatientFirstName + ' ' + @PatientLastName + ', �������: ' + @DiagnosisName;
        FETCH NEXT FROM patient_doctor_cursor INTO @PatientFirstName, @PatientLastName, @DiagnosisName;
    END;
    
    CLOSE patient_doctor_cursor;
    DEALLOCATE patient_doctor_cursor;
    
    FETCH NEXT FROM doctor_cursor INTO @DoctorID, @DoctorFirstName, @DoctorLastName, @Specialization;
END;

CLOSE doctor_cursor;
DEALLOCATE doctor_cursor;
GO

-- �������� �������� ��� �����������
CREATE INDEX IX_Patients_AttendingDoctorID ON Patients(AttendingDoctorID);
CREATE INDEX IX_Patients_WardID ON Patients(WardID);
CREATE INDEX IX_Patients_AdmissionDate ON Patients(AdmissionDate);
CREATE INDEX IX_Doctors_DepartmentID ON Doctors(DepartmentID);
CREATE INDEX IX_Doctors_Specialization ON Doctors(Specialization);
CREATE INDEX IX_Diagnoses_PatientID ON Diagnoses(PatientID);
CREATE INDEX IX_Diagnoses_DoctorID ON Diagnoses(DoctorID);
CREATE INDEX IX_Treatments_PatientID ON Treatments(PatientID);
CREATE INDEX IX_Treatments_DoctorID ON Treatments(DoctorID);
CREATE INDEX IX_Treatments_DiagnosisID ON Treatments(DiagnosisID);
CREATE INDEX IX_Wards_DepartmentID ON Wards(DepartmentID);
GO