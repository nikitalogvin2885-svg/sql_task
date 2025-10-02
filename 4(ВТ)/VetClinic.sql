USE master;
GO

-- �������� ���� ������, ���� ��� ����������
IF DB_ID('VetClinicDB') IS NOT NULL
    DROP DATABASE VetClinicDB;
GO

-- �������� ���� ������
CREATE DATABASE VetClinicDB;
GO

USE VetClinicDB;
GO

-- �������� ����������������� ������� ������� � ������������ �������
CREATE TABLE Appointments_Denormalized (
    AppointmentID INT IDENTITY(1,1) PRIMARY KEY,
    OwnerInfo NVARCHAR(200),            -- ���, �������, email, ����� ���������
    PetInfo NVARCHAR(200),              -- ������, ���, ������, �������, ��� ���������
    VetInfo NVARCHAR(150),              -- ���, ������������� ����������
    AppointmentDate DATETIME,           -- ���� � ����� ������
    Diagnosis NVARCHAR(200),            -- �������
    Treatment NVARCHAR(500),            -- ����������� �������, ���������, ���������
    TreatmentCost DECIMAL(10, 2),       -- ��������� �������
    Vaccinations NVARCHAR(300),         -- ��������� �������� � ������
    NextVisitDate DATETIME,             -- ���� ���������� ������
    PaymentInfo NVARCHAR(150)           -- ������ ������, �����, ���� ������
);
GO

-- ���������� ����������������� ������� �������
INSERT INTO Appointments_Denormalized (
    OwnerInfo, PetInfo, VetInfo, AppointmentDate,
    Diagnosis, Treatment, TreatmentCost, Vaccinations, NextVisitDate, PaymentInfo
)
VALUES
('������ ���� ���������; +79123456789; ivanov@mail.ru; �. ������, ��. ������, �.10, ��.15',
 '������; �����; ����������; 3 ����; 4.5 ��',
 '������� ���� ����������; ��������, ������',
 '2023-11-10 10:00:00',
 '�������, �������� �� ����',
 '�����: Royal Canin Gastrointestinal, ��������: ��������� 1�*2�/���� 10 ����, �����: ���.B12 1��*3 ���',
 3500.00,
 '�����: 2022-05-15; ���������: 2022-06-20; ������: 2023-01-10',
 '2023-11-20 10:00:00',
 '���������� �����; 3500.00; 2023-11-10'),

('�������� ����� ��������; +79234567890; smirnova@mail.ru; �. �����-���������, ������� ��., �.5, ��.42',
 '����; ������; �������� �������; 5 ���; 35 ��',
 '������� ������� �������������; �������, ��������',
 '2023-11-10 14:30:00',
 '������ ������ ���, ��������� ������������� ��������',
 '�����: ���������� 0.1��*5 ����, ��������: ���������� 1�*2�/���� 30 ����, ������: 10 �������',
 7200.00,
 '�����: 2021-03-10; ���������: 2021-04-15; �����������: 2022-03-20; �����������: 2022-04-05',
 '2023-11-24 14:30:00',
 '��������; 7200.00; 2023-11-10'),

('������ ������� ������������; +79345678901; petrov@mail.ru; �. ������������, ��. ������-��������, �.120, ��.7',
 '����; �������; ���; 10 ���; 0.4 ��',
 '��������� ����� ��������; ���������, ��������',
 '2023-11-11 11:00:00',
 '����������, ��������� ������',
 '��������: ������� 0.2��*7 ����, ����: ����������� ���� ��� ��, �����: 5 ��������',
 2800.00,
 '�������: 2021-05-10; �������: 2021-06-15',
 '2023-11-25 11:00:00',
 '����������� ������; 2800.00; 2023-11-11'),

('������� ����� ���������; +79456789012; kozlova@mail.ru; �. �����������, ��. ������� ��������, �.85, ��.112',
 '������; �����; ����������; 1 ���; 3.8 ��',
 '������� ���� ����������; ����������, ����������',
 '2023-11-11 16:00:00',
 '��������, �������� �� ����',
 '�����: ��������� 0.5��*3 ���, �������: ��������������� 5 ����������, ��������: ��������� 1/4�*7 ����',
 4100.00,
 '�����: 2023-02-15; ���������: 2023-03-20',
 '2023-12-01 16:00:00',
 '���������� �����; 4100.00; 2023-11-11'),

('��������� ����� ����������; +79567890123; mihailova@example.com; �. ������, ��. �������, �.25, ��.33',
 '�����; ������; ��������; 2 ����; 28 ��',
 '������� �������� ��������; ���������, ���-����������',
 '2023-11-12 09:30:00',
 '����� ������, ��������',
 '�����: Royal Canin Cardiac, ��������: �������� 1/2�*2�/����, ��� ������: 1 ���������, �������: �������� �����',
 8500.00,
 '�����: 2022-04-10; ���������: 2022-05-15; �����������: 2022-06-20',
 '2023-12-12 09:30:00',
 '��������; 8500.00; 2023-11-12');
GO

-- �������� ����������������� ������
PRINT '����������������� ������� Appointments_Denormalized:';
GO
SELECT * FROM Appointments_Denormalized;
GO

/***********************************************************************
* ���� 2: ���������� � 1��
* ��������� 1��:
* 1. ��������� �������� � OwnerInfo, PetInfo, VetInfo, Vaccinations, PaymentInfo
* 2. ������������� ������ � Treatment, Vaccinations
* 3. ����������� �������� � ���������� �����
***********************************************************************/

-- �������� ������� � 1��
CREATE TABLE Appointments_1NF (
    RecordID INT IDENTITY(1,1) PRIMARY KEY,
    AppointmentID INT,
    OwnerFName NVARCHAR(50),
    OwnerMName NVARCHAR(50),
    OwnerLName NVARCHAR(50),
    OwnerPhone NVARCHAR(20),
    OwnerEmail NVARCHAR(100),
    OwnerAddress NVARCHAR(200),
    PetName NVARCHAR(50),
    PetSpecies NVARCHAR(50),
    PetBreed NVARCHAR(50),
    PetAge NVARCHAR(20),
    PetWeight DECIMAL(5,2),
    VetFName NVARCHAR(50),
    VetMName NVARCHAR(50),
    VetLName NVARCHAR(50),
    VetSpecialization NVARCHAR(100),
    AppointmentDate DATETIME,
    Diagnosis NVARCHAR(200),
    TreatmentItem NVARCHAR(200),
    TreatmentCost DECIMAL(10, 2),
    VaccineName NVARCHAR(50),
    VaccineDate DATE,
    NextVisitDate DATETIME,
    PaymentMethod NVARCHAR(50),
    PaymentAmount DECIMAL(10, 2),
    PaymentDate DATE
);
GO

-- ���������� ������� � 1�� (��������� ��������� ��������)
-- ����� 1 - ������
INSERT INTO Appointments_1NF (
    AppointmentID, OwnerFName, OwnerMName, OwnerLName, OwnerPhone, OwnerEmail, OwnerAddress,
    PetName, PetSpecies, PetBreed, PetAge, PetWeight,
    VetFName, VetMName, VetLName, VetSpecialization, AppointmentDate, Diagnosis,
    TreatmentItem, TreatmentCost, VaccineName, VaccineDate, NextVisitDate,
    PaymentMethod, PaymentAmount, PaymentDate
)
SELECT 1, '����', '���������', '������', '+79123456789', 'ivanov@mail.ru', '�. ������, ��. ������, �.10, ��.15',
       '������', '�����', '����������', '3 ����', 4.5,
       '����', '����������', '�������', '��������, ������', '2023-11-10 10:00:00', '�������, �������� �� ����',
       '�����: Royal Canin Gastrointestinal', 3500.00, '�����', '2022-05-15', '2023-11-20 10:00:00',
       '���������� �����', 3500.00, '2023-11-10'
UNION ALL
SELECT 1, '����', '���������', '������', '+79123456789', 'ivanov@mail.ru', '�. ������, ��. ������, �.10, ��.15',
       '������', '�����', '����������', '3 ����', 4.5,
       '����', '����������', '�������', '��������, ������', '2023-11-10 10:00:00', '�������, �������� �� ����',
       '��������: ��������� 1�*2�/���� 10 ����', 3500.00, '���������', '2022-06-20', '2023-11-20 10:00:00',
       '���������� �����', 3500.00, '2023-11-10'
UNION ALL
SELECT 1, '����', '���������', '������', '+79123456789', 'ivanov@mail.ru', '�. ������, ��. ������, �.10, ��.15',
       '������', '�����', '����������', '3 ����', 4.5,
       '����', '����������', '�������', '��������, ������', '2023-11-10 10:00:00', '�������, �������� �� ����',
       '�����: ���.B12 1��*3 ���', 3500.00, '������', '2023-01-10', '2023-11-20 10:00:00',
       '���������� �����', 3500.00, '2023-11-10'

-- ����� 2 - ����
UNION ALL
SELECT 2, '�����', '��������', '��������', '+79234567890', 'smirnova@mail.ru', '�. �����-���������, ������� ��., �.5, ��.42',
       '����', '������', '�������� �������', '5 ���', 35.0,
       '�������', '�������������', '�������', '�������, ��������', '2023-11-10 14:30:00', '������ ������ ���, ��������� ������������� ��������',
       '�����: ���������� 0.1��*5 ����', 7200.00, '�����', '2021-03-10', '2023-11-24 14:30:00',
       '��������', 7200.00, '2023-11-10'
UNION ALL
SELECT 2, '�����', '��������', '��������', '+79234567890', 'smirnova@mail.ru', '�. �����-���������, ������� ��., �.5, ��.42',
       '����', '������', '�������� �������', '5 ���', 35.0,
       '�������', '�������������', '�������', '�������, ��������', '2023-11-10 14:30:00', '������ ������ ���, ��������� ������������� ��������',
       '��������: ���������� 1�*2�/���� 30 ����', 7200.00, '���������', '2021-04-15', '2023-11-24 14:30:00',
       '��������', 7200.00, '2023-11-10'
UNION ALL
SELECT 2, '�����', '��������', '��������', '+79234567890', 'smirnova@mail.ru', '�. �����-���������, ������� ��., �.5, ��.42',
       '����', '������', '�������� �������', '5 ���', 35.0,
       '�������', '�������������', '�������', '�������, ��������', '2023-11-10 14:30:00', '������ ������ ���, ��������� ������������� ��������',
       '������: 10 �������', 7200.00, '�����������', '2022-03-20', '2023-11-24 14:30:00',
       '��������', 7200.00, '2023-11-10'
UNION ALL
SELECT 2, '�����', '��������', '��������', '+79234567890', 'smirnova@mail.ru', '�. �����-���������, ������� ��., �.5, ��.42',
       '����', '������', '�������� �������', '5 ���', 35.0,
       '�������', '�������������', '�������', '�������, ��������', '2023-11-10 14:30:00', '������ ������ ���, ��������� ������������� ��������',
       NULL, 7200.00, '�����������', '2022-04-05', '2023-11-24 14:30:00',
       '��������', 7200.00, '2023-11-10'

-- ����� 3 - ����
UNION ALL
SELECT 3, '�������', '������������', '������', '+79345678901', 'petrov@mail.ru', '�. ������������, ��. ������-��������, �.120, ��.7',
       '����', '�������', '���', '10 ���', 0.4,
       '�����', '��������', '���������', '���������, ��������', '2023-11-11 11:00:00', '����������, ��������� ������',
       '��������: ������� 0.2��*7 ����', 2800.00, '�������', '2021-05-10', '2023-11-25 11:00:00',
       '����������� ������', 2800.00, '2023-11-11'
UNION ALL
SELECT 3, '�������', '������������', '������', '+79345678901', 'petrov@mail.ru', '�. ������������, ��. ������-��������, �.120, ��.7',
       '����', '�������', '���', '10 ���', 0.4,
       '�����', '��������', '���������', '���������, ��������', '2023-11-11 11:00:00', '����������, ��������� ������',
       '����: ����������� ���� ��� ��', 2800.00, '�������', '2021-06-15', '2023-11-25 11:00:00',
       '����������� ������', 2800.00, '2023-11-11'
UNION ALL
SELECT 3, '�������', '������������', '������', '+79345678901', 'petrov@mail.ru', '�. ������������, ��. ������-��������, �.120, ��.7',
       '����', '�������', '���', '10 ���', 0.4,
       '�����', '��������', '���������', '���������, ��������', '2023-11-11 11:00:00', '����������, ��������� ������',
       '�����: 5 ��������', 2800.00, NULL, NULL, '2023-11-25 11:00:00',
       '����������� ������', 2800.00, '2023-11-11'

-- ����� 4 - ������
UNION ALL
SELECT 4, '�����', '���������', '�������', '+79456789012', 'kozlova@mail.ru', '�. �����������, ��. ������� ��������, �.85, ��.112',
       '������', '�����', '����������', '1 ���', 3.8,
       '����', '����������', '�������', '����������, ����������', '2023-11-11 16:00:00', '��������, �������� �� ����',
       '�����: ��������� 0.5��*3 ���', 4100.00, '�����', '2023-02-15', '2023-12-01 16:00:00',
       '���������� �����', 4100.00, '2023-11-11'
UNION ALL
SELECT 4, '�����', '���������', '�������', '+79456789012', 'kozlova@mail.ru', '�. �����������, ��. ������� ��������, �.85, ��.112',
       '������', '�����', '����������', '1 ���', 3.8,
       '����', '����������', '�������', '����������, ����������', '2023-11-11 16:00:00', '��������, �������� �� ����',
       '�������: ��������������� 5 ����������', 4100.00, '���������', '2023-03-20', '2023-12-01 16:00:00',
       '���������� �����', 4100.00, '2023-11-11'
UNION ALL
SELECT 4, '�����', '���������', '�������', '+79456789012', 'kozlova@mail.ru', '�. �����������, ��. ������� ��������, �.85, ��.112',
       '������', '�����', '����������', '1 ���', 3.8,
       '����', '����������', '�������', '����������, ����������', '2023-11-11 16:00:00', '��������, �������� �� ����',
       '��������: ��������� 1/4�*7 ����', 4100.00, NULL, NULL, '2023-12-01 16:00:00',
       '���������� �����', 4100.00, '2023-11-11'

-- ����� 5 - �����
UNION ALL
SELECT 5, '�����', '����������', '���������', '+79567890123', 'mihailova@example.com', '�. ������, ��. �������, �.25, ��.33',
       '�����', '������', '��������', '2 ����', 28.0,
       '��������', '��������', '�������', '���������, ���-����������', '2023-11-12 09:30:00', '����� ������, ��������',
       '�����: Royal Canin Cardiac', 8500.00, '�����', '2022-04-10', '2023-12-12 09:30:00',
       '��������', 8500.00, '2023-11-12'
UNION ALL
SELECT 5, '�����', '����������', '���������', '+79567890123', 'mihailova@example.com', '�. ������, ��. �������, �.25, ��.33',
       '�����', '������', '��������', '2 ����', 28.0,
       '��������', '��������', '�������', '���������, ���-����������', '2023-11-12 09:30:00', '����� ������, ��������',
       '��������: �������� 1/2�*2�/����', 8500.00, '���������', '2022-05-15', '2023-12-12 09:30:00',
       '��������', 8500.00, '2023-11-12'
UNION ALL
SELECT 5, '�����', '����������', '���������', '+79567890123', 'mihailova@example.com', '�. ������, ��. �������, �.25, ��.33',
       '�����', '������', '��������', '2 ����', 28.0,
       '��������', '��������', '�������', '���������, ���-����������', '2023-11-12 09:30:00', '����� ������, ��������',
       '��� ������: 1 ���������', 8500.00, '�����������', '2022-06-20', '2023-12-12 09:30:00',
       '��������', 8500.00, '2023-11-12'
UNION ALL
SELECT 5, '�����', '����������', '���������', '+79567890123', 'mihailova@example.com', '�. ������, ��. �������, �.25, ��.33',
       '�����', '������', '��������', '2 ����', 28.0,
       '��������', '��������', '�������', '���������, ���-����������', '2023-11-12 09:30:00', '����� ������, ��������',
       '�������: �������� �����', 8500.00, NULL, NULL, '2023-12-12 09:30:00',
       '��������', 8500.00, '2023-11-12';
GO

-- �������� ������ � 1��
PRINT '������� � 1�� Appointments_1NF:';
GO
SELECT * FROM Appointments_1NF;
GO

-- �������� ���������� ������

CREATE TABLE AnimalSpecies (
    SpeciesID INT IDENTITY(1,1) PRIMARY KEY,
    SpeciesName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200)
);
GO

CREATE TABLE AnimalBreeds (
    BreedID INT IDENTITY(1,1) PRIMARY KEY,
    SpeciesID INT NOT NULL,
    BreedName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200),
    FOREIGN KEY (SpeciesID) REFERENCES AnimalSpecies(SpeciesID)
);
GO

-- 3. ���������
CREATE TABLE Owners (
    OwnerID INT IDENTITY(1,1) PRIMARY KEY,
    FName NVARCHAR(50) NOT NULL,
    MName NVARCHAR(50),
    LName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    Address NVARCHAR(200),
    RegistrationDate DATETIME DEFAULT GETDATE(),
    CHECK (Phone LIKE '+7[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);
GO

-- 4. ��������
CREATE TABLE Pets (
    PetID INT IDENTITY(1,1) PRIMARY KEY,
    OwnerID INT NOT NULL,
    Name NVARCHAR(50) NOT NULL,
    SpeciesID INT NOT NULL,
    BreedID INT,
    Age INT,
    Weight DECIMAL(5,2),
    BirthDate DATE,
    RegistrationDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (OwnerID) REFERENCES Owners(OwnerID),
    FOREIGN KEY (SpeciesID) REFERENCES AnimalSpecies(SpeciesID),
    FOREIGN KEY (BreedID) REFERENCES AnimalBreeds(BreedID)
);
GO

-- 5. ����������
CREATE TABLE Vets (
    VetID INT IDENTITY(1,1) PRIMARY KEY,
    FName NVARCHAR(50) NOT NULL,
    MName NVARCHAR(50),
    LName NVARCHAR(50) NOT NULL,
    Specialization NVARCHAR(200),
    HireDate DATE,
    Salary DECIMAL(10, 2)
);
GO

CREATE TABLE VetSpecializations (
    SpecializationID INT IDENTITY(1,1) PRIMARY KEY,
    SpecializationName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 7. ����� ����������� � ������������� (������ �� ������)
CREATE TABLE VetSpecializationLink (
    VetID INT NOT NULL,
    SpecializationID INT NOT NULL,
    PRIMARY KEY (VetID, SpecializationID),
    FOREIGN KEY (VetID) REFERENCES Vets(VetID),
    FOREIGN KEY (SpecializationID) REFERENCES VetSpecializations(SpecializationID)
);
GO

-- 8. ������
CREATE TABLE Appointments (
    AppointmentID INT IDENTITY(1,1) PRIMARY KEY,
    PetID INT NOT NULL,
    VetID INT NOT NULL,
    AppointmentDate DATETIME NOT NULL,
    Diagnosis NVARCHAR(200),
    NextVisitDate DATETIME,
    FOREIGN KEY (PetID) REFERENCES Pets(PetID),
    FOREIGN KEY (VetID) REFERENCES Vets(VetID)
);
GO

-- 9. �������
CREATE TABLE Treatments (
    TreatmentID INT IDENTITY(1,1) PRIMARY KEY,
    AppointmentID INT NOT NULL,
    TreatmentDescription NVARCHAR(200) NOT NULL,
    Cost DECIMAL(10, 2),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID)
);
GO

CREATE TABLE TreatmentTypes (
    TreatmentTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TreatmentTypeName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 11. ����� ������� � ����� �������
CREATE TABLE TreatmentTypeLink (
    TreatmentID INT NOT NULL,
    TreatmentTypeID INT NOT NULL,
    PRIMARY KEY (TreatmentID, TreatmentTypeID),
    FOREIGN KEY (TreatmentID) REFERENCES Treatments(TreatmentID),
    FOREIGN KEY (TreatmentTypeID) REFERENCES TreatmentTypes(TreatmentTypeID)
);
GO

CREATE TABLE Vaccines (
    VaccineID INT IDENTITY(1,1) PRIMARY KEY,
    VaccineName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200),
    ValidityPeriod INT  -- � �������
);
GO

-- 13. ����������
CREATE TABLE Vaccinations (
    VaccinationID INT IDENTITY(1,1) PRIMARY KEY,
    PetID INT NOT NULL,
    VaccineID INT NOT NULL,
    VaccinationDate DATE NOT NULL,
    NextVaccinationDate DATE,
    FOREIGN KEY (PetID) REFERENCES Pets(PetID),
    FOREIGN KEY (VaccineID) REFERENCES Vaccines(VaccineID)
);
GO

-- 14. ������� ������
CREATE TABLE PaymentMethods (
    PaymentMethodID INT IDENTITY(1,1) PRIMARY KEY,
    MethodName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 15. �������
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    AppointmentID INT NOT NULL,
    PaymentMethodID INT NOT NULL,
    PaymentDate DATETIME NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    Description NVARCHAR(200),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID),
    FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethods(PaymentMethodID)
);
GO

-- ���������� ���������� ������

-- 1. ���� ��������
INSERT INTO AnimalSpecies (SpeciesName, Description)
VALUES
('�����', '�������� �����'),
('������', '�������� ������'),
('�������', '�������� �������'),
('�����', '�������� ������'),
('������', '�������� �������');
GO

-- ����� ������ �� AnimalSpecies
PRINT '������� AnimalSpecies:';
GO
SELECT * FROM AnimalSpecies;
GO

-- 2. ������ ��������
INSERT INTO AnimalBreeds (SpeciesID, BreedName, Description)
VALUES
(1, '����������', '�������������� ������ �����'),
(1, '����������', '��������������� ������ �����'),
(2, '�������� �������', '��������� ������ �����'),
(2, '��������', '��������� ������ �����'),
(3, '���', '������� �������'),
(3, '���������', '������ �������');
GO

-- ����� ������ �� AnimalBreeds
PRINT '������� AnimalBreeds:';
GO
SELECT * FROM AnimalBreeds;
GO

-- 3. ������������� �����������
INSERT INTO VetSpecializations (SpecializationName, Description)
VALUES
('��������', '����� ������� ��������'),
('������', '������������� ��������'),
('�������', '������� ������-������������� ��������'),
('��������', '������� ������� �������'),
('���������', '���������� �� ������'),
('����������', '������� ������ �����������'),
('����������', '������� ������������� �������'),
('���������', '������� ��������-���������� �����������'),
('���-����������', '���������� �������������� ������������');
GO

-- ����� ������ �� VetSpecializations
PRINT '������� VetSpecializations:';
GO
SELECT * FROM VetSpecializations;
GO

-- 4. ������� ������
INSERT INTO PaymentMethods (MethodName, Description)
VALUES
('��������', '������ ��������� � �������'),
('���������� �����', '������ ���������� ������ ����� ��������'),
('����������� ������', '������ ����� ����������� ��������� �������');
GO

-- ����� ������ �� PaymentMethods
PRINT '������� PaymentMethods:';
GO
SELECT * FROM PaymentMethods;
GO

-- 5. ���� �������
INSERT INTO TreatmentTypes (TreatmentTypeName, Description)
VALUES
('�����', '����������� �������'),
('��������', '����������� ���������'),
('�����', '��������'),
('������', '��������� ���������'),
('��������', '���������� �������'),
('����', '����������� ����'),
('�����', '������ ���������'),
('�������', '�������� ��������'),
('���', '�������������� ������������'),
('�������', '������������ �������');
GO

-- ����� ������ �� TreatmentTypes
PRINT '������� TreatmentTypes:';
GO
SELECT * FROM TreatmentTypes;
GO

-- 6. �������
INSERT INTO Vaccines (VaccineName, Description, ValidityPeriod)
VALUES
('�����', '������� ������ ���� ����������', 12),
('���������', '������� ������ ���������', 12),
('������', '������� ������ ������� �����', 12),
('�����������', '������� ������ ������������', 12),
('�����������', '������� ������ ������������ �����', 12),
('�������', '������� ������ ������� ��������', 12),
('�������', '������� ������ ��������', 12);
GO

-- ����� ������ �� Vaccines
PRINT '������� Vaccines:';
GO
SELECT * FROM Vaccines;
GO

-- 7. ���������
INSERT INTO Owners (FName, MName, LName, Phone, Email, Address)
VALUES
('����', '���������', '������', '+79123456789', 'ivanov@mail.ru', '�. ������, ��. ������, �.10, ��.15'),
('�����', '��������', '��������', '+79234567890', 'smirnova@mail.ru', '�. �����-���������, ������� ��., �.5, ��.42'),
('�������', '������������', '������', '+79345678901', 'petrov@mail.ru', '�. ������������, ��. ������-��������, �.120, ��.7'),
('�����', '���������', '�������', '+79456789012', 'kozlova@mail.ru', '�. �����������, ��. ������� ��������, �.85, ��.112'),
('�����', '����������', '���������', '+79567890123', 'mihailova@example.com', '�. ������, ��. �������, �.25, ��.33');
GO

-- ����� ������ �� Owners
PRINT '������� Owners:';
GO
SELECT * FROM Owners;
GO

-- 8. ��������
INSERT INTO Pets (OwnerID, Name, SpeciesID, BreedID, Age, Weight, BirthDate)
VALUES
(1, '������', 1, 1, 3, 4.5, DATEADD(YEAR, -3, GETDATE())),
(2, '����', 2, 3, 5, 35.0, DATEADD(YEAR, -5, GETDATE())),
(3, '����', 3, 5, 10, 0.4, DATEADD(YEAR, -10, GETDATE())),
(4, '������', 1, 2, 1, 1, 3.8, DATEADD(YEAR, -1, GETDATE())),
(5, '�����', 2, 4, 2, 28.0, DATEADD(YEAR, -2, GETDATE()));
GO

-- ����� ������ �� Pets
PRINT '������� Pets:';
GO
SELECT * FROM Pets;
GO

-- 9. ����������
INSERT INTO Vets (FName, MName, LName, Specialization, HireDate, Salary)
VALUES
('����', '����������', '�������', '��������, ������', '2018-05-10', 45000.00),
('�������', '�������������', '�������', '�������, ��������', '2019-03-15', 50000.00),
('�����', '��������', '���������', '���������, ��������', '2017-11-20', 48000.00),
('����', '����������', '�������', '����������, ����������', '2020-01-05', 42000.00),
('��������', '��������', '�������', '���������, ���-����������', '2016-09-12', 55000.00);
GO

-- ����� ������ �� Vets
PRINT '������� Vets:';
GO
SELECT * FROM Vets;
GO

-- 10. ����� ����������� � �������������
INSERT INTO VetSpecializationLink (VetID, SpecializationID)
VALUES
(1, 1), (1, 2),  -- �������: ��������, ������
(2, 3), (2, 4),  -- �������: �������, ��������
(3, 5), (3, 1),  -- ���������: ���������, ��������
(4, 6), (4, 7),  -- �������: ����������, ����������
(5, 8), (5, 9);  -- �������: ���������, ���-����������
GO

-- ����� ������ �� VetSpecializationLink
PRINT '������� VetSpecializationLink:';
GO
SELECT * FROM VetSpecializationLink;
GO

-- 11. ������
INSERT INTO Appointments (PetID, VetID, AppointmentDate, Diagnosis, NextVisitDate)
VALUES
(1, 1, '2023-11-10 10:00:00', '�������, �������� �� ����', '2023-11-20 10:00:00'),
(2, 2, '2023-11-10 14:30:00', '������ ������ ���, ��������� ������������� ��������', '2023-11-24 14:30:00'),
(3, 3, '2023-11-11 11:00:00', '����������, ��������� ������', '2023-11-25 11:00:00'),
(4, 4, '2023-11-11 16:00:00', '��������, �������� �� ����', '2023-12-01 16:00:00'),
(5, 5, '2023-11-12 09:30:00', '����� ������, ��������', '2023-12-12 09:30:00');
GO

-- ����� ������ �� Appointments
PRINT '������� Appointments:';
GO
SELECT * FROM Appointments;
GO

-- 12. �������
INSERT INTO Treatments (AppointmentID, TreatmentDescription, Cost)
VALUES
(1, '�����: Royal Canin Gastrointestinal', 1500.00),
(1, '��������: ��������� 1�*2�/���� 10 ����', 1000.00),
(1, '�����: ���.B12 1��*3 ���', 1000.00),
(2, '�����: ���������� 0.1��*5 ����', 2500.00),
(2, '��������: ���������� 1�*2�/���� 30 ����', 3000.00),
(2, '������: 10 �������', 1700.00),
(3, '��������: ������� 0.2��*7 ����', 800.00),
(3, '����: ����������� ���� ��� ��', 1200.00),
(3, '�����: 5 ��������', 800.00),
(4, '�����: ��������� 0.5��*3 ���', 1500.00),
(4, '�������: ��������������� 5 ����������', 1200.00),
(4, '��������: ��������� 1/4�*7 ����', 600.00),
(5, '�����: Royal Canin Cardiac', 2000.00),
(5, '��������: �������� 1/2�*2�/����', 3000.00),
(5, '��� ������: 1 ���������', 2000.00),
(5, '�������: �������� �����', 1500.00);
GO

-- ����� ������ �� Treatments
PRINT '������� Treatments:';
GO
SELECT * FROM Treatments;
GO

-- 13. ����� ������� � ����� �������
INSERT INTO TreatmentTypeLink (TreatmentID, TreatmentTypeID)
VALUES
(1, 1), (2, 2), (3, 3), (4, 3), (5, 2), (6, 4), (7, 5), (8, 6), (9, 7),
(10, 9), (11, 2), (12, 10), (13, 11);
GO

-- ����� ������ �� TreatmentTypeLink
PRINT '������� TreatmentTypeLink:';
GO
SELECT * FROM TreatmentTypeLink;
GO

-- 14. ����������
INSERT INTO Vaccinations (PetID, VaccineID, VaccinationDate, NextVaccinationDate)
VALUES
(1, 1, '2022-05-15', '2023-05-15'),  -- ������, �����
(1, 2, '2022-06-20', '2023-06-20'),  -- ������, ���������
(1, 3, '2023-01-10', '2024-01-10'),  -- ������, ������
(2, 1, '2021-03-10', '2022-03-10'),  -- ����, �����
(2, 2, '2021-04-15', '2022-04-15'),  -- ����, ���������
(2, 4, '2022-03-20', '2023-03-20'),  -- ����, �����������
(2, 5, '2022-04-05', '2023-04-05'),  -- ����, �����������
(3, 6, '2021-05-10', '2022-05-10'),  -- ����, �������
(3, 7, '2021-06-15', '2022-06-15'),  -- ����, �������
(4, 1, '2023-02-15', '2024-02-15'),  -- ������, �����
(4, 2, '2023-03-20', '2024-03-20'),  -- ������, ���������
(5, 1, '2022-04-10', '2023-04-10'),  -- �����, �����
(5, 2, '2022-05-15', '2023-05-15'),  -- �����, ���������
(5, 4, '2022-06-20', '2023-06-20');  -- �����, �����������
GO

-- ����� ������ �� Vaccinations
PRINT '������� Vaccinations:';
GO
SELECT * FROM Vaccinations;
GO

-- 15. �������
INSERT INTO Payments (AppointmentID, PaymentMethodID, PaymentDate, Amount, Description)
VALUES
(1, 2, '2023-11-10 10:15:00', 3500.00, '������ ������ �������'),
(2, 1, '2023-11-10 14:45:00', 7200.00, '������ ������ �����'),
(3, 3, '2023-11-11 11:15:00', 2800.00, '������ ������ ����'),
(4, 2, '2023-11-11 16:15:00', 4100.00, '������ ������ �������'),
(5, 1, '2023-11-12 09:45:00', 8500.00, '������ ������ ������');
GO

-- ����� ������ �� Payments
PRINT '������� Payments:';
GO
SELECT * FROM Payments;
GO

-- ����������� ����������� ��������

-- 1. �������������� ��������� ������������� (������������ ������)
PRINT '1. �������������� ��������� ������������� (������������):';
GO

SELECT
    a.AppointmentID,
    CONCAT(o.FName, ' ', o.MName, ' ', o.LName, '; ', o.Phone, '; ', o.Email, '; ', o.Address) AS OwnerInfo,
    CONCAT(p.Name, '; ', s.SpeciesName, '; ', b.BreedName, '; ', p.Age, ' ���; ', p.Weight, ' ��') AS PetInfo,
    CONCAT(v.FName, ' ', v.MName, ' ', v.LName, '; ',
           (SELECT STRING_AGG(vs.SpecializationName, ', ')
            FROM VetSpecializationLink vsl
            JOIN VetSpecializations vs ON vsl.SpecializationID = vs.SpecializationID
            WHERE vsl.VetID = v.VetID)) AS VetInfo,
    a.AppointmentDate,
    a.Diagnosis,
    (
        SELECT STRING_AGG(t.TreatmentDescription, '; ')
        FROM Treatments t
        WHERE t.AppointmentID = a.AppointmentID
    ) AS Treatment,
    (
        SELECT SUM(t.Cost)
        FROM Treatments t
        WHERE t.AppointmentID = a.AppointmentID
    ) AS TreatmentCost,
    (
        SELECT STRING_AGG(CONCAT(vc.VaccineName, ': ', CONVERT(VARCHAR, vn.VaccinationDate, 104)), '; ')
        FROM Vaccinations vn
        JOIN Vaccines vc ON vn.VaccineID = vc.VaccineID
        WHERE vn.PetID = p.PetID
    ) AS Vaccinations,
    a.NextVisitDate,
    (
        SELECT TOP 1 CONCAT(pm.MethodName, '; ', p.Amount, '; ', CONVERT(VARCHAR, p.PaymentDate, 104))
        FROM Payments p
        JOIN PaymentMethods pm ON p.PaymentMethodID = pm.PaymentMethodID
        WHERE p.AppointmentID = a.AppointmentID
        ORDER BY p.PaymentDate DESC
    ) AS PaymentInfo
FROM Appointments a
JOIN Pets p ON a.PetID = p.PetID
JOIN Owners o ON p.OwnerID = o.OwnerID
JOIN Vets v ON a.VetID = v.VetID
JOIN AnimalSpecies s ON p.SpeciesID = s.SpeciesID
LEFT JOIN AnimalBreeds b ON p.BreedID = b.BreedID;
GO

-- ������������ ������ 2 � �������������� CTE
PRINT '2. ������������ ������������� �����������:';
GO

WITH AppointmentRevenue AS (
    SELECT
        a.AppointmentID,
        vsl.SpecializationID,
        SUM(t.Cost) AS AppointmentRevenue
    FROM Appointments a
    JOIN Vets v ON a.VetID = v.VetID
    JOIN VetSpecializationLink vsl ON v.VetID = vsl.VetID
    JOIN Treatments t ON a.AppointmentID = t.AppointmentID
    GROUP BY a.AppointmentID, vsl.SpecializationID
)
SELECT
    vs.SpecializationName,
    COUNT(DISTINCT ar.AppointmentID) AS AppointmentCount,
    COUNT(DISTINCT a.PetID) AS UniquePets,
    SUM(ar.AppointmentRevenue) AS TotalRevenue
FROM AppointmentRevenue ar
JOIN VetSpecializations vs ON ar.SpecializationID = vs.SpecializationID
JOIN Appointments a ON ar.AppointmentID = a.AppointmentID
GROUP BY vs.SpecializationName
ORDER BY AppointmentCount DESC;
GO

-- 3. ���������� �� ����� ��������
PRINT '3. ���������� �� ����� ��������:';
GO

SELECT
    s.SpeciesName,
    COUNT(p.PetID) AS PetCount,
    COUNT(DISTINCT o.OwnerID) AS OwnerCount,
    (
        SELECT COUNT(*)
        FROM Appointments a
        WHERE a.PetID = p.PetID
    ) AS TotalAppointments,
    (
        SELECT SUM(t.Cost)
        FROM Appointments a
        JOIN Treatments t ON a.AppointmentID = t.AppointmentID
        WHERE a.PetID = p.PetID
    ) AS TotalRevenue
FROM Pets p
JOIN AnimalSpecies s ON p.SpeciesID = s.SpeciesID
JOIN Owners o ON p.OwnerID = o.OwnerID
GROUP BY s.SpeciesName
ORDER BY PetCount DESC;
GO

-- 4. ������ ����������
PRINT '4. ������ ����������:';
GO

SELECT
    vc.VaccineName,
    COUNT(vn.VaccinationID) AS VaccinationCount,
    COUNT(DISTINCT vn.PetID) AS UniquePets,
    MIN(vn.VaccinationDate) AS EarliestVaccination,
    MAX(vn.VaccinationDate) AS LatestVaccination
FROM Vaccinations vn
JOIN Vaccines vc ON vn.VaccineID = vc.VaccineID
GROUP BY vc.VaccineName
ORDER BY VaccinationCount DESC;
GO

-- 5. ���������� ������ ��������
PRINT '5. ���������� ������ ��������:';
GO

SELECT
    s.SpeciesName,
    b.BreedName,
    COUNT(p.PetID) AS PetCount,
    COUNT(DISTINCT o.OwnerID) AS OwnerCount
FROM Pets p
JOIN AnimalSpecies s ON p.SpeciesID = s.SpeciesID
JOIN AnimalBreeds b ON p.BreedID = b.BreedID
JOIN Owners o ON p.OwnerID = o.OwnerID
GROUP BY s.SpeciesName, b.BreedName
ORDER BY PetCount DESC;
GO

-- 6. ������ ������� �� �����
PRINT '6. ������ ������� �� �����:';
GO

SELECT
    tt.TreatmentTypeName,
    COUNT(t.TreatmentID) AS TreatmentCount,
    SUM(t.Cost) AS TotalCost,
    AVG(t.Cost) AS AvgCost
FROM Treatments t
JOIN TreatmentTypeLink ttl ON t.TreatmentID = ttl.TreatmentID
JOIN TreatmentTypes tt ON ttl.TreatmentTypeID = tt.TreatmentTypeID
GROUP BY tt.TreatmentTypeName
ORDER BY TreatmentCount DESC;
GO

-- 7. ���������� ����������
PRINT '7. ���������� ����������:';
GO

SELECT
    CONCAT(o.FName, ' ', o.LName) AS OwnerName,
    o.Phone,
    COUNT(DISTINCT p.PetID) AS PetCount,
    COUNT(DISTINCT a.AppointmentID) AS AppointmentCount,
    (
        SELECT SUM(p.Amount)
        FROM Payments p
        JOIN Appointments ap ON p.AppointmentID = ap.AppointmentID
        WHERE ap.PetID IN (SELECT PetID FROM Pets WHERE OwnerID = o.OwnerID)
    ) AS TotalSpent
FROM Owners o
LEFT JOIN Pets p ON o.OwnerID = p.OwnerID
LEFT JOIN Appointments a ON p.PetID = a.PetID
GROUP BY CONCAT(o.FName, ' ', o.LName), o.Phone, o.OwnerID
ORDER BY TotalSpent DESC;
GO

-- 8. ������������� �����������
PRINT '8. ������������� �����������:';
GO

SELECT
    CONCAT(v.FName, ' ', v.LName) AS VetName,
    (
        SELECT STRING_AGG(vs.SpecializationName, ', ')
        FROM VetSpecializationLink vsl
        JOIN VetSpecializations vs ON vsl.SpecializationID = vs.SpecializationID
        WHERE vsl.VetID = v.VetID
    ) AS Specializations,
    COUNT(a.AppointmentID) AS AppointmentCount,
    SUM(
        SELECT SUM(t.Cost)
        FROM Treatments t
        WHERE t.AppointmentID = a.AppointmentID
    ) AS TotalRevenue,
    AVG(DATEDIFF(DAY, a.AppointmentDate, a.NextVisitDate)) AS AvgDaysToNextVisit
FROM Vets v
LEFT JOIN Appointments a ON v.VetID = a.VetID
GROUP BY CONCAT(v.FName, ' ', v.LName), v.VetID
ORDER BY AppointmentCount DESC;
GO

-- ������������ ������ 8 � �������������� CTE
PRINT '8. ������������� ����������� (������������):';
GO

WITH VetRevenue AS (
    SELECT
        a.VetID,
        a.AppointmentID,
        SUM(t.Cost) AS AppointmentRevenue
    FROM Appointments a
    JOIN Treatments t ON a.AppointmentID = t.AppointmentID
    GROUP BY a.VetID, a.AppointmentID
)
SELECT
    CONCAT(v.FName, ' ', v.LName) AS VetName,
    (
        SELECT STRING_AGG(vs.SpecializationName, ', ')
        FROM VetSpecializationLink vsl
        JOIN VetSpecializations vs ON vsl.SpecializationID = vs.SpecializationID
        WHERE vsl.VetID = v.VetID
    ) AS Specializations,
    COUNT(vr.AppointmentID) AS AppointmentCount,
    SUM(vr.AppointmentRevenue) AS TotalRevenue,
    AVG(DATEDIFF(DAY, a.AppointmentDate, a.NextVisitDate)) AS AvgDaysToNextVisit
FROM Vets v
LEFT JOIN Appointments a ON v.VetID = a.VetID
LEFT JOIN VetRevenue vr ON a.AppointmentID = vr.AppointmentID
GROUP BY CONCAT(v.FName, ' ', v.LName), v.VetID
ORDER BY AppointmentCount DESC;
GO

-- 9. ��������������� ������ ��������
PRINT '9. ��������������� ������ ��������:';
GO

SELECT
    s.SpeciesName,
    b.BreedName,
    AVG(p.Age) AS AvgAge,
    MIN(p.Age) AS MinAge,
    MAX(p.Age) AS MaxAge,
    AVG(p.Weight) AS AvgWeight,
    MIN(p.Weight) AS MinWeight,
    MAX(p.Weight) AS MaxWeight,
    COUNT(p.PetID) AS PetCount
FROM Pets p
JOIN AnimalSpecies s ON p.SpeciesID = s.SpeciesID
LEFT JOIN AnimalBreeds b ON p.BreedID = b.BreedID
GROUP BY s.SpeciesName, b.BreedName
ORDER BY PetCount DESC;
GO

-- 10. ������ �������� �� �������� ������
PRINT '10. ������ �������� �� �������� ������:';
GO

SELECT
    pm.MethodName AS PaymentMethod,
    COUNT(p.PaymentID) AS PaymentCount,
    SUM(p.Amount) AS TotalAmount,
    AVG(p.Amount) AS AvgPayment
FROM Payments p
JOIN PaymentMethods pm ON p.PaymentMethodID = pm.PaymentMethodID
GROUP BY pm.MethodName
ORDER BY TotalAmount DESC;
GO
