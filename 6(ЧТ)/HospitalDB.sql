CREATE DATABASE HospitalDB;
GO
USE HospitalDB;
GO

-- Проверка существования таблиц и их удаление, если они существуют
IF OBJECT_ID('Treatments', 'U') IS NOT NULL DROP TABLE Treatments;
IF OBJECT_ID('Diagnoses', 'U') IS NOT NULL DROP TABLE Diagnoses;
IF OBJECT_ID('Patients', 'U') IS NOT NULL DROP TABLE Patients;
IF OBJECT_ID('Doctors', 'U') IS NOT NULL DROP TABLE Doctors;
IF OBJECT_ID('Wards', 'U') IS NOT NULL DROP TABLE Wards;
IF OBJECT_ID('Departments', 'U') IS NOT NULL DROP TABLE Departments;
GO

-- Таблица "Отделения"
CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(100) NOT NULL,
    HeadDoctorID INT NULL, -- Будет заполнено после создания таблицы Doctors
    Phone NVARCHAR(20),
    Floor INT
);
GO

-- Таблица "Палаты"
CREATE TABLE Wards (
    WardID INT IDENTITY(1,1) PRIMARY KEY,
    WardNumber NVARCHAR(10) NOT NULL,
    DepartmentID INT FOREIGN KEY REFERENCES Departments(DepartmentID),
    Capacity INT NOT NULL,
    CurrentOccupancy INT NOT NULL DEFAULT 0
);
GO

-- Таблица "Врачи"
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

-- Обновление таблицы Departments для добавления связи с главным врачом
ALTER TABLE Departments ADD CONSTRAINT FK_Departments_HeadDoctor 
FOREIGN KEY (HeadDoctorID) REFERENCES Doctors(DoctorID);
GO

-- Таблица "Пациенты"
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

-- Таблица "Диагнозы"
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

-- Таблица "Лечение"
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

-- Заполнение тестовыми данными: Отделения
INSERT INTO Departments (DepartmentName, Phone, Floor) VALUES
('Терапия', '+79001112233', 1),
('Хирургия', '+79002223344', 2),
('Кардиология', '+79003334455', 1),
('Неврология', '+79004445566', 3),
('Педиатрия', '+79005556677', 2);
GO

-- Заполнение тестовыми данными: Палаты
INSERT INTO Wards (WardNumber, DepartmentID, Capacity, CurrentOccupancy) VALUES
('101', 1, 4, 2),
('102', 1, 4, 3),
('201', 2, 3, 1),
('202', 2, 3, 2),
('103', 3, 2, 1),
('301', 4, 3, 2),
('203', 5, 4, 3);
GO

-- Заполнение тестовыми данными: Врачи
INSERT INTO Doctors (FirstName, LastName, Specialization, Phone, Email, HireDate, DepartmentID, Salary) VALUES
('Иван', 'Петров', 'Терапевт', '+79006667788', 'ivan.petrov@hospital.ru', '2015-03-15', 1, 80000.00),
('Мария', 'Сидорова', 'Хирург', '+79007778899', 'maria.sidorova@hospital.ru', '2018-07-20', 2, 95000.00),
('Алексей', 'Козлов', 'Кардиолог', '+79008889900', 'alexey.kozlov@hospital.ru', '2016-11-10', 3, 90000.00),
('Ольга', 'Васильева', 'Невролог', '+79009990011', 'olga.vasilyeva@hospital.ru', '2019-05-25', 4, 85000.00),
('Сергей', 'Николаев', 'Педиатр', '+79001112299', 'sergey.nikolaev@hospital.ru', '2017-09-30', 5, 82000.00),
('Елена', 'Фёдорова', 'Терапевт', '+79002223388', 'elena.fedorova@hospital.ru', '2020-01-15', 1, 75000.00);
GO

-- Обновление главных врачей отделений
UPDATE Departments SET HeadDoctorID = 1 WHERE DepartmentID = 1;
UPDATE Departments SET HeadDoctorID = 2 WHERE DepartmentID = 2;
UPDATE Departments SET HeadDoctorID = 3 WHERE DepartmentID = 3;
UPDATE Departments SET HeadDoctorID = 4 WHERE DepartmentID = 4;
UPDATE Departments SET HeadDoctorID = 5 WHERE DepartmentID = 5;
GO

-- Заполнение тестовыми данными: Пациенты
INSERT INTO Patients (FirstName, LastName, BirthDate, Gender, Phone, Address, InsurancePolicy, AdmissionDate, DischargeDate, WardID, AttendingDoctorID) VALUES
('Дмитрий', 'Иванов', '1980-05-15', 'Мужской', '+79011112233', 'ул. Ленина, д. 10', 'POL123456', '2023-10-01', NULL, 1, 1),
('Анна', 'Смирнова', '1975-12-20', 'Женский', '+79022223344', 'ул. Пушкина, д. 25', 'POL123457', '2023-10-05', NULL, 1, 6),
('Петр', 'Кузнецов', '1965-08-10', 'Мужской', '+79033334455', 'ул. Гагарина, д. 15', 'POL123458', '2023-10-10', '2023-10-25', 2, 1),
('Екатерина', 'Попова', '1990-03-30', 'Женский', '+79044445566', 'ул. Садовая, д. 8', 'POL123459', '2023-10-12', NULL, 3, 2),
('Михаил', 'Соколов', '1988-11-05', 'Мужской', '+79055556677', 'ул. Центральная, д. 30', 'POL123460', '2023-10-15', NULL, 4, 2),
('Ольга', 'Лебедева', '1972-07-18', 'Женский', '+79066667788', 'ул. Мира, д. 12', 'POL123461', '2023-10-18', NULL, 5, 3),
('Ирина', 'Новикова', '1995-01-25', 'Женский', '+79077778899', 'ул. Школьная, д. 5', 'POL123462', '2023-10-20', NULL, 6, 4),
('Александр', 'Морозов', '1983-09-14', 'Мужской', '+79088889900', 'ул. Лесная, д. 18', 'POL123463', '2023-10-22', NULL, 7, 5);
GO

-- Заполнение тестовыми данными: Диагнозы
INSERT INTO Diagnoses (PatientID, DoctorID, DiagnosisName, DiagnosisDate, Severity, Description) VALUES
(1, 1, 'Грипп', '2023-10-01', 'Средняя', 'Острая респираторная вирусная инфекция'),
(2, 6, 'Бронхит', '2023-10-05', 'Легкая', 'Воспаление бронхов'),
(3, 1, 'Пневмония', '2023-10-10', 'Тяжелая', 'Воспаление легких'),
(4, 2, 'Аппендицит', '2023-10-12', 'Средняя', 'Воспаление аппендикса'),
(5, 2, 'Холецистит', '2023-10-15', 'Средняя', 'Воспаление желчного пузыря'),
(6, 3, 'Гипертония', '2023-10-18', 'Хроническое', 'Повышенное артериальное давление'),
(7, 4, 'Мигрень', '2023-10-20', 'Хроническое', 'Сильные головные боли'),
(8, 5, 'ОРВИ', '2023-10-22', 'Легкая', 'Острая респираторная вирусная инфекция у ребенка');
GO

-- Заполнение тестовыми данными: Лечение
INSERT INTO Treatments (PatientID, DoctorID, DiagnosisID, TreatmentName, StartDate, EndDate, Dosage, Frequency, Cost, Status) VALUES
(1, 1, 1, 'Противовирусная терапия', '2023-10-01', '2023-10-10', '200 мг', '2 раза в день', 5000.00, 'Completed'),
(1, 1, 1, 'Жаропонижающие', '2023-10-01', '2023-10-05', '500 мг', '3 раза в день', 1500.00, 'Completed'),
(2, 6, 2, 'Антибиотики', '2023-10-05', NULL, '250 мг', '3 раза в день', 3000.00, 'Active'),
(3, 1, 3, 'Антибиотики широкого спектра', '2023-10-10', '2023-10-25', '500 мг', '2 раза в день', 8000.00, 'Completed'),
(4, 2, 4, 'Хирургическая операция', '2023-10-12', NULL, NULL, 'Единоразово', 25000.00, 'Active'),
(5, 2, 5, 'Противовоспалительная терапия', '2023-10-15', NULL, '400 мг', '2 раза в день', 4500.00, 'Active'),
(6, 3, 6, 'Гипотензивные препараты', '2023-10-18', NULL, '50 мг', '1 раз в день', 2000.00, 'Active'),
(7, 4, 7, 'Обезболивающие', '2023-10-20', NULL, '100 мг', 'по необходимости', 1200.00, 'Active'),
(8, 5, 8, 'Симптоматическое лечение', '2023-10-22', NULL, '10 мл', '3 раза в день', 800.00, 'Active');
GO

-- Вложенные запросы

-- 1. Скалярный подзапрос: Пациенты, чье лечение дороже средней стоимости лечения
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

-- 2. Табличный подзапрос с IN: Врачи, которые лечили пациентов с тяжелыми диагнозами
SELECT DISTINCT
    d.FirstName,
    d.LastName,
    d.Specialization
FROM Doctors d
WHERE d.DoctorID IN (
    SELECT di.DoctorID
    FROM Diagnoses di
    WHERE di.Severity = 'Тяжелая'
);
GO

-- 3. Коррелированный подзапрос: Пациенты, которые находятся в больнице дольше среднего срока
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

-- 4. EXISTS: Врачи, которые являются главными врачами отделений
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

-- Курсоры

-- 1. Курсор: Информация о пациентах и их лечении
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
    PRINT 'Пациент: ' + @FirstName + ' ' + @LastName + ', Диагноз: ' + @DiagnosisName + ', Лечение: ' + @TreatmentName + ', Стоимость: ' + CAST(@Cost AS NVARCHAR(20));
    FETCH NEXT FROM patient_cursor INTO @PatientID, @FirstName, @LastName, @DiagnosisName, @TreatmentName, @Cost;
END;

CLOSE patient_cursor;
DEALLOCATE patient_cursor;
GO

-- 2. Вложенные курсоры: Врачи и их пациенты
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
    PRINT 'Врач: ' + @DoctorFirstName + ' ' + @DoctorLastName + ', Специализация: ' + @Specialization;
    
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
        PRINT '  Пациент: ' + @PatientFirstName + ' ' + @PatientLastName + ', Диагноз: ' + @DiagnosisName;
        FETCH NEXT FROM patient_doctor_cursor INTO @PatientFirstName, @PatientLastName, @DiagnosisName;
    END;
    
    CLOSE patient_doctor_cursor;
    DEALLOCATE patient_doctor_cursor;
    
    FETCH NEXT FROM doctor_cursor INTO @DoctorID, @DoctorFirstName, @DoctorLastName, @Specialization;
END;

CLOSE doctor_cursor;
DEALLOCATE doctor_cursor;
GO

-- Создание индексов для оптимизации
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