--1
SELECT * FROM MsTreatment
SELECT [Maximum Price] = MAX(Price), [Minimum Price] = MIN(Price), [Average Price] = CAST(ROUND(AVG(Price),0) AS DECIMAL(8,2))
FROM MsTreatment

--2 
SELECT StaffPosition,[Gender] = LEFT(StaffGender,1), [Average Salary] = 'Rp. ' + CAST(CAST(AVG(StaffSalary) AS DECIMAL(10,2)) AS VARCHAR) 
FROM MsStaff 
GROUP BY StaffPosition,StaffGender

--3
SELECT [TransactionDate] = CONVERT(varchar,TransactionDate,107), COUNT(TransactionId)
FROM HeaderSalonServices
GROUP BY TransactionDate

--4
SELECT [CustomerGender] = UPPER(CustomerGender), [Total Transaction] = COUNT(TransactionId)
FROM MsCustomer MS
JOIN HeaderSalonServices HSS
ON MS.CustomerId = HSS.CustomerId
GROUP BY CustomerGender

--5
SELECT TreatmentTypeName, [Total Transaction] = COUNT(HSS.TransactionId)
FROM MsTreatmentType MTT
JOIN MsTreatment MS ON MTT.TreatmentTypeId = MS.TreatmentTypeId
JOIN DetailSalonServices DSS ON DSS.TreatmentId = MS.TreatmentId
JOIN HeaderSalonServices HSS ON HSS.TransactionId = DSS.TransactionId
GROUP BY TreatmentTypeName
ORDER BY COUNT(HSS.TransactionId) DESC

--6
SELECT [Date] = CONVERT(VARCHAR,TransactionDate,106), [Revenue per Day] = 'Rp. ' + CAST(SUM(Price) AS VARCHAR)
FROM HeaderSalonServices HSS
JOIN DetailSalonServices DSS
ON HSS.TransactionId = DSS.TransactionId
JOIN MsTreatment MT
ON MT.TreatmentId = DSS.TreatmentId
GROUP BY TransactionDate
HAVING SUM(Price) BETWEEN 1000000 AND 5000000

--7
SELECT [ID] = REPLACE(MTT.TreatmentTypeId,'TT0','Treatment Type '),TreatmentTypeName,[Total Treatment per Type] = CAST(COUNT(TreatmentTypeName) AS VARCHAR) + ' Treatment'
FROM MsTreatmentType MTT
JOIN MsTreatment MT
ON MTT.TreatmentTypeId = MT.TreatmentTypeId
GROUP BY TreatmentTypeName,MTT.TreatmentTypeId
HAVING COUNT(TreatmentTypeName) > 5
ORDER BY COUNT(TreatmentTypeName) DESC

--8
SELECT [StaffName] = LEFT(StaffName,CHARINDEX(' ',StaffName)),HSS.TransactionId,[Total Treatment per Transaction] = COUNT(TreatmentId)
FROM MsStaff MS
JOIN HeaderSalonServices HSS
ON MS.StaffId = HSS.StaffId
JOIN DetailSalonServices DSS
ON DSS.TransactionId = HSS.TransactionId
GROUP BY StaffName,HSS.TransactionId

--9
SELECT TransactionDate,CustomerName,TreatmentName,Price
FROM HeaderSalonServices HSS
JOIN MsCustomer MC
ON HSS.CustomerId = MC.CustomerId
JOIN DetailSalonServices DSS
ON HSS.TransactionId = DSS.TransactionId
JOIN MsTreatment MT
ON MT.TreatmentId = DSS.TreatmentId
JOIN MsStaff MS
ON HSS.StaffId = MS.StaffId
WHERE DATENAME(WEEKDAY,TransactionDate) LIKE 'Thursday'
AND StaffName LIKE '%Ryan%'
ORDER BY TransactionDate,CustomerName

--10
SELECT TransactionDate,CustomerName,[Total Price] = SUM(Price)
FROM HeaderSalonServices HSS
JOIN MsCustomer MC
ON HSS.CustomerId = MC.CustomerId
JOIN DetailSalonServices DSS
ON DSS.TransactionId = HSS.TransactionId
JOIN MsTreatment MT
ON MT.TreatmentId = DSS.TreatmentId
WHERE DATENAME(DAY,TransactionDate) > 20
GROUP BY TransactionDate,CustomerName
ORDER BY TransactionDate DESC