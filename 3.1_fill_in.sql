set DATESTYLE to "DMY";

CREATE TABLE Cities (
    City_ID INT PRIMARY KEY,
    City_name VARCHAR(15) NOT NULL UNIQUE,
    Amount_users INT,
    Amount_scores INT,
    Country VARCHAR(40)
);
        
        
CREATE TABLE Users (
    User_ID INT PRIMARY KEY,
    First_name VARCHAR(50),
    Last_name VARCHAR(50),
    City_ID INT,
    User_prof jsonb --JSON
);


CREATE TABLE Teams (
    Team_ID INT PRIMARY KEY,
    Team_name VARCHAR(50) NOT NULL UNIQUE,
    University_ID INT,
    Captain_ID INT
);

CREATE TABLE Teams_users (
    Team_ID INT,
    User_ID INT,
    PRIMARY KEY (Team_ID, User_ID)
);


CREATE TABLE KVN_Events (
    Event_ID INT PRIMARY KEY,
    Event_name VARCHAR(100),
    Description TEXT, 
    Game_ID INT,
    Amount_scores INT,
    Average_score DOUBLE precision,
    Teams INT ARRAY,
    Event_type VARCHAR(100)
);


CREATE TABLE Places (
    Place_ID INT PRIMARY KEY,
    Place_name VARCHAR(30) UNIQUE,
    Address TEXT,
    Average_score DOUBLE precision,
    Amount_scores INT,
    City_ID INT REFERENCES Cities (City_ID) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Games (
    Game_ID INT PRIMARY KEY,
    Game_name VARCHAR(50),
    League_name VARCHAR(30),
    Date_game DATE,
    Place_ID INT,
    Previous_game_ID INT, -- need ALTER TABLE
    Next_game_ID INT,
    Integral_game_score DOUBLE precision
);

CREATE TABLE Scores (
    Score_ID INT PRIMARY KEY,
    Score SMALLINT CONSTRAINT score_range CHECK (score >= 0 AND score <= 10),
    Datetime Timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    User_ID INT NOT NULL,
    Event_ID INT NOT NULL,
    Comments TEXT --JSON
);


--FILL IN

COPY Scores(Score_ID, Score, USER_ID, Event_ID, Comments) FROM '/home/ubuntu/SQL_HOMETASK/scores.csv' WITH (FORMAT csv); --100 миллионов

COPY KVN_Events(Event_ID, Event_name, Description, Game_ID, Amount_scores, Average_score, Teams, Event_type) FROM '/home/ubuntu/SQL_HOMETASK/KVN_Events.csv' WITH (FORMAT csv); --миллион
       
COPY Users (User_ID, First_name, Last_name, City_ID, User_prof) FROM '/home/ubuntu/SQL_HOMETASK/users.csv' WITH (FORMAT csv); --миллион

--COPY Games (Game_ID, Game_name, League_name, Date_game, Place_ID, Previous_game_ID, Next_game_ID, Integral_game_score) FROM --'/home/ivan/Desktop/SQL_prak/games.csv' WITH (FORMAT csv);

--COPY Teams (Team_ID, Team_name, University_ID, Captain_ID) FROM '/home/ivan/Desktop/SQL_prak/teames.csv' WITH (FORMAT csv);

INSERT INTO Cities (City_ID, CIty_name, Country) VALUES
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
    (0, 'Пятигорск', 'Россия');


INSERT INTO Teams (Team_ID, Team_name, Captain_ID) VALUES
    (1, 'Сборная МГУ', 1),
    (2, 'Сборная ВШЭ', 8),
    (3, 'Команда КВН Физтех', 11),
    (4, 'Команда КВН город Пятигорск', 3),
    (5, 'Ревва и Галустян', 5),
    (6, 'Соло Гусмана', 7),
    (7, 'Медведев, Путин и Трамп', 7);
    

 
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
    (10, 'Полуфинал 2', 'Российская лига', '15/12/2019', 1, 11),
    (11, 'Финал', 'Российская лига', '31/12/2019', 1, NULL);
   

    
ALTER TABLE Games ADD 
    FOREIGN KEY (Previous_game_ID)
    REFERENCES Games (Game_ID) ON DELETE SET NULL ON UPDATE CASCADE,
    ADD 
    FOREIGN KEY (Next_game_ID)
    REFERENCES Games (Game_ID) ON DELETE SET NULL ON UPDATE CASCADE;


ALTER TABLE Scores ADD
    FOREIGN KEY (USER_ID)
    REFERENCES Users (USER_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD 
    FOREIGN KEY (Event_ID)
    REFERENCES KVN_Events ON DELETE CASCADE ON UPDATE CASCADE;
    
 
ALTER TABLE Users ADD 
    FOREIGN KEY (City_ID)
    REFERENCES Cities ON DELETE RESTRICT ON UPDATE CASCADE;
    

