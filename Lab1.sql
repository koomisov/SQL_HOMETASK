--1.
SELECT * FROM employee
WHERE Commission = (SELECT max(Commission) FROM employee); 
--1)Выбрать продавца, с максимальными комиссионными.
	

--2.
SELECT * FROM Sales_order 
WHERE EXTRACT(MONTH FROM Ship_date) IN (12, 1, 2);  --выбрать зимние дни

WITH Winter AS (
	SELECT * FROM Sales_order 
	WHERE EXTRACT(MONTH FROM Ship_date) IN (12, 1, 2)
)
SELECT * FROM Winter
WHERE Total = (SELECT max(Total) FROM WINTER);
 -- 2)Выбрать зимний день, в который был продан товар на максимальную сумму в Нью Йорке


--3.
 
SELECT s.Total, e.Department_ID
FROM  Sales_order s INNER JOIN Customer c
	ON s.Customer_ID = c.Customer_ID
	INNER JOIN Employee e
	ON c.Salesperson_ID = e.employee_ID;


SELECT sum(s.Total), e.Department_ID 
FROM  Sales_order s INNER JOIN Customer c
	ON s.Customer_ID = c.Customer_ID
	INNER JOIN Employee e
	ON c.Salesperson_ID = e.employee_ID
	GROUP BY e.Department_ID;

SELECT avg(s.Total), e.Department_ID, sum(s.Total), count(e.Employee_ID)
FROM  Sales_order s INNER JOIN Customer c
	ON s.Customer_ID = c.Customer_ID
	INNER JOIN Employee e
	ON c.Salesperson_ID = e.employee_ID
	GROUP BY e.Department_ID
	ORDER BY avg DESC;

	
	
SELECT avg(s.Total), e.Department_ID, sum(s.Total), count(e.Employee_ID)
FROM  Sales_order s INNER JOIN Customer c
	ON s.Customer_ID = c.Customer_ID
	INNER JOIN Employee e
	ON c.Salesperson_ID = e.employee_ID
	GROUP BY e.Department_ID
	ORDER BY avg DESC LIMIT 1;

--3) Выбрать самый эффективный отдел продаж -лучшее соотношение количество работников/сумма продаж


SELECT ROUND(count(e.Employee_ID) / sum(s.Total), 3) as effectiveness,  e.Department_ID
FROM  Sales_order s INNER JOIN Customer c
	ON s.Customer_ID = c.Customer_ID
	INNER JOIN Employee e
	ON c.Salesperson_ID = e.employee_ID
	GRO	UP BY e.Department_ID 
	ORDER BY effectiveness DESC LIMIT 1;

--4.
SELECT (sum(COALESCE(Salary,0)) - sum(COALESCE(Commission,0))) / COUNT(*) as average FROM employee; 
--4) Выбрать среднюю зарплату сотрудника компании, учитывая комиссионные.


SELECT AVG(COALESCE(Salary,0) - COALESCE(Commission,0)) FROM employee;

