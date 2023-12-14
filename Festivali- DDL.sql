CREATE DATABASE Festivali
USE Festivali

CREATE TABLE Publiku (
    Nr_Leternjoftimit INT PRIMARY KEY,
    Emri VARCHAR (50) not null,
    Mbiemri VARCHAR (50) not null,
    Gjinia CHAR (1),
    CHECK(Gjinia IN('M','F'))
);

CREATE TABLE Tiketa (
    QR_Code INT PRIMARY KEY IDENTITY (1000,1),
    Cmimi SMALLMONEY,
    mosha INT not null CHECK (mosha >= 18),
    VIP CHAR (1) CHECK (VIP in ('T', 'F')),
    Rregullt CHAR (1) CHECK (Rregullt in ('T', 'F'))
);

CREATE TABLE Rezervimi (
    ID_Rezervimi INT PRIMARY KEY,
    DataRezervimit DATE
);

CREATE TABLE Sigurimi (
    S_ID INT PRIMARY KEY IDENTITY(1,1),
    Emri VARCHAR (50) not null,
    Mbiemri VARCHAR (50) not null,
    Pozita VARCHAR (30) not null
);

CREATE TABLE Konfirmimi (
   Nr_Leternjoftimit INT not null,
   ID_Rezervimi INT not null,
   Email VARCHAR(75) not null,
   Nr_Kontaktues VARCHAR(20),
   PRIMARY KEY (Nr_Leternjoftimit, ID_Rezervimi),
   FOREIGN KEY (Nr_Leternjoftimit) REFERENCES Publiku(Nr_Leternjoftimit),
   FOREIGN KEY (ID_Rezervimi) REFERENCES Rezervimi(ID_Rezervimi)
);

CREATE TABLE Kontrolla (
   S_ID INT not null,
   Nr_Leternjoftimit INT not null UNIQUE,
   PRIMARY KEY (S_ID, Nr_Leternjoftimit),
   FOREIGN KEY (Nr_Leternjoftimit) REFERENCES Publiku(Nr_Leternjoftimit),
   FOREIGN KEY (S_ID) REFERENCES Sigurimi(S_ID)
);

CREATE TABLE Blerja (
	QR_Code INT UNIQUE,
	Nr_Leternjoftimit INT not null UNIQUE,
	NrBlerjeve INT not null CHECK (NrBlerjeve <= 5),
	PRIMARY KEY (QR_Code, Nr_Leternjoftimit),
	FOREIGN KEY (Nr_Leternjoftimit) REFERENCES Publiku(Nr_Leternjoftimit),
	FOREIGN KEY (QR_Code) REFERENCES Tiketa(QR_Code)
);

CREATE TABLE Pagesa (
	ID_Rezervimi INT not null,
	Kuponi_Fiskal INT not null,
	Cmimi SMALLMONEY,
	DataEPageses DATE not null,
	PRIMARY KEY (ID_Rezervimi, Kuponi_Fiskal),
	FOREIGN KEY (ID_Rezervimi) REFERENCES Rezervimi(ID_Rezervimi)
);
ALTER TABLE Pagesa
drop column Cmimi


CREATE TABLE Kompania_Biletave (
	ID_KB INT PRIMARY KEY,
	EmriKompanise VARCHAR (50) not null,
	CEO VARCHAR(75) not null,
	Selia VARCHAR(25),
	NrPunetoreve INT,
);

CREATE TABLE Shitje (
   QR_Code INT PRIMARY KEY,
   Cmimi SMALLMONEY,
   Nr_Leternjoftimit INT,
   ID_KB int,
   FOREIGN KEY (QR_Code) REFERENCES Tiketa(QR_Code),
   FOREIGN KEY (Nr_Leternjoftimit) REFERENCES Publiku(Nr_Leternjoftimit),
   FOREIGN KEY (ID_KB) REFERENCES Kompania_Biletave(ID_KB)
);

CREATE TABLE Stafi (
	ID_Stafi INT PRIMARY KEY,
	Emri VARCHAR(50) not null,
	Mbiemri VARCHAR(50) not null,
	Email VARCHAR(75) UNIQUE,
	Nr_Tel VARCHAR(20) UNIQUE
);

CREATE TABLE Menaxheri_Marketingut (
	ID_Stafi INT PRIMARY KEY,
	RrjetetSociale VARCHAR(20),
	FOREIGN KEY (ID_Stafi) REFERENCES Stafi (ID_Stafi)
);

CREATE TABLE Sponzori (
	ID_Sponzori INT PRIMARY KEY,
	Emri VARCHAR(50) not null,
	Email VARCHAR(50) not null,
	NrKontaktues VARCHAR(20) UNIQUE,
	Selia VARCHAR(25),
	ID_Stafi INT,
	FOREIGN KEY (ID_Stafi) REFERENCES Menaxheri_Marketingut (ID_Stafi)
);

CREATE TABLE Menaxheri_Financave (
	ID_Stafi INT PRIMARY KEY,
	NrKontratave INT,
	DataTakimit DATE,
	ID_KB INT,
	FOREIGN KEY (ID_Stafi) REFERENCES Stafi (ID_Stafi),
	FOREIGN KEY (ID_KB) REFERENCES Kompania_Biletave (ID_KB)
);

CREATE TABLE Menaxheri_Kryesor (
    ID_Stafi INT PRIMARY KEY,
    VitetNeLidership INT,
    FOREIGN KEY (ID_Stafi) REFERENCES Stafi(ID_Stafi),
    Mbikeqyresi_ID INT null,
    CONSTRAINT Mbikeqyresi foreign key(Mbikeqyresi_ID) REFERENCES Menaxheri_Kryesor(ID_Stafi)
);

CREATE TABLE Ekipi_Ndertues (
	ID_EkipiNdertues INT PRIMARY KEY,
	Emri VARCHAR(50),
	NrPuntoreve INT
);

CREATE TABLE Skena (
  ID_Skena INT PRIMARY KEY,
  Nr_Hyrjeve INT,
  ID_EkipiNdertues INT,
  FOREIGN KEY (ID_EkipiNdertues) REFERENCES Ekipi_Ndertues(ID_EkipiNdertues),
Hapesira NUMERIC (10,2)
);

CREATE TABLE Lokacioni (
	ID_Lokacioni INT PRIMARY KEY,
	Qyteti VARCHAR(255),
	Rruga VARCHAR(255),
	Hapesira NUMERIC (4,2),
	ID_Skena INT,
	ID_Stafi INT,
	FOREIGN KEY (ID_Skena) REFERENCES Skena (ID_Skena),
	FOREIGN KEY (ID_Stafi) REFERENCES Menaxheri_Kryesor (ID_Stafi)
);

CREATE TABLE Ndertimi (
	ID_Skena INT,
	ID_EkipiNdertues INT,
	ID_Lokacioni INT,
	PRIMARY KEY (ID_Skena, ID_EkipiNdertues, ID_Lokacioni),
	FOREIGN KEY (ID_Skena) REFERENCES Skena (ID_Skena),
	FOREIGN KEY (ID_EkipiNdertues) REFERENCES Ekipi_Ndertues (ID_EkipiNdertues),
	FOREIGN KEY (ID_Lokacioni) REFERENCES Lokacioni (ID_Lokacioni)
);

CREATE TABLE Performuesi (
	ID_Performuesi INT PRIMARY KEY,
	EmriArtistik VARCHAR(50),
	NumriKontaktues VARCHAR(20),
	ID_Skena INT,
	FOREIGN KEY (ID_Skena) REFERENCES Skena(ID_Skena)
);

CREATE TABLE Balerini (
	ID_Performuesi INT PRIMARY KEY,
	Nr_Koreografive INT,
	ID_Skena INT,
	FOREIGN KEY (ID_Performuesi) REFERENCES Performuesi(ID_Performuesi),
	FOREIGN KEY (ID_Skena) REFERENCES Skena(ID_Skena)
);

CREATE TABLE Kengetari (
   ID_Performuesi INT PRIMARY KEY,
   Nr_Kengeve INT,
   FOREIGN KEY (ID_Performuesi) REFERENCES Performuesi(ID_Performuesi)
);


--Insertimet

INSERT INTO Publiku (Nr_Leternjoftimit, Emri, Mbiemri, Gjinia)
VALUES (1234567890, 'John', 'Doe', 'M'),
       (1234567878, 'Travis', 'Brady', 'M'),
       (1345678901, 'Slade', 'Brewer', 'F'),
       (1456789012, 'Henry', 'Mcknight', 'M'),
       (1567890123, 'Sarah', 'Taylor', 'F'),
       (1678901234, 'Barry', 'Cote', 'M'),
       (1789012345, 'Emily', 'Baker', 'F'),
       (1890123456, 'Stone', 'Parks', 'M'),
       (1901234567, 'Jessica', 'Clark', 'F'),
       (1012345678, 'Sam', 'Martin', 'M'),
       (1123456789, 'Karen', 'Martin', 'F'),
	   (1345678903, 'Arman', 'Luna', 'M'),
       (1345478908, 'Uzair', 'Vargas', 'M'),
       (1345878902, 'Stella', 'Ryan', 'F'),
       (1345674909, 'Anisha', 'Nash', 'F'),
       (1345678912, 'Anastasia', 'Alvarez', 'F'),
       (1345678920, 'Amy', 'Maddox', 'F'),
       (1345578908, 'Rosanna', 'Benson', 'F'),
       (1345238905, 'Rico', 'Tapia', 'M'),
       (1345674910, 'Tilly', 'Terrell', 'M'),
	   (1345678925, 'Ciara', 'Barber', 'F'),
	   (1345600925, 'Andile', 'Clacher', 'F'),
	   (1345698925, 'Hosee', 'Anker', 'M'),
	   (1045618925, 'Jowan', 'Anholts', 'M'),
	   (1345608925, 'Bendik', 'Hutmacher', 'M'),
	   (1345628925, 'Moana', 'Alberts', 'F'),
	   (1305678925, 'Reina', 'Barlow', 'F'),
	   (1340678925, 'Zana', 'Meir', 'F'),
	   (1345670025, 'Aline', 'Korosa', 'F'),
	   (1340008925, 'Adam', 'Gros', 'M');

INSERT INTO Tiketa (Cmimi, Mosha, VIP, Rregullt)
VALUES (150.70, 21, 'T', 'F'),
       (80.50, 18, 'F', 'T'),
	   (50.70, 23, 'F', 'T'),
       (80.50, 26, 'F', 'T'),
       (150.70, 19, 'T', 'F'),
	   (80.50, 26, 'F', 'T'),
       (150.70, 20, 'T', 'F'),
	   (150.70, 27, 'T', 'F'),
       (80.50, 28, 'F', 'T'),
	   (150.70, 19, 'T', 'F'),
       (80.50, 18, 'F', 'T'),
       (150.70, 21, 'T', 'F'),
       (80.50, 25, 'F', 'T'),
       (50.70, 29, 'F', 'T'),
       (80.50, 30, 'F', 'T'),
       (80.50, 24, 'F', 'T'),
       (150.70, 26, 'T', 'F'),
	   (50.70, 21, 'F', 'T'),
       (50.50, 22, 'F', 'T'),
       (50.70, 23, 'F', 'T'),
       (80.50, 24, 'F', 'T'),
       (150.70, 25, 'T', 'F'),
       (80.50, 26, 'F', 'T'),
       (80.50, 26, 'F', 'T'),
	   (80.50, 26, 'F', 'T'),
	   (50.50, 22, 'F', 'T'),
	   (50.50, 22, 'F', 'T'),
       (50.70, 23, 'F', 'T'),
       (80.50, 26, 'F', 'T'),
       (150.70, 19, 'T', 'F');

INSERT INTO Rezervimi (ID_Rezervimi, DataRezervimit)
VALUES (1, '2022-01-01'),
       (2, '2022-01-02'),
       (3, '2022-01-03'),
       (4, '2022-01-04'),
       (5, '2022-01-05'),
       (6, '2022-01-06'),
       (7, '2022-01-07'),
       (8, '2022-01-08'),
       (9, '2022-01-09'),
       (10, '2022-01-10');

INSERT INTO Sigurimi (Emri, Mbiemri, Pozita)
VALUES ('Lee', 'Moreno', 'Entrance Security'),
       ('Len', 'Rodriguez', 'Monitoring Security'),
       ('Dean', 'Bryan', 'Patrolling Security'),
       ('Slade', 'Brewer', 'Entrance Security'),
       ('Brynn', 'Moss', 'Security Guard'),
       ('Sue', 'Johnson', 'Monitoring Security'),
       ('Chris', 'Williams', 'Patrolling Security'),
       ('Kim', 'Fletcher', 'Entrance Security'),
       ('Tom', 'Brown', 'Patrolling Security'),
       ('Amy', 'Burnett', 'Entrance Security');

INSERT INTO Konfirmimi (Nr_Leternjoftimit, ID_Rezervimi, Email, Nr_Kontaktues)
VALUES (1234567878, 1, 'be@hotmail.net', '901-234-5678'),
       (1345678901, 2, 'jk@gmail.com', '234-567-8902'),
       (1456789012, 3, 'op@hotmail.net', '567-890-1234'),
       (1567890123, 4, 'vb@gmail.com', '456-789-0123'),
       (1678901234, 5, 'as@hotmail.net', '345-678-9012'),
       (1789012345, 6, 'qv@gmail.com', '555-555-1212'),
       (1890123456, 7, 'kj@gmail.com', '678-901-2345'),
       (1901234567, 8, 'jh@hotmail.net', '789-012-3456'),
       (1012345678, 9, 'as@gmail.com', '890-123-4567'),
       (1345678903, 1, 'as@hotmail.net', '345-678-9012'),
       (1345478908, 2, 'as@hotmail.net', '345-678-9012'),
       (1345878902, 3, 'as@hotmail.net', '345-678-9012'),
       (1345674909, 9, 'ad@gmail.com', '012-345-6789'),
       (1345674909, 8, 'ad@gmail.com', '012-345-6789'),
       (1345674909, 7, 'ad@gmail.com', '012-345-6789'),
       (1345578908, 4, 'op@hotmail.net', '567-890-1234'),
       (1345578908, 5, 'op@hotmail.net', '567-890-1234'),
       (1345578908, 6, 'op@hotmail.net', '567-890-1234'),
       (1345678925, 2, 'be@hotmail.net', '901-234-5678'),
       (1345678925, 3, 'be@hotmail.net', '901-234-5678'),
       (1345678925, 4, 'be@hotmail.net', '901-234-5678'),
       (1045618925, 9, 'jh@hotmail.net', '789-012-3456'),
       (1045618925, 10, 'jh@hotmail.net', '789-012-3456'),
       (1045618925, 7, 'jh@hotmail.net', '789-012-3456'),
	   (1345670025, 8, 'ak@hotmail.net', '532-253-1238');

INSERT INTO Kontrolla (S_ID, Nr_Leternjoftimit)
VALUES (1, 1012345678),
       (1, 1678901234),
       (1, 1456789012),
       (1, 1901234567),
	   (1, 1345678903),
       (1, 1234567878),
       (4, 1345678901),
       (4, 1789012345),
	   (4, 1345478908),
       (4, 1567890123),
       (4, 1890123456),
       (4, 1340008925),
       (8, 1345670025),
       (8, 1340678925),
       (8, 1305678925),
       (8, 1345628925),
	   (8, 1345878902),
       (8, 1345698925),
       (10, 1345674910),
       (10, 1345600925),
       (10, 1123456789),
       (10, 1045618925),
       (10, 1345238905),
       (10, 1345578908),
       (10, 1345674909);

INSERT INTO Blerja (QR_Code, Nr_Leternjoftimit, NrBlerjeve)
VALUES (1009, 1678901234, 2),
       (1008, 1567890123, 5),
       (1007, 1456789012, 3),
       (1006, 1345678901, 3),
       (1005, 1234567878, 4),
       (1004, 1123456789, 3),
       (1003, 1012345678, 2),
       (1002, 1901234567, 1),
       (1001, 1890123456, 4),
       (1000, 1789012345, 3);

INSERT INTO Pagesa (ID_Rezervimi, Kuponi_Fiskal, DataEPageses)
VALUES (1, 6000001, '2022-01-01'),
       (1, 7000002, '2022-01-02'),
       (2, 8000003, '2022-01-03'),
       (2, 9000004, '2022-01-04'),
       (2, 1000005, '2022-01-05'),
       (3, 2000006, '2022-01-06'),
       (3, 3000007, '2022-01-07'),
       (3, 4000008, '2022-01-08'),
       (4, 5000009, '2022-01-09'),
	   (4, 6000010, '2022-01-10'),
	   (4, 5001009, '2022-01-09'),
	   (5, 5002009, '2022-01-09'),
	   (5, 5003009, '2022-01-09'),
	   (6, 5004009, '2022-01-09'),
	   (6, 5005009, '2022-01-09'),
	   (7, 5006009, '2022-01-09'),
	   (7, 5007009, '2022-01-09'),
	   (7, 6000011, '2022-01-09'),
	   (8, 6000021, '2022-01-09'),
	   (8, 6000031, '2022-01-09'),
	   (9, 6000041, '2022-01-09'),
	   (9, 6000051, '2022-01-09'),
	   (9, 6000061, '2022-01-09'),
	   (10, 6000071, '2022-01-09'),
	   (10, 6000081, '2022-01-09');

INSERT INTO Kompania_Biletave (ID_KB, EmriKompanise, CEO, Selia, NrPunetoreve)
VALUES (91, 'Ticketock', 'John Smith', 'Napoli', 50),
       (92, 'Ticket Hunt', 'Jane Doe', 'New York', 100),
       (93, 'Advancement Ticket', 'Bob Johnson', 'Paris', 150),
       (94, 'Elite Ticket', 'Samantha Williams', 'Rome', 200),
       (95, 'Ticket’s Corner', 'David Anderson', 'London', 250),
       (96, 'Think Smart', 'Sarah Davis', 'Mexico City', 300),
       (97, 'Open Ticket', 'Michael Brown', 'San Antonio', 350),
       (98, 'Ticket Lab', 'Emily Thompson', 'Tokyo', 400),
       (99, 'Ticket House', 'William Jones', 'Dallas', 450),
       (100, 'The Good Ticket', 'Ashley Smith', 'Los Angeles', 500);

INSERT INTO Shitje (QR_Code, Cmimi, Nr_Leternjoftimit, ID_KB)
VALUES (1000, 50.00, 1678901234, 95),
       (1001, 100.00, 1456789012, 95),
       (1002, 150.00, 1012345678, 95),
       (1003, 200.00, 1890123456, 95),
       (1004, 50.00, 1678901234, 95),
       (1005, 300.00, 1890123456, 95),
       (1006, 100.00, 1456789012, 95),
       (1007, 150.00, 1123456789, 95),
       (1008, 300.00, 1012345678, 95),
       (1009, 200.00, 1123456789, 95);

INSERT INTO Ekipi_Ndertues (ID_EkipiNdertues, Emri, NrPuntoreve)
VALUES (1, 'ACME Corporation', 50),
       (2, 'XYZ Inc.', 75),
       (3, 'ABC Enterprises', 100),
       (4, 'DefTech LLC', 75),
       (5, 'Ghi JKL', 250),
       (6, 'Mno Company', 225),
       (7, 'Pqr Corp.', 200),
       (8, 'Stu Ventures', 225),
       (9, 'Vwx Group', 250),
       (10, 'Yza Holdings', 75);

INSERT INTO Stafi (ID_Stafi, Emri, Mbiemri, Email, Nr_Tel)
VALUES	(20, 'Fatima', 'Winters', 'fw@gmail.com', '123-456-7890'),
		(30, 'Ashley', 'Smith', 'jk@gmail.com', '123-456-7900'),
		(40, 'Annabel', 'Sosa', 'as@gmail.com', '123-456-7910');

INSERT INTO Menaxheri_Kryesor (ID_Stafi, VitetNeLidership, Mbikeqyresi_ID)
VALUES	(20, 5, 20);

INSERT INTO Menaxheri_Marketingut (ID_Stafi, RrjetetSociale)
VALUES	(30, 'Instagram');

INSERT INTO Menaxheri_Financave (ID_Stafi, NrKontratave, DataTakimit, ID_KB)
VALUES	(40, 5, '2022-01-01', 100);

INSERT INTO Sponzori (ID_Sponzori, Emri, Email, NrKontaktues, Selia, ID_Stafi)
VALUES	(111, 'Cash and Bash', 'sponsor1@email.com', '123-456-7890', 'New York', 30),
		(222, 'White BEAR', 'sponsor2@email.com', '234-567-8901', 'Los Angeles', 30),
		(333, 'Box of Surprises', 'sponsor3@email.com', '345-678-9012', 'Chicago', 30),
		(444, 'Live in an Event', 'sponsor4@email.com', '456-789-0123', 'Houston', 30),
		(555, 'Event of Enigma', 'sponsor5@email.com', '567-890-1234', 'Phoenix', 30),
		(666, 'Let it Rain', 'sponsor6@email.com', '678-901-2345', 'Philadelphia', 30),
		(777, 'Spot on Sponsors', 'sponsor7@email.com', '789-012-3456', 'San Antonio', 30),
		(888, 'Point Break', 'sponsor8@email.com', '890-123-4567', 'San Diego', 30),
		(999, 'Ocean’s Sponsorship', 'sponsor9@email.com', '901-234-5678', 'Dallas', 30),
		(101, 'Future Conquest', 'sponsor10@email.com', '012-345-6789', 'San Jose', 30);

INSERT INTO Skena (ID_Skena, Nr_Hyrjeve, ID_EkipiNdertues, Hapesira)
VALUES (001, 4, 1, 123.45),
       (002, 5, 2, 234.56),
       (003, 6, 3, 345.67),
       (004, 7, 4, 456.78),
       (005, 1, 5, 567.89),
       (006, 2, 6, 678.90),
       (007, 2, 7, 789.01),
       (008, 10, 8, 890.12),
       (009, 5, 9, 901.23),
       (010, 4, 10, 112.34);

INSERT INTO Lokacioni (ID_Lokacioni, Qyteti, Rruga, Hapesira, ID_Skena, ID_Stafi)
VALUES  (3300, 'Seoul', 'Shade Avenue', 50.00, 002, 20),
        (3301, 'Athens', 'Lawn Row', 60.00, 004, 20),
        (3302, 'Skopje', 'Arctic Lane', 70.00, 006, 20),
        (3303, 'Tripoli', 'Moon Lane', 80.00, 008, 20),
        (3304, 'Sarajevo', 'Moonlight Lane', 90.00, 010, 20),
        (3305, 'Dublin', 'Corporation Lane', 10.00, 001, 20),
        (3306, 'Prague', 'Gold Lane', 10.00, 003, 20),
        (3307, 'Oslo', 'Beaver Passage', 10.00, 005, 20),
        (3308, 'Ljubljana', 'Ash Lane', 30.00, 007, 20),
        (3309, 'Manila', 'Centre Way', 40.00, 009, 20);

INSERT INTO Ndertimi (ID_Skena, ID_EkipiNdertues, ID_Lokacioni)
VALUES (001, 1, 3300),
       (002, 2, 3301),
       (003, 3, 3302),
       (004, 4, 3303),
       (005, 5, 3304),
       (006, 6, 3305),
       (007, 7, 3306),
       (008, 8, 3307),
       (009, 9, 3308),
       (010, 10, 3309);

INSERT INTO Performuesi (ID_Performuesi, EmriArtistik, NumriKontaktues, ID_Skena)
VALUES (1, 'Beast', '555-123-4567', 001),
       (2, 'Jackpot', '555-987-6543', 005),
       (3, 'Syte', '555-567-8901',002),
       (4, 'Moon', '555-246-8079', 004),
       (5, 'Genesis', '555-369-7415', 003),
       (6, 'Storm', '555-159-7536', 004),
       (7, 'Chaos', '555-753-9624', 004),
       (8, 'Trilogy', '555-147-2580', 001),
       (9, 'Moon', '555-369-8415', 005),
       (10, 'TNT', '555-159-6532', 001);

INSERT INTO Balerini (ID_Performuesi, Nr_Koreografive, ID_Skena)
VALUES (1, 10, 001),
       (2, 15, 002),
       (3, 5, 003),
       (4, 20, 001),
       (5, 15, 005),
       (6, 10, 006),
       (7, 5, 002),
       (8, 20, 003),
       (9, 15, 004),
       (10, 10, 004);

INSERT INTO Kengetari (ID_Performuesi, Nr_Kengeve)
VALUES
(1, 5),
(2, 6),
(3, 7),
(4, 8),
(5, 9),
(6, 10),
(7, 11),
(8, 12),
(9, 13),
(10, 14);

--UPDATE I TE DHENAVE
UPDATE Tiketa
SET VIP = 'T', Rregullt ='F'
WHERE Cmimi = 80.50;

UPDATE Sigurimi
SET Pozita = 'Patrolling Security'
WHERE S_ID = 1;

UPDATE Sigurimi
SET Pozita = 'Entrance Security'
WHERE S_ID = 2;

UPDATE Konfirmimi
SET Email = 'be@outlook.com'
WHERE Nr_Leternjoftimit = 1345678925;

UPDATE Konfirmimi
SET Nr_Kontaktues = '246-899-4578'
WHERE Nr_Leternjoftimit = 1345674909;

UPDATE Konfirmimi
SET Email = 'as@hotmail.com', Nr_Kontaktues = '157-900-1259'
WHERE Nr_Leternjoftimit = 1012345678;

UPDATE Blerja
SET NrBlerjeve = 2
WHERE QR_CODE = 1009;

UPDATE Kompania_Biletave 
SET EmriKompanise = 'Adventure Destionation'
WHERE ID_KB = 96;

UPDATE Kompania_Biletave 
SET Selia = 'Bologna'
WHERE ID_KB = 99;

UPDATE Kompania_Biletave 
SET NrPunetoreve = 110
WHERE ID_KB = 92;

UPDATE Kompania_Biletave 
SET CEO = 'Wesley Morgan'
WHERE ID_KB = 98;

UPDATE Ekipi_Ndertues
SET Emri = 'AC Construction'
WHERE ID_EkipiNdertues = 5;

UPDATE Ekipi_Ndertues
SET NrPuntoreve = 80
WHERE ID_EkipiNdertues = 2;

UPDATE Stafi
SET Email = 'fatimaw@hotmail.com'
WHERE ID_Stafi = 20;

UPDATE Stafi
SET Nr_Tel = '134-268-8822'
WHERE ID_Stafi = 40;

UPDATE Sponzori
SET Emri = 'Let it Snow'
WHERE ID_Sponzori = 666;

UPDATE Sponzori
SET Selia = 'Arizona'
WHERE ID_Sponzori = 999;

UPDATE Skena
SET Nr_Hyrjeve = 9
WHERE ID_Skena = 007;

UPDATE Skena
SET Hapesira = 550.75
WHERE ID_Skena = 005;

UPDATE Lokacioni
SET Rruga = 'Third Avenue'
WHERE ID_Lokacioni = 3304;

UPDATE Performuesi
SET EmriArtistik = 'Rockstar'
WHERE ID_Performuesi = 5;

--DELETE I TE DHENAVE
DELETE FROM Sigurimi WHERE Pozita = 'Security Guard';
DELETE FROM Konfirmimi WHERE ID_Rezervimi = 1;
DELETE FROM Konfirmimi WHERE Nr_Leternjoftimit = 1345878902;
DELETE FROM Kontrolla WHERE Nr_Leternjoftimit = 1901234567;
DELETE FROM Blerja WHERE QR_Code = 1001;
DELETE FROM Pagesa WHERE Kuponi_Fiskal = 5007009;
DELETE FROM Kompania_Biletave WHERE ID_KB = 96;
DELETE FROM Kompania_Biletave WHERE EmriKompanise = 'Ticketock';
DELETE FROM Sponzori WHERE Selia = 'Phoenix';
DELETE FROM Sponzori WHERE ID_Sponzori = 888;
