WITH Winter AS (
	SELECT * FROM Sales_order 
	WHERE EXTRACT(MONTH FROM Ship_date) IN (12, 1, 2)
)
SELECT * FROM Winter
WHERE Total = (SELECT max(Total) FROM Winter);