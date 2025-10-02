USE master;
GO

-- �������� � �������� ���� ������, ���� ��� ����������
IF DB_ID('SportsSectionDB') IS NOT NULL
BEGIN
    ALTER DATABASE SportsSectionDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE SportsSectionDB;
END
GO

-- �������� ���� ������
CREATE DATABASE SportsSectionDB;
GO

USE SportsSectionDB;
GO

-- �������� � �������� �������, ���� ��� ����������
IF OBJECT_ID('Achievements_Denormalized', 'U') IS NOT NULL
    DROP TABLE Achievements_Denormalized;
GO

-- =============================================
-- 1. ����������������� ������� "���������� �����������"
-- =============================================
CREATE TABLE Achievements_Denormalized (
    AchievementID INT IDENTITY(1,1) PRIMARY KEY,
    AthleteInfo NVARCHAR(200),
    CoachInfo NVARCHAR(150),
    CompetitionInfo NVARCHAR(200),
    AchievementDate NVARCHAR(50),
    AchievementType NVARCHAR(100),
    AchievementPlace INT,
    TrainingInfo NVARCHAR(150),
    Comments NVARCHAR(500)
);
GO

-- ���������� ����������������� �������
INSERT INTO Achievements_Denormalized (
    AthleteInfo, CoachInfo, CompetitionInfo, AchievementDate, AchievementType,
    AchievementPlace, TrainingInfo, Comments
)
VALUES
('������ ���� ���������; 1995-05-15; �; 180; 75; ��������; ������: ���',
 '�������� ���� ����������; ��������; 15 ��� �����; ������ ������ ���������',
 '��������� ������; ������; 2025-10-10; 2025-10-15; ������� "�����������"',
 '2025-10-12',
 '1 �����; 50� ������� �����',
 1,
 '����������: 5 ��� � ������; �������������� ���������',
 '������ ������ ������� �� 0.5 �������'),

('������� ����� ��������; 2000-08-22; �; 170; 60; ˸���� ��������; ������: ��',
 '�������� ������� �������������; ˸���� ��������; 10 ��� �����; ������ 1 ���������',
 '����� ������; ������; 2025-10-18; 2025-10-20; ������� "�������"',
 '2025-10-19',
 '2 �����; 100�',
 2,
 '����������: 6 ��� � ������; ��������� �������',
 '��������� ������� ����'),

('������� ������� ������������; 1998-11-30; �; 175; 70; ����; ������: ���',
 '��������� ����� ��������; ����; 20 ��� �����; ����������� ������ ������',
 '���������� ����; ������������; 2025-11-05; 2025-11-10; ������ ������ "����"',
 '2025-11-08',
 '3 �����; ������� ��������� �� 70 ��',
 3,
 '����������: 6 ��� � ������; ��������� 3 ���� � ������',
 '���������� � ���������������� ����');
GO

-- �������� ����������������� ������
SELECT * FROM Achievements_Denormalized;
GO

-- �������� � �������� �������, ���� ��� ����������
IF OBJECT_ID('Achievements_1NF', 'U') IS NOT NULL
    DROP TABLE Achievements_1NF;
GO

-- =============================================
-- 2. ������������ �� 1��
-- =============================================
CREATE TABLE Achievements_1NF (
    RecordID INT IDENTITY(1,1) PRIMARY KEY,
    AchievementID INT,
    AthleteFName NVARCHAR(50),
    AthleteMName NVARCHAR(50),
    AthleteLName NVARCHAR(50),
    AthleteBirthDate DATE,
    AthleteGender NVARCHAR(1),
    AthleteHeight INT,
    AthleteWeight INT,
    AthleteSport NVARCHAR(50),
    AthleteRank NVARCHAR(50),
    CoachFName NVARCHAR(50),
    CoachMName NVARCHAR(50),
    CoachLName NVARCHAR(50),
    CoachSport NVARCHAR(50),
    CoachExperience INT,
    CoachCategory NVARCHAR(100),
    CompetitionName NVARCHAR(100),
    CompetitionCity NVARCHAR(100),
    CompetitionStartDate DATE,
    CompetitionEndDate DATE,
    CompetitionVenue NVARCHAR(100),
    AchievementDate DATE,
    AchievementType NVARCHAR(100),
    AchievementPlace INT,
    TrainingFrequency NVARCHAR(50),
    TrainingProgram NVARCHAR(100),
    Comments NVARCHAR(500)
);
GO

-- ���������� ������� � 1��
INSERT INTO Achievements_1NF (
    AchievementID, AthleteFName, AthleteMName, AthleteLName, AthleteBirthDate, AthleteGender,
    AthleteHeight, AthleteWeight, AthleteSport, AthleteRank, CoachFName, CoachMName, CoachLName,
    CoachSport, CoachExperience, CoachCategory, CompetitionName, CompetitionCity,
    CompetitionStartDate, CompetitionEndDate, CompetitionVenue, AchievementDate,
    AchievementType, AchievementPlace, TrainingFrequency, TrainingProgram, Comments
)
SELECT
    AchievementID,
    PARSENAME(REPLACE(AthleteInfo, '; ', '.'), 3) AS AthleteFName,
    PARSENAME(REPLACE(AthleteInfo, '; ', '.'), 2) AS AthleteMName,
    PARSENAME(REPLACE(AthleteInfo, '; ', '.'), 1) AS AthleteLName,
    CAST(PARSENAME(REPLACE(AthleteInfo, '; ', '.'), 4) AS DATE) AS AthleteBirthDate,
    PARSENAME(REPLACE(AthleteInfo, '; ', '.'), 5) AS AthleteGender,
    CAST(PARSENAME(REPLACE(AthleteInfo, '; ', '.'), 6) AS INT) AS AthleteHeight,
    CAST(PARSENAME(REPLACE(AthleteInfo, '; ', '.'), 7) AS INT) AS AthleteWeight,
    PARSENAME(REPLACE(AthleteInfo, '; ', '.'), 8) AS AthleteSport,
    PARSENAME(REPLACE(AthleteInfo, '; ', '.'), 9) AS AthleteRank,
    PARSENAME(REPLACE(CoachInfo, '; ', '.'), 1) AS CoachFName,
    PARSENAME(REPLACE(CoachInfo, '; ', '.'), 2) AS CoachMName,
    PARSENAME(REPLACE(CoachInfo, '; ', '.'), 3) AS CoachLName,
    PARSENAME(REPLACE(CoachInfo, '; ', '.'), 4) AS CoachSport,
    CAST(PARSENAME(REPLACE(CoachInfo, '; ', '.'), 5) AS INT) AS CoachExperience,
    PARSENAME(REPLACE(CoachInfo, '; ', '.'), 6) AS CoachCategory,
    PARSENAME(REPLACE(CompetitionInfo, '; ', '.'), 1) AS CompetitionName,
    PARSENAME(REPLACE(CompetitionInfo, '; ', '.'), 2) AS CompetitionCity,
    CAST(PARSENAME(REPLACE(CompetitionInfo, '; ', '.'), 3) AS DATE) AS CompetitionStartDate,
    CAST(PARSENAME(REPLACE(CompetitionInfo, '; ', '.'), 4) AS DATE) AS CompetitionEndDate,
    PARSENAME(REPLACE(CompetitionInfo, '; ', '.'), 5) AS CompetitionVenue,
    CAST(AchievementDate AS DATE) AS AchievementDate,
    PARSENAME(REPLACE(AchievementType, '; ', '.'), 1) AS AchievementType,
    CAST(PARSENAME(REPLACE(AchievementType, '; ', '.'), 2) AS INT) AS AchievementPlace,
    PARSENAME(REPLACE(TrainingInfo, '; ', '.'), 1) AS TrainingFrequency,
    PARSENAME(REPLACE(TrainingInfo, '; ', '.'), 2) AS TrainingProgram,
    Comments
FROM Achievements_Denormalized;
GO

-- �������� ������ � 1��
SELECT * FROM Achievements_1NF;
GO

-- �������� � �������� ������, ���� ��� ����������
IF OBJECT_ID('Sports', 'U') IS NOT NULL DROP TABLE Sports;
IF OBJECT_ID('Ranks', 'U') IS NOT NULL DROP TABLE Ranks;
IF OBJECT_ID('CoachCategories', 'U') IS NOT NULL DROP TABLE CoachCategories;
IF OBJECT_ID('Athletes', 'U') IS NOT NULL DROP TABLE Athletes;
IF OBJECT_ID('Coaches', 'U') IS NOT NULL DROP TABLE Coaches;
IF OBJECT_ID('Competitions', 'U') IS NOT NULL DROP TABLE Competitions;
IF OBJECT_ID('Achievements', 'U') IS NOT NULL DROP TABLE Achievements;
GO

-- =============================================
-- 3. ������������ �� 3�� (�������� ���������� ������)
-- =============================================
-- 1. ���� ������
CREATE TABLE Sports (
    SportID INT IDENTITY(1,1) PRIMARY KEY,
    SportName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 2. ������� �����������
CREATE TABLE Ranks (
    RankID INT IDENTITY(1,1) PRIMARY KEY,
    RankName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 3. ��������� ��������
CREATE TABLE CoachCategories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(200)
);
GO

-- 4. ����������
CREATE TABLE Athletes (
    AthleteID INT IDENTITY(1,1) PRIMARY KEY,
    FName NVARCHAR(50) NOT NULL,
    MName NVARCHAR(50),
    LName NVARCHAR(50) NOT NULL,
    BirthDate DATE,
    Gender NVARCHAR(1),
    Height INT,
    Weight INT,
    SportID INT NOT NULL,
    RankID INT NOT NULL,
    FOREIGN KEY (SportID) REFERENCES Sports(SportID),
    FOREIGN KEY (RankID) REFERENCES Ranks(RankID)
);
GO

-- 5. �������
CREATE TABLE Coaches (
    CoachID INT IDENTITY(1,1) PRIMARY KEY,
    FName NVARCHAR(50) NOT NULL,
    MName NVARCHAR(50),
    LName NVARCHAR(50) NOT NULL,
    SportID INT NOT NULL,
    ExperienceYears INT,
    CategoryID INT NOT NULL,
    FOREIGN KEY (SportID) REFERENCES Sports(SportID),
    FOREIGN KEY (CategoryID) REFERENCES CoachCategories(CategoryID)
);
GO

-- 6. ������������
CREATE TABLE Competitions (
    CompetitionID INT IDENTITY(1,1) PRIMARY KEY,
    CompetitionName NVARCHAR(100) NOT NULL,
    City NVARCHAR(100),
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    Venue NVARCHAR(100)
);
GO

-- 7. ����������
CREATE TABLE Achievements (
    AchievementID INT IDENTITY(1,1) PRIMARY KEY,
    AthleteID INT NOT NULL,
    CoachID INT NOT NULL,
    CompetitionID INT NOT NULL,
    AchievementDate DATE NOT NULL,
    AchievementType NVARCHAR(100) NOT NULL,
    AchievementPlace INT,
    Comments NVARCHAR(500),
    FOREIGN KEY (AthleteID) REFERENCES Athletes(AthleteID),
    FOREIGN KEY (CoachID) REFERENCES Coaches(CoachID),
    FOREIGN KEY (CompetitionID) REFERENCES Competitions(CompetitionID)
);
GO

-- ���������� ���������� ������
INSERT INTO Sports (SportName, Description)
VALUES
('��������', '������������ ���� ������'),
('˸���� ��������', '���, ������ � �������'),
('����', '������ ������������');
GO

INSERT INTO Ranks (RankName, Description)
VALUES
('���', '�������� � ������� ������'),
('��', '������ ������'),
('���', '����������� ������ ������');
GO

INSERT INTO CoachCategories (CategoryName, Description)
VALUES
('������ ������ ���������', '������ ���������������� ���������'),
('������ 1 ���������', '������ ���������������� ���������'),
('����������� ������ ������', '�������� ������');
GO

-- ���������� �������� ������
INSERT INTO Athletes (FName, MName, LName, BirthDate, Gender, Height, Weight, SportID, RankID)
VALUES
('����', '���������', '������', '1995-05-15', '�', 180, 75, 1, 1),
('�����', '��������', '�������', '2000-08-22', '�', 170, 60, 2, 2),
('�������', '������������', '�������', '1998-11-30', '�', 175, 70, 3, 3);
GO

INSERT INTO Coaches (FName, MName, LName, SportID, ExperienceYears, CategoryID)
VALUES
('����', '����������', '��������', 1, 15, 1),
('�������', '�������������', '��������', 2, 10, 2),
('�����', '��������', '���������', 3, 20, 3);
GO

INSERT INTO Competitions (CompetitionName, City, StartDate, EndDate, Venue)
VALUES
('��������� ������', '������', '2025-10-10', '2025-10-15', '������� "�����������"'),
('����� ������', '������', '2025-10-18', '2025-10-20', '������� "�������"'),
('���������� ����', '������������', '2025-11-05', '2025-11-10', '������ ������ "����"');
GO

INSERT INTO Achievements (AthleteID, CoachID, CompetitionID, AchievementDate, AchievementType, AchievementPlace, Comments)
VALUES
(1, 1, 1, '2025-10-12', '1 �����; 50� ������� �����', 1, '������ ������ ������� �� 0.5 �������'),
(2, 2, 2, '2025-10-19', '2 �����; 100�', 2, '��������� ������� ����'),
(3, 3, 3, '2025-11-08', '3 �����; ������� ��������� �� 70 ��', 3, '���������� � ���������������� ����');
GO

-- =============================================
-- 4. ������������� �������
-- =============================================
-- 1. ������������ ����� ������
PRINT '1. ������������ ����� ������:';
GO
SELECT
    s.SportName,
    COUNT(a.AchievementID) AS AchievementsCount,
    COUNT(DISTINCT a.AthleteID) AS AthletesCount
FROM Achievements a
JOIN Athletes ath ON a.AthleteID = ath.AthleteID
JOIN Sports s ON ath.SportID = s.SportID
GROUP BY s.SportName
ORDER BY AchievementsCount DESC;
GO

-- 2. ���������� �� ��������
PRINT '2. ���������� �� ��������:';
GO
SELECT
    CONCAT(c.FName, ' ', c.MName, ' ', c.LName) AS CoachName,
    s.SportName,
    cc.CategoryName,
    COUNT(a.AchievementID) AS AchievementsCount,
    COUNT(DISTINCT a.AthleteID) AS AthletesCount
FROM Achievements a
JOIN Coaches c ON a.CoachID = c.CoachID
JOIN Sports s ON c.SportID = s.SportID
JOIN CoachCategories cc ON c.CategoryID = cc.CategoryID
GROUP BY CONCAT(c.FName, ' ', c.MName, ' ', c.LName), s.SportName, cc.CategoryName, c.CoachID
ORDER BY AchievementsCount DESC;
GO

-- 3. ���������� �� �������������
PRINT '3. ���������� �� �������������:';
GO
SELECT
    comp.CompetitionName,
    comp.City,
    COUNT(a.AchievementID) AS AchievementsCount,
    COUNT(DISTINCT a.AthleteID) AS AthletesCount
FROM Achievements a
JOIN Competitions comp ON a.CompetitionID = comp.CompetitionID
GROUP BY comp.CompetitionName, comp.City
ORDER BY AchievementsCount DESC;
GO
�