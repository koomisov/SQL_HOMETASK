CREATE USER test;

GRANT SELECT, UPDATE, INSERT ON Scores to test;

GRANT SELECT (User_ID, First_name, Last_name, City_ID), UPDATE (User_prof) ON Users to test;

GRANT SELECT ON KVN_EVENTS to test;

CREATE VIEW Moscow AS SELECT * FROM Users WHERE City_ID = 1 WITH CHECK OPTION;

GRANT SELECT ON Moscow to test;

CREATE ROLE Place_viewer;

GRANT UPDATE(First_name) ON Moscow to Place_viewer;

GRANT Place_viewer to test;

SET ROLE test;

SELECT * FROM Scores LIMIT 1;

UPDATE Scores SET Score = 10 WHERE Score_ID = 1;

--SELECT * FROM Users LIMIT 1; --Denied

SELECT (User_ID, First_name, Last_name, City_ID) FROM Users LIMIT 1;

--UPDATE Users SET First_name = 'Vasya' WHERE City_ID = 1 AND User_ID < 100; --denied

UPDATE Moscow SET First_name = 'Vasya' WHERE User_ID < 100;

Создать юзер1 дать права, потом залогиниться от его имени и дать еще кому-нибудь права.\

REVOKE SELECT, UPDATE, INSERT ON Customer from user1;

DROP ROLE user1;

CREATE ROLE user1 CREATEROLE LOGIN PASSWORD '123456';

GRANT SELECT, UPDATE, INSERT ON Customer to user1 WITH GRANT OPTION;

psql -h localhost -U user1 -d postgres

CREATE ROLE USER2;

GRANT UPDATE, INSERT ON Customer to user2;