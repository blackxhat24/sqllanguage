UPDATE MsStaff SET StaffSalary = StaffSalary + 150000 
FROM MsStaff ms JOIN TrTransactionHeader tr ON ms.StaffId = tr.StaffId 
WHERE datename(month, TransactionDate) = 'August'
