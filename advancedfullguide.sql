-- no 1
SELECT CustomerName, CustomerEmail, [Total Price] = sum(ProductPrice * Quantity)
FROM Customer c 
join HeaderTransaction ht on c.CustomerId = ht.CustomerId 
join DetailTransaction dt on ht.TransactionId = dt.TransactionId
join Product p on p.ProductId = dt.ProductId
WHERE DATEDIFF(year, '2020-05-03', CustomerDOB) < -23
GROUP BY CustomerName, CustomerEmail
HAVING sum(ProductPrice * Quantity) > 35000000

--SELECT CustomerName, CustomerDOB From Customer

--no 2
SELECT TOP 3 ProductName, [Total] = sum(ProductPrice * Quantity) 
FROM Product p 
join ProductType pt on  p.ProductTypeId = pt.ProductTypeId
join DetailTransaction dt on p.ProductId = dt.ProductId
WHERE ProductTypeName = 'Watches' 
GROUP BY ProductName
UNION
SELECT * FROM
(SELECT TOP 3 ProductName, [Total] = sum(ProductPrice * Quantity)
FROM Product p 
join ProductType pt on  p.ProductTypeId = pt.ProductTypeId
join DetailTransaction dt on p.ProductId = dt.ProductId
WHERE ProductTypeName = 'Jewelry'
GROUP BY ProductName
ORDER BY sum(ProductPrice * Quantity) DESC) b 

--no 3
SELECT ProductName, ProductTypeName, ProductPrice
FROM Product p
join ProductType pt on  p.ProductTypeId = pt.ProductTypeId
WHERE ProductId in(
    SELECT ProductId
	FROM DetailTransaction
	WHERE Quantity > 3
) and ProductName LIKE '% % Earrings'

-- no 4
CREATE VIEW [CustomerData] as
SELECT CustomerName, CustomerDOB, CustomerGender, CustomerEmail 
FROM Customer 
WHERE datepart(year, CustomerDOB) <= 1995 and CustomerEmail LIKE '%@gmail.com'

--no 5
CREATE VIEW [LastThreeMonthsTransaction] as
SELECT TransactionDate, [Total Income] = sum(ProductPrice * Quantity)
FROM Product p 
join DetailTransaction dt on p.ProductId = dt.ProductId
join HeaderTransaction ht on ht.TransactionId = dt.TransactionId
WHERE DATEDIFF(month, '2020-04-28', TransactionDate) > -3
GROUP BY TransactionDate
HAVING sum(ProductPrice * Quantity) > 10000000  

--no 6
SELECT [ID] = REPLACE(TransactionId,'TA','Transaction '), TransactionDate, CustomerName
FROM HeaderTransaction ht
join Customer c on c.CustomerId = ht.CustomerId
join Staff s on s.StaffId = ht.StaffId,
(
   SELECT [avg] = AVG(StaffSalary)
   FROM Staff
) as average
WHERE StaffSalary < average.[avg] AND DATEPART(day, TransactionDate) = 05

--no 7
CREATE PROCEDURE [ViewMonthlyReport] @Month nvarchar(30) AS
SELECT TransactionDate, [Total Income] = sum(ProductPrice * Quantity), [Total Transaction] = count(ht.TransactionId), [Average Income] = AVG(ProductPrice * Quantity)
FROM Product p 
join DetailTransaction dt on p.ProductId = dt.ProductId
join HeaderTransaction ht on ht.TransactionId = dt.TransactionId
WHERE datename(month, TransactionDate) = @Month
GROUP BY TransactionDate

EXEC ViewMonthlyReport 'January'

--no 8
CREATE PROCEDURE [UpdateStock] @ProductId nvarchar(30), @Jumlah int AS
BEGIN
	DECLARE @compare varchar(30)
	SELECT
		@compare = ProductId
	FROM
		Product
	
	IF @compare = @ProductId
	BEGIN
		UPDATE Product
		SET ProductStock = ProductStock + @Jumlah
		WHERE ProductId = @ProductId
		PRINT 'Selected product’s stock has been updated.'
	END
	ELSE
	BEGIN
		PRINT 'Product doesn’t exists.'
	END
END



--DROP PROCEDURE UpdateStock

EXEC UpdateStock 'PD020', 2
SELECT * FROM Product WHERE ProductId = 'PD020'

-- no 9
CREATE PROCEDURE [TransactionReport] 
@nomor varchar(30) 
AS
DECLARE @TotalSales INT
DECLARE @TotalTrans INT
DECLARE @NamaProduk varchar(MAX)
DECLARE @Kuantitas INT
DECLARE @TipeProduct varchar(30)
DECLARE @HargaProduct INT
DECLARE @Total INT
DECLARE @Tanggal DATETIME
DECLARE @Nama varchar(Max)
SELECT @Tanggal = TransactionDate, @Nama = CustomerName
FROM HeaderTransaction ht 
JOIN Customer c ON ht.CustomerId = c.CustomerId
WHERE TransactionId = @nomor
BEGIN
	PRINT 'Transaction Report'
	PRINT '------------------'
	PRINT 'Transaction Date	: ' + CONVERT(CHAR(10),@Tanggal,105)
	PRINT 'Customer			: ' + @Nama
	PRINT ''
END
DECLARE db CURSOR FOR
SELECT ProductName, Quantity, ProductTypeName, ProductPrice, 
[Total] = sum(ProductPrice * Quantity),
[TotalTrans] = count(TransactionId) 
FROM DetailTransaction dt
JOIN Product p ON dt.ProductId = p.ProductId
JOIN ProductType pt on p.ProductTypeId = pt.ProductTypeId
WHERE TransactionId = @nomor
GROUP BY p.ProductId,ProductName, Quantity, ProductTypeName,ProductPrice
OPEN db
FETCH NEXT FROM db INTO @NamaProduk, @Kuantitas, @TipeProduct, @HargaProduct, @Total,@TotalTrans
SET @TotalTrans = 0
SET @TotalSales = 0
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @TotalTrans = @TotalTrans + 1
	SET @TotalSales = @TotalSales + @Total
	PRINT 'Product Name		: ' + @NamaProduk + '(' + CAST(@Kuantitas AS varchar) + 'pcs)'
	PRINT 'Product Type Name	: ' + @TipeProduct
	PRINT 'Product Price		: ' + CAST(@HargaProduct AS varchar)
	PRINT ''
	PRINT 'Total Price	: ' + CAST(@Total AS varchar)
	FETCH NEXT FROM db INTO @NamaProduk, @Kuantitas, @TipeProduct, @HargaProduct, @Total, @TotalTrans
	PRINT '---------------------------------------------------------------'
END
BEGIN
	PRINT 'Total Transaction : ' + CAST(@TotalTrans AS varchar)
	PRINT 'Total Sales		  : ' + CAST(@TotalSales AS varchar)
END
CLOSE db

DEALLOCATE db

--EXEC TransactionReport 'TA007'

--DROP PROCEDURE TransactionReport

-- no 10
CREATE TRIGGER [BackupDeletedProduct] ON Product FOR DELETE AS
CREATE TABLE BackupProduct(
	ProductId CHAR(5) PRIMARY KEY CHECK(ProductId LIKE 'PD[0-9][0-9][0-9]'),
	ProductTypeId CHAR(5) FOREIGN KEY REFERENCES ProductType(ProductTypeId),
	ProductName VARCHAR(50) NOT NULL,
	ProductPrice INT NOT NULL,
	ProductStock INT NOT NULL
)
BEGIN
    SET NOCOUNT ON;
	INSERT INTO BackupProduct
	(
		ProductId,
		ProductTypeId,
		ProductName,
		ProductPrice,
		ProductStock 
	)
    SELECT
		ProductId, ProductTypeId, ProductName, ProductPrice, ProductStock
    FROM
        deleted;
END
	

SELECT * From Product 
DELETE Product WHERE ProductId = 'PD001'
SELECT * From BackupProduct
