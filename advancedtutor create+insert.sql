USE master
GO
IF NOT EXISTS(SELECT name FROM master.dbo.sysdatabases WHERE name = 'Swaravsky')
	CREATE DATABASE Swaravsky
GO
USE Swaravsky
GO
CREATE TABLE Customer(
	CustomerId CHAR(5) PRIMARY KEY CHECK(CustomerId LIKE 'CR[0-9][0-9][0-9]'),
	CustomerName VARCHAR(30) NOT NULL,
	CustomerGender VARCHAR(7) NOT NULL,
	CustomerDOB DATE NOT NULL,
	CustomerEmail VARCHAR(25) NOT NULL
)

GO
CREATE TABLE Staff(
	StaffId CHAR(5) PRIMARY KEY CHECK(StaffId LIKE 'SA[0-9][0-9][0-9]'),
	StaffName VARCHAR(30) NOT NULL,
	StaffGender VARCHAR(7) NOT NULL,
	StaffDOB DATE NOT NULL,
	StaffSalary FLOAT NOT NULL
)

GO
CREATE TABLE ProductType(
	ProductTypeId CHAR(5) PRIMARY KEY CHECK(ProductTypeId LIKE 'PT[0-9][0-9][0-9]'),
	ProductTypeName VARCHAR(15) NOT NULL
)

GO
CREATE TABLE Product(
	ProductId CHAR(5) PRIMARY KEY CHECK(ProductId LIKE 'PD[0-9][0-9][0-9]'),
	ProductTypeId CHAR(5) FOREIGN KEY REFERENCES ProductType(ProductTypeId) ON UPDATE CASCADE ON DELETE CASCADE,
	ProductName VARCHAR(30) NOT NULL,
	ProductPrice FLOAT NOT NULL,
	ProductStock INT NOT NULL
)

GO
CREATE TABLE HeaderTransaction(
	TransactionId CHAR(5) PRIMARY KEY CHECK(TransactionId LIKE 'TA[0-9][0-9][0-9]'),
	StaffId CHAR(5) FOREIGN KEY REFERENCES Staff(StaffId) ON UPDATE CASCADE ON DELETE CASCADE,
	CustomerId CHAR(5) FOREIGN KEY REFERENCES Customer(CustomerId) ON UPDATE CASCADE ON DELETE CASCADE,
	TransactionDate DATE NOT NULL
)

GO
CREATE TABLE DetailTransaction(
	TransactionId CHAR(5) FOREIGN KEY REFERENCES HeaderTransaction(TransactionId) ON UPDATE CASCADE ON DELETE CASCADE,
	ProductId CHAR(5) FOREIGN KEY REFERENCES Product(ProductId) ON UPDATE CASCADE ON DELETE CASCADE,
	Quantity INT NOT NULL,
	PRIMARY KEY(TransactionId, ProductId)
)

GO
INSERT INTO Customer VALUES
('CR001', 'Valerie Tia', 'Female', '1993-10-05', 'valerie@gmail.com'),
('CR002', 'Daniel Yusman Marti', 'Male', '1995-04-10', 'daniel@yahoo.com'),
('CR003', 'Rima Ayu', 'Male', '1994-01-30', 'rimaa@hotmail.com'),
('CR004', 'Erika Claudia', 'Female', '1997-12-27', 'erika@gmail.com'),
('CR005', 'Victoria', 'Female', '1995-10-11', 'victoria@gmail.com')

GO
INSERT INTO Staff VALUES
('SA001', 'Aria Mila', 'Female', '1996-02-13', 6000000),
('SA002', 'Lukas', 'Male', '1993-12-21', 6700000),
('SA003', 'Victor Damian Erlangga', 'Male', '1993-03-25', 5500000),
('SA004', 'Gilbert Oktavianus', 'Male', '1992-03-09', 8000000),
('SA005', 'Gisell Adelyn', 'Female', '1997-07-14', 6500000)

GO
INSERT INTO ProductType VALUES
('PT001', 'Jewelry'),
('PT002', 'Watches'),
('PT003', 'Accesories'),
('PT004', 'Decoration')

GO
INSERT INTO Product VALUES
('PD001', 'PT001', 'Swan Necklace', 1900000, 5),
('PD002', 'PT001', 'Ginko Pendant Necklace', 2900000, 3),
('PD003', 'PT001', 'Flower Necklace', 1800000, 8),
('PD004', 'PT001', 'Pink Heart Earrings', 1500000, 10),
('PD005', 'PT001', 'Round Moon Earrings', 2000000, 8),
('PD006', 'PT001', 'Stone Bangle Links Bracelet', 21000000, 7),
('PD007', 'PT001', 'Sparkling Swan Bracelet', 2900000, 7),
('PD008', 'PT002', 'Crystalline Pure Watch', 8000000, 5),
('PD009', 'PT002', 'Crystal Rose Watch', 7000000, 10),
('PD010', 'PT002', 'Crystal Lake Watch', 9000000, 6),
('PD011', 'PT003', 'Subtle Smartphone Case', 7000000, 10),
('PD012', 'PT003', 'Bunny Bag Charm', 1000000, 20),
('PD013', 'PT003', 'Crystalline Pen', 1200000, 20),
('PD014', 'PT004', 'Star Ornament', 2000000, 17),
('PD015', 'PT004', 'Christmas Bell Ornament', 2600000, 15),
('PD016', 'PT004', 'Enchanted Rose', 3000000, 12),
('PD017', 'PT001', 'Louison Earrings', 3200000, 9),
('PD018', 'PT001', 'Moon Pearl Earrings', 3000000, 10),
('PD019', 'PT001', 'Hollow Pendant Necklace', 3500000, 5),
('PD020', 'PT001', 'Sparkling Cat Ring', 4000000, 15)

GO
INSERT INTO HeaderTransaction VALUES
('TA001', 'SA001', 'CR001', '2020-01-05'),
('TA002', 'SA002', 'CR003', '2020-01-07'),
('TA003', 'SA003', 'CR005', '2020-01-13'),
('TA004', 'SA004', 'CR002', '2020-01-13'),
('TA005', 'SA005', 'CR004', '2020-04-01'),
('TA006', 'SA001', 'CR002', '2020-02-19'),
('TA007', 'SA002', 'CR004', '2020-02-20'),
('TA008', 'SA003', 'CR003', '2020-01-22'),
('TA009', 'SA004', 'CR005', '2020-02-09'),
('TA010', 'SA005', 'CR001', '2020-05-15'),
('TA011', 'SA001', 'CR005', '2020-03-05'),
('TA012', 'SA002', 'CR004', '2020-02-17'),
('TA013', 'SA003', 'CR003', '2020-03-27'),
('TA014', 'SA004', 'CR002', '2020-04-11'),
('TA015', 'SA005', 'CR001', '2020-03-27')

GO
INSERT INTO DetailTransaction VALUES
('TA001', 'PD001', 1),
('TA002', 'PD007', 2),
('TA003', 'PD017', 1),
('TA004', 'PD020', 1),
('TA005', 'PD011', 3),
('TA006', 'PD006', 2),
('TA007', 'PD004', 2),
('TA008', 'PD006', 1),
('TA009', 'PD014', 1),
('TA010', 'PD002', 1),
('TA011', 'PD016', 3),
('TA012', 'PD019', 1),
('TA013', 'PD005', 1),
('TA014', 'PD009', 4),
('TA015', 'PD010', 1),
('TA005', 'PD003', 1),
('TA006', 'PD018', 4),
('TA010', 'PD013', 1),
('TA007', 'PD008', 1),
('TA014', 'PD012', 4)

EXEC sp_msforeachtable 'SELECR * FROM ?'
