DROP TABLE IF EXISTS Movies;
DROP TABLE IF EXISTS Directors;
DROP TABLE IF EXISTS Actors;
DROP TABLE IF EXISTS Persons;  

--Persons Table 
CREATE TABLE Persons( 
Pid SERIAL, 
Aid SERIAL, 
Did SERIAL, 
Name TEXT NOT NULL, 
Address TEXT NOT NULL, 
PRIMARY KEY(Pid) 
);  

-- Movies Table 
CREATE TABLE Movies( 
Mid SERIAL, 
Main_Actor TEXT NOT NULL, 
Main_Director TEXT NOT NULL, 
name TEXT NOT NULL, 
Release_Date DATE NOT NULL, 
Domestic_Sales INT, 
Foreign_Sales INT, 
DVDBluray_Sales INT, 
PRIMARY KEY(Mid) 
);  

-- Directors Table  
CREATE TABLE Directors( 
Did SERIAL REFERENCES Persons(Pid), 
Film_School TEXT, 
DirectorsGuild_Date INT NOT NULL, 
PRIMARY KEY(Did) 
);  

-- Actors Table 
CREATE TABLE Actors( 
Aid SERIAL REFERENCES Persons(Pid), 
Height_Inches INT NOT NULL, 
Weight_LBS INT NOT NULL, 
Hair_Color TEXT NOT NULL, 
Eye_Color TEXT NOT NULL, 
Birthday DATE NOT NULL,
ActorsGuild_Date INT NOT NULL, 
PRIMARY KEY(Aid)
); 

--Insert Persons 
INSERT INTO Persons (Name, Address) 
VALUES ('James Cameron', '15 Hollywood Ln'),  
('Steven Spielberg', '16 Hollywood Ln'),  
('Sean Connery', '007 Hollywood Ln'),  
('Harrison Ford', '10 Hollywood Ln');  

--Insert Directors 
INSERT INTO Directors(Film_School, DirectorsGuild_Date) 
VALUES 	('Fullerton College', '1976'),  
	('California State University', '1963');  

--Insert Actors 
INSERT INTO Actors(Birthday, Height_Inches, Weight_LBS, Hair_Color, Eye_Color, ActorsGuild_Date) 
VALUES 	('1942-07-13', '74', '180', 'brown', 'brown', '1954'),  
	('1930-08-30', '73', '175', 'brown', 'green', '1966');  

--Insert Movies 
INSERT INTO Movies(Main_Actor, Main_Director, Name, Release_Date, Domestic_Sales, Foreign_Sales,DVDBluray_Sales)
VALUES 	('Harrison Ford', 'Steven Spielberg', 'The Last Crusade', '1989-05-29', '450000000', '20000000', '0000000'),  
	('Sean Connery', 'Guy Hamilton', 'GoldFinger', '1964-09-18', '100000000', '2000000', '1000000');  


  
--Functional Dependencies: All non-primary key columns are individually dependent on the Primary key in its respective table.   
SELECT Movies.Main_Director FROM Movies 
WHERE  Movies.Main_Actor = 'Sean Connery';  
