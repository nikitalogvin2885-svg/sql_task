CREATE DATABASE BeautySalonDB;
GO

USE BeautySalonDB;
GO

CREATE TABLE Cities (
    CityID INT PRIMARY KEY IDENTITY(1,1),
    CityName NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE ServiceTypes (
    ServiceTypeID INT PRIMARY KEY IDENTITY(1,1),
    TypeName NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE Services (
    ServiceID INT PRIMARY KEY IDENTITY(1,1),
    ServiceName NVARCHAR(100) NOT NULL,
    ServiceTypeID INT,
    Duration INT NOT NULL, 
    Price DECIMAL(10, 2) NOT NULL,
    Description NVARCHAR(500),
    FOREIGN KEY (ServiceTypeID) REFERENCES ServiceTypes(ServiceTypeID)
);
GO

CREATE TABLE Clients (
    ClientID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20) NOT NULL,
    CityID INT,
    RegistrationDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CityID) REFERENCES Cities(CityID)
);
GO

CREATE TABLE Masters (
    MasterID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20) NOT NULL,
    ServiceTypeID INT,
    Experience INT, 
    FOREIGN KEY (ServiceTypeID) REFERENCES ServiceTypes(ServiceTypeID)
);
GO

CREATE TABLE Consumables (
    ConsumableID INT PRIMARY KEY IDENTITY(1,1),
    ConsumableName NVARCHAR(100) NOT NULL,
    Quantity INT NOT NULL,
    Cost DECIMAL(10, 2) NOT NULL,
    Description NVARCHAR(500)
);
GO

CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY IDENTITY(1,1),
    ClientID INT NOT NULL,
    MasterID INT NOT NULL,
    ServiceID INT NOT NULL,
    AppointmentDate DATETIME NOT NULL,
    Status NVARCHAR(20) DEFAULT 'Scheduled', 
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
    FOREIGN KEY (MasterID) REFERENCES Masters(MasterID),
    FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID)
);
GO

CREATE TABLE ConsumableUsages (
    UsageID INT PRIMARY KEY IDENTITY(1,1),
    AppointmentID INT NOT NULL,
    ConsumableID INT NOT NULL,
    QuantityUsed INT NOT NULL,
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID),
    FOREIGN KEY (ConsumableID) REFERENCES Consumables(ConsumableID)
);
GO

INSERT INTO Cities (CityName) VALUES
('Москва'), ('Санкт-Петербург'), ('Казань'), ('Новосибирск'), ('Екатеринбург');
GO

INSERT INTO ServiceTypes (TypeName) VALUES
('Волосы'), ('Ногти'), ('Кожа'), ('Макияж'), ('Массаж');
GO

INSERT INTO Services (ServiceName, ServiceTypeID, Duration, Price, Description) VALUES
('Стрижка', 1, 60, 1500.00, 'Классическая стрижка'),
('Окрашивание', 1, 120, 3000.00, 'Окрашивание волос'),
('Маникюр', 2, 60, 1200.00, 'Классический маникюр'),
('Педикюр', 2, 90, 1800.00, 'Классический педикюр'),
('Чистка лица', 3, 60, 2500.00, 'Глубокая чистка лица'),
('Массаж лица', 3, 45, 2000.00, 'Расслабляющий массаж лица'),
('Вечерний макияж', 4, 90, 3500.00, 'Вечерний макияж'),
('Дневной макияж', 4, 60, 2500.00, 'Дневной макияж'),
('Антицеллюлитный массаж', 5, 60, 2800.00, 'Антицеллюлитный массаж'),
('Расслабляющий массаж', 5, 60, 2500.00, 'Расслабляющий массаж');
GO

INSERT INTO Clients (FirstName, LastName, Email, Phone, CityID) VALUES
('Иван', 'Иванов', 'ivan.ivanov@example.com', '+79123456789', 1),
('Петр', 'Петров', 'petr.petrov@example.com', '+79223456789', 2),
('Сидор', 'Сидоров', 'sidor.sidorov@example.com', '+79323456789', 3),
('Мария', 'Кузнецова', 'maria.kuznetsova@example.com', '+79423456789', 4),
('Анна', 'Васильева', 'anna.vasilyeva@example.com', '+79523456789', 5);
GO

INSERT INTO Masters (FirstName, LastName, Email, Phone, ServiceTypeID, Experience) VALUES
('Алексей', 'Смирнов', 'alexey.smirnov@example.com', '+79134567890', 1, 5),
('Ольга', 'Кузнецова', 'olga.kuznetsova@example.com', '+79234567890', 2, 3),
('Дмитрий', 'Попов', 'dmitry.popov@example.com', '+79334567890', 3, 4),
('Елена', 'Иванова', 'elena.ivanova@example.com', '+79434567890', 4, 6),
('Наталья', 'Соколова', 'natalya.sokolova@example.com', '+79534567890', 5, 7);
GO


INSERT INTO Consumables (ConsumableName, Quantity, Cost, Description) VALUES
('Краска для волос', 50, 300.00, 'Профессиональная краска для волос'),
('Лак для ногтей', 100, 150.00, 'Лак для маникюра'),
('Крем для лица', 30, 500.00, 'Увлажняющий крем для лица'),
('Тени для век', 20, 400.00, 'Палитра теней для макияжа'),
('Массажное масло', 15, 600.00, 'Масло для массажа');
GO

INSERT INTO Appointments (ClientID, MasterID, ServiceID, AppointmentDate, Status) VALUES
(1, 1, 1, '2023-06-10T10:00:00', 'Completed'),
(2, 2, 3, '2023-06-10T11:30:00', 'Completed'),
(3, 3, 5, '2023-06-11T09:00:00', 'Completed'),
(4, 4, 7, '2023-06-11T15:00:00', 'Scheduled'),
(5, 5, 9, '2023-06-12T14:00:00', 'Scheduled'),
(1, 2, 2, '2023-06-12T16:00:00', 'Scheduled'),
(3, 1, 2, '2023-06-13T11:00:00', 'Scheduled'),
(4, 4, 8, '2023-06-14T17:00:00', 'Scheduled');
GO

INSERT INTO ConsumableUsages (AppointmentID, ConsumableID, QuantityUsed) VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 1),
(5, 5, 1),
(6, 1, 1),
(7, 2, 1);
GO

SELECT
    c.FirstName,
    c.LastName,
    (SELECT SUM(s.Price) FROM Appointments a JOIN Services s ON a.ServiceID = s.ServiceID WHERE a.ClientID = c.ClientID AND a.Status = 'Completed') AS TotalSpent
FROM
    Clients c
WHERE
    (SELECT SUM(s.Price) FROM Appointments a JOIN Services s ON a.ServiceID = s.ServiceID WHERE a.ClientID = c.ClientID AND a.Status = 'Completed') >
    (SELECT AVG(TotalSpent) FROM (SELECT SUM(s.Price) AS TotalSpent FROM Appointments a JOIN Services s ON a.ServiceID = s.ServiceID WHERE a.Status = 'Completed' GROUP BY a.ClientID) AS AvgSpent);

SELECT
    m.FirstName,
    m.LastName,
    m.ServiceTypeID
FROM
    Masters m
WHERE
    m.MasterID IN (
        SELECT DISTINCT a.MasterID
        FROM Appointments a
        JOIN Services s ON a.ServiceID = s.ServiceID
        JOIN ServiceTypes st ON s.ServiceTypeID = st.ServiceTypeID
        WHERE st.TypeName = 'Волосы'
    );

SELECT
    s.ServiceName,
    s.Duration,
    st.TypeName
FROM
    Services s
JOIN
    ServiceTypes st ON s.ServiceTypeID = st.ServiceTypeID
WHERE
    s.Duration > (
        SELECT AVG(Duration)
        FROM Services
        WHERE ServiceTypeID = s.ServiceTypeID
    );

SELECT
    c.FirstName,
    c.LastName,
    c.Phone
FROM
    Clients c
WHERE
    EXISTS (
        SELECT 1
        FROM Appointments a
        WHERE a.ClientID = c.ClientID
        GROUP BY a.ClientID
        HAVING COUNT(*) > 1
    );

DECLARE @ClientID INT, @FirstName NVARCHAR(50), @LastName NVARCHAR(50), @ServiceName NVARCHAR(100), @AppointmentDate DATETIME, @Status NVARCHAR(20);
DECLARE client_cursor CURSOR FOR
SELECT
    c.ClientID,
    c.FirstName,
    c.LastName,
    s.ServiceName,
    a.AppointmentDate,
    a.Status
FROM
    Clients c
JOIN
    Appointments a ON c.ClientID = a.ClientID
JOIN
    Services s ON a.ServiceID = s.ServiceID;
OPEN client_cursor;
FETCH NEXT FROM client_cursor INTO @ClientID, @FirstName, @LastName, @ServiceName, @AppointmentDate, @Status;
PRINT 'ИНФОРМАЦИЯ О ЗАПИСЯХ КЛИЕНТОВ';
PRINT '========================================';
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Клиент: ' + @FirstName + ' ' + @LastName + ', Услуга: ' + @ServiceName + ', Дата: ' + CONVERT(NVARCHAR(20), @AppointmentDate, 120) + ', Статус: ' + @Status;
    FETCH NEXT FROM client_cursor INTO @ClientID, @FirstName, @LastName, @ServiceName, @AppointmentDate, @Status;
END;
CLOSE client_cursor;
DEALLOCATE client_cursor;

DECLARE @MasterID INT, @MasterName NVARCHAR(100), @ClientName NVARCHAR(100), @ServiceNamef NVARCHAR(100), @AppointmentDatef DATETIME, @Statusf NVARCHAR(20);
DECLARE master_cursor CURSOR FOR
SELECT MasterID, FirstName + ' ' + LastName AS MasterName FROM Masters;
OPEN master_cursor;
FETCH NEXT FROM master_cursor INTO @MasterID, @MasterName;
PRINT 'ЗАПИСИ ПО МАСТЕРАМ';
PRINT '============================';
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '';
    PRINT 'Мастер: ' + @MasterName;
    PRINT '----------------------------------------';
    DECLARE appointment_cursor CURSOR LOCAL FOR
    SELECT c.FirstName + ' ' + c.LastName, s.ServiceName, a.AppointmentDate, a.Status
    FROM Appointments a
    JOIN Clients c ON a.ClientID = c.ClientID
    JOIN Services s ON a.ServiceID = s.ServiceID
    WHERE a.MasterID = @MasterID;
    OPEN appointment_cursor;
    FETCH NEXT FROM appointment_cursor INTO @ClientName, @ServiceName, @AppointmentDate, @Status;
    IF @@FETCH_STATUS != 0
        PRINT '   Нет записей';
    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT '   Клиент: ' + @ClientName + ', Услуга: ' + @ServiceName + ', Дата: ' + CONVERT(NVARCHAR(20), @AppointmentDate, 120) + ', Статус: ' + @Status;
        FETCH NEXT FROM appointment_cursor INTO @ClientName, @ServiceName, @AppointmentDate, @Status;
    END;
    CLOSE appointment_cursor;
    DEALLOCATE appointment_cursor;
    FETCH NEXT FROM master_cursor INTO @MasterID, @MasterName;
END;
CLOSE master_cursor;
DEALLOCATE master_cursor;

DECLARE @AppointmentID INT, @AppointmentDated DATETIME;
DECLARE appointment_update_cursor CURSOR FOR
SELECT AppointmentID, AppointmentDate FROM Appointments WHERE Status = 'Scheduled' AND AppointmentDate < DATEADD(DAY, -1, GETDATE());
OPEN appointment_update_cursor;
FETCH NEXT FROM appointment_update_cursor INTO @AppointmentID, @AppointmentDate;
PRINT 'ОБНОВЛЕНИЕ СТАТУСА ЗАПИСЕЙ';
PRINT '================================';
WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE Appointments
    SET Status = 'Cancelled'
    WHERE AppointmentID = @AppointmentID;
    PRINT 'Запись ID ' + CAST(@AppointmentID AS VARCHAR) + ' - статус изменен на "Cancelled"';
    FETCH NEXT FROM appointment_update_cursor INTO @AppointmentID, @AppointmentDate;
END;
CLOSE appointment_update_cursor;
DEALLOCATE appointment_update_cursor;
PRINT 'Обновление завершено.';

CREATE INDEX IX_Clients_CityID ON Clients(CityID);
CREATE INDEX IX_Masters_Specialization ON Masters(Specialization);
CREATE INDEX IX_Services_ServiceTypeID ON Services(ServiceTypeID);
CREATE INDEX IX_Appointments_ClientID ON Appointments(ClientID);
CREATE INDEX IX_Appointments_MasterID ON Appointments(MasterID);
CREATE INDEX IX_Appointments_ServiceID ON Appointments(ServiceID);
CREATE INDEX IX_Appointments_Status ON Appointments(Status);
CREATE INDEX IX_ConsumableUsages_AppointmentID ON ConsumableUsages(AppointmentID);
CREATE INDEX IX_ConsumableUsages_ConsumableID ON ConsumableUsages(ConsumableID);
