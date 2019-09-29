SELECT Employee_ID, first_name, last_name, Commission, MAX(Commission) 
OVER (ORDER BY Commission DESC) 
FROM Employee 
WHERE Commission IS NOT NULL
LIMIT 1;