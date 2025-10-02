USE master;
GO

-- Удаление базы данных, если она существует
IF DB_ID('VetClinicDB') IS NOT NULL
    DROP DATABASE VetClinicDB;
GO

-- Создание базы данных
CREATE DATABASE VetClinicDB;
GO

USE VetClinicDB;
GO

-- Создание денормализованной таблицы приемов в ветеринарной клинике
CREATE TABLE Appointments_Denormalized (
    AppointmentID INT IDENTITY(1,1) PRIMARY KEY,
    OwnerInfo NVARCHAR(200),            -- ФИО, телефон, email, адрес владельца
    PetInfo NVARCHAR(200),              -- Кличка, вид, порода, возраст, вес животного
    VetInfo NVARCHAR(150),              -- ФИО, специализация ветеринара
    AppointmentDate DATETIME,           -- Дата и время приема
    Diagnosis NVARCHAR(200),            -- Диагноз
    Treatment NVARCHAR(500),            -- Назначенное лечение, процедуры, лекарства
    TreatmentCost DECIMAL(10, 2),       -- Стоимость лечения
    Vaccinations NVARCHAR(300),         -- Сделанные прививки с датами
    NextVisitDate DATETIME,             -- Дата следующего визита
    PaymentInfo NVARCHAR(150)           -- Способ оплаты, сумма, дата оплаты
);
GO

-- Заполнение денормализованной таблицы данными
INSERT INTO Appointments_Denormalized (
    OwnerInfo, PetInfo, VetInfo, AppointmentDate,
    Diagnosis, Treatment, TreatmentCost, Vaccinations, NextVisitDate, PaymentInfo
)
VALUES
('Иванов Петр Сергеевич; +79123456789; ivanov@mail.ru; г. Москва, ул. Ленина, д.10, кв.15',
 'Барсик; Кошка; Персидская; 3 года; 4.5 кг',
 'Петрова Анна Васильевна; Терапевт, Хирург',
 '2023-11-10 10:00:00',
 'Гастрит, Аллергия на корм',
 'Диета: Royal Canin Gastrointestinal, Таблетки: Фортфлора 1т*2р/день 10 дней, Уколы: Вит.B12 1мл*3 дня',
 3500.00,
 'Чумка: 2022-05-15; Бешенство: 2022-06-20; Лейкоз: 2023-01-10',
 '2023-11-20 10:00:00',
 'Банковская карта; 3500.00; 2023-11-10'),

('Смирнова Мария Ивановна; +79234567890; smirnova@mail.ru; г. Санкт-Петербург, Невский пр., д.5, кв.42',
 'Рекс; Собака; Немецкая овчарка; 5 лет; 35 кг',
 'Сидоров Дмитрий Александрович; Ортопед, Невролог',
 '2023-11-10 14:30:00',
 'Артрит задних лап, Дисплазия тазобедренных суставов',
 'Уколы: Мелоксикам 0.1мл*5 дней, Таблетки: Кондронова 1т*2р/день 30 дней, Массаж: 10 сеансов',
 7200.00,
 'Чумка: 2021-03-10; Бешенство: 2021-04-15; Лептоспироз: 2022-03-20; Коронавирус: 2022-04-05',
 '2023-11-24 14:30:00',
 'Наличные; 7200.00; 2023-11-10'),

('Петров Алексей Владимирович; +79345678901; petrov@mail.ru; г. Екатеринбург, ул. Мамина-Сибиряка, д.120, кв.7',
 'Кеша; Попугай; Ара; 10 лет; 0.4 кг',
 'Васильева Ольга Петровна; Орнитолог, Терапевт',
 '2023-11-11 11:00:00',
 'Авитаминоз, Выпадение перьев',
 'Витамины: Гамавит 0.2мл*7 дней, Корм: Специальный корм для ар, Ванны: 5 процедур',
 2800.00,
 'Ньюкасл: 2021-05-10; Орнитоз: 2021-06-15',
 '2023-11-25 11:00:00',
 'Электронные деньги; 2800.00; 2023-11-11'),

('Козлова Елена Сергеевна; +79456789012; kozlova@mail.ru; г. Новосибирск, ул. Красный проспект, д.85, кв.112',
 'Мурзик; Кошка; Британская; 1 год; 3.8 кг',
 'Новиков Иван Михайлович; Дерматолог, Аллерголог',
 '2023-11-11 16:00:00',
 'Дерматит, Аллергия на пыль',
 'Уколы: Дексафорт 0.5мл*3 дня, Шампунь: Антисептический 5 применений, Таблетки: Супрастин 1/4т*7 дней',
 4100.00,
 'Чумка: 2023-02-15; Бешенство: 2023-03-20',
 '2023-12-01 16:00:00',
 'Банковская карта; 4100.00; 2023-11-11'),

('Михайлова Ольга Дмитриевна; +79567890123; mihailova@example.com; г. Казань, ул. Баумана, д.25, кв.33',
 'Бобик; Собака; Лабрадор; 2 года; 28 кг',
 'Петрова Светлана Ивановна; Кардиолог, УЗИ-специалист',
 '2023-11-12 09:30:00',
 'Порок сердца, Ожирение',
 'Диета: Royal Canin Cardiac, Таблетки: Кардикет 1/2т*2р/день, УЗИ сердца: 1 процедура, Анализы: биохимия крови',
 8500.00,
 'Чумка: 2022-04-10; Бешенство: 2022-05-15; Лептоспироз: 2022-06-20',
 '2023-12-12 09:30:00',
 'Наличные; 8500.00; 2023-11-12');
GO

-- Просмотр денормализованных данных
PRINT 'Денормализованная таблица Appointments_Denormalized:';
GO
SELECT * FROM Appointments_Denormalized;
GO

/***********************************************************************
* ЭТАП 2: ПРИВЕДЕНИЕ К 1НФ
* Нарушения 1НФ:
* 1. Составные значения в OwnerInfo, PetInfo, VetInfo, Vaccinations, PaymentInfo
* 2. Повторяющиеся группы в Treatment, Vaccinations
* 3. Неатомарные значения в нескольких полях
***********************************************************************/

-- Создание таблицы в 1НФ
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

-- Заполнение таблицы в 1НФ (разбиваем составные значения)
-- Прием 1 - Барсик
INSERT INTO Appointments_1NF (
    AppointmentID, OwnerFName, OwnerMName, OwnerLName, OwnerPhone, OwnerEmail, OwnerAddress,
    PetName, PetSpecies, PetBreed, PetAge, PetWeight,
    VetFName, VetMName, VetLName, VetSpecialization, AppointmentDate, Diagnosis,
    TreatmentItem, TreatmentCost, VaccineName, VaccineDate, NextVisitDate,
    PaymentMethod, PaymentAmount, PaymentDate
)
SELECT 1, 'Петр', 'Сергеевич', 'Иванов', '+79123456789', 'ivanov@mail.ru', 'г. Москва, ул. Ленина, д.10, кв.15',
       'Барсик', 'Кошка', 'Персидская', '3 года', 4.5,
       'Анна', 'Васильевна', 'Петрова', 'Терапевт, Хирург', '2023-11-10 10:00:00', 'Гастрит, Аллергия на корм',
       'Диета: Royal Canin Gastrointestinal', 3500.00, 'Чумка', '2022-05-15', '2023-11-20 10:00:00',
       'Банковская карта', 3500.00, '2023-11-10'
UNION ALL
SELECT 1, 'Петр', 'Сергеевич', 'Иванов', '+79123456789', 'ivanov@mail.ru', 'г. Москва, ул. Ленина, д.10, кв.15',
       'Барсик', 'Кошка', 'Персидская', '3 года', 4.5,
       'Анна', 'Васильевна', 'Петрова', 'Терапевт, Хирург', '2023-11-10 10:00:00', 'Гастрит, Аллергия на корм',
       'Таблетки: Фортфлора 1т*2р/день 10 дней', 3500.00, 'Бешенство', '2022-06-20', '2023-11-20 10:00:00',
       'Банковская карта', 3500.00, '2023-11-10'
UNION ALL
SELECT 1, 'Петр', 'Сергеевич', 'Иванов', '+79123456789', 'ivanov@mail.ru', 'г. Москва, ул. Ленина, д.10, кв.15',
       'Барсик', 'Кошка', 'Персидская', '3 года', 4.5,
       'Анна', 'Васильевна', 'Петрова', 'Терапевт, Хирург', '2023-11-10 10:00:00', 'Гастрит, Аллергия на корм',
       'Уколы: Вит.B12 1мл*3 дня', 3500.00, 'Лейкоз', '2023-01-10', '2023-11-20 10:00:00',
       'Банковская карта', 3500.00, '2023-11-10'

-- Прием 2 - Рекс
UNION ALL
SELECT 2, 'Мария', 'Ивановна', 'Смирнова', '+79234567890', 'smirnova@mail.ru', 'г. Санкт-Петербург, Невский пр., д.5, кв.42',
       'Рекс', 'Собака', 'Немецкая овчарка', '5 лет', 35.0,
       'Дмитрий', 'Александрович', 'Сидоров', 'Ортопед, Невролог', '2023-11-10 14:30:00', 'Артрит задних лап, Дисплазия тазобедренных суставов',
       'Уколы: Мелоксикам 0.1мл*5 дней', 7200.00, 'Чумка', '2021-03-10', '2023-11-24 14:30:00',
       'Наличные', 7200.00, '2023-11-10'
UNION ALL
SELECT 2, 'Мария', 'Ивановна', 'Смирнова', '+79234567890', 'smirnova@mail.ru', 'г. Санкт-Петербург, Невский пр., д.5, кв.42',
       'Рекс', 'Собака', 'Немецкая овчарка', '5 лет', 35.0,
       'Дмитрий', 'Александрович', 'Сидоров', 'Ортопед, Невролог', '2023-11-10 14:30:00', 'Артрит задних лап, Дисплазия тазобедренных суставов',
       'Таблетки: Кондронова 1т*2р/день 30 дней', 7200.00, 'Бешенство', '2021-04-15', '2023-11-24 14:30:00',
       'Наличные', 7200.00, '2023-11-10'
UNION ALL
SELECT 2, 'Мария', 'Ивановна', 'Смирнова', '+79234567890', 'smirnova@mail.ru', 'г. Санкт-Петербург, Невский пр., д.5, кв.42',
       'Рекс', 'Собака', 'Немецкая овчарка', '5 лет', 35.0,
       'Дмитрий', 'Александрович', 'Сидоров', 'Ортопед, Невролог', '2023-11-10 14:30:00', 'Артрит задних лап, Дисплазия тазобедренных суставов',
       'Массаж: 10 сеансов', 7200.00, 'Лептоспироз', '2022-03-20', '2023-11-24 14:30:00',
       'Наличные', 7200.00, '2023-11-10'
UNION ALL
SELECT 2, 'Мария', 'Ивановна', 'Смирнова', '+79234567890', 'smirnova@mail.ru', 'г. Санкт-Петербург, Невский пр., д.5, кв.42',
       'Рекс', 'Собака', 'Немецкая овчарка', '5 лет', 35.0,
       'Дмитрий', 'Александрович', 'Сидоров', 'Ортопед, Невролог', '2023-11-10 14:30:00', 'Артрит задних лап, Дисплазия тазобедренных суставов',
       NULL, 7200.00, 'Коронавирус', '2022-04-05', '2023-11-24 14:30:00',
       'Наличные', 7200.00, '2023-11-10'

-- Прием 3 - Кеша
UNION ALL
SELECT 3, 'Алексей', 'Владимирович', 'Петров', '+79345678901', 'petrov@mail.ru', 'г. Екатеринбург, ул. Мамина-Сибиряка, д.120, кв.7',
       'Кеша', 'Попугай', 'Ара', '10 лет', 0.4,
       'Ольга', 'Петровна', 'Васильева', 'Орнитолог, Терапевт', '2023-11-11 11:00:00', 'Авитаминоз, Выпадение перьев',
       'Витамины: Гамавит 0.2мл*7 дней', 2800.00, 'Ньюкасл', '2021-05-10', '2023-11-25 11:00:00',
       'Электронные деньги', 2800.00, '2023-11-11'
UNION ALL
SELECT 3, 'Алексей', 'Владимирович', 'Петров', '+79345678901', 'petrov@mail.ru', 'г. Екатеринбург, ул. Мамина-Сибиряка, д.120, кв.7',
       'Кеша', 'Попугай', 'Ара', '10 лет', 0.4,
       'Ольга', 'Петровна', 'Васильева', 'Орнитолог, Терапевт', '2023-11-11 11:00:00', 'Авитаминоз, Выпадение перьев',
       'Корм: Специальный корм для ар', 2800.00, 'Орнитоз', '2021-06-15', '2023-11-25 11:00:00',
       'Электронные деньги', 2800.00, '2023-11-11'
UNION ALL
SELECT 3, 'Алексей', 'Владимирович', 'Петров', '+79345678901', 'petrov@mail.ru', 'г. Екатеринбург, ул. Мамина-Сибиряка, д.120, кв.7',
       'Кеша', 'Попугай', 'Ара', '10 лет', 0.4,
       'Ольга', 'Петровна', 'Васильева', 'Орнитолог, Терапевт', '2023-11-11 11:00:00', 'Авитаминоз, Выпадение перьев',
       'Ванны: 5 процедур', 2800.00, NULL, NULL, '2023-11-25 11:00:00',
       'Электронные деньги', 2800.00, '2023-11-11'

-- Прием 4 - Мурзик
UNION ALL
SELECT 4, 'Елена', 'Сергеевна', 'Козлова', '+79456789012', 'kozlova@mail.ru', 'г. Новосибирск, ул. Красный проспект, д.85, кв.112',
       'Мурзик', 'Кошка', 'Британская', '1 год', 3.8,
       'Иван', 'Михайлович', 'Новиков', 'Дерматолог, Аллерголог', '2023-11-11 16:00:00', 'Дерматит, Аллергия на пыль',
       'Уколы: Дексафорт 0.5мл*3 дня', 4100.00, 'Чумка', '2023-02-15', '2023-12-01 16:00:00',
       'Банковская карта', 4100.00, '2023-11-11'
UNION ALL
SELECT 4, 'Елена', 'Сергеевна', 'Козлова', '+79456789012', 'kozlova@mail.ru', 'г. Новосибирск, ул. Красный проспект, д.85, кв.112',
       'Мурзик', 'Кошка', 'Британская', '1 год', 3.8,
       'Иван', 'Михайлович', 'Новиков', 'Дерматолог, Аллерголог', '2023-11-11 16:00:00', 'Дерматит, Аллергия на пыль',
       'Шампунь: Антисептический 5 применений', 4100.00, 'Бешенство', '2023-03-20', '2023-12-01 16:00:00',
       'Банковская карта', 4100.00, '2023-11-11'
UNION ALL
SELECT 4, 'Елена', 'Сергеевна', 'Козлова', '+79456789012', 'kozlova@mail.ru', 'г. Новосибирск, ул. Красный проспект, д.85, кв.112',
       'Мурзик', 'Кошка', 'Британская', '1 год', 3.8,
       'Иван', 'Михайлович', 'Новиков', 'Дерматолог, Аллерголог', '2023-11-11 16:00:00', 'Дерматит, Аллергия на пыль',
       'Таблетки: Супрастин 1/4т*7 дней', 4100.00, NULL, NULL, '2023-12-01 16:00:00',
       'Банковская карта', 4100.00, '2023-11-11'

-- Прием 5 - Бобик
UNION ALL
SELECT 5, 'Ольга', 'Михайловна', 'Михайлова', '+79567890123', 'mihailova@example.com', 'г. Казань, ул. Баумана, д.25, кв.33',
       'Бобик', 'Собака', 'Лабрадор', '2 года', 28.0,
       'Светлана', 'Ивановна', 'Петрова', 'Кардиолог, УЗИ-специалист', '2023-11-12 09:30:00', 'Порок сердца, Ожирение',
       'Диета: Royal Canin Cardiac', 8500.00, 'Чумка', '2022-04-10', '2023-12-12 09:30:00',
       'Наличные', 8500.00, '2023-11-12'
UNION ALL
SELECT 5, 'Ольга', 'Михайловна', 'Михайлова', '+79567890123', 'mihailova@example.com', 'г. Казань, ул. Баумана, д.25, кв.33',
       'Бобик', 'Собака', 'Лабрадор', '2 года', 28.0,
       'Светлана', 'Ивановна', 'Петрова', 'Кардиолог, УЗИ-специалист', '2023-11-12 09:30:00', 'Порок сердца, Ожирение',
       'Таблетки: Кардикет 1/2т*2р/день', 8500.00, 'Бешенство', '2022-05-15', '2023-12-12 09:30:00',
       'Наличные', 8500.00, '2023-11-12'
UNION ALL
SELECT 5, 'Ольга', 'Михайловна', 'Михайлова', '+79567890123', 'mihailova@example.com', 'г. Казань, ул. Баумана, д.25, кв.33',
       'Бобик', 'Собака', 'Лабрадор', '2 года', 28.0,
       'Светлана', 'Ивановна', 'Петрова', 'Кардиолог, УЗИ-специалист', '2023-11-12 09:30:00', 'Порок сердца, Ожирение',
       'УЗИ сердца: 1 процедура', 8500.00, 'Лептоспироз', '2022-06-20', '2023-12-12 09:30:00',
       'Наличные', 8500.00, '2023-11-12'
UNION ALL
SELECT 5, 'Ольга', 'Михайловна', 'Михайлова', '+79567890123', 'mihailova@example.com', 'г. Казань, ул. Баумана, д.25, кв.33',
       'Бобик', 'Собака', 'Лабрадор', '2 года', 28.0,
       'Светлана', 'Ивановна', 'Петрова', 'Кардиолог, УЗИ-специалист', '2023-11-12 09:30:00', 'Порок сердца, Ожирение',
       'Анализы: биохимия крови', 8500.00, NULL, NULL, '2023-12-12 09:30:00',
       'Наличные', 8500.00, '2023-11-12';
GO

-- Просмотр данных в 1НФ
PRINT 'Таблица в 1НФ Appointments_1NF:';
GO
SELECT * FROM Appointments_1NF;
GO

-- Создание справочных таблиц

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

-- 3. Владельцы
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

-- 4. Животные
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

-- 5. Ветеринары
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

-- 7. Связь ветеринаров и специализаций (многие ко многим)
CREATE TABLE VetSpecializationLink (
    VetID INT NOT NULL,
    SpecializationID INT NOT NULL,
    PRIMARY KEY (VetID, SpecializationID),
    FOREIGN KEY (VetID) REFERENCES Vets(VetID),
    FOREIGN KEY (SpecializationID) REFERENCES VetSpecializations(SpecializationID)
);
GO

-- 8. Приемы
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

-- 9. Лечение
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

-- 11. Связь лечения и типов лечения
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
    ValidityPeriod INT  -- в месяцах
);
GO

-- 13. Вакцинации
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

-- 14. Способы оплаты
CREATE TABLE PaymentMethods (
    PaymentMethodID INT IDENTITY(1,1) PRIMARY KEY,
    MethodName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 15. Платежи
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

-- Заполнение справочных таблиц

-- 1. Виды животных
INSERT INTO AnimalSpecies (SpeciesName, Description)
VALUES
('Кошка', 'Домашние кошки'),
('Собака', 'Домашние собаки'),
('Попугай', 'Домашние попугаи'),
('Хомяк', 'Домашние хомяки'),
('Кролик', 'Домашние кролики');
GO

-- Вывод данных из AnimalSpecies
PRINT 'Таблица AnimalSpecies:';
GO
SELECT * FROM AnimalSpecies;
GO

-- 2. Породы животных
INSERT INTO AnimalBreeds (SpeciesID, BreedName, Description)
VALUES
(1, 'Персидская', 'Длинношерстная порода кошек'),
(1, 'Британская', 'Короткошерстная порода кошек'),
(2, 'Немецкая овчарка', 'Служебная порода собак'),
(2, 'Лабрадор', 'Охотничья порода собак'),
(3, 'Ара', 'Крупные попугаи'),
(3, 'Волнистый', 'Мелкие попугаи');
GO

-- Вывод данных из AnimalBreeds
PRINT 'Таблица AnimalBreeds:';
GO
SELECT * FROM AnimalBreeds;
GO

-- 3. Специализации ветеринаров
INSERT INTO VetSpecializations (SpecializationName, Description)
VALUES
('Терапевт', 'Общая терапия животных'),
('Хирург', 'Хирургические операции'),
('Ортопед', 'Лечение опорно-двигательного аппарата'),
('Невролог', 'Лечение нервной системы'),
('Орнитолог', 'Специалист по птицам'),
('Дерматолог', 'Лечение кожных заболеваний'),
('Аллерголог', 'Лечение аллергических реакций'),
('Кардиолог', 'Лечение сердечно-сосудистых заболеваний'),
('УЗИ-специалист', 'Проведение ультразвуковых исследований');
GO

-- Вывод данных из VetSpecializations
PRINT 'Таблица VetSpecializations:';
GO
SELECT * FROM VetSpecializations;
GO

-- 4. Способы оплаты
INSERT INTO PaymentMethods (MethodName, Description)
VALUES
('Наличные', 'Оплата наличными в клинике'),
('Банковская карта', 'Оплата банковской картой через терминал'),
('Электронные деньги', 'Оплата через электронные платежные системы');
GO

-- Вывод данных из PaymentMethods
PRINT 'Таблица PaymentMethods:';
GO
SELECT * FROM PaymentMethods;
GO

-- 5. Типы лечения
INSERT INTO TreatmentTypes (TreatmentTypeName, Description)
VALUES
('Диета', 'Специальное питание'),
('Таблетки', 'Пероральные препараты'),
('Уколы', 'Инъекции'),
('Массаж', 'Массажные процедуры'),
('Витамины', 'Витаминные добавки'),
('Корм', 'Специальный корм'),
('Ванны', 'Водные процедуры'),
('Шампунь', 'Наружные средства'),
('УЗИ', 'Ультразвуковое исследование'),
('Анализы', 'Лабораторные анализы');
GO

-- Вывод данных из TreatmentTypes
PRINT 'Таблица TreatmentTypes:';
GO
SELECT * FROM TreatmentTypes;
GO

-- 6. Вакцины
INSERT INTO Vaccines (VaccineName, Description, ValidityPeriod)
VALUES
('Чумка', 'Вакцина против чумы плотоядных', 12),
('Бешенство', 'Вакцина против бешенства', 12),
('Лейкоз', 'Вакцина против лейкоза кошек', 12),
('Лептоспироз', 'Вакцина против лептоспироза', 12),
('Коронавирус', 'Вакцина против коронавируса собак', 12),
('Ньюкасл', 'Вакцина против болезни Ньюкасла', 12),
('Орнитоз', 'Вакцина против орнитоза', 12);
GO

-- Вывод данных из Vaccines
PRINT 'Таблица Vaccines:';
GO
SELECT * FROM Vaccines;
GO

-- 7. Владельцы
INSERT INTO Owners (FName, MName, LName, Phone, Email, Address)
VALUES
('Петр', 'Сергеевич', 'Иванов', '+79123456789', 'ivanov@mail.ru', 'г. Москва, ул. Ленина, д.10, кв.15'),
('Мария', 'Ивановна', 'Смирнова', '+79234567890', 'smirnova@mail.ru', 'г. Санкт-Петербург, Невский пр., д.5, кв.42'),
('Алексей', 'Владимирович', 'Петров', '+79345678901', 'petrov@mail.ru', 'г. Екатеринбург, ул. Мамина-Сибиряка, д.120, кв.7'),
('Елена', 'Сергеевна', 'Козлова', '+79456789012', 'kozlova@mail.ru', 'г. Новосибирск, ул. Красный проспект, д.85, кв.112'),
('Ольга', 'Михайловна', 'Михайлова', '+79567890123', 'mihailova@example.com', 'г. Казань, ул. Баумана, д.25, кв.33');
GO

-- Вывод данных из Owners
PRINT 'Таблица Owners:';
GO
SELECT * FROM Owners;
GO

-- 8. Животные
INSERT INTO Pets (OwnerID, Name, SpeciesID, BreedID, Age, Weight, BirthDate)
VALUES
(1, 'Барсик', 1, 1, 3, 4.5, DATEADD(YEAR, -3, GETDATE())),
(2, 'Рекс', 2, 3, 5, 35.0, DATEADD(YEAR, -5, GETDATE())),
(3, 'Кеша', 3, 5, 10, 0.4, DATEADD(YEAR, -10, GETDATE())),
(4, 'Мурзик', 1, 2, 1, 1, 3.8, DATEADD(YEAR, -1, GETDATE())),
(5, 'Бобик', 2, 4, 2, 28.0, DATEADD(YEAR, -2, GETDATE()));
GO

-- Вывод данных из Pets
PRINT 'Таблица Pets:';
GO
SELECT * FROM Pets;
GO

-- 9. Ветеринары
INSERT INTO Vets (FName, MName, LName, Specialization, HireDate, Salary)
VALUES
('Анна', 'Васильевна', 'Петрова', 'Терапевт, Хирург', '2018-05-10', 45000.00),
('Дмитрий', 'Александрович', 'Сидоров', 'Ортопед, Невролог', '2019-03-15', 50000.00),
('Ольга', 'Петровна', 'Васильева', 'Орнитолог, Терапевт', '2017-11-20', 48000.00),
('Иван', 'Михайлович', 'Новиков', 'Дерматолог, Аллерголог', '2020-01-05', 42000.00),
('Светлана', 'Ивановна', 'Петрова', 'Кардиолог, УЗИ-специалист', '2016-09-12', 55000.00);
GO

-- Вывод данных из Vets
PRINT 'Таблица Vets:';
GO
SELECT * FROM Vets;
GO

-- 10. Связь ветеринаров и специализаций
INSERT INTO VetSpecializationLink (VetID, SpecializationID)
VALUES
(1, 1), (1, 2),  -- Петрова: Терапевт, Хирург
(2, 3), (2, 4),  -- Сидоров: Ортопед, Невролог
(3, 5), (3, 1),  -- Васильева: Орнитолог, Терапевт
(4, 6), (4, 7),  -- Новиков: Дерматолог, Аллерголог
(5, 8), (5, 9);  -- Петрова: Кардиолог, УЗИ-специалист
GO

-- Вывод данных из VetSpecializationLink
PRINT 'Таблица VetSpecializationLink:';
GO
SELECT * FROM VetSpecializationLink;
GO

-- 11. Приемы
INSERT INTO Appointments (PetID, VetID, AppointmentDate, Diagnosis, NextVisitDate)
VALUES
(1, 1, '2023-11-10 10:00:00', 'Гастрит, Аллергия на корм', '2023-11-20 10:00:00'),
(2, 2, '2023-11-10 14:30:00', 'Артрит задних лап, Дисплазия тазобедренных суставов', '2023-11-24 14:30:00'),
(3, 3, '2023-11-11 11:00:00', 'Авитаминоз, Выпадение перьев', '2023-11-25 11:00:00'),
(4, 4, '2023-11-11 16:00:00', 'Дерматит, Аллергия на пыль', '2023-12-01 16:00:00'),
(5, 5, '2023-11-12 09:30:00', 'Порок сердца, Ожирение', '2023-12-12 09:30:00');
GO

-- Вывод данных из Appointments
PRINT 'Таблица Appointments:';
GO
SELECT * FROM Appointments;
GO

-- 12. Лечение
INSERT INTO Treatments (AppointmentID, TreatmentDescription, Cost)
VALUES
(1, 'Диета: Royal Canin Gastrointestinal', 1500.00),
(1, 'Таблетки: Фортфлора 1т*2р/день 10 дней', 1000.00),
(1, 'Уколы: Вит.B12 1мл*3 дня', 1000.00),
(2, 'Уколы: Мелоксикам 0.1мл*5 дней', 2500.00),
(2, 'Таблетки: Кондронова 1т*2р/день 30 дней', 3000.00),
(2, 'Массаж: 10 сеансов', 1700.00),
(3, 'Витамины: Гамавит 0.2мл*7 дней', 800.00),
(3, 'Корм: Специальный корм для ар', 1200.00),
(3, 'Ванны: 5 процедур', 800.00),
(4, 'Уколы: Дексафорт 0.5мл*3 дня', 1500.00),
(4, 'Шампунь: Антисептический 5 применений', 1200.00),
(4, 'Таблетки: Супрастин 1/4т*7 дней', 600.00),
(5, 'Диета: Royal Canin Cardiac', 2000.00),
(5, 'Таблетки: Кардикет 1/2т*2р/день', 3000.00),
(5, 'УЗИ сердца: 1 процедура', 2000.00),
(5, 'Анализы: биохимия крови', 1500.00);
GO

-- Вывод данных из Treatments
PRINT 'Таблица Treatments:';
GO
SELECT * FROM Treatments;
GO

-- 13. Связь лечения и типов лечения
INSERT INTO TreatmentTypeLink (TreatmentID, TreatmentTypeID)
VALUES
(1, 1), (2, 2), (3, 3), (4, 3), (5, 2), (6, 4), (7, 5), (8, 6), (9, 7),
(10, 9), (11, 2), (12, 10), (13, 11);
GO

-- Вывод данных из TreatmentTypeLink
PRINT 'Таблица TreatmentTypeLink:';
GO
SELECT * FROM TreatmentTypeLink;
GO

-- 14. Вакцинации
INSERT INTO Vaccinations (PetID, VaccineID, VaccinationDate, NextVaccinationDate)
VALUES
(1, 1, '2022-05-15', '2023-05-15'),  -- Барсик, Чумка
(1, 2, '2022-06-20', '2023-06-20'),  -- Барсик, Бешенство
(1, 3, '2023-01-10', '2024-01-10'),  -- Барсик, Лейкоз
(2, 1, '2021-03-10', '2022-03-10'),  -- Рекс, Чумка
(2, 2, '2021-04-15', '2022-04-15'),  -- Рекс, Бешенство
(2, 4, '2022-03-20', '2023-03-20'),  -- Рекс, Лептоспироз
(2, 5, '2022-04-05', '2023-04-05'),  -- Рекс, Коронавирус
(3, 6, '2021-05-10', '2022-05-10'),  -- Кеша, Ньюкасл
(3, 7, '2021-06-15', '2022-06-15'),  -- Кеша, Орнитоз
(4, 1, '2023-02-15', '2024-02-15'),  -- Мурзик, Чумка
(4, 2, '2023-03-20', '2024-03-20'),  -- Мурзик, Бешенство
(5, 1, '2022-04-10', '2023-04-10'),  -- Бобик, Чумка
(5, 2, '2022-05-15', '2023-05-15'),  -- Бобик, Бешенство
(5, 4, '2022-06-20', '2023-06-20');  -- Бобик, Лептоспироз
GO

-- Вывод данных из Vaccinations
PRINT 'Таблица Vaccinations:';
GO
SELECT * FROM Vaccinations;
GO

-- 15. Платежи
INSERT INTO Payments (AppointmentID, PaymentMethodID, PaymentDate, Amount, Description)
VALUES
(1, 2, '2023-11-10 10:15:00', 3500.00, 'Оплата приема Барсика'),
(2, 1, '2023-11-10 14:45:00', 7200.00, 'Оплата приема Рекса'),
(3, 3, '2023-11-11 11:15:00', 2800.00, 'Оплата приема Кеши'),
(4, 2, '2023-11-11 16:15:00', 4100.00, 'Оплата приема Мурзика'),
(5, 1, '2023-11-12 09:45:00', 8500.00, 'Оплата приема Бобика');
GO

-- Вывод данных из Payments
PRINT 'Таблица Payments:';
GO
SELECT * FROM Payments;
GO

-- Продолжение контрольных запросов

-- 1. Восстановление исходного представления (исправленный запрос)
PRINT '1. Восстановление исходного представления (исправленный):';
GO

SELECT
    a.AppointmentID,
    CONCAT(o.FName, ' ', o.MName, ' ', o.LName, '; ', o.Phone, '; ', o.Email, '; ', o.Address) AS OwnerInfo,
    CONCAT(p.Name, '; ', s.SpeciesName, '; ', b.BreedName, '; ', p.Age, ' лет; ', p.Weight, ' кг') AS PetInfo,
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

-- Исправленный запрос 2 с использованием CTE
PRINT '2. Популярность специализаций ветеринаров:';
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

-- 3. Статистика по видам животных
PRINT '3. Статистика по видам животных:';
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

-- 4. Анализ вакцинаций
PRINT '4. Анализ вакцинаций:';
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

-- 5. Популярные породы животных
PRINT '5. Популярные породы животных:';
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

-- 6. Анализ лечения по типам
PRINT '6. Анализ лечения по типам:';
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

-- 7. Активность владельцев
PRINT '7. Активность владельцев:';
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

-- 8. Загруженность ветеринаров
PRINT '8. Загруженность ветеринаров:';
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

-- Исправленный запрос 8 с использованием CTE
PRINT '8. Загруженность ветеринаров (исправленный):';
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

-- 9. Демографический анализ животных
PRINT '9. Демографический анализ животных:';
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

-- 10. Анализ платежей по способам оплаты
PRINT '10. Анализ платежей по способам оплаты:';
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
