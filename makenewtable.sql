CREATE TABLE MsTopping(
	ToppingId CHAR(5) PRIMARY KEY CHECK(ToppingId LIKE 'TO[0-9][0-9][0-9]'),
	ToppingName VARCHAR(20) NOT NULL CHECK(len(ToppingName) > 5),
	ToppingPrice INT NOT NULL
)
