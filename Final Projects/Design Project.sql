--Database Design Project
--Kyle Berkoski
--Whose Line Is It Anyway Database
--1 December 2014



DROP TABLE IF EXISTS Skits CASCADE;
DROP TABLE IF EXISTS WhoseLineEpisodes CASCADE;
DROP TABLE IF EXISTS TVShows CASCADE;
DROP TABLE IF EXISTS Movies CASCADE;
DROP TABLE IF EXISTS OtherWorks CASCADE;
DROP TABLE IF EXISTS WorksIn CASCADE;
DROP TABLE IF EXISTS Actors CASCADE;
DROP TABLE IF EXISTS Musicians CASCADE;
DROP TABLE IF EXISTS People CASCADE;


CREATE TABLE People(
PID SERIAL NOT NULL,
FirstName TEXT NOT NULL,
LastName TEXT NOT NULL,
Birthday DATE,
PRIMARY KEY (PID)
);

CREATE TABLE Actors(
PID SERIAL REFERENCES People,
ActingStart INT NOT NULL
);

CREATE TABLE Musicians(
PID SERIAL REFERENCES People,
MainInstrument TEXT NOT NULL
);

CREATE TABLE WhoseLineEpisodes(
WLID SERIAL,
WLSeason INT NOT NULL,
WLEpisode INT NOT NULL,
PRIMARY KEY (WLID)
);

CREATE TABLE Skits(
WLID SERIAL REFERENCES WhoseLineEpisodes (WLID),
SkitName TEXT,
SkitTopic TEXT
);

CREATE TABLE Movies(
MID INT NOT NULL,
MovieName TEXT NOT NULL,
ReleaseDate DATE NOT NULL,
PRIMARY KEY (MID)
);

CREATE TABLE TVShows(
TVID INT NOT NULL,
ShowName TEXT NOT NULL,
PRIMARY KEY (TVID)
);

CREATE TABLE OtherWorks(
OID INT NOT NULL,
TVID INT,
MID INT,
PRIMARY KEY (OID)
);

CREATE TABLE WorksIn(
PID INT REFERENCES People (PID),
WLID INT REFERENCES WhoseLineEpisodes (WLID),
OID INT REFERENCES OtherWorks (OID)
);

--People
INSERT INTO People (FirstName, LastName, Birthday)
VALUES  ('Drew', 'Carey', '1958-05-23'),
	('Ryan', 'Styles', '1959-04-22'),
	('Robin', 'Williams', '1951-07-21'),
	('Stephen', 'Colbert', '1964-05-13');
INSERT INTO People (FirstName, LastName)
VALUES	('Laura', 'Hall');

--Actors in same order as People Insert
INSERT INTO Actors (ActingStart)
VALUES	('1991'),
	('1989'),
	('1984'),
	('1976');

--Musicians 
INSERT INTO Musicians (PID, MainInstrument)
VALUES	('5', 'Piano');
	
--Movies in same order as People Insert, each person has 2 movies
INSERT INTO Movies (MID, MovieName, ReleaseDate)
VALUES	('1', 'Jack and Jill', '2011-11-11'),
	('2', 'Robots', '2005-03-11'),
	('3', 'Courting Courtney', '1997-10-30'),
	('4', 'Astro Boy', '2009-10-23'),
	('5', 'The Hobbit: Desolation of Smaug', '2013-12-13'),
	('6', 'Mr. Peabody & Sherman', '2014-03-07'),
	('7', 'Night at the Museum', '2006-12-22'),
	('8', 'Good Will Hunting', '1998-01-09');

INSERT INTO TVShows (TVID, ShowName)
VALUES	('1', 'The Drew Carey Show'),
	('2', 'The Price Is Right'),
	('3', 'Reno 911!'),
	('4', 'Rugrats'),
	('5', 'The Colbert Report'),
	('6', 'The O''Reilly Factor'),
	('7', 'Friends'),
	('8', 'Mork & Mindy');
	
INSERT INTO OtherWorks (OID, MID)
VALUES	('1', '1'), ('2', '2'), ('3', '3'), ('4', '4'),
	('5', '5'), ('6', '6'), ('7', '7'), ('8', '8');
	
INSERT INTO OtherWorks (OID, TVID)
VALUES	('9', '1'), ('10', '2'), ('11', '3'), ('12', '4'),
	('13', '5'), ('14', '6'), ('15', '7'), ('16', '8');	

INSERT INTO WhoseLineEpisodes (WLSeason, WLEpisode)
VALUES	('1', '10'),
	('1', '17'),
	('3', '9'),
	('3', '1');

INSERT INTO Skits (SkitName)
VALUES	('Scenes From a Hat'),
	('HoeDown'),
	('Props'),
	('Three Headed Broadway Star');


INSERT INTO WorksIn (PID, WLID)
VALUES	('1', '1'),
	('1', '2'),
	('1', '3'),
	('1', '4'),
	('2', '1'),
	('2', '2'),
	('2', '3'),
	('2', '4'),
	('3', '1'),
	('3', '2'),
	('3', '3'),
	('3', '4'),
	('4', '1'),
	('4', '2'),
	('4', '3'),
	('4', '4'),
	('5', '1'),
	('5', '2'),
	('5', '3'),
	('5', '4');
INSERT INTO WorksIn (PID, OID)
VALUES	('1', '1'),
	('1', '2'),
	('1', '9'),
	('1', '10'),
	('2', '3'),
	('2', '4'),
	('2', '11'),
	('2', '12'),
	('3', '5'),
	('3', '6'),
	('3', '13'),
	('3', '14'),
	('4', '7'),
	('4', '8'),
	('4', '15'),
	('4', '16');

--Return all movies Ryan Stiles has been in
SELECT * FROM Movies
WHERE MID IN
	(SELECT MID FROM OtherWorks
	WHERE OID IN
		(SELECT OID FROM WorksIn
		WHERE PID IN
			(SELECT PID FROM People
			WHERE FirstName = 'Ryan')));


--VIEW Drew Carrey's Other Works Besides WhoseLine
DROP VIEW IF EXISTS Drew_Carey_Other;
CREATE VIEW Drew_Carey_Other AS
SELECT TVShows.ShowName, Movies.MovieName
FROM TVShows
FULL JOIN OtherWorks
ON TVShows.TVID=OtherWorks.TVID
FULL JOIN Movies
ON Movies.MID=OtherWorks.MID
WHERE OID IN
	(SELECT OID FROM WorksIn
	WHERE PID IN
		(SELECT PID FROM People
		WHERE FirstName = 'Drew'));

SELECT * FROM Drew_Carey_Other;

--Stored Procedure 
DROP FUNCTION IF EXISTS DefaultInstrument();
CREATE FUNCTION DefaultInstrument()
RETURNS TABLE (MainInstrument TEXT) AS $$
BEGIN
	UPDATE Musicians 
	SET MainInstrument="Piano"
	WHERE MainInstrument = null;
END
$$ LANGUAGE PLPGSQL

select DefaultInstrument();
Fetch all from results;

--Triggers 
CREATE	TRIGGER	DefaultInstrument
AFTER INSERT ON	Musicians
FOR EACH ROW
EXECUTE	PROCEDURE DefaultInstrument();

--Security
CREATE ROLE admin WITH LOGIN PASSWORD 'alpaca';
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES TO admin;

CREATE ROLE Drew_Carey WITH LOGIN PASSWORD 'Points';
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES TO Drew_Carey;

CREATE ROLE Ryan_Stiles WITH LOGIN PASSWORD 'ILoveDrewCarey'
REVOKE SELECT, INSERT, UPDATE, DELETE, ON ALL TABLES TO Ryan_Stiles;
					