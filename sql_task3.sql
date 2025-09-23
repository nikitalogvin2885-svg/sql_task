USE VashDom;
GO

CREATE TABLE Clients (
    ClientID int PRIMARY KEY IDENTITY(1,1),
    FullName nvarchar(100) NOT NULL,
    Phone nvarchar(15) NOT NULL,
    Email nvarchar(100),
    ClientType nvarchar(10) NOT NULL CHECK (ClientType IN ('Покупатель', 'Арендатор')),
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
    Type nvarchar(50) NOT NULL CHECK (Type IN ('Квартира', 'Дом', 'Коммерческая', 'Земля')),
    Area decimal(10, 2) NOT NULL CHECK (Area > 0),
    Price decimal(18, 2) NOT NULL CHECK (Price > 0),
    Rooms int CHECK (Rooms > 0),
    Description nvarchar(500),
    Status nvarchar(20) NOT NULL CHECK (Status IN ('Продажа', 'Аренда', 'Продано', 'Снято с продажи')),
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
('Иванов Иван Иванович', '+79123456789', 'ivanov.ii@example.com', 'Покупатель', '2023-01-10'),
('Петрова Мария Сергеевна', '+79221112233', 'petrova.ms@example.com', 'Арендатор', '2023-02-15'),
('Сидоров Алексей Петрович', '+79334445566', 'sidorov.ap@example.com', 'Покупатель', '2023-03-20'),
('Кузнецова Ольга Ивановна', '+79445556677', 'kuznecova.oi@example.com', 'Арендатор', '2023-04-05'),
('Васильев Дмитрий Владимирович', '+79556667788', 'vasiliev.dv@example.com', 'Покупатель', '2023-05-12'),
('Новикова Анна Александровна', '+79667778899', 'novikova.aa@example.com', 'Арендатор', '2023-06-18'),
('Смирнов Сергей Николаевич', '+79778889900', 'smirnov.sn@example.com', 'Покупатель', '2023-07-22'),
('Алексеева Елена Викторовна', '+79889990011', 'alekseeva.ev@example.com', 'Арендатор', '2023-08-05'),
('Козлов Андрей Михайлович', '+79991112233', 'kozlov.am@example.com', 'Покупатель', '2023-09-10'),
('Морозова Ирина Петровна', '+79102223344', 'morozova.ip@example.com', 'Арендатор', '2023-10-15');
GO

INSERT INTO Realtors (FullName, Phone, Email, ExperienceYears, LicenseNumber)
VALUES
('Алексеев Алексей Алексеевич', '+79111112233', 'alekseev.aa@example.com', 5, 'Л001000001'),
('Борисова Ольга Петровна', '+79222223344', 'borisova.op@example.com', 7, 'Л001000002'),
('Викторов Виктор Викторович', '+79333334455', 'viktorov.vv@example.com', 3, 'Л001000003'),
('Галина Сергеевна Петрова', '+79444445566', 'petrova.gs@example.com', 10, 'Л001000004'),
('Дмитриев Дмитрий Дмитриевич', '+79555556677', 'dmitriev.dd@example.com', 4, 'Л001000005');
GO

INSERT INTO Properties (Address, Type, Area, Price, Rooms, Description, Status, RealtorID)
VALUES
('Москва, ул. Ленина, д. 10, кв. 5', 'Квартира', 65.50, 8500000.00, 2, 'Двухкомнатная квартира в центре города', 'Продажа', 1),
('Москва, ул. Гагарина, д. 25, кв. 12', 'Квартира', 85.30, 12000000.00, 3, 'Трехкомнатная квартира с ремонтом', 'Продажа', 2),
('Подмосковье, д. Солнечное, ул. Лесная, д. 5', 'Дом', 150.00, 25000000.00, 5, 'Загородный дом с участком 10 соток', 'Продажа', 3),
('Москва, ул. Тверская, д. 15, офис 305', 'Коммерческая', 120.00, 15000000.00, 1, 'Офисное помещение в центре', 'Аренда', 4),
('Москва, ул. Садовая, д. 3, кв. 7', 'Квартира', 50.00, 6500000.00, 1, 'Однокомнатная квартира', 'Продажа', 5),
('Москва, МКАД, 25 км, участок 12', 'Земля', 1000.00, 5000000.00, 0, 'Земельный участок под ИЖС', 'Продажа', 1),
('Москва, ул. Новый Арбат, д. 30, кв. 15', 'Квартира', 100.00, 20000000.00, 4, 'Элитная четырехкомнатная квартира', 'Продажа', 2),
('Москва, ул. Пресненская, д. 10, кв. 8', 'Квартира', 75.00, 10000000.00, 3, 'Трехкомнатная квартира, евроремонт', 'Аренда', 3),
('Москва, ул. Профсоюзная, д. 50, кв. 18', 'Квартира', 60.00, 7500000.00, 2, 'Двухкомнатная квартира', 'Продажа', 4),
('Москва, ул. Ломоносовская, д. 20, кв. 25', 'Квартира', 55.00, 7000000.00, 1, 'Однокомнатная квартира, хорошее состояние', 'Аренда', 5);
GO

INSERT INTO Viewings (PropertyID, ClientID, RealtorID, ViewingDate, ViewingTime, Comments)
VALUES
(1, 1, 1, '2023-10-01', '10:00:00', 'Клиенту понравилась квартира, рассматривает покупку'),
(2, 2, 2, '2023-10-01', '12:00:00', 'Клиент заинтересован, но хочет посмотреть еще варианты'),
(3, 3, 3, '2023-10-02', '11:00:00', 'Клиент готов рассматривать покупку'),
(4, 4, 4, '2023-10-02', '14:00:00', 'Клиенту подходит помещение для офиса'),
(5, 5, 5, '2023-10-03', '10:30:00', 'Клиент рассматривает покупку'),
(6, 6, 1, '2023-10-03', '15:00:00', 'Клиент заинтересован в участке'),
(7, 7, 2, '2023-10-04', '11:30:00', 'Клиенту понравилась квартира, но высокая цена'),
(8, 8, 3, '2023-10-04', '13:00:00', 'Клиент рассматривает аренду'),
(9, 9, 4, '2023-10-05', '10:00:00', 'Клиент заинтересован в покупке'),
(10, 10, 5, '2023-10-05', '12:30:00', 'Клиент рассматривает аренду'),
(1, 2, 1, '2023-10-06', '11:00:00', 'Повторный просмотр'),
(3, 5, 3, '2023-10-06', '14:30:00', 'Клиент хочет еще раз посмотреть дом'),
(5, 7, 5, '2023-10-07', '10:00:00', 'Клиент готов сделать предложение'),
(7, 1, 2, '2023-10-07', '15:00:00', 'Клиент рассматривает покупку'),
(9, 3, 4, '2023-10-08', '12:00:00', 'Клиенту понравилась квартира');
GO

SELECT * FROM Clients;
SELECT * FROM Realtors;
SELECT * FROM Properties;
SELECT * FROM Viewings;