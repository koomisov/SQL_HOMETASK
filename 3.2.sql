--Хайповые мероприятия
EXPLAIN ANALYZE SELECT Event_ID, Event_name, Description, Game_ID, Amount_scores, Average_score, Teams, Event_type 
FROM KVN_Events
WHERE Amount_scores > 100
AND Average_score > 5;

Gather  (cost=1000.00..22248.70 rows=20287 width=72)
Execution time: 176.203 ms

-- CREATE INDEX kvn_index ON KVN_EVENTS (Average_score, Amount_scores);
CREATE INDEX kvn_index ON KVN_EVENTS (Average_score);
EXPLAIN ANALYZE SELECT Event_ID, Event_name, Description, Game_ID, Amount_scores, Average_score, Teams, Event_type 
FROM KVN_Events
WHERE Amount_scores > 100
AND Average_score > 5;

--------------------------------------------------------------------------------------------------------------

--Позитивный пользователь
EXPLAIN SELECT User_ID, u.First_name, u.Last_name, AVG(s.score)
FROM Users u
INNER JOIN Scores s
USING(User_ID)
WHERE City_id = 1
GROUP BY User_ID;

Finalize GroupAggregate  (cost=2897114.22..2949574.50 rows=91100 width=49)
-- Примерно 9 минут


EXPLAIN ANALYZE SELECT User_ID, u.First_name, u.Last_name, AVG(s.score)
FROM Users u
INNER JOIN Scores s
USING(User_ID)
WHERE City_id = 1
GROUP BY User_ID;

Execution time: 241050.982 ms


CREATE INDEX score_index ON Scores USING hash(user_id);
EXPLAIN ANALYZE SELECT User_ID, u.First_name, u.Last_name, AVG(s.score)
FROM Users u
INNER JOIN Scores s
USING(User_ID)
WHERE City_id = 1
GROUP BY User_ID;
Execution time: 242077.882 ms
                217073
(Hash Join)



CREATE INDEX score_index ON Users(City_ID);
EXPLAIN ANALYZE SELECT User_ID, u.First_name, u.Last_name, AVG(s.score)
FROM Users u
INNER JOIN Scores s
USING(User_ID)
WHERE City_id = 1
GROUP BY User_ID;
Execution time: 243101.123 ms

------------------------------------------------------------------------------------

EXPLAIN ANALYZE SELECT u.User_ID, u.First_name, u.Last_name, s.score
FROM User u, Scores s
WHERE s.Event_ID = 1 AND u.User_ID = s.User_ID;

Execution time: 183735.673 ms

CREATE INDEX score_index ON Scores(Event_ID);
EXPLAIN ANALYZE SELECT u.User_ID, u.First_name, u.Last_name, s.score
FROM Users u, Scores s
WHERE s.Event_ID = 1 AND u.User_ID = s.User_ID;

Execution time: 56.046 ms

------------------------------------------------------------------------------------------

FULL TEXT SEARCH


SELECT Event_name FROM KVN_Events
WHERE  to_tsvector('english', Description) @@ to_tsquery('Betazoid');
Execution time: 3604.254 ms

CREATE INDEX idx ON KVN_Events USING GIN (to_tsvector('english', Description));
SELECT Event_name FROM KVN_Events
WHERE  to_tsvector('english', Description) @@ to_tsquery('Betazoid');
Execution time: 145.457 ms





SELECT First_name, Last_name FROM Users
WHERE  to_tsvector('english', User_prof) @@ to_tsquery('Engineer');
Execution time: 16914.993 ms
Execution time: 9428.173 ms



CREATE INDEX idx ON Users USING GIN (to_tsvector('english', User_prof));
SELECT First_name, Last_name FROM Users
WHERE  to_tsvector('english', User_prof) @@ to_tsquery('Engineer');
Execution time: 131.216 ms
Execution time: 283.777 ms

-----------------------------------------------------------------------------------------

JSON

SELECT First_name, Last_name, User_prof->'color', User_prof->'nation' FROM Users
WHERE User_prof @> '{"job": "Lead Mining Agent"}';
Execution time: 305.613 ms


CREATE INDEX idxgintags ON Users USING GIN ((user_prof -> 'job'));
SELECT First_name, Last_name, User_prof->'color', User_prof->'nation' FROM Users
WHERE User_prof @> '{"job": "Lead Mining Agent"}'
Execution time: 309.711 ms


----------------------------------------------------------------------------------

ARRAY

SELECT Teams[1] FROM KVN_EVENTS WHERE TEAMS[2] = 2;
Execution time: 3722.180 ms


CREATE INDEX idx_test ON KVN_Events USING GIN (Teams);
EXPLAIN ANALYZE SELECT Teams[1] FROM KVN_EVENTS WHERE TEAMS[2] = 2;
Execution time: 3697.527 ms



-------------------------------------------------------------------------------------------

Оптимизация таблицы Scores

1) CREATE TABLE Scores_GG (
    Score_ID INT NOT NULL,
    Score SMALLINT CONSTRAINT score_range CHECK (score >= 0 AND score <= 10),
    Datetime Timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    User_ID INT NOT NULL,
    Event_ID INT NOT NULL,
    Comments TEXT --JSON
)PARTITION BY RANGE (Datetime);

CREATE TABLE New_Day PARTITION OF Scores_GG FOR VALUES FROM ('2019-01-01 00:00:00') TO ('2020-01-01 00:00:00'); --PARTITION BY RANGE (Datetime);

--Нельзя CREATE INDEX score_index ON Scores(Datetime);








