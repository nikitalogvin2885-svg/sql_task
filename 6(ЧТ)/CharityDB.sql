CREATE DATABASE CharityDB;
GO

USE CharityDB;
GO

CREATE TABLE Cities (
    CityID INT PRIMARY KEY IDENTITY(1,1),
    CityName NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE ProjectTypes (
    ProjectTypeID INT PRIMARY KEY IDENTITY(1,1),
    TypeName NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY IDENTITY(1,1),
    ProjectName NVARCHAR(100) NOT NULL,
    ProjectTypeID INT,
    Description NVARCHAR(500),
    StartDate DATE NOT NULL,
    EndDate DATE,
    Budget DECIMAL(18, 2) NOT NULL,
    FOREIGN KEY (ProjectTypeID) REFERENCES ProjectTypes(ProjectTypeID)
);
GO

CREATE TABLE Donors (
    DonorID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    CityID INT,
    RegistrationDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CityID) REFERENCES Cities(CityID)
);
GO

CREATE TABLE Recipients (
    RecipientID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    CityID INT,
    RegistrationDate DATETIME DEFAULT GETDATE(),
    Description NVARCHAR(500),
    FOREIGN KEY (CityID) REFERENCES Cities(CityID)
);
GO

CREATE TABLE Donations (
    DonationID INT PRIMARY KEY IDENTITY(1,1),
    DonorID INT NOT NULL,
    ProjectID INT,
    DonationDate DATETIME NOT NULL,
    Amount DECIMAL(18, 2) NOT NULL,
    PaymentMethod NVARCHAR(50),
    Comments NVARCHAR(500),
    FOREIGN KEY (DonorID) REFERENCES Donors(DonorID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);
GO

CREATE TABLE AidDistributions (
    DistributionID INT PRIMARY KEY IDENTITY(1,1),
    ProjectID INT NOT NULL,
    RecipientID INT NOT NULL,
    DistributionDate DATETIME NOT NULL,
    Amount DECIMAL(18, 2) NOT NULL,
    Description NVARCHAR(500),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID),
    FOREIGN KEY (RecipientID) REFERENCES Recipients(RecipientID)
);
GO

INSERT INTO Cities (CityName) VALUES
('Москва'), ('Санкт-Петербург'), ('Казань'), ('Новосибирск'), ('Екатеринбург');
GO

INSERT INTO ProjectTypes (TypeName) VALUES
('Образование'), ('Медицина'), ('Социальная поддержка'), ('Экология'), ('Культура');
GO

INSERT INTO Projects (ProjectName, ProjectTypeID, Description, StartDate, EndDate, Budget) VALUES
('Образование для всех', 1, 'Обеспечение учебниками детей из малообеспеченных семей', '2023-01-01', '2023-12-31', 5000000.00),
('Медицинская помощь', 2, 'Оказание медицинской помощи нуждающимся', '2023-02-01', '2023-11-30', 7000000.00),
('Поддержка пожилых', 3, 'Оказание социальной помощи пожилым людям', '2023-03-01', '2023-10-31', 4000000.00),
('Экологические инициативы', 4, 'Озеленение городов и защита природы', '2023-04-01', '2023-09-30', 3000000.00),
('Культурные мероприятия', 5, 'Организация бесплатных концертов и выставок', '2023-05-01', '2023-10-31', 2500000.00);
GO

INSERT INTO Donors (FirstName, LastName, Email, Phone, CityID) VALUES
('Иван', 'Иванов', 'ivan.ivanov@example.com', '+79123456789', 1),
('Петр', 'Петров', 'petr.petrov@example.com', '+79223456789', 2),
('Сидор', 'Сидоров', 'sidor.sidorov@example.com', '+79323456789', 3),
('Мария', 'Кузнецова', 'maria.kuznetsova@example.com', '+79423456789', 4),
('Анна', 'Васильева', 'anna.vasilyeva@example.com', '+79523456789', 5);
GO

INSERT INTO Recipients (FirstName, LastName, Email, Phone, CityID, Description) VALUES
('Алексей', 'Смирнов', 'alexey.smirnov@example.com', '+79134567890', 1, 'Малообеспеченная семья с детьми'),
('Ольга', 'Кузнецова', 'olga.kuznetsova@example.com', '+79234567890', 2, 'Пожилая женщина, нуждается в лекарствах'),
('Дмитрий', 'Попов', 'dmitry.popov@example.com', '+79334567890', 3, 'Инвалид, нуждается в социальной поддержке'),
('Елена', 'Иванова', 'elena.ivanova@example.com', '+79434567890', 4, 'Многодетная семья'),
('Наталья', 'Соколова', 'natalya.sokolova@example.com', '+79534567890', 5, 'Безработный, нуждается в помощи');
GO

INSERT INTO Donations (DonorID, ProjectID, DonationDate, Amount, PaymentMethod, Comments) VALUES
(1, 1, '2023-06-01T10:00:00', 50000.00, 'Банковский перевод', 'Ежемесячное пожертвование'),
(2, 2, '2023-06-02T11:00:00', 100000.00, 'Кредитная карта', 'Разовое пожертвование'),
(3, 3, '2023-06-03T12:00:00', 30000.00, 'Наличные', 'Пожертвование на день рождения'),
(4, 4, '2023-06-04T13:00:00', 20000.00, 'Банковский перевод', 'Ежемесячное пожертвование'),
(5, 5, '2023-06-05T14:00:00', 25000.00, 'Кредитная карта', 'Разовое пожертвование'),
(1, 2, '2023-06-06T15:00:00', 75000.00, 'Банковский перевод', 'Дополнительное пожертвование'),
(2, 3, '2023-06-07T16:00:00', 50000.00, 'Наличные', 'Пожертвование от компании');
GO

INSERT INTO AidDistributions (ProjectID, RecipientID, DistributionDate, Amount, Description) VALUES
(1, 1, '2023-06-10T09:00:00', 10000.00, 'Учебники для детей'),
(2, 2, '2023-06-11T10:00:00', 50000.00, 'Лекарства'),
(3, 3, '2023-06-12T11:00:00', 15000.00, 'Продукты и одежда'),
(4, 4, '2023-06-13T12:00:00', 8000.00, 'Саженцы для озеленения'),
(5, 5, '2023-06-14T13:00:00', 12000.00, 'Билеты на концерт'),
(1, 3, '2023-06-15T14:00:00', 7000.00, 'Канцелярские товары');
GO

SELECT
    d.FirstName,
    d.LastName,
    (SELECT SUM(Amount) FROM Donations WHERE DonorID = d.DonorID) AS TotalDonations
FROM
    Donors d
WHERE
    (SELECT SUM(Amount) FROM Donations WHERE DonorID = d.DonorID) > (SELECT AVG(TotalDonations) FROM (SELECT SUM(Amount) AS TotalDonations FROM Donations GROUP BY DonorID) AS AvgDonations);

SELECT
    p.ProjectName,
    pt.TypeName,
    p.Budget
FROM
    Projects p
JOIN
    ProjectTypes pt ON p.ProjectTypeID = pt.ProjectTypeID
WHERE
    p.ProjectID IN (SELECT DISTINCT ProjectID FROM Donations WHERE ProjectID IS NOT NULL);

SELECT
    p.ProjectName,
    p.Budget,
    (SELECT SUM(Amount) FROM Donations WHERE ProjectID = p.ProjectID) AS TotalDonations
FROM
    Projects p
WHERE
    (SELECT SUM(Amount) FROM Donations WHERE ProjectID = p.ProjectID) > p.Budget * 1.5;

SELECT
    r.FirstName,
    r.LastName,
    r.Description
FROM
    Recipients r
WHERE
    EXISTS (
        SELECT 1
        FROM AidDistributions ad
        WHERE ad.RecipientID = r.RecipientID
        GROUP BY ad.RecipientID
        HAVING COUNT(DISTINCT ad.ProjectID) > 1
    );

DECLARE @DonorID INT, @FirstName NVARCHAR(50), @LastName NVARCHAR(50), @TotalDonations DECIMAL(18, 2);
DECLARE donor_cursor CURSOR FOR
SELECT
    d.DonorID,
    d.FirstName,
    d.LastName,
    (SELECT SUM(Amount) FROM Donations WHERE DonorID = d.DonorID) AS TotalDonations
FROM
    Donors d;
OPEN donor_cursor;
FETCH NEXT FROM donor_cursor INTO @DonorID, @FirstName, @LastName, @TotalDonations;
PRINT 'ИНФОРМАЦИЯ О ДОНОРАХ И ИХ ПОЖЕРТВОВАНИЯХ';
PRINT '========================================';
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'ID: ' + CAST(@DonorID AS VARCHAR) + ', ' + @FirstName + ' ' + @LastName + ', Сумма пожертвований: ' + CAST(@TotalDonations AS VARCHAR);
    FETCH NEXT FROM donor_cursor INTO @DonorID, @FirstName, @LastName, @TotalDonations;
END;
CLOSE donor_cursor;
DEALLOCATE donor_cursor;

DECLARE @ProjectID INT, @ProjectName NVARCHAR(100);
DECLARE @DonationID INT, @DonorName NVARCHAR(100), @Amount DECIMAL(18, 2);

DECLARE project_cursor CURSOR FOR
    SELECT ProjectID, ProjectName FROM Projects;
OPEN project_cursor;
FETCH NEXT FROM project_cursor INTO @ProjectID, @ProjectName;

PRINT 'ПОЖЕРТВОВАНИЯ ПО ПРОЕКТАМ';
PRINT '============================';

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '';
    PRINT 'Проект: ' + @ProjectName;
    PRINT '----------------------------------------';

    DECLARE donation_cursor CURSOR LOCAL FOR
        SELECT do.DonationID, d.FirstName + ' ' + d.LastName, do.Amount
        FROM Donations do
        JOIN Donors d ON do.DonorID = d.DonorID
        WHERE do.ProjectID = @ProjectID;

    OPEN donation_cursor;
    FETCH NEXT FROM donation_cursor INTO @DonationID, @DonorName, @Amount;

    IF @@FETCH_STATUS != 0
        PRINT '   Нет пожертвований';

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT '   Пожертвование ID: ' + CAST(@DonationID AS VARCHAR) + ', Донор: ' + @DonorName + ', Сумма: ' + CAST(@Amount AS VARCHAR);
        FETCH NEXT FROM donation_cursor INTO @DonationID, @DonorName, @Amount;
    END;

    CLOSE donation_cursor;
    DEALLOCATE donation_cursor;

    FETCH NEXT FROM project_cursor INTO @ProjectID, @ProjectName;
END;

CLOSE project_cursor;
DEALLOCATE project_cursor;


DECLARE @ProjectIDf INT, @ProjectNamef NVARCHAR(100), @TotalDonationsf DECIMAL(18, 2), @Budget DECIMAL(18, 2);
DECLARE project_update_cursor CURSOR FOR
SELECT p.ProjectID, p.ProjectName, p.Budget, (SELECT ISNULL(SUM(Amount), 0) FROM Donations WHERE ProjectID = p.ProjectID) AS TotalDonations
FROM Projects p
WHERE p.EndDate < GETDATE();
OPEN project_update_cursor;
FETCH NEXT FROM project_update_cursor INTO @ProjectID, @ProjectName, @Budget, @TotalDonations;
PRINT 'ОБНОВЛЕНИЕ СТАТУСА ПРОЕКТОВ';
PRINT '================================';
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Проект "' + @ProjectName + '" завершен. Собрано: ' + CAST(@TotalDonations AS VARCHAR) + ' из ' + CAST(@Budget AS VARCHAR);
    FETCH NEXT FROM project_update_cursor INTO @ProjectID, @ProjectName, @Budget, @TotalDonations;
END;
CLOSE project_update_cursor;
DEALLOCATE project_update_cursor;
PRINT 'Обновление завершено.';

CREATE INDEX IX_Donors_CityID ON Donors(CityID);
CREATE INDEX IX_Recipients_CityID ON Recipients(CityID);
CREATE INDEX IX_Donations_DonorID ON Donations(DonorID);
CREATE INDEX IX_Donations_ProjectID ON Donations(ProjectID);
CREATE INDEX IX_AidDistributions_ProjectID ON AidDistributions(ProjectID);
CREATE INDEX IX_AidDistributions_RecipientID ON AidDistributions(RecipientID);
CREATE INDEX IX_Projects_ProjectTypeID ON Projects(ProjectTypeID);
