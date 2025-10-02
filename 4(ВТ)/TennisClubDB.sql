USE master;
GO

-- �������� � �������� ���� ������, ���� ��� ����������
IF DB_ID('TennisClubDB') IS NOT NULL
BEGIN
    ALTER DATABASE TennisClubDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TennisClubDB;
END
GO

-- �������� ���� ������
CREATE DATABASE TennisClubDB;
GO

USE TennisClubDB;
GO

-- �������� � �������� �������, ���� ��� ����������
IF OBJECT_ID('TennisEvents_Denormalized', 'U') IS NOT NULL
    DROP TABLE TennisEvents_Denormalized;
GO

-- =============================================
-- 1. ����������������� ������� "������� � �������"
-- =============================================
CREATE TABLE TennisEvents_Denormalized (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    PlayerInfo NVARCHAR(200),
    CoachInfo NVARCHAR(150),
    CourtInfo NVARCHAR(100),
    TournamentInfo NVARCHAR(200),
    EventDate NVARCHAR(50),
    EventType NVARCHAR(100),
    EventDuration INT,
    EventCost DECIMAL(10, 2),
    MembershipInfo NVARCHAR(150),
    MatchesCount INT,
    PaymentInfo NVARCHAR(150),
    Comments NVARCHAR(500)
);
GO

-- ���������� ����������������� �������
INSERT INTO TennisEvents_Denormalized (
    PlayerInfo, CoachInfo, CourtInfo, TournamentInfo, EventDate, EventType,
    EventDuration, EventCost, MembershipInfo, MatchesCount, PaymentInfo, Comments
)
VALUES
('������ ���� ���������; +79123456789; ivanov@mail.ru; 1995-05-15; ������������',
 '�������� ���� ����������; ������ ������ ���������; 10 ��� �����',
 '���� 1; ����; �� �����; ��������� ����',
 '�������� ��������� ������; 2025-11-10; 2025-11-20; �������� ����: 500000',
 '2025-11-10 18:00:00',
 '���������� ����� ��������',
 120, 3000.00,
 '������������; 2025-01-15; 2025-12-31; ��������',
 45,
 '���������� �����; 2025-11-01; 3000.00',
 '���������� � �������, ����� ������ ��� �������'),

('������� ����� ��������; +79234567890; petrova@mail.ru; 2000-08-22; ��������',
 '�������� ������� �������������; ������ 1 ���������; 5 ��� �����',
 '���� 2; �����; � ���������; ��������� ����',
 '����� ������; 2025-11-15; 2025-11-25; �������� ����: 50000',
 '2025-11-12 19:30:00',
 '��������� ����������',
 90, 1500.00,
 '��������; 2025-09-01; 2026-02-28; 12 ������� � �����',
 28,
 '��������; 2025-10-15; 1500.00',
 '������ ��� ������� � ������ �����'),

('������� ������� ������������; +79345678901; smirnov@mail.ru; 1998-11-30; �����',
 '��������� ����� ��������; ������ �� ������ � ������; 8 ��� �����',
 '���� 3; �����; �� �����; ��������� ���',
 '��������� ������; 2025-11-20; 2025-11-30; �������� ����: 10000',
 '2025-11-15 10:00:00',
 '�������������� ����',
 60, 2000.00,
 '�����; 2025-07-01; 2026-06-30; 8 ������� � �����',
 15,
 '���������� �����; 2025-10-05; 2000.00',
 '���������� � ���������� �������, ����� ������ ��� ������� � ������');
GO

-- �������� ����������������� ������
SELECT * FROM TennisEvents_Denormalized;
GO

-- �������� � �������� �������, ���� ��� ����������
IF OBJECT_ID('TennisEvents_1NF', 'U') IS NOT NULL
    DROP TABLE TennisEvents_1NF;
GO

-- =============================================
-- 2. ������������ �� 1��
-- =============================================
CREATE TABLE TennisEvents_1NF (
    RecordID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT,
    PlayerFName NVARCHAR(50),
    PlayerMName NVARCHAR(50),
    PlayerLName NVARCHAR(50),
    PlayerPhone NVARCHAR(20),
    PlayerEmail NVARCHAR(100),
    PlayerBirthDate DATE,
    PlayerLevel NVARCHAR(50),
    CoachFName NVARCHAR(50),
    CoachMName NVARCHAR(50),
    CoachLName NVARCHAR(50),
    CoachCategory NVARCHAR(100),
    CoachExperience INT,
    CourtNumber NVARCHAR(10),
    CourtSurface NVARCHAR(50),
    CourtLocation NVARCHAR(50),
    CourtLighting BIT,
    TournamentName NVARCHAR(100),
    TournamentStartDate DATE,
    TournamentEndDate DATE,
    TournamentPrize NVARCHAR(100),
    EventDate DATETIME,
    EventType NVARCHAR(100),
    EventDuration INT,
    EventCost DECIMAL(10, 2),
    MembershipType NVARCHAR(50),
    MembershipStartDate DATE,
    MembershipEndDate DATE,
    MembershipVisitsLimit NVARCHAR(50),
    MatchesCount INT,
    PaymentMethod NVARCHAR(50),
    PaymentDate DATE,
    PaymentAmount DECIMAL(10, 2),
    Comments NVARCHAR(500)
);
GO

-- ���������� ������� � 1��
INSERT INTO TennisEvents_1NF (
    EventID, PlayerFName, PlayerMName, PlayerLName, PlayerPhone, PlayerEmail, PlayerBirthDate, PlayerLevel,
    CoachFName, CoachMName, CoachLName, CoachCategory, CoachExperience, CourtNumber, CourtSurface, CourtLocation, CourtLighting,
    TournamentName, TournamentStartDate, TournamentEndDate, TournamentPrize, EventDate, EventType,
    EventDuration, EventCost, MembershipType, MembershipStartDate, MembershipEndDate, MembershipVisitsLimit,
    MatchesCount, PaymentMethod, PaymentDate, PaymentAmount, Comments
)
SELECT
    EventID,
    PARSENAME(REPLACE(PlayerInfo, '; ', '.'), 3) AS PlayerFName,
    PARSENAME(REPLACE(PlayerInfo, '; ', '.'), 2) AS PlayerMName,
    PARSENAME(REPLACE(PlayerInfo, '; ', '.'), 1) AS PlayerLName,
    PARSENAME(REPLACE(PlayerInfo, '; ', '.'), 4) AS PlayerPhone,
    PARSENAME(REPLACE(PlayerInfo, '; ', '.'), 5) AS PlayerEmail,
    CAST(PARSENAME(REPLACE(PlayerInfo, '; ', '.'), 6) AS DATE) AS PlayerBirthDate,
    PARSENAME(REPLACE(PlayerInfo, '; ', '.'), 7) AS PlayerLevel,
    PARSENAME(REPLACE(CoachInfo, '; ', '.'), 1) AS CoachFName,
    PARSENAME(REPLACE(CoachInfo, '; ', '.'), 2) AS CoachMName,
    PARSENAME(REPLACE(CoachInfo, '; ', '.'), 3) AS CoachLName,
    PARSENAME(REPLACE(CoachInfo, '; ', '.'), 4) AS CoachCategory,
    CAST(PARSENAME(REPLACE(CoachInfo, '; ', '.'), 5) AS INT) AS CoachExperience,
    PARSENAME(REPLACE(CourtInfo, '; ', '.'), 1) AS CourtNumber,
    PARSENAME(REPLACE(CourtInfo, '; ', '.'), 2) AS CourtSurface,
    PARSENAME(REPLACE(CourtInfo, '; ', '.'), 3) AS CourtLocation,
    CASE WHEN PARSENAME(REPLACE(CourtInfo, '; ', '.'), 4) = '��������� ����' THEN 1 ELSE 0 END AS CourtLighting,
    PARSENAME(REPLACE(TournamentInfo, '; ', '.'), 1) AS TournamentName,
    CAST(PARSENAME(REPLACE(TournamentInfo, '; ', '.'), 2) AS DATE) AS TournamentStartDate,
    CAST(PARSENAME(REPLACE(TournamentInfo, '; ', '.'), 3) AS DATE) AS TournamentEndDate,
    PARSENAME(REPLACE(TournamentInfo, '; ', '.'), 4) AS TournamentPrize,
    CAST(EventDate AS DATETIME) AS EventDate,
    PARSENAME(REPLACE(TournamentInfo, '; ', '.'), 5) AS EventType,
    EventDuration, EventCost,
    PARSENAME(REPLACE(MembershipInfo, '; ', '.'), 1) AS MembershipType,
    CAST(PARSENAME(REPLACE(MembershipInfo, '; ', '.'), 2) AS DATE) AS MembershipStartDate,
    CAST(PARSENAME(REPLACE(MembershipInfo, '; ', '.'), 3) AS DATE) AS MembershipEndDate,
    PARSENAME(REPLACE(MembershipInfo, '; ', '.'), 4) AS MembershipVisitsLimit,
    MatchesCount,
    PARSENAME(REPLACE(PaymentInfo, '; ', '.'), 1) AS PaymentMethod,
    CAST(PARSENAME(REPLACE(PaymentInfo, '; ', '.'), 2) AS DATE) AS PaymentDate,
    CAST(PARSENAME(REPLACE(PaymentInfo, '; ', '.'), 3) AS DECIMAL(10, 2)) AS PaymentAmount,
    Comments
FROM TennisEvents_Denormalized;
GO

-- �������� ������ � 1��
SELECT * FROM TennisEvents_1NF;
GO

-- �������� � �������� ������, ���� ��� ����������
IF OBJECT_ID('PlayerLevels', 'U') IS NOT NULL DROP TABLE PlayerLevels;
IF OBJECT_ID('Players', 'U') IS NOT NULL DROP TABLE Players;
IF OBJECT_ID('CoachCategories', 'U') IS NOT NULL DROP TABLE CoachCategories;
IF OBJECT_ID('Coaches', 'U') IS NOT NULL DROP TABLE Coaches;
IF OBJECT_ID('CourtSurfaces', 'U') IS NOT NULL DROP TABLE CourtSurfaces;
IF OBJECT_ID('Courts', 'U') IS NOT NULL DROP TABLE Courts;
IF OBJECT_ID('Tournaments', 'U') IS NOT NULL DROP TABLE Tournaments;
IF OBJECT_ID('MembershipTypes', 'U') IS NOT NULL DROP TABLE MembershipTypes;
IF OBJECT_ID('Memberships', 'U') IS NOT NULL DROP TABLE Memberships;
IF OBJECT_ID('EventTypes', 'U') IS NOT NULL DROP TABLE EventTypes;
IF OBJECT_ID('Events', 'U') IS NOT NULL DROP TABLE Events;
IF OBJECT_ID('PaymentMethods', 'U') IS NOT NULL DROP TABLE PaymentMethods;
IF OBJECT_ID('Payments', 'U') IS NOT NULL DROP TABLE Payments;
GO

-- =============================================
-- 3. ������������ �� 3�� (�������� ���������� ������)
-- =============================================
-- 1. ������ �������
CREATE TABLE PlayerLevels (
    LevelID INT IDENTITY(1,1) PRIMARY KEY,
    LevelName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 2. ������
CREATE TABLE Players (
    PlayerID INT IDENTITY(1,1) PRIMARY KEY,
    FName NVARCHAR(50) NOT NULL,
    MName NVARCHAR(50),
    LName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    BirthDate DATE,
    LevelID INT NOT NULL,
    FOREIGN KEY (LevelID) REFERENCES PlayerLevels(LevelID)
);
GO

-- 3. ��������� ��������
CREATE TABLE CoachCategories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 4. �������
CREATE TABLE Coaches (
    CoachID INT IDENTITY(1,1) PRIMARY KEY,
    FName NVARCHAR(50) NOT NULL,
    MName NVARCHAR(50),
    LName NVARCHAR(50) NOT NULL,
    CategoryID INT NOT NULL,
    ExperienceYears INT,
    FOREIGN KEY (CategoryID) REFERENCES CoachCategories(CategoryID)
);
GO

-- 5. ���� �������� ������
CREATE TABLE CourtSurfaces (
    SurfaceID INT IDENTITY(1,1) PRIMARY KEY,
    SurfaceName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 6. ����
CREATE TABLE Courts (
    CourtID INT IDENTITY(1,1) PRIMARY KEY,
    CourtNumber NVARCHAR(10) NOT NULL,
    SurfaceID INT NOT NULL,
    Location NVARCHAR(50) NOT NULL,
    HasLighting BIT,
    FOREIGN KEY (SurfaceID) REFERENCES CourtSurfaces(SurfaceID)
);
GO

-- 7. �������
CREATE TABLE Tournaments (
    TournamentID INT IDENTITY(1,1) PRIMARY KEY,
    TournamentName NVARCHAR(100) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    PrizeFund NVARCHAR(100)
);
GO

-- 8. ���� �����������
CREATE TABLE MembershipTypes (
    MembershipTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200),
    VisitsLimit NVARCHAR(50)
);
GO

-- 9. ���������� �������
CREATE TABLE Memberships (
    MembershipID INT IDENTITY(1,1) PRIMARY KEY,
    PlayerID INT NOT NULL,
    MembershipTypeID INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID),
    FOREIGN KEY (MembershipTypeID) REFERENCES MembershipTypes(MembershipTypeID)
);
GO

-- 10. ���� ������� (����������, ����, ������)
CREATE TABLE EventTypes (
    EventTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 11. ������� (����������, �����, �������)
CREATE TABLE Events (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    PlayerID INT NOT NULL,
    CoachID INT,
    CourtID INT NOT NULL,
    TournamentID INT,
    EventTypeID INT NOT NULL,
    EventDate DATETIME NOT NULL,
    Duration INT,
    Cost DECIMAL(10, 2),
    FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID),
    FOREIGN KEY (CoachID) REFERENCES Coaches(CoachID),
    FOREIGN KEY (CourtID) REFERENCES Courts(CourtID),
    FOREIGN KEY (TournamentID) REFERENCES Tournaments(TournamentID),
    FOREIGN KEY (EventTypeID) REFERENCES EventTypes(EventTypeID)
);
GO

-- 12. ������� ������
CREATE TABLE PaymentMethods (
    PaymentMethodID INT IDENTITY(1,1) PRIMARY KEY,
    MethodName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 13. �������
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    PlayerID INT NOT NULL,
    EventID INT,
    PaymentMethodID INT NOT NULL,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    Description NVARCHAR(200),
    FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID),
    FOREIGN KEY (EventID) REFERENCES Events(EventID),
    FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethods(PaymentMethodID)
);
GO

-- ���������� ���������� ������
INSERT INTO PlayerLevels (LevelName, Description)
VALUES
('������������', '������ � ���������������� �������'),
('��������', '������-��������'),
('�����', '������ �� 18 ���');
GO

INSERT INTO CoachCategories (CategoryName, Description)
VALUES
('������ ������ ���������', '������ � ������ ����������'),
('������ 1 ���������', '������ � ������ ����������'),
('������ �� ������ � ������', '������, ������������������ �� ������ � ������');
GO

INSERT INTO CourtSurfaces (SurfaceName, Description)
VALUES
('����', '������� ��������'),
('�����', '��������� ��������'),
('�����', '�������� ��������');
GO

INSERT INTO EventTypes (TypeName, Description)
VALUES
('����������', '�������������� ��� ��������� ����������'),
('����', '���������������� ����'),
('������', '������� � �������');
GO

INSERT INTO PaymentMethods (MethodName, Description)
VALUES
('���������� �����', '������ ���������� ������'),
('��������', '������ ���������'),
('����������� ������', '������ ����� ����������� ��������� �������');
GO

INSERT INTO MembershipTypes (TypeName, Description, VisitsLimit)
VALUES
('������������', '����������� ��������� ��� ��������������', '��������'),
('��������', '��������� �� 12 ������� � �����', '12 ������� � �����'),
('�����', '��������� �� 8 ������� � �����', '8 ������� � �����');
GO

-- ���������� �������� ������
INSERT INTO Players (FName, MName, LName, Phone, Email, BirthDate, LevelID)
VALUES
('����', '���������', '������', '+79123456789', 'ivanov@mail.ru', '1995-05-15', 1),
('�����', '��������', '�������', '+79234567890', 'petrova@mail.ru', '2000-08-22', 2),
('�������', '������������', '�������', '+79345678901', 'smirnov@mail.ru', '1998-11-30', 3);
GO

INSERT INTO Coaches (FName, MName, LName, CategoryID, ExperienceYears)
VALUES
('����', '����������', '��������', 1, 10),
('�������', '�������������', '��������', 2, 5),
('�����', '��������', '���������', 3, 8);
GO

INSERT INTO Courts (CourtNumber, SurfaceID, Location, HasLighting)
VALUES
('1', 1, '�� �����', 1),
('2', 2, '� ���������', 1),
('3', 3, '�� �����', 0);
GO

INSERT INTO Tournaments (TournamentName, StartDate, EndDate, PrizeFund)
VALUES
('�������� ��������� ������', '2025-11-10', '2025-11-20', '500000'),
('����� ������', '2025-11-15', '2025-11-25', '50000'),
('��������� ������', '2025-11-20', '2025-11-30', '10000');
GO

INSERT INTO Memberships (PlayerID, MembershipTypeID, StartDate, EndDate)
VALUES
(1, 1, '2025-01-15', '2025-12-31'),
(2, 2, '2025-09-01', '2026-02-28'),
(3, 3, '2025-07-01', '2026-06-30');
GO

INSERT INTO Events (PlayerID, CoachID, CourtID, TournamentID, EventTypeID, EventDate, Duration, Cost)
VALUES
(1, 1, 1, 1, 1, '2025-11-10 18:00:00', 120, 3000.00),
(2, 2, 2, 2, 1, '2025-11-12 19:30:00', 90, 1500.00),
(3, 3, 3, 3, 1, '2025-11-15 10:00:00', 60, 2000.00);
GO

INSERT INTO Payments (PlayerID, EventID, PaymentMethodID, PaymentDate, Amount, Description)
VALUES
(1, 1, 1, '2025-11-01', 3000.00, '������ ���������� ����� ��������'),
(2, 2, 2, '2025-10-15', 1500.00, '������ ��������� ����������'),
(3, 3, 1, '2025-10-05', 2000.00, '������ ��������������� �����');
GO

-- =============================================
-- 4. ������������� �������
-- =============================================
-- 1. ������������ ����� �������� ������
PRINT '1. ������������ ����� �������� ������:';
GO
SELECT
    cs.SurfaceName AS CourtSurface,
    COUNT(e.EventID) AS EventsCount,
    SUM(e.Cost) AS TotalRevenue
FROM Events e
JOIN Courts c ON e.CourtID = c.CourtID
JOIN CourtSurfaces cs ON c.SurfaceID = cs.SurfaceID
GROUP BY cs.SurfaceName
ORDER BY EventsCount DESC;
GO

-- 2. ���������� �� ��������
PRINT '2. ���������� �� ��������:';
GO
SELECT
    CONCAT(c.FName, ' ', c.MName, ' ', c.LName) AS CoachName,
    cc.CategoryName AS CoachCategory,
    COUNT(e.EventID) AS EventsCount,
    SUM(e.Duration) AS TotalMinutes,
    COUNT(DISTINCT p.PlayerID) AS UniquePlayers
FROM Events e
JOIN Coaches c ON e.CoachID = c.CoachID
JOIN CoachCategories cc ON c.CategoryID = cc.CategoryID
JOIN Players p ON e.PlayerID = p.PlayerID
GROUP BY CONCAT(c.FName, ' ', c.MName, ' ', c.LName), cc.CategoryName, c.CoachID
ORDER BY EventsCount DESC;
GO

-- 3. ���������� �� �������
PRINT '3. ���������� �� �������:';
GO
SELECT
    CONCAT(p.FName, ' ', p.MName, ' ', p.LName) AS PlayerName,
    pl.LevelName AS PlayerLevel,
    COUNT(e.EventID) AS EventsCount,
    SUM(e.Duration) AS TotalMinutes,
    SUM(pay.Amount) AS TotalPayments
FROM Players p
JOIN PlayerLevels pl ON p.LevelID = pl.LevelID
JOIN Events e ON p.PlayerID = e.PlayerID
JOIN Payments pay ON p.PlayerID = pay.PlayerID AND e.EventID = pay.EventID
GROUP BY CONCAT(p.FName, ' ', p.MName, ' ', p.LName), pl.LevelName, p.PlayerID
ORDER BY TotalPayments DESC;
GO
