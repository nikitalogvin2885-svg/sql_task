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
('������'), ('�����-���������'), ('������'), ('�����������'), ('������������');
GO

INSERT INTO ServiceTypes (TypeName) VALUES
('������'), ('�����'), ('����'), ('������'), ('������');
GO

INSERT INTO Services (ServiceName, ServiceTypeID, Duration, Price, Description) VALUES
('�������', 1, 60, 1500.00, '������������ �������'),
('�����������', 1, 120, 3000.00, '����������� �����'),
('�������', 2, 60, 1200.00, '������������ �������'),
('�������', 2, 90, 1800.00, '������������ �������'),
('������ ����', 3, 60, 2500.00, '�������� ������ ����'),
('������ ����', 3, 45, 2000.00, '������������� ������ ����'),
('�������� ������', 4, 90, 3500.00, '�������� ������'),
('������� ������', 4, 60, 2500.00, '������� ������'),
('��������������� ������', 5, 60, 2800.00, '��������������� ������'),
('������������� ������', 5, 60, 2500.00, '������������� ������');
GO

INSERT INTO Clients (FirstName, LastName, Email, Phone, CityID) VALUES
('����', '������', 'ivan.ivanov@example.com', '+79123456789', 1),
('����', '������', 'petr.petrov@example.com', '+79223456789', 2),
('�����', '�������', 'sidor.sidorov@example.com', '+79323456789', 3),
('�����', '���������', 'maria.kuznetsova@example.com', '+79423456789', 4),
('����', '���������', 'anna.vasilyeva@example.com', '+79523456789', 5);
GO

INSERT INTO Masters (FirstName, LastName, Email, Phone, ServiceTypeID, Experience) VALUES
('�������', '�������', 'alexey.smirnov@example.com', '+79134567890', 1, 5),
('�����', '���������', 'olga.kuznetsova@example.com', '+79234567890', 2, 3),
('�������', '�����', 'dmitry.popov@example.com', '+79334567890', 3, 4),
('�����', '�������', 'elena.ivanova@example.com', '+79434567890', 4, 6),
('�������', '��������', 'natalya.sokolova@example.com', '+79534567890', 5, 7);
GO


INSERT INTO Consumables (ConsumableName, Quantity, Cost, Description) VALUES
('������ ��� �����', 50, 300.00, '���������������� ������ ��� �����'),
('��� ��� ������', 100, 150.00, '��� ��� ��������'),
('���� ��� ����', 30, 500.00, '����������� ���� ��� ����'),
('���� ��� ���', 20, 400.00, '������� ����� ��� �������'),
('��������� �����', 15, 600.00, '����� ��� �������');
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
        WHERE st.TypeName = '������'
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
PRINT '���������� � ������� ��������';
PRINT '========================================';
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '������: ' + @FirstName + ' ' + @LastName + ', ������: ' + @ServiceName + ', ����: ' + CONVERT(NVARCHAR(20), @AppointmentDate, 120) + ', ������: ' + @Status;
    FETCH NEXT FROM client_cursor INTO @ClientID, @FirstName, @LastName, @ServiceName, @AppointmentDate, @Status;
END;
CLOSE client_cursor;
DEALLOCATE client_cursor;

DECLARE @MasterID INT, @MasterName NVARCHAR(100), @ClientName NVARCHAR(100), @ServiceNamef NVARCHAR(100), @AppointmentDatef DATETIME, @Statusf NVARCHAR(20);
DECLARE master_cursor CURSOR FOR
SELECT MasterID, FirstName + ' ' + LastName AS MasterName FROM Masters;
OPEN master_cursor;
FETCH NEXT FROM master_cursor INTO @MasterID, @MasterName;
PRINT '������ �� ��������';
PRINT '============================';
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT '';
    PRINT '������: ' + @MasterName;
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
        PRINT '   ��� �������';
    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT '   ������: ' + @ClientName + ', ������: ' + @ServiceName + ', ����: ' + CONVERT(NVARCHAR(20), @AppointmentDate, 120) + ', ������: ' + @Status;
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
PRINT '���������� ������� �������';
PRINT '================================';
WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE Appointments
    SET Status = 'Cancelled'
    WHERE AppointmentID = @AppointmentID;
    PRINT '������ ID ' + CAST(@AppointmentID AS VARCHAR) + ' - ������ ������� �� "Cancelled"';
    FETCH NEXT FROM appointment_update_cursor INTO @AppointmentID, @AppointmentDate;
END;
CLOSE appointment_update_cursor;
DEALLOCATE appointment_update_cursor;
PRINT '���������� ���������.';

CREATE INDEX IX_Clients_CityID ON Clients(CityID);
CREATE INDEX IX_Masters_Specialization ON Masters(Specialization);
CREATE INDEX IX_Services_ServiceTypeID ON Services(ServiceTypeID);
CREATE INDEX IX_Appointments_ClientID ON Appointments(ClientID);
CREATE INDEX IX_Appointments_MasterID ON Appointments(MasterID);
CREATE INDEX IX_Appointments_ServiceID ON Appointments(ServiceID);
CREATE INDEX IX_Appointments_Status ON Appointments(Status);
CREATE INDEX IX_ConsumableUsages_AppointmentID ON ConsumableUsages(AppointmentID);
CREATE INDEX IX_ConsumableUsages_ConsumableID ON ConsumableUsages(ConsumableID);
