-- 1) Рекурсивный

--Задача. Построить уровень иерархии игр. То есть финал имеет уровень 1, полуфинал уровень 2, итд. 
--Часто этапы называются по-разному. Четвертьфинал может называться промежуточной игрой. Отборочный - начальным этапом.
--Поэтому соотнести уровень иерархии игры, и как игры соотносятся - достаточно сложно. Для этого есть такой запрос.

--Если поменять Next_game_ID IS NULL на Game_ID = id игры, то можно строить относительную иерархию


INSERT INTO Games (Game_ID, Game_name, League_name, Date_game, Place_ID, Next_game_ID) VALUES
    (12, 'Полуфинал 2', 'Российская лига', '15/12/2019', 1, 13),
    (13, 'Финал 2', 'Российская лига', '31/12/2020', 1, NULL);

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

--Часто игры проводятся в одном месте. Хочется узнать, какие игры проходили в каком месте и каком порядке в этом месте

/* SELECT Game_name, Place_ID, Date_Game,
    row_number() OVER (PARTITION BY Place_ID ORDER BY Date_game) as Time_order
FROM Games
ORDER BY Place_ID, Time_order;
*/

SELECT g.Game_name, p.Place_name, g.Date_Game,
    row_number() OVER (PARTITION BY Place_ID ORDER BY Date_game) as Time_order
FROM Games as g
INNER JOIN Places as p
USING (Place_ID)
ORDER BY p.Place_ID, Time_order;


-- 3) 

-- Хотим вывести все университеты с городами и странами, где они живут(если есть)

SELECT U.University_name, C.Name, C.Country FROM Universities as U
LEFT OUTER JOIN Cities as C
USING (City_ID);




--4)

-- Итоговая оценка конкурса формируется из средней оценки членов жюри. Данный запрос выставляет эту оценку 



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

SELECT * FROM Universities;





--6) Delete на ограничение целостности 

DELETE FROM Event_types WHERE Name = 'Приветствие';