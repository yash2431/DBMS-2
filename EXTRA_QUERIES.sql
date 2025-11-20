CREATE DATABASE EXTRA_1

-- 1. CREATE TABLES
CREATE TABLE Formats (
 format_id INT IDENTITY(1,1) PRIMARY KEY,
 format_name VARCHAR(20) NOT NULL UNIQUE,
 overs_per_innings INT,
 description VARCHAR(200)
);

CREATE TABLE Players (
 player_id INT IDENTITY(1,1) PRIMARY KEY,
 player_name VARCHAR(100) NOT NULL,
 country VARCHAR(50) NOT NULL,
 date_of_birth DATE,
 role VARCHAR(50) NOT NULL,
 bating_style VARCHAR(50),
 bowling_style VARCHAR(50),
 debut_year INT,
 CONSTRAINT CHK_PlayerRole CHECK (role IN
 ('Batsman', 'Bowler', 'All-rounder', 'Wicket-keeper')
 )
);

CREATE TABLE Bating_Statistics (
 bating_statistics_id INT IDENTITY(1,1) PRIMARY KEY,
 player_id INT NOT NULL,
 format_id INT NOT NULL,
 innings INT DEFAULT 0,
 runs_scored INT DEFAULT 0,
 centuries INT DEFAULT 0,
 bating_average DECIMAL(6, 2),
 strike_rate DECIMAL(6, 2),

 FOREIGN KEY (player_id) REFERENCES Players(player_id)
 ON DELETE CASCADE ON UPDATE CASCADE,
 FOREIGN KEY (format_id) REFERENCES Formats(format_id)
 ON DELETE NO ACTION ON UPDATE NO ACTION,

 UNIQUE(player_id, format_id)
);

CREATE TABLE Bowling_Statistics (
 bowling_statistics_id INT IDENTITY(1,1) PRIMARY KEY,
 player_id INT NOT NULL,
 format_id INT NOT NULL,
 matches_played INT DEFAULT 0,
 wickets_taken INT DEFAULT 0,
 best_bowling VARCHAR(10),
 five_wicket_hauls INT DEFAULT 0,
 economy_rate DECIMAL(5, 2),
 FOREIGN KEY (player_id) REFERENCES Players(player_id)
 ON DELETE CASCADE ON UPDATE CASCADE,
 FOREIGN KEY (format_id) REFERENCES Formats(format_id)
 ON DELETE NO ACTION ON UPDATE NO ACTION,
 UNIQUE(player_id, format_id)
);

-- 2. POPULATE DATA
INSERT INTO Formats (format_name, overs_per_innings, description) VALUES
('Test', NULL, 'MulƟ-day format with unlimited overs'),
('ODI', 50, 'One Day InternaƟonal - 50 overs per side'),
('T20', 20, 'Twenty20 - 20 overs per side'),
('T10', 10, 'Ten10 - 10 overs per side'),
('The Hundred', NULL, '100 balls per side format'),
('List A', 50, 'Limited overs domesƟc cricket'),
('First Class', NULL, 'MulƟ-day domesƟc cricket format');

INSERT INTO Players (player_name, country, date_of_birth, role, bating_style, bowling_style, debut_year) VALUES
('Virat Kohli', 'India', '1988-11-05', 'Batsman', 'Right-hand bat', 'Right-arm medium', 2008),
('Jasprit Bumrah', 'India', '1993-12-06', 'Bowler', 'Right-hand bat', 'Right-arm fast', 2016),
('Steve Smith', 'Australia', '1989-06-02', 'Batsman', 'Right-hand bat', 'Leg break', 2010),
('Pat Cummins', 'Australia', '1993-05-08', 'All-rounder', 'Right-hand bat', 'Right-arm fast', 2011),
('Joe Root', 'England', '1990-12-30', 'Batsman', 'Right-hand bat', 'Right-arm off break', 2012),
('Shaheen Afridi', 'Pakistan', '2000-04-06', 'Bowler', 'LeŌ-hand bat', 'LeŌ-arm fast', 2018),
('Babar Azam', 'Pakistan', '1994-10-15', 'Batsman', 'Right-hand bat', 'Right-arm off break', 2015);

INSERT INTO Bating_Statistics (player_id, format_id, innings, runs_scored, centuries, bating_average, strike_rate) VALUES
((SELECT player_id FROM Players WHERE player_name = 'Virat Kohli'), (SELECT format_id FROM Formats WHERE
format_name = 'Test'), 196, 8848, 29, 47.55, 58.07),
((SELECT player_id FROM Players WHERE player_name = 'Virat Kohli'), (SELECT format_id FROM Formats WHERE
format_name = 'ODI'), 283, 13906, 50, 59.18, 93.42),
((SELECT player_id FROM Players WHERE player_name = 'Steve Smith'), (SELECT format_id FROM Formats WHERE
format_name = 'Test'), 196, 9685, 32, 56.97, 54.26),
((SELECT player_id FROM Players WHERE player_name = 'Joe Root'), (SELECT format_id FROM Formats WHERE
format_name = 'Test'), 272, 12377, 34, 50.10, 51.82),
((SELECT player_id FROM Players WHERE player_name = 'Babar Azam'), (SELECT format_id FROM Formats WHERE
format_name = 'ODI'), 125, 5729, 19, 56.72, 89.23),
((SELECT player_id FROM Players WHERE player_name = 'Pat Cummins'), (SELECT format_id FROM Formats WHERE
format_name = 'ODI'), 89, 1747, 1, 29.78, 88.56),
((SELECT player_id FROM Players WHERE player_name = 'Virat Kohli'), (SELECT format_id FROM Formats WHERE
format_name = 'T20'), 117, 4188, 1, 52.73, 138.43);

INSERT INTO Bowling_Statistics (player_id, format_id, matches_played, wickets_taken, best_bowling, five_wicket_hauls,
economy_rate) VALUES
((SELECT player_id FROM Players WHERE player_name = 'Jasprit Bumrah'), (SELECT format_id FROM Formats WHERE
format_name = 'Test'), 36, 159, '6/27', 11, 2.42),
((SELECT player_id FROM Players WHERE player_name = 'Jasprit Bumrah'), (SELECT format_id FROM Formats WHERE
format_name = 'ODI'), 89, 149, '6/19', 5, 5.08),
((SELECT player_id FROM Players WHERE player_name = 'Jasprit Bumrah'), (SELECT format_id FROM Formats WHERE
format_name = 'T20'), 70, 89, '3/7', 0, 7.36),
((SELECT player_id FROM Players WHERE player_name = 'Pat Cummins'), (SELECT format_id FROM Formats WHERE
format_name = 'Test'), 60, 269, '6/23', 14, 2.56),
((SELECT player_id FROM Players WHERE player_name = 'Pat Cummins'), (SELECT format_id FROM Formats WHERE
format_name = 'ODI'), 95, 171, '5/70', 2, 5.17),
((SELECT player_id FROM Players WHERE player_name = 'Shaheen Afridi'), (SELECT format_id FROM Formats WHERE
format_name = 'Test'), 31, 122, '6/51', 6, 2.71),
((SELECT player_id FROM Players WHERE player_name = 'Shaheen Afridi'), (SELECT format_id FROM Formats WHERE
format_name = 'ODI'), 57, 97, '6/35', 3, 5.73);


--1. Get bowling staƟsƟcs of Pat Cummins in all formats
SELECT Players.player_name,Formats.format_name,Bowling_Statistics.*
FROM Players INNER JOIN Bowling_Statistics
ON Players.player_id = Bowling_Statistics.player_id
INNER JOIN Formats
ON Formats.format_id = Bowling_Statistics.format_id
WHERE PLAYER_NAME = 'PAT CUMMINS'

--2. Count how many players belong to each country 
SELECT COUNTRY,COUNT(Players.player_id) AS PLAYER_COUNT
FROM Players
GROUP BY country

--3. Show top 5 highest strike rates in T20 format 
SELECT TOP 5 Bating_Statistics.strike_rate,Formats.format_name
FROM Bating_Statistics INNER JOIN Formats
ON Bating_Statistics.format_id = Formats.format_id
WHERE Formats.format_name = 'T20'

--4. Show bowlers with economy < 3 in Test format
SELECT Players.player_name,Bowling_Statistics.economy_rate,Formats.format_name
FROM PLAYERS INNER JOIN Bowling_Statistics
ON Players.player_id = Bowling_Statistics.player_id
INNER JOIN Formats
ON Bowling_Statistics.format_id = Formats.format_id
WHERE Formats.format_name = 'TEST' AND Bowling_Statistics.economy_rate < 3

--5. List players who play as All-rounders and have both >1000 runs and >50 wickets 
SELECT DISTINCT Players.player_name
FROM PLAYERS INNER JOIN Bowling_Statistics
ON Players.player_id = Bowling_Statistics.player_id
INNER JOIN Bating_Statistics
ON Players.player_id = Bating_Statistics.player_id
WHERE Bating_Statistics.runs_scored > 1000 AND Bowling_Statistics.wickets_taken > 50

--6. Show average baƫng strike rate for each format
SELECT AVG(Bating_Statistics.strike_rate) AS AVG_STRIKE_RATE,Formats.format_name
FROM Bating_Statistics INNER JOIN Formats
ON Bating_Statistics.format_id = Formats.format_id
GROUP BY Formats.format_name

--7. List top 3 bowlers with most 5-wicket hauls 
SELECT TOP 3 Players.player_name
FROM Players INNER JOIN Bowling_Statistics
ON Players.player_id = Bowling_Statistics.player_id
ORDER BY Bowling_Statistics.five_wicket_hauls DESC

--8. Find the youngest player in the database 
SELECT player_name
FROM Players
WHERE date_of_birth IN(
	SELECT MAX(date_of_birth)
	FROM PLAYERS
);

--9. Show players who have never scored a century in any format 
SELECT Players.player_name
FROM Players LEFT JOIN Bating_Statistics
ON Players.player_id = Bating_Statistics.player_id
WHERE Bating_Statistics.centuries IS NULL

--10. Display the player name who has the lowest bowling economy in ODI
SELECT TOP 1 Players.player_name,Bowling_Statistics.economy_rate
FROM Players INNER JOIN Bowling_Statistics
ON Players.player_id = Bowling_Statistics.player_id
INNER JOIN Formats
ON Bowling_Statistics.format_id = Formats.format_id
WHERE Formats.format_name = 'ODI'
ORDER BY Bowling_Statistics.economy_rate
 