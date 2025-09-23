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
('Иванов Иван Иванович', '+79123456789', 'Москва, ул. Ленина, д. 1, кв. 10', 'ivanov.ii@example.com'),
('Петрова Мария Сергеевна', '+79221112233', 'Москва, ул. Гагарина, д. 5, кв. 25', 'petrova.ms@example.com'),
('Сидоров Алексей Петрович', '+79334445566', 'Санкт-Петербург, Невский пр., д. 10, кв. 15', 'sidorov.ap@example.com'),
('Кузнецова Ольга Ивановна', '+79445556677', 'Казань, ул. Баумана, д. 15, кв. 30', 'kuznecova.oi@example.com'),
('Васильев Дмитрий Владимирович', '+79556667788', 'Новосибирск, Красный пр., д. 20, кв. 5', 'vasiliev.dv@example.com'),
('Николаева Елена Александровна', '+79667778899', 'Екатеринбург, ул. Мамина-Сибиряка, д. 100, кв. 12', 'nikolaeva.ea@example.com'),
('Смирнов Сергей Николаевич', '+79778889900', 'Самара, ул. Советской Армии, д. 200, кв. 7', 'smirnov.sn@example.com');
GO

INSERT INTO Pets (Name, Type, Breed, BirthDate, OwnerID)
VALUES
('Барсик', 'Кот', 'Британская короткошерстная', '2019-05-10', 1),
('Рекс', 'Собака', 'Лабрадор', '2018-07-15', 1),
('Мурка', 'Кот', 'Сибирская', '2020-03-20', 2),
('Белка', 'Собака', 'Джек-рассел-терьер', '2021-01-05', 3),
('Лайма', 'Собака', 'Овчарка', '2017-11-12', 4),
('Том', 'Кот', 'Мейн-кун', '2019-09-18', 5),
('Лео', 'Собака', 'Такса', '2020-07-22', 2),
('Милка', 'Кот', 'Сфинкс', '2021-08-05', 3),
('Бонифаций', 'Кот', 'Персидская', '2018-06-14', 6),
('Джек', 'Собака', 'Бульдог', '2019-12-25', 7);
GO

INSERT INTO Doctors (FullName, Specialization, Phone)
VALUES
('Алексеев Алексей Алексеевич', 'Терапевт', '+79111112233'),
('Борисова Ольга Петровна', 'Хирург', '+79222223344'),
('Викторов Виктор Викторович', 'Дерматолог', '+79333334455'),
('Галина Сергеевна Петрова', 'Кардиолог', '+79444445566'),
('Дмитриев Дмитрий Дмитриевич', 'Стоматолог', '+79555556677'),
('Егорова Елена Владимировна', 'Офтальмолог', '+79666667788'),
('Жуков Сергей Иванович', 'Невролог', '+79777778899');
GO

INSERT INTO Visits (PetID, DoctorID, VisitDate, Diagnosis, Treatment)
VALUES
(1, 1, '2023-09-01', 'Профилактический осмотр', 'Витамины'),
(2, 2, '2023-09-02', 'Перелом лапы', 'Гипс'),
(3, 1, '2023-09-03', 'Аллергия', 'Антигистаминные препараты'),
(4, 3, '2023-09-04', 'Дерматит', 'Мази и шампуни'),
(5, 4, '2023-09-05', 'Сердечная недостаточность', 'Сердечные препараты'),
(6, 1, '2023-09-06', 'Профилактический осмотр', 'Витамины'),
(7, 5, '2023-09-07', 'Зубной камень', 'Чистка зубов'),
(8, 2, '2023-09-08', 'Ушиб', 'Обезболивающие препараты'),
(9, 6, '2023-09-09', 'Конъюнктивит', 'Глазные капли'),
(10, 7, '2023-09-10', 'Неврологические нарушения', 'Седативные препараты'),
(1, 1, '2023-10-01', 'Вакцинация', 'Прививка'),
(3, 3, '2023-10-02', 'Выпадение шерсти', 'Витаминные добавки'),
(5, 4, '2023-10-03', 'Повторный осмотр', 'Контроль состояния'),
(7, 5, '2023-10-04', 'Повторная чистка зубов', 'Профилактика'),
(9, 1, '2023-10-05', 'Профилактический осмотр', 'Витамины');
GO
