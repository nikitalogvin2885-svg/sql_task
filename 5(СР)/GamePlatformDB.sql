USE master;
GO

-- �������� ���� ������ ��� ������� ���������
IF DB_ID('GamePlatformDB') IS NULL
    CREATE DATABASE GamePlatformDB;
GO

USE GamePlatformDB;
GO

-- �������� ������������ ������, ���� ��� ����
IF OBJECT_ID('PlayerAchievements', 'U') IS NOT NULL DROP TABLE PlayerAchievements;
IF OBJECT_ID('TeamMembers', 'U') IS NOT NULL DROP TABLE TeamMembers;
IF OBJECT_ID('TournamentTeams', 'U') IS NOT NULL DROP TABLE TournamentTeams;
IF OBJECT_ID('Achievements', 'U') IS NOT NULL DROP TABLE Achievements;
IF OBJECT_ID('Tournaments', 'U') IS NOT NULL DROP TABLE Tournaments;
IF OBJECT_ID('Teams', 'U') IS NOT NULL DROP TABLE Teams;
IF OBJECT_ID('Games', 'U') IS NOT NULL DROP TABLE Games;
IF OBJECT_ID('Players', 'U') IS NOT NULL DROP TABLE Players;
GO

-- ������� ������
CREATE TABLE Players (
    PlayerID INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    RegistrationDate DATETIME NOT NULL DEFAULT GETDATE(),
    Level INT NOT NULL DEFAULT 1 CHECK (Level > 0),
    ExperiencePoints INT NOT NULL DEFAULT 0 CHECK (ExperiencePoints >= 0),
    Country NVARCHAR(50)
);
GO

-- ������� ����
CREATE TABLE Games (
    GameID INT IDENTITY(1,1) PRIMARY KEY,
    GameName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    ReleaseDate DATE NOT NULL,
    Developer NVARCHAR(100) NOT NULL,
    Genre NVARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0),
    Rating DECIMAL(3,1) CHECK (Rating BETWEEN 0 AND 10)
);
GO

-- ������� �������
CREATE TABLE Teams (
    TeamID INT IDENTITY(1,1) PRIMARY KEY,
    TeamName NVARCHAR(100) NOT NULL UNIQUE,
    GameID INT NOT NULL,
    CreationDate DATETIME NOT NULL DEFAULT GETDATE(),
    LeaderID INT NOT NULL,
    Description NVARCHAR(255),
    FOREIGN KEY (GameID) REFERENCES Games(GameID),
    FOREIGN KEY (LeaderID) REFERENCES Players(PlayerID)
);
GO

-- ������� �������
CREATE TABLE Tournaments (
    TournamentID INT IDENTITY(1,1) PRIMARY KEY,
    TournamentName NVARCHAR(100) NOT NULL,
    GameID INT NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NOT NULL,
    PrizePool DECIMAL(10,2) NOT NULL CHECK (PrizePool > 0),
    MaxTeams INT NOT NULL CHECK (MaxTeams > 0),
    Description NVARCHAR(255),
    FOREIGN KEY (GameID) REFERENCES Games(GameID)
);
GO

-- ������� ����������
CREATE TABLE Achievements (
    AchievementID INT IDENTITY(1,1) PRIMARY KEY,
    AchievementName NVARCHAR(100) NOT NULL,
    GameID INT NOT NULL,
    Description NVARCHAR(255),
    Points INT NOT NULL CHECK (Points > 0),
    FOREIGN KEY (GameID) REFERENCES Games(GameID)
);
GO

-- ������� ��� ����� ������� � �� ����������
CREATE TABLE PlayerAchievements (
    PlayerAchievementID INT IDENTITY(1,1) PRIMARY KEY,
    PlayerID INT NOT NULL,
    AchievementID INT NOT NULL,
    AchievementDate DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID),
    FOREIGN KEY (AchievementID) REFERENCES Achievements(AchievementID)
);
GO

-- ������� ��� ����� ������� � ������
CREATE TABLE TeamMembers (
    TeamMemberID INT IDENTITY(1,1) PRIMARY KEY,
    TeamID INT NOT NULL,
    PlayerID INT NOT NULL,
    JoinDate DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID),
    FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID)
);
GO

-- ������� ��� ����� ������ � ��������
CREATE TABLE TournamentTeams (
    TournamentTeamID INT IDENTITY(1,1) PRIMARY KEY,
    TournamentID INT NOT NULL,
    TeamID INT NOT NULL,
    RegistrationDate DATETIME NOT NULL DEFAULT GETDATE(),
    Place INT,
    FOREIGN KEY (TournamentID) REFERENCES Tournaments(TournamentID),
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID)
);
GO

-- ���������� ������ ��������� �������
-- ������
INSERT INTO Players (Username, FirstName, LastName, Email, RegistrationDate, Level, ExperiencePoints, Country) VALUES
('Gamer1', '����', '������', 'ivan.ivanov@email.com', '2023-01-15 10:00:00', 10, 5000, '������'),
('Gamer2', '�����', '�������', 'maria.petrova@email.com', '2023-02-20 11:00:00', 15, 8000, '������'),
('Gamer3', '�������', '�������', 'alexey.sidorov@email.com', '2023-03-10 12:00:00', 8, 3500, '�������'),
('Gamer4', '����', '�������', 'anna.kozlova@email.com', '2023-04-05 13:00:00', 12, 6000, '��������'),
('Gamer5', '�������', '�������', 'dmitry.smirnov@email.com', '2023-05-18 14:00:00', 20, 12000, '���������');
GO

-- ����
INSERT INTO Games (GameName, Description, ReleaseDate, Developer, Genre, Price, Rating) VALUES
('StarCraft II', '��������� � �������� �������', '2010-07-27', 'Blizzard Entertainment', '���������', 29.99, 9.2),
('Dota 2', '��������������������� ������-���� � ����� MOBA', '2013-07-09', 'Valve Corporation', 'MOBA', 0.00, 8.9),
('Counter-Strike: Global Offensive', '��������������������� ����� �� ������� ����', '2012-08-21', 'Valve Corporation', '�����', 0.00, 8.5),
('World of Warcraft', '������ � ����������� ����', '2004-11-23', 'Blizzard Entertainment', 'MMORPG', 14.99, 8.7),
('League of Legends', '��������������������� ������-���� � ����� MOBA', '2009-10-27', 'Riot Games', 'MOBA', 0.00, 8.8);
GO

-- �������
INSERT INTO Teams (TeamName, GameID, CreationDate, LeaderID, Description) VALUES
('Team Elite', 1, '2023-01-20 15:00:00', 1, '���������������� ������� �� StarCraft II'),
('Victory', 2, '2023-02-15 16:00:00', 2, '������� �� Dota 2'),
('Strike', 3, '2023-03-10 17:00:00', 3, '������� �� CS:GO'),
('Mythic', 4, '2023-04-05 18:00:00', 4, '������� � World of Warcraft'),
('Legends', 5, '2023-05-18 19:00:00', 5, '������� �� League of Legends');
GO

-- �������
INSERT INTO Tournaments (TournamentName, GameID, StartDate, EndDate, PrizePool, MaxTeams, Description) VALUES
('StarCraft II Championship', 1, '2023-11-01 09:00:00', '2023-11-10 18:00:00', 10000.00, 16, '��������� ��������� �� StarCraft II'),
('Dota 2 Invitational', 2, '2023-12-05 10:00:00', '2023-12-15 19:00:00', 25000.00, 24, '��������������� ������ �� Dota 2'),
('CS:GO Major', 3, '2024-01-10 11:00:00', '2024-01-20 20:00:00', 50000.00, 24, '������� ������ �� CS:GO'),
('WoW Arena Tournament', 4, '2024-02-05 12:00:00', '2024-02-15 21:00:00', 5000.00, 32, '������ �� ������ � World of Warcraft'),
('LoL World Series', 5, '2024-03-01 13:00:00', '2024-03-20 22:00:00', 100000.00, 32, '������� ������ �� League of Legends');
GO

-- ����������
INSERT INTO Achievements (AchievementName, GameID, Description, Points) VALUES
('Master of StarCraft', 1, '������ � 100 ������', 100),
('Dota 2 Champion', 2, '������ � �������', 200),
('CS:GO Legend', 3, '1000 �������', 150),
('WoW Hero', 4, '������ ��� ��������� ������', 250),
('LoL Master', 5, '���������� ������ ����', 180);
GO

-- ���������� �������
INSERT INTO PlayerAchievements (PlayerID, AchievementID, AchievementDate) VALUES
(1, 1, '2023-06-15 10:00:00'),
(2, 2, '2023-07-20 11:00:00'),
(3, 3, '2023-08-10 12:00:00'),
(4, 4, '2023-09-05 13:00:00'),
(5, 5, '2023-10-18 14:00:00');
GO

-- ��������� ������
INSERT INTO TeamMembers (TeamID, PlayerID, JoinDate) VALUES
(1, 1, '2023-01-20 15:00:00'),
(2, 2, '2023-02-15 16:00:00'),
(3, 3, '2023-03-10 17:00:00'),
(4, 4, '2023-04-05 18:00:00'),
(5, 5, '2023-05-18 19:00:00');
GO

-- ������� �� ��������
INSERT INTO TournamentTeams (TournamentID, TeamID, RegistrationDate, Place) VALUES
(1, 1, '2023-10-01 10:00:00', 1),
(2, 2, '2023-11-05 11:00:00', 3),
(3, 3, '2023-12-10 12:00:00', NULL),
(4, 4, '2024-01-05 13:00:00', NULL),
(5, 5, '2024-02-18 14:00:00', NULL);
GO

-- ������� ��������
-- ������� 1: ������ ������� � �� ������� � ������
SELECT PlayerID, Username, FirstName, LastName, Level, ExperiencePoints, Country
FROM Players;
GO

-- ������� 2: ������ ��� � �� ������� � ����������
SELECT GameID, GameName, Developer, Genre, Price, Rating
FROM Games;
GO

-- ������� 3: ������ ������ � ��������� ���� � ������
SELECT t.TeamID, t.TeamName, g.GameName, p.Username AS LeaderUsername
FROM Teams t
INNER JOIN Games g ON t.GameID = g.GameID
INNER JOIN Players p ON t.LeaderID = p.PlayerID;
GO

-- ������� 4: ������ �������� � ��������� ���� � ��������� �����
SELECT TournamentID, TournamentName, g.GameName, StartDate, EndDate, PrizePool, MaxTeams
FROM Tournaments t
INNER JOIN Games g ON t.GameID = g.GameID;
GO

-- ������� 5: ������ ���������� �������
SELECT pa.PlayerAchievementID, p.Username, a.AchievementName, g.GameName, pa.AchievementDate, a.Points
FROM PlayerAchievements pa
INNER JOIN Players p ON pa.PlayerID = p.PlayerID
INNER JOIN Achievements a ON pa.AchievementID = a.AchievementID
INNER JOIN Games g ON a.GameID = g.GameID;
GO

-- ������� 6: ������ ������ � �� ����������
SELECT t.TeamName, p.Username, p.FirstName, p.LastName, tm.JoinDate
FROM TeamMembers tm
INNER JOIN Teams t ON tm.TeamID = t.TeamID
INNER JOIN Players p ON tm.PlayerID = p.PlayerID;
GO

-- ������� 7: �������, ����������� � ��������
SELECT t.TournamentName, tm.TeamName, tt.RegistrationDate, tt.Place
FROM TournamentTeams tt
INNER JOIN Tournaments t ON tt.TournamentID = t.TournamentID
INNER JOIN Teams tm ON tt.TeamID = tm.TeamID;
GO
