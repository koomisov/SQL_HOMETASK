set DATESTYLE to "DMY";


CREATE TABLE Cities (
    City_ID SMALLINT PRIMARY KEY,
    Name Varchar(15) NOT NULL UNIQUE,
    Country Varchar(15)
);


CREATE SEQUENCE Univer_seq INCREMENT BY 2 START WITH 1;

CREATE TABLE Universities (
    University_ID SMALLINT PRIMARY KEY DEFAULT nextval('Univer_seq'),
    University_name Varchar(50) NOT NULL UNIQUE,
    City_ID SMALLINT REFERENCES Cities (City_ID) ON DELETE SET NULL ON UPDATE CASCADE
);


CREATE TABLE Users (
    User_ID SMALLINT PRIMARY KEY,
    First_name Varchar(15),
    Last_name VARCHAR(15),
    City_ID SMALLINT REFERENCES Cities (City_ID) ON DELETE SET NULL
);


CREATE TABLE Teams (
    Team_ID SMALLINT PRIMARY KEY,
    Team_name VARCHAR(50) NOT NULL UNIQUE,
    University_ID SMALLINT REFERENCES Universities (University_ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    Captain_ID SMALLINT REFERENCES Users (User_ID) ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE Places (
    Place_ID SMALLINT PRIMARY KEY,
    Place_name VARCHAR(30) UNIQUE,
    Address TEXT,
    City_ID SMALLINT REFERENCES Cities (City_ID) ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE Games (
    Game_ID SMALLINT PRIMARY KEY,
    Game_name VARCHAR(50),
    League_name VARCHAR(30),
    Date_game DATE,
    Place_ID SMALLINT REFERENCES Places (Place_ID) ON DELETE RESTRICT,
    Previous_game_ID SMALLINT, -- need ALTER TABLE
    Next_game_ID SMALLINT
);


CREATE TABLE Event_types (
    Event_type_ID SMALLINT PRIMARY KEY,
    Name VARCHAR(30),
    Type_description TEXT
);


CREATE TABLE KVN_Events (
    Event_ID SMALLINT PRIMARY KEY,
    Event_type_ID SMALLINT REFERENCES Event_types (Event_type_ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    Description TEXT, 
    Game_ID SMALLINT REFERENCES Games (Game_ID) ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE Teams_events (
    Team_ID SMALLINT REFERENCES Teams (Team_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    Event_ID SMALLINT REFERENCES KVN_Events (Event_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    Integral_jury_score double precision DEFAULT 0.0 CONSTRAINT jury_score_range CHECK (Integral_jury_score >= 0 AND Integral_jury_score <= 10),
    PRIMARY KEY (Team_ID, Event_ID)
);


CREATE TABLE Teams_games (
    Team_ID SMALLINT REFERENCES Teams (Team_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    Game_ID SMALLINT REFERENCES Games (Game_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    Total_score NUMERIC(1,1) CONSTRAINT jury_score_range CHECK (Total_score >= 0 AND Total_score <= 10),
    Promotion SMALLINT CONSTRAINT pr_range CHECK (Promotion = 0 or Promotion = 1),
    PRIMARY KEY (Team_ID, Game_ID)
);


CREATE TABLE Teams_users (
    Team_ID SMALLINT REFERENCES Teams (Team_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    User_ID SMALLINT REFERENCES Users (User_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (Team_ID, User_ID)
);


CREATE TABLE Scores (
    Score_ID SMALLSERIAL PRIMARY KEY,
    Score SMALLINT CONSTRAINT score_range CHECK (score >= 0 AND score <= 10),
    Datetime Timestamp NOT NULL DEFAULT  CURRENT_TIMESTAMP,
    User_ID SMALLINT NOT NULL REFERENCES Users (User_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    Event_ID SMALLINT NOT NULL REFERENCES KVN_Events (Event_ID) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE Jury_results (
    User_ID SMALLINT REFERENCES Users (User_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    Team_ID SMALLINT,
    Event_ID SMALLINT, 
    J_score SMALLINT NOT NULL,
    PRIMARY KEY (User_ID, Team_ID, Event_ID)
);


ALTER TABLE Jury_results ADD 
    FOREIGN KEY (Team_ID)
    REFERENCES Teams (Team_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD
    FOREIGN KEY (Event_ID)
    REFERENCES KVN_Events (Event_ID) ON DELETE CASCADE ON UPDATE CASCADE;

    

INSERT INTO Cities (City_ID, Name, Country) VALUES
    (1, 'Москва', 'Россия'),
    (2, 'Эльдорадо', 'Страна кайфа'),
    (3, 'Капакабана', ''),
    (4, 'Одесса', 'Украина'),
    (5, 'Севастополь', 'Россия'),
    (6, 'Чебоксары', 'Россия'),
    (7, 'Долгопрудный', 'Россия'),
    (8, 'Минск', 'Беларусь'),
    (9, 'Казань', 'Россия'),
    (10, 'Хайфа', 'Израиль'),
    (11, 'New York', 'USA'),
    (12, 'Пятигорск', 'Россия');
    

    

INSERT INTO Universities (University_name, City_ID) 
    SELECT 'МГУ', City_ID FROM Cities WHERE Name = 'Москва' RETURNING University_ID;
    
INSERT INTO Universities (University_name, City_ID) 
    SELECT 'ВШЭ', City_ID FROM Cities WHERE Name = 'Москва';
    
INSERT INTO Universities (University_name, City_ID) 
    SELECT 'Физтех', City_ID FROM Cities WHERE Name = 'Долгопрудный';
    
INSERT INTO Universities (University_name, City_ID) 
    SELECT 'ЧГУ', City_ID FROM Cities WHERE Name = 'Чебоксары';

INSERT INTO Universities (University_name, City_ID) 
    SELECT 'КФУ', City_ID FROM Cities WHERE Name = 'Казань';
    
INSERT INTO Universities (University_name, City_ID) 
    SELECT 'БГУ', City_ID FROM Cities WHERE Name = 'Минск';

INSERT INTO Universities (University_name, City_ID) 
    SELECT 'Технион', City_ID FROM Cities WHERE Name = 'Хайфа';
    
INSERT INTO Universities (University_name, City_ID) 
    SELECT 'Севастопольский филиал МГУ', City_ID FROM Cities WHERE Name = 'Севастополь';
    
INSERT INTO Universities (University_name, City_ID) 
    SELECT 'Одесский университет', City_ID FROM Cities WHERE Name = 'Одесса';
    
INSERT INTO Universities (University_name, City_ID) 
    SELECT 'КАИ', City_ID FROM Cities WHERE Name = 'Казань';
    



    
INSERT INTO Users (User_ID, First_name, Last_name, City_ID) VALUES
    (1, 'Иван', 'Медведев', 1),
    (2, 'Владимир', 'Путин', 1),
    (3, 'Ольга', 'Кортункова', 12),
    (4, 'Александр', 'Масляков', 1),
    (5, 'Александр', 'Ревва', 1),
    (6, 'Donald', 'Trump', 11),
    (7, 'Юлий', 'Гусман', 1),
    (8, 'Илья', 'Паузнер', 1),
    (9, 'Антон', 'Кваша', 1 ),
    (10, 'София', 'Николаева', 1),
    (11, 'Артем', 'Агафонов', 7);
    
INSERT INTO Users (User_ID, First_name, Last_name) VALUES
    (12, 'Михаил', 'Галустян'),
    (13, 'Джокер', '');

    
    
    
 
INSERT INTO Teams (Team_ID, Team_name, University_ID, Captain_ID)
    SELECT 1, 'Сборная МГУ', un.University_ID, 1 FROM Universities un
    WHERE un.University_name = 'МГУ';
    
INSERT INTO Teams (Team_ID, Team_name, University_ID, Captain_ID)
    SELECT 2, 'Сборная ВШЭ', un.University_ID, 8 FROM Universities un
    WHERE un.University_name = 'ВШЭ';

INSERT INTO Teams (Team_ID, Team_name, University_ID, Captain_ID)
    SELECT 3, 'Команда КВН Физтех', un.University_ID, 11 FROM Universities un
    WHERE un.University_name = 'Физтех';
    
INSERT INTO Teams (Team_ID, Team_name, University_ID, Captain_ID)
    SELECT 4, 'Команда КВН город Пятигорск', un.University_ID, 3 FROM Universities un
    WHERE un.University_name = 'Физтех';

INSERT INTO Teams (Team_ID, Team_name, University_ID, Captain_ID)
    SELECT 5, 'Ревва и Галустян', un.University_ID, 5 FROM Universities un
    WHERE un.University_name = 'Физтех';
 
INSERT INTO Teams (Team_ID, Team_name, University_ID, Captain_ID)
    SELECT 6, 'Соло Гусмана', un.University_ID, 7 FROM Universities un
    WHERE un.University_name = 'Физтех';
    
INSERT INTO Teams (Team_ID, Team_name) VALUES
    (7, 'Медведев, Путин и Трамп');
    
 
 
INSERT INTO Places (Place_ID, Place_name, Address, City_ID) VALUES 
    (1, 'Театр Советской Армии', 'метро Достоевская', 1),
    (2, 'Планета КВН', 'метро Марьина Роща', 1);
    
INSERT INTO Places (Place_ID, Place_name) VALUES 
    (3, 'Пляж Сочи'),
    (4, 'Воробьевы горы'),
    (5, 'Парковка'),
    (6, 'Флакон'),
	(7, 'Юрмала Арена'),
	(8, 'Дом на Яузе');
 
 
 
 
INSERT INTO Games (Game_ID, Game_name, League_name, Date_game, Place_ID, Next_game_ID) VALUES
    (1, 'Отборочный этап 1', 'Российская лига', '01/09/2019', 3,  5),
    (2, 'Отборочный этап 2', 'Российская лига', '15/09/2019', 4,  6),
    (3, 'Отборочный этап 3', 'Российская лига', '30/09/2019', 5,  7),
    (4, 'Отборочный этап 4', 'Российская лига', '01/10/2019', 7, 8),
    (5, 'Четвертьфинал 1', 'Российская лига', '15/10/2019', 6, 9),
    (6, 'Четвертьфинал 2', 'Российская лига', '18/10/2019', 8, 9),
    (7, 'Четвертьфинал 3', 'Российская лига', '20/10/2019', 2, 9),
    (8, 'Четвертьфинал 4', 'Российская лига', '25/10/2019', 6, 9),
    (9, 'Полуфинал 1', 'Российская лига', '01/12/2019', 1, 11),
    (10, 'Полуфинал 1', 'Российская лига', '15/12/2019', 1, 11),
    (11, 'Финал', 'Российская лига', '31/12/2019', 1, NULL);
    

ALTER TABLE Games ADD 
    FOREIGN KEY (Previous_game_ID)
    REFERENCES Games (Game_ID) ON DELETE SET NULL ON UPDATE CASCADE,
    ADD 
    FOREIGN KEY (Next_game_ID)
    REFERENCES Games (Game_ID) ON DELETE SET NULL ON UPDATE CASCADE;

 
 

INSERT INTO Event_types (Event_type_ID, Type_description, Name) VALUES
    (1, '', 'Приветствие'),
    (2, '', 'Разминка'),
    (3, 'Студенческий театр эстрадной миниатюры', 'СТЭМ'),
    (4, 'С 2011 года в Высшей лиге КВН появилась разновидность СТЭМа, под названием «СТЭМ со звездой». Главное условие конкурса: задействование в нём известной личности.', 'СТЭМ со звездой'),
    (5, 'Бюро рационализации и изобретений', 'БРИЗ'),
    (6, '', 'Музыкальный конкурс'),
    (7, '', 'Биатлон'),
    (8, '', 'Конкурс новостей'),
    (9, '', 'Домашнее задание'),
    (10, '', 'Капитанский конкурс');
 
 
 
 
INSERT INTO KVN_Events (Event_ID, Event_type_ID, Description, Game_ID) VALUES
    (1, 1, 'Физкульт привет', 1),
    (2, 4, 'СТЭМ со звездой', 9),
    (3, 5, '', 10),
    (4, 8, 'Плохие новости', 10),
    (5, 1, 'Финальное приветствие', 11),
    (6, 2, 'Финальная разминка', 11),
    (7, 3, 'Финальный СТЭМ', 11),
    (8, 6, 'Финальная музыкальный конкурс', 11),
    (9, 7, 'Финальный биатлон', 11),
    (10, 10, 'Финальный капитанский конкурс', 11);
 

 
  
INSERT INTO Teams_games (Team_ID, Game_ID) VALUES
    (1, 1),
    (1, 5),
    (1, 9),
    (1, 11),
    (2, 1),
    (2, 5),
    (2, 9),
    (2, 11),
    (3, 2),
    (3, 6),
    (3, 10),
    (4, 2),
    (5, 3),
    (6, 4),
    (7, 4),
    (7, 8),
    (7, 10),
    (7, 11),
    (6, 8),
    (5, 7);
    




INSERT INTO Teams_events (Team_ID, Event_ID) 
    SELECT tg.Team_ID, ev.Event_ID
    FROM KVN_Events ev INNER JOIN Games
    ON ev.Game_ID = Games.Game_ID
    INNER JOIN Teams_games tg 
    ON Games.Game_ID = tg.Game_ID;
 
 
 
 
INSERT INTO Teams_users (Team_ID, User_ID) VALUES
    (1, 1),
    (1, 2),
    (1, 3),
    (2, 8),
    (2, 9),
    (2, 10),
    (2, 2),
    (3, 11),
    (4, 3), 
    (4, 1),
    (5, 5),
    (5, 12),
    (1, 6),
    (6, 7),
    (1, 13),
    (2, 13),
    (3, 13),
    (7, 1),
    (7, 2),
    (7, 6),
    (7, 13);
    
    
 
 
INSERT INTO Scores (Score_ID, Score, User_ID, Event_ID) VALUES
    (1, 10, 1, 10),
    (2, 10, 2, 10),
    (3, 9, 3, 10),
    (4, 10, 4, 10),
    (5, 0, 1, 4),
    (6, 1, 2, 4),
    (7, 10, 5, 10),
    (8, 10, 6, 10),
    (9, 1, 5, 4),
    (10, 10, 7, 10);
 
 
 
 
INSERT INTO Jury_results (User_ID, Team_ID, Event_ID, J_score) VALUES
    (2, 1, 10, 10),
    (7, 1, 10, 10);
