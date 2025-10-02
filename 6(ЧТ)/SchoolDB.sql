CREATE DATABASE SchoolDB;
GO

USE SchoolDB;
GO

-- Проверка существования таблиц и их удаление, если они существуют
IF OBJECT_ID('Grades', 'U') IS NOT NULL DROP TABLE Grades;
IF OBJECT_ID('Schedule', 'U') IS NOT NULL DROP TABLE Schedule;
IF OBJECT_ID('Students', 'U') IS NOT NULL DROP TABLE Students;
IF OBJECT_ID('Teachers', 'U') IS NOT NULL DROP TABLE Teachers;
IF OBJECT_ID('Classes', 'U') IS NOT NULL DROP TABLE Classes;
IF OBJECT_ID('Subjects', 'U') IS NOT NULL DROP TABLE Subjects;
GO

-- Таблица "Предметы"
CREATE TABLE Subjects (
    SubjectID INT IDENTITY(1,1) PRIMARY KEY,
    SubjectName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500)
);
GO

-- Таблица "Классы"
CREATE TABLE Classes (
    ClassID INT IDENTITY(1,1) PRIMARY KEY,
    ClassName NVARCHAR(50) NOT NULL,
    Year INT NOT NULL
);
GO

-- Таблица "Учителя"
CREATE TABLE Teachers (
    TeacherID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    HireDate DATE,
    Position NVARCHAR(50)
);
GO

-- Таблица "Ученики"
CREATE TABLE Students (
    StudentID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    BirthDate DATE,
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    ClassID INT FOREIGN KEY REFERENCES Classes(ClassID),
    EnrollmentDate DATE
);
GO

-- Таблица "Расписание"
CREATE TABLE Schedule (
    ScheduleID INT IDENTITY(1,1) PRIMARY KEY,
    SubjectID INT FOREIGN KEY REFERENCES Subjects(SubjectID),
    TeacherID INT FOREIGN KEY REFERENCES Teachers(TeacherID),
    ClassID INT FOREIGN KEY REFERENCES Classes(ClassID),
    DayOfWeek NVARCHAR(20) NOT NULL,
    LessonTime TIME NOT NULL,
    Classroom NVARCHAR(20)
);
GO

-- Таблица "Оценки"
CREATE TABLE Grades (
    GradeID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
    SubjectID INT FOREIGN KEY REFERENCES Subjects(SubjectID),
    TeacherID INT FOREIGN KEY REFERENCES Teachers(TeacherID),
    Grade DECIMAL(3,1) CHECK (Grade BETWEEN 2 AND 5),
    GradeDate DATE,
    Semester INT
);
GO

-- Заполнение тестовыми данными
-- Предметы
INSERT INTO Subjects (SubjectName, Description) VALUES
('Математика', 'Алгебра и геометрия'),
('Русский язык', 'Грамматика и литература'),
('Физика', 'Основы физики'),
('Химия', 'Основы химии'),
('История', 'Всеобщая история'),
('Биология', 'Основы биологии'),
('Информатика', 'Основы программирования'),
('Физическая культура', 'Спорт и здоровье');
GO

-- Классы
INSERT INTO Classes (ClassName, Year) VALUES
('5А', 5),
('5Б', 5),
('10А', 10),
('11Б', 11);
GO

-- Учителя
INSERT INTO Teachers (FirstName, LastName, Email, Phone, HireDate, Position) VALUES
('Иван', 'Петров', 'ivan.petrov@school.ru', '+79001112233', '2010-09-01', 'Учитель математики'),
('Мария', 'Сидорова', 'maria.sidorova@school.ru', '+79002223344', '2012-09-01', 'Учитель русского языка'),
('Алексей', 'Козлов', 'alexey.kozlov@school.ru', '+79003334455', '2015-09-01', 'Учитель физики');
GO

-- Ученики
INSERT INTO Students (FirstName, LastName, BirthDate, Email, Phone, ClassID, EnrollmentDate) VALUES
('Анна', 'Иванова', '2010-05-15', 'anna.ivanova@school.ru', '+79004445566', 1, '2020-09-01'),
('Петр', 'Смирнов', '2011-08-20', 'petr.smirnov@school.ru', '+79005556677', 2, '2021-09-01'),
('Ольга', 'Кузнецова', '2005-03-10', 'olga.kuznetsova@school.ru', '+79006667788', 3, '2015-09-01');
GO

-- Расписание
INSERT INTO Schedule (SubjectID, TeacherID, ClassID, DayOfWeek, LessonTime, Classroom) VALUES
(1, 1, 1, 'Понедельник', '09:00:00', '101'),
(2, 2, 1, 'Понедельник', '10:00:00', '102'),
(3, 3, 3, 'Вторник', '09:00:00', '201');
GO

-- Оценки
INSERT INTO Grades (StudentID, SubjectID, TeacherID, Grade, GradeDate, Semester) VALUES
(1, 1, 1, 4.5, '2023-10-15', 1),
(1, 2, 2, 5.0, '2023-10-20', 1),
(2, 1, 1, 3.5, '2023-10-15', 1),
(3, 3, 3, 4.0, '2023-10-18', 1);
GO

-- Вложенные запросы
-- 1. Скалярный подзапрос: ученики со средним баллом выше общего среднего
SELECT
    s.FirstName,
    s.LastName,
    c.ClassName,
    (SELECT AVG(CAST(g2.Grade AS FLOAT)) FROM Grades g2 WHERE g2.StudentID = s.StudentID) AS AvgGrade
FROM Students s
JOIN Classes c ON s.ClassID = c.ClassID
WHERE (SELECT AVG(CAST(g.Grade AS FLOAT)) FROM Grades g WHERE g.StudentID = s.StudentID) >
      (SELECT AVG(CAST(Grade AS FLOAT)) FROM Grades)
ORDER BY AvgGrade DESC;
GO

-- 2. Табличный подзапрос с IN: учителя, которые ведут предмет "Математика"
SELECT DISTINCT
    t.FirstName,
    t.LastName,
    t.Position
FROM Teachers t
WHERE t.TeacherID IN (
    SELECT s.TeacherID
    FROM Schedule s
    JOIN Subjects sub ON s.SubjectID = sub.SubjectID
    WHERE sub.SubjectName = 'Математика'
);
GO

-- 3. Коррелированный подзапрос: ученики с оценками выше среднего по классу
SELECT
    s.FirstName,
    s.LastName,
    c.ClassName,
    g.Grade
FROM Students s
JOIN Classes c ON s.ClassID = c.ClassID
JOIN Grades g ON s.StudentID = g.StudentID
WHERE g.Grade > (
    SELECT AVG(CAST(g2.Grade AS FLOAT))
    FROM Grades g2
    JOIN Students s2 ON g2.StudentID = s2.StudentID
    WHERE s2.ClassID = s.ClassID
);
GO

-- 4. EXISTS: ученики, у которых есть оценки по физике
SELECT DISTINCT
    s.FirstName,
    s.LastName,
    c.ClassName
FROM Students s
JOIN Classes c ON s.ClassID = c.ClassID
WHERE EXISTS (
    SELECT 1
    FROM Grades g
    JOIN Subjects sub ON g.SubjectID = sub.SubjectID
    WHERE g.StudentID = s.StudentID
    AND sub.SubjectName = 'Физика'
);
GO

-- Курсоры
-- 1. Курсор: ученики и их средние оценки
DECLARE @StudentID INT, @FirstName NVARCHAR(50), @LastName NVARCHAR(50), @AvgGrade FLOAT;
DECLARE student_cursor CURSOR FOR
SELECT
    s.StudentID,
    s.FirstName,
    s.LastName,
    AVG(CAST(g.Grade AS FLOAT)) AS AvgGrade
FROM Students s
LEFT JOIN Grades g ON s.StudentID = g.StudentID
GROUP BY s.StudentID, s.FirstName, s.LastName
ORDER BY s.LastName;
OPEN student_cursor;
FETCH NEXT FROM student_cursor INTO @StudentID, @FirstName, @LastName, @AvgGrade;
WHILE @@FETCH_STATUS = 0
BEGIN
    FETCH NEXT FROM student_cursor INTO @StudentID, @FirstName, @LastName, @AvgGrade;
END;
CLOSE student_cursor;
DEALLOCATE student_cursor;
GO

-- 2. Вложенные курсоры: ученики по классам
DECLARE @ClassID INT, @ClassName NVARCHAR(50);
DECLARE @StFirstName NVARCHAR(50), @StLastName NVARCHAR(50), @StEmail NVARCHAR(100);
DECLARE class_cursor CURSOR FOR
SELECT ClassID, ClassName
FROM Classes
ORDER BY ClassName;
OPEN class_cursor;
FETCH NEXT FROM class_cursor INTO @ClassID, @ClassName;
WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE student_class_cursor CURSOR LOCAL FOR
    SELECT FirstName, LastName, Email
    FROM Students
    WHERE ClassID = @ClassID
    ORDER BY LastName;
    OPEN student_class_cursor;
    FETCH NEXT FROM student_class_cursor INTO @StFirstName, @StLastName, @StEmail;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        FETCH NEXT FROM student_class_cursor INTO @StFirstName, @StLastName, @StEmail;
    END;
    CLOSE student_class_cursor;
    DEALLOCATE student_class_cursor;
    FETCH NEXT FROM class_cursor INTO @ClassID, @ClassName;
END;
CLOSE class_cursor;
DEALLOCATE class_cursor;
GO

-- Создание индексов
CREATE INDEX IX_Students_ClassID ON Students(ClassID);
CREATE INDEX IX_Grades_StudentID ON Grades(StudentID);
CREATE INDEX IX_Grades_SubjectID ON Grades(SubjectID);
CREATE INDEX IX_Grades_Grade ON Grades(Grade);
CREATE INDEX IX_Schedule_TeacherID ON Schedule(TeacherID);
CREATE INDEX IX_Schedule_ClassID ON Schedule(ClassID);
GO
