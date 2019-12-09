--По Москве много пользователей, отдельный сервак для регистрации москвичей (Изменяемое)


CREATE VIEW Moscow AS SELECT * FROM Users WHERE City_ID = 1 WITH CHECK OPTION;

--Аналитика по лайкам за день - индекс не наследуется
CREATE MATERIALIZED VIEW Todays_likes AS SELECT s.Score_ID, s.Score, s.Datetime, s.Event_ID FROM Scores s WHERE DATE(Datetime) = current_date; 

--За месяц (Неизменяемое, только отдельные столбцы)
CREATE VIEW Month_likes AS SELECT Avg(s.Score) as Average, s.Event_ID FROM Scores s WHERE DATE(Datetime) >= date_trunc('month', CURRENT_DATE) AND Datetime <= current_timestamp GROUP BY s.Event_ID;

INSERT INTO Month_likes (Average, Event_ID) VALUES (1.0, 11) -- Нельзя
UPDATE Month_likes SET Average = 1.0 WHERE Event_ID = 9; -- Нельзя
UPDATE Month_likes SET Event_ID = 100 WHERE Event_ID = 9; -- Нельзя


CREATE TRIGGER trg ON Month_likes INSTEAD OF INSERT AS BEGIN INSERT INTO Scores (Average, Event_ID) SELECT i.Average, i.Event_id FROM inserted i END



--Аналитика по лайкам для Москвы отдельно
CREATE VIEW Moscow AS SELECT * FROM Users WHERE City_ID = 1 WITH CHECK OPTION;
CREATE VIEW Moscows_likes AS SELECT u.User_ID, Count(s.Score) FROM Moscow u, Scores s WHERE u.User_ID = s.User_ID GROUP BY (u.USER_ID);
SELECT * FROM Moscows_likes;


--Функции

CREATE FUNCTION show_scores() RETURNS SETOF record AS $$ SELECT s.Score_ID, s.Score, s.Datetime, s.Event_ID FROM Scores s WHERE DATE(Datetime) = current_date; $$ LANGUAGE SQL;





SELECT add_user_Moscow(100000000000, 'IVAN', 'MEDVEDEV');



CREATE FUNCTION most_active_city() RETURNS record AS $$ SELECT city_id, City_name, amount_scores FROM Cities ORDER BY Amount_scores DESC LIMIT 1; $$ LANGUAGE SQL;
SELECT most_active_city();