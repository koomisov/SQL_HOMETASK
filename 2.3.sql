-- 1) Рекурсивный

WITH RECURSIVE r AS (
    SELECT Game_ID, Game_name, Next_game_ID, 1 AS level
    FROM Games
    WHERE Next_game_ID IS NULL


    UNION

    SELECT Games.Game_ID, Games.Game_name, Games.Next_game_ID, r.level + 1 AS level
    FROM Games
    INNER JOIN r
    ON Games.Next_game_ID = r.Game_ID
    
)
SELECT * FROM r;


-- 2) Оконная функция

SELECT Game_name, Place_ID, Date_Game,
    row_number() OVER (PARTITION BY Place_ID ORDER BY Date_game) as Time_order
FROM Games
ORDER BY Place_ID, Time_order;


-- 3) 

SELECT U.University_name, C.Name, C.Country FROM Universities as U
LEFT OUTER JOIN Cities as C
USING (City_ID);




--4)

INSERT INTO Jury_results (User_ID, Team_ID, Event_ID, J_score) VALUES
    (3, 1, 1, 5);


UPDATE Teams_events SET Integral_jury_score = New_table.averg
FROM 

(SELECT Team_ID, Event_ID, ROUND(AVG(J_score), 1) AS averg 
FROM Jury_results GROUP BY Team_ID, Event_ID) AS New_table

WHERE Teams_events.Team_ID = New_table.Team_ID
AND Teams_events.Event_ID = New_table.Event_ID;


SELECT * FROM Teams_events;




-- 5) Update на ограничение целостности
SELECT * FROM Universities;

UPDATE Cities SET City_ID = 21 WHERE City_ID = 6;





--6) Delete на ограничение целостности 

DELETE FROM Event_types WHERE Name = 'Приветствие';