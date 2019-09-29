SELECT ROUND(avg(s.Total), 3) as avg, e.Department_ID, sum(s.Total), count(e.Employee_ID)
FROM Sales_order s INNER JOIN Customer c
	ON s.Customer_ID = c.Customer_ID
	INNER JOIN Employee e
	ON c.Salesperson_ID = e.employee_ID
	GROUP BY e.Department_ID
	ORDER BY avg DESC LIMIT 1;