Коннектимся к бд через терминал:
1. sudo -u postgres psql GG




1) Потерянное изменение для READ UNCOMMITTED

Такая аномалия возникает, когда две транзакции читают одну и ту же строку таблицы, затем одна транзакция обновляет эту строку, а после этого вторая транзакция тоже обновляет ту же строку, не учитывая изменений, сделанных первой транзакцией.

Потерянное обновление не допускается стандартом ни на одном уровне изоляции.


BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT Score FROM Scores WHERE Score_ID = 3;
=> SELECT Score FROM Scores WHERE Score_ID = 3;
UPDATE SCORES SET score = score - 2 WHERE Score_ID = 3;
=> UPDATE SCORES SET score = score - 2 WHERE Score_ID= 3; 
// Если Потерянное обновление, то было бы 7, а не 5
COMMIT;
=> COMMIT;






2) Грязное чтение для READ COMMITTED (В PG тоже, что и UNCOMMITTED)

Такая аномалия возникает, когда транзакция читает еще не зафиксированные изменения, сделанные другой транзакцией.


BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
=> BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
UPDATE SCORES SET score = score - 2 WHERE Score_ID = 3;
=> SELECT Score FROM Scores WHERE Score_ID = 3; // При грязном чтении увидели бы 7, а не 9;
COMMIT;
=> COMMIT;





3) Неповторяющееся чтение для READ COMMITTED

Аномалия неповторяющегося чтения возникает, когда транзакция читает одну и ту же строку два раза, и в промежутке между чтениями вторая транзакция изменяет (или удаляет) эту строку и фиксирует изменения. Тогда первая транзакция получит разные результаты.


BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
=> BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT Score FROM Scores WHERE Score_ID = 3;
=> UPDATE SCORES SET score = score - 2 WHERE Score_ID = 3;
=> COMMIT;
SELECT Score FROM Scores WHERE Score_ID = 3;
COMMIT;

IF (SELECT Score FROM Scores WHERE Score_ID = 3) == 9 THEN
    | Вклиниваемся
    |
    UPDATE SCORES SET score = score - 2 WHERE Score_ID = 3;;
END IF;

Практический вывод: в транзакции нельзя принимать решения на основании данных, прочитанных предыдущим оператором — потому что за время между выполнением операторов все может измениться.





4) Неповторяющееся чтение для REPEATABLE READ

BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
=> BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT Score FROM Scores WHERE Score_ID = 3;
=> UPDATE SCORES SET score = score - 2 WHERE Score_ID = 3;
=> COMMIT;
SELECT Score FROM Scores WHERE Score_ID = 3;
COMMIT;





5) Фантомы для REPEATABLE READ

Фантомное чтение возникает, когда транзакция два раза читает набор строк по одному и тому же условию, и в промежутке между чтениями вторая транзакция добавляет строки, удовлетворяющие этому условию (и фиксирует изменения). Тогда первая транзакция получит разные наборы строк.

BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
=> BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM Scores WHERE score > 5;
=> INSERT INTO Scores (Score_ID, Score, User_ID, Event_ID) VALUES
      (11, 10, 1, 4);
=> COMMIT;
SELECT * FROM Scores WHERE score > 5;
COMMIT;


В PG не допускается


6) Фантомы для SERIALIZABLE 

BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
=> BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;;
SELECT * FROM Scores WHERE score > 5;
=> INSERT INTO Scores (Score_ID, Score, User_ID, Event_ID) VALUES
      (11, 10, 1, 4);
=> COMMIT;
SELECT * FROM Scores WHERE score > 5;
COMMIT;












