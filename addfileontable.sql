ALTER TABLE MsCustomer
ADD CustomerEmail VARCHAR(20)
ALTER TABLE MsCustomer
ADD CONSTRAINT check_email CHECK(CHARINDEX('@',CustomerEmail)!=0)
