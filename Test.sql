CREATE TABLE Citi (
    City_ID SMALLSERIAL PRIMARY KEY,
    Name Varchar(15) NOT NULL UNIQUE,
    Country Varchar(15)
);

INSERT INTO Citi (Name, Country) VALUES
    ('Москва', 'Россия'),
	('Лондон', 'Англия');
	
SELECT * FROM Citi;