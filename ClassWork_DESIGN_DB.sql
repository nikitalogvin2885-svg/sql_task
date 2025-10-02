USE ShopDB;
GO

-- �������� ������� Customers
CREATE TABLE Customers (
    CustomerNo INT IDENTITY PRIMARY KEY,
    FName NVARCHAR(15) NOT NULL,
    LName NVARCHAR(15) NOT NULL,
    MName NVARCHAR(15) NULL,
    Address1 NVARCHAR(50) NOT NULL,
    Address2 NVARCHAR(50) NULL,
    City NCHAR(10) NOT NULL,
    Phone CHAR(12) NOT NULL UNIQUE,
    DateInSystem DATE NULL,
    CHECK (Phone LIKE '([0-9][0-9][0-9])[0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);
GO

-- �������� ������� Employees
CREATE TABLE Employees (
    EmployeeID INT IDENTITY PRIMARY KEY,
    FName NVARCHAR(15) NOT NULL,
    LName NVARCHAR(15) NOT NULL,
    MName NVARCHAR(15) NOT NULL,
    Salary MONEY NOT NULL,
    PriorSalary MONEY NOT NULL,
    HireDate DATE NOT NULL,
    TerminationDate DATE NULL,
    ManagerEmpID INT NULL,
    FOREIGN KEY (ManagerEmpID) REFERENCES Employees(EmployeeID)
);
GO

-- �������� ������� Products
CREATE TABLE Products (
    ProdID INT PRIMARY KEY,
    Description NCHAR(50),
    UnitPrice MONEY NOT NULL,
    Weight NUMERIC(18, 0) NULL
);
GO

-- �������� ������� Orders
CREATE TABLE Orders (
    OrderID INT IDENTITY PRIMARY KEY,
    CustomerNo INT NOT NULL,
    OrderDate DATE NOT NULL,
    EmployeeID INT NOT NULL,
    FOREIGN KEY (CustomerNo) REFERENCES Customers(CustomerNo),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
GO

-- �������� ������� OrderDetails
CREATE TABLE OrderDetails (
    OrderID INT NOT NULL,
    LineItem INT NOT NULL,
    ProdID INT NOT NULL,
    Qty INT NOT NULL,
    UnitPrice MONEY NOT NULL,
    PRIMARY KEY (OrderID, LineItem),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProdID) REFERENCES Products(ProdID)
);
GO

-- ���������� ������� Employees
INSERT INTO Employees (FName, LName, MName, Salary, PriorSalary, HireDate, TerminationDate, ManagerEmpID)
VALUES
('����', '��������', '��������', 2000, 0, '2009-11-20', NULL, NULL),
('��������', '��������', '���������', 800, 0, '2009-11-20', NULL, 1);
GO

-- ���������� ������� Customers
INSERT INTO Customers (FName, LName, MName, Address1, Address2, City, Phone, DateInSystem)
VALUES
('�������', '�������', '��������', '������ 15', NULL, '�������', '(092)3212211', '2009-11-20'),
('�������', '������', '���������', '������������ 5', NULL, '����', '(092)7612343', '2010-08-17'),
('����', '��������', '�����������', '�������� 5', NULL, '��������', '(044)2134212', '2010-09-18');
GO

-- ���������� ������� Products
INSERT INTO Products (ProdID, Description, UnitPrice, Weight)
VALUES
(1, '������', 45, 2),
(2, '������', 30, 1),
(3, '�����', 32, 1),
(4, '��������', 20, 2),
(5, '�����', 26, 2);
GO

-- ���������� ������� Orders
INSERT INTO Orders (CustomerNo, OrderDate, EmployeeID)
VALUES
(1, '2009-12-28', 1),
(2, '2010-09-01', 2),
(3, '2010-09-18', 2);
GO

-- ���������� ������� OrderDetails
INSERT INTO OrderDetails (OrderID, LineItem, ProdID, Qty, UnitPrice)
VALUES
(1, 1, 1, 5, 45),
(1, 2, 2, 5, 30),
(1, 3, 5, 5, 26),
(2, 1, 3, 10, 32),
(2, 2, 4, 15, 20),
(3, 1, 5, 20, 26),
(3, 2, 3, 18, 32);
GO

-- �������� ������
SELECT * FROM Customers;
SELECT * FROM Employees;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM OrderDetails;