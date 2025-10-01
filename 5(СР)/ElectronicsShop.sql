-- =============================================
-- �������� ��������� ���� ������
-- =============================================
USE ElectronicsShopDB;
GO

-- �������� ������� ��������� �������
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500)
);
GO

-- �������� ������� �����������
CREATE TABLE Suppliers (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    CompanyName NVARCHAR(100) NOT NULL,
    ContactName NVARCHAR(50),
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    City NVARCHAR(50)
);
GO

-- �������� ������� �������
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    CategoryID INT,
    SupplierID INT,
    Price DECIMAL(10,2) NOT NULL,
    UnitsInStock INT DEFAULT 0,
    Description NVARCHAR(500),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);
GO

-- �������� ������� ��������
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Phone NVARCHAR(20),
    City NVARCHAR(50),
    RegistrationDate DATETIME DEFAULT GETDATE()
);
GO

-- �������� ������� �������
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2),
    Status NVARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
GO

-- �������� ������� ������� �������
CREATE TABLE OrderDetails (
    OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- =============================================
-- ���������� ��������� �������
-- =============================================
-- ���������� ���������
INSERT INTO Categories (CategoryName, Description) VALUES
('���������', '��������� �������� � ����������'),
('��������', '����������� ����������'),
('��������', '���������� ����������'),
('��������', '����� ����������'),
('������� �������', '������� ���������');
GO

-- ���������� ������� ����������
INSERT INTO Suppliers (CompanyName, ContactName, Phone, Email, City) VALUES
('TechSupply Ltd', '���� ������', '+7-495-123-4567', 'ivan@techsupply.ru', '������'),
('ElectroWorld', '���� ��������', '+7-812-987-6543', 'anna@electroworld.ru', '���'),
('GadgetPro', '���� ������', '+7-495-555-0123', 'petr@gadgetpro.ru', '������'),
('MegaTech', '����� ��������', '+7-495-777-8888', 'elena@megatech.ru', '������');
GO

-- ���������� ������� ������
INSERT INTO Products (ProductName, CategoryID, SupplierID, Price, UnitsInStock, Description) VALUES
('iPhone 15 Pro', 1, 1, 89990.00, 15, '����������� �������� Apple'),
('Samsung Galaxy S24', 1, 2, 79990.00, 20, '����������� �������� Samsung'),
('MacBook Air M2', 2, 1, 119990.00, 8, '��������� Apple � ����������� M2'),
('Dell XPS 13', 2, 3, 99990.00, 12, '����������� ��������� Dell'),
('iPad Air', 3, 1, 59990.00, 25, '������� Apple �������� ������'),
('AirPods Pro', 4, 1, 24990.00, 50, '������������ �������� Apple'),
('Sony WH-1000XM5', 4, 4, 29990.00, 30, '����������� �������� � ���������������'),
('PlayStation 5', 5, 4, 54990.00, 5, '������� ������� Sony');
GO

-- ���������� ������� �������
INSERT INTO Customers (FirstName, LastName, Email, Phone, City) VALUES
('�������', '������', 'alexey.ivanov@email.com', '+7-915-123-4567', '������'),
('�����', '�������', 'maria.petrova@email.com', '+7-921-987-6543', '���'),
('�������', '�������', 'dmitry.sidorov@email.com', '+7-916-555-0123', '������'),
('����', '�������', 'anna.kozlova@email.com', '+7-495-777-8888', '������������'),
('������', '�������', 'sergey.smirnov@email.com', '+7-903-111-2222', '�����������');
GO

-- ���������� ������� ������
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount, Status) VALUES
(1, '2024-01-15', 89990.00, 'Completed'),
(2, '2024-01-16', 139980.00, 'Completed'),
(3, '2024-01-17', 119990.00, 'Pending'),
(1, '2024-01-18', 84980.00, 'Completed'),
(4, '2024-01-19', 54990.00, 'Processing');
GO

-- ���������� ������� ������������
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice) VALUES
(1, 1, 1, 89990.00),
(2, 2, 1, 79990.00),
(2, 6, 2, 24990.00),
(2, 5, 1, 59990.00),
(3, 3, 1, 119990.00),
(4, 6, 1, 24990.00),
(4, 7, 2, 29990.00),
(5, 8, 1, 54990.00);
GO

-- =============================================
-- ���� 1: ������� ������� (INNER JOIN)
-- =============================================
-- ������� 1.1: ������� ��� ������ � ���������� ���������
SELECT p.ProductName, c.CategoryName, p.Price
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID;
GO

-- ������� 1.2: �������� ������ � ����������� � �����������
SELECT p.ProductName, s.CompanyName, s.City, p.Price
FROM Products p
INNER JOIN Suppliers s ON p.SupplierID = s.SupplierID;
GO

-- ������� 1.3: ������� ������ � ������� ��������
SELECT o.OrderID, c.FirstName + ' ' + c.LastName AS CustomerName,
       o.OrderDate, o.TotalAmount, o.Status
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID;
GO

-- =============================================
-- ���� 2: LEFT JOIN �������
-- =============================================
-- ������� 2.1: �������� ��� ��������� � ���������� ������� � ������
SELECT c.CategoryName, COUNT(p.ProductID) as ProductCount
FROM Categories c
LEFT JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryID, c.CategoryName;
GO

-- ������� 2.2: ������� ���� �������� � �� ������ (������� �������� ��� �������)
SELECT c.FirstName + ' ' + c.LastName AS CustomerName,
       o.OrderID, o.OrderDate, o.TotalAmount
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
ORDER BY c.LastName;
GO

-- =============================================
-- ���� 3: RIGHT JOIN �������
-- =============================================
-- ������� 3.1: �������� ��� ������ � �� ������ (������� ������, ������� �� ����������)
SELECT p.ProductName, od.Quantity, od.UnitPrice, o.OrderDate
FROM OrderDetails od
RIGHT JOIN Products p ON od.ProductID = p.ProductID
LEFT JOIN Orders o ON od.OrderID = o.OrderID
ORDER BY p.ProductName;
GO

-- =============================================
-- ���� 4: FULL OUTER JOIN �������
-- =============================================
-- ������� 4.1: ������ ���������� ����������� � ������� ��������
SELECT COALESCE(s.City, c.City) as City,
       COUNT(DISTINCT s.SupplierID) as SuppliersCount,
       COUNT(DISTINCT c.CustomerID) as CustomersCount
FROM Suppliers s
FULL OUTER JOIN Customers c ON s.City = c.City
GROUP BY COALESCE(s.City, c.City);
GO

-- =============================================
-- ���� 5: ������������� JOIN
-- =============================================
-- ������� 5.1: ������ ���������� � �������
SELECT
    o.OrderID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    p.ProductName,
    cat.CategoryName,
    sup.CompanyName as SupplierName,
    od.Quantity,
    od.UnitPrice,
    od.Quantity * od.UnitPrice as LineTotal,
    o.OrderDate
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID
INNER JOIN Categories cat ON p.CategoryID = cat.CategoryID
INNER JOIN Suppliers sup ON p.SupplierID = sup.SupplierID
ORDER BY o.OrderID, od.OrderDetailID;
GO

-- ������� 5.2: ���-5 ����� ���������� �������
SELECT TOP 5
    p.ProductName,
    cat.CategoryName,
    SUM(od.Quantity) as TotalSold,
    SUM(od.Quantity * od.UnitPrice) as TotalRevenue
FROM Products p
INNER JOIN Categories cat ON p.CategoryID = cat.CategoryID
INNER JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName, cat.CategoryName
ORDER BY TotalSold DESC;
GO

-- =============================================
-- ���� 6: �������������� (SELF JOIN)
-- =============================================
-- ������� 6.1: ����� �������� �� ������ ������
SELECT
    c1.FirstName + ' ' + c1.LastName AS Customer1,
    c2.FirstName + ' ' + c2.LastName AS Customer2,
    c1.City
FROM Customers c1
INNER JOIN Customers c2 ON c1.City = c2.City AND c1.CustomerID < c2.CustomerID
ORDER BY c1.City;
GO

-- =============================================
-- ���� 7: ���������� ������� � JOIN
-- =============================================
-- ������� 7.1: ���������� �� �����������
SELECT
    s.CompanyName,
    COUNT(p.ProductID) as ProductsCount,
    AVG(p.Price) as AvgPrice,
    SUM(ISNULL(od.Quantity, 0)) as TotalSold
FROM Suppliers s
LEFT JOIN Products p ON s.SupplierID = p.SupplierID
LEFT JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY s.SupplierID, s.CompanyName
ORDER BY TotalSold DESC;
GO

-- ������� 7.2: ������ ������ �� �������
SELECT
    YEAR(o.OrderDate) as OrderYear,
    MONTH(o.OrderDate) as OrderMonth,
    COUNT(DISTINCT o.OrderID) as OrdersCount,
    COUNT(DISTINCT o.CustomerID) as UniqueCustomers,
    SUM(od.Quantity * od.UnitPrice) as TotalRevenue
FROM Orders o
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
ORDER BY OrderYear, OrderMonth;
GO
