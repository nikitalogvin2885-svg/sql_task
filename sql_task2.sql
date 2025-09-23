USE FitnessMaximum;
GO

CREATE TABLE Members (
    MemberID int PRIMARY KEY IDENTITY(1,1),
    FullName nvarchar(100) NOT NULL,
    Phone nvarchar(15) NOT NULL,
    RegistrationDate date NOT NULL DEFAULT CAST(GETDATE() AS date),
    Email nvarchar(100)
);
GO

CREATE TABLE Trainers (
    TrainerID int PRIMARY KEY IDENTITY(1,1),
    FullName nvarchar(100) NOT NULL,
    Specialization nvarchar(50) NOT NULL,
    Rate decimal(10, 2) NOT NULL CHECK (Rate > 0)
);
GO

CREATE TABLE Memberships (
    MembershipID int PRIMARY KEY IDENTITY(1,1),
    Type nvarchar(50) NOT NULL,
    Price decimal(10, 2) NOT NULL CHECK (Price > 0),
    DurationDays int NOT NULL CHECK (DurationDays > 0)
);
GO

CREATE TABLE MemberMemberships (
    MemberMembershipID int PRIMARY KEY IDENTITY(1,1),
    MemberID int NOT NULL,
    MembershipID int NOT NULL,
    StartDate date NOT NULL DEFAULT CAST(GETDATE() AS date),
    EndDate date NOT NULL,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (MembershipID) REFERENCES Memberships(MembershipID)
);
GO

CREATE TABLE Visits (
    VisitID int PRIMARY KEY IDENTITY(1,1),
    MemberID int NOT NULL,
    VisitDate date NOT NULL,
    VisitTime time NOT NULL,
    TrainerID int NULL,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (TrainerID) REFERENCES Trainers(TrainerID)
);
GO

SELECT * FROM Members;
SELECT * FROM Trainers;
SELECT * FROM Memberships;
SELECT * FROM MemberMemberships;
SELECT * FROM Visits;

INSERT INTO Members (FullName, Phone, RegistrationDate, Email)
VALUES
('Иванов Иван Иванович', '+79123456789', '2023-01-10', 'ivanov.ii@example.com'),
('Петрова Мария Сергеевна', '+79221112233', '2023-02-15', 'petrova.ms@example.com'),
('Сидоров Алексей Петрович', '+79334445566', '2023-03-20', 'sidorov.ap@example.com'),
('Кузнецова Ольга Ивановна', '+79445556677', '2023-04-05', 'kuznecova.oi@example.com'),
('Васильев Дмитрий Владимирович', '+79556667788', '2023-05-12', 'vasiliev.dv@example.com'),
('Новикова Анна Александровна', '+79667778899', '2023-06-18', 'novikova.aa@example.com'),
('Смирнов Сергей Николаевич', '+79778889900', '2023-07-22', 'smirnov.sn@example.com'),
('Алексеева Елена Викторовна', '+79889990011', '2023-08-05', 'alekseeva.ev@example.com'),
('Козлов Андрей Михайлович', '+79991112233', '2023-09-10', 'kozlov.am@example.com'),
('Морозова Ирина Петровна', '+79102223344', '2023-10-15', 'morozova.ip@example.com');
GO

INSERT INTO Trainers (FullName, Specialization, Rate)
VALUES
('Алексеев Алексей Алексеевич', 'Фитнес', 1500.00),
('Борисова Ольга Петровна', 'Йога', 1800.00),
('Викторов Виктор Викторович', 'Силовые тренировки', 2000.00),
('Галина Сергеевна Петрова', 'Пилатес', 1700.00),
('Дмитриев Дмитрий Дмитриевич', 'Кардио', 1600.00),
('Егорова Елена Владимировна', 'Аэробика', 1750.00),
('Жуков Сергей Иванович', 'Кроссфит', 2100.00);
GO

INSERT INTO Memberships (Type, Price, DurationDays)
VALUES
('Разовый', 500.00, 1),
('Дневной', 1500.00, 30),
('Месячный', 3000.00, 30),
('Квартальный', 8000.00, 90),
('Годовой', 25000.00, 365),
('Студенческий', 2000.00, 30);
GO

INSERT INTO MemberMemberships (MemberID, MembershipID, StartDate, EndDate)
VALUES
(1, 3, '2023-01-10', DATEADD(day, 30, '2023-01-10')),
(2, 4, '2023-02-15', DATEADD(day, 90, '2023-02-15')),
(3, 2, '2023-03-20', DATEADD(day, 30, '2023-03-20')),
(4, 5, '2023-04-05', DATEADD(year, 1, '2023-04-05')),
(5, 3, '2023-05-12', DATEADD(day, 30, '2023-05-12')),
(6, 4, '2023-06-18', DATEADD(day, 90, '2023-06-18')),
(7, 6, '2023-07-22', DATEADD(day, 30, '2023-07-22')),
(8, 3, '2023-08-05', DATEADD(day, 30, '2023-08-05')),
(9, 2, '2023-09-10', DATEADD(day, 30, '2023-09-10')),
(10, 5, '2023-10-15', DATEADD(year, 1, '2023-10-15'));
GO

INSERT INTO Visits (MemberID, VisitDate, VisitTime, TrainerID)
VALUES
(1, '2023-09-01', '09:00:00', 1),
(2, '2023-09-01', '10:30:00', 2),
(3, '2023-09-02', '14:00:00', 3),
(4, '2023-09-02', '11:00:00', 4),
(5, '2023-09-03', '15:00:00', 5),
(6, '2023-09-03', '10:00:00', 1),
(7, '2023-09-04', '13:00:00', 2),
(8, '2023-09-04', '12:00:00', 3),
(1, '2023-09-05', '16:00:00', 4),
(2, '2023-09-05', '11:30:00', 5),
(3, '2023-09-06', '17:00:00', 6),
(4, '2023-09-06', '09:30:00', 1),
(5, '2023-09-07', '14:30:00', 7),
(6, '2023-09-07', '10:30:00', 2),
(7, '2023-09-08', '16:30:00', 3),
(8, '2023-09-08', '12:00:00', 4),
(9, '2023-09-09', '18:00:00', 5),
(10, '2023-09-09', '11:00:00', 6);
GO
