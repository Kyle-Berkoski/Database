-- Movies Table
DROP TABLE IF EXISTS Movies;
CREATE TABLE Movies(
name TEXT NOT NULL,
ReleaseDate DATE NOT NULL,
DomesticSales INT,
ForeignSales INT,
DVD_BluraySales INT,
PRIMARY KEY(name, ReleaseDate)
--could add domestic sales to primary key, 
--not sure if it's necessary
);

-- Directors Table
DROP TABLE IF EXISTS Directors;
CREATE TABLE Directors(
name TEXT NOT NULL,
address TEXT,
School_Attended TEXT,
Guilded_Date DATE,
PRIMARY KEY(name, address)
--Concerns with the primary key: What if 
--there are two directors with the same name,
--that went to the same school,
--they live together,
--and they were guilded together.
--It is possible, though not plausible, so I'm unsure
--if I should take into account this extremely minor
--impossiblity or just leave it the way it is.
);

-- Actors Table
DROP TABLE IF EXISTS Actors;
CREATE TABLE Actors(
ActorID char(5),
name TEXT NOT NULL,
address TEXT NOT NULL,
DOB DATE NOT NULL,
HairColor TEXT,
EyeColor TEXT NOT NULL,
HeightInches INT NOT NULL,
WeightLBS INT NOT NULL,
Guilded_Date DATE,
PRIMARY KEY(name, address)
--Concerns for this primary key are the same as the directors
);
