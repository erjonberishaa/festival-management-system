--4 QUERY TE THJESHTA (ME VETEM NJE TABELE)

--1. Shfaqni emailat e konfirmimeve (pa perseritjen e tyre)
SELECT DISTINCT Email
FROM Konfirmimi

--2. Shfaqni emrat e Kompanive te Biletave te cilat fillojne me shkronjen T
SELECT *
FROM Kompania_Biletave
WHERE EmriKompanise like 'T%'

--3. Shfaqni te gjithe antaret e Publikut te cilet jane femra dhe ju mbaron mbiemri me shkronjen r
SELECT *
FROM Publiku
WHERE Gjinia  = 'F'  and Mbiemri like '%_r'

--4. Shfaqni te gjitha rezervimet qe jane bere mes datave 2022-01-01 dhe 2022-01-07 
SELECT DataRezervimit
FROM Rezervimi
WHERE DataRezervimit BETWEEN '2022-01-01' and '2022-01-07'


--4 QUERY TE THJESHTA (ME DY OSE ME SHUME TABELA)
--1. Selektoni tiketat sipas QR_Codet si dhe numrin e blerjeve dhe cmimin e atyre tiketave
SELECT t.QR_Code, b.NrBlerjeve, sh.Cmimi
FROM Tiketa t, Blerja b, Shitje sh
WHERE t.QR_Code = b.QR_Code and b.Nr_Leternjoftimit = sh.Nr_Leternjoftimit

--2. Selektoni emrin, mbiemrin si dhe numrin e blerjeve nga ata persona te caktuar nga publiku
SELECT p.Emri, p.Mbiemri, b.NrBlerjeve
FROM Publiku p, Blerja b
WHERE p.Nr_Leternjoftimit = b.Nr_Leternjoftimit;

--3. Selektoni Emrin artistik te performuesit dhe numrin e kengeve qe do performoje ai
SELECT p.EmriArtistik, k.Nr_Kengeve
FROM Performuesi p, Kengetari k
WHERE p.ID_Performuesi = k.ID_Performuesi

--4. Selektoni numrin e hyrjeve te skenave si dhe Emrin e kompanive qe kane punuar skenen
SELECT s.Nr_Hyrjeve, en.Emri
FROM Skena s, Ekipi_Ndertues en
WHERE s.ID_EkipiNdertues = en.ID_EkipiNdertues


--4 QUERY TE AVANCUARA (ME DY OSE ME SHUME TABELA)
--1. Selektoni mesataren e blerjeve si dhe cmimin maksimal nga keto blerje te tiketave
SELECT AVG(NrBlerjeve) as [Mesatarja_e_blerjeve], MAX (Cmimi) as [Cmimi Maksimal]
FROM Tiketa t
inner join Blerja b 
ON t.QR_Code=b.QR_Code

--2. Selektoni numrin total te performuesve dhe minimumin e kengeve qe do kendohen
SELECT COUNT(EmriArtistik) as [Numri_total_i_performuesve], MIN(Nr_Kengeve) as [Me_se_paku_kenge]
FROM Performuesi p
INNER JOIN Kengetari k
ON p.ID_Performuesi = k.Nr_Kengeve

--3. Listoni qytetet ne te cilat hapesira e skenes eshte me e vogel se 300metra katror dhe ai qytet fillon me shkronjen s 
SELECT Qyteti as [Qyteti_sipas_hapesires_se_skenes]
FROM Skena s
INNER JOIN Lokacioni l
ON s.ID_Skena = l.ID_Skena
WHERE s.Hapesira < 300.00 and l.Qyteti like 'S%'

--4. Shfaqni Emrin dhe mbiemrin e gjinine femerore si dhe emailin qe kane perdorur per rezervim, e poashtu edhe daten kur ka ndodhur rezervimi *Rendisni sipas dates me te madhe*
SELECT p.Emri, p.Mbiemri, k.Email, r.DataRezervimit
FROM Publiku p
INNER JOIN Konfirmimi k
ON p.Nr_Leternjoftimit = k.Nr_Leternjoftimit
RIGHT JOIN Rezervimi r
ON r.ID_Rezervimi = k.ID_Rezervimi
WHERE  Gjinia = 'F' and (DataRezervimit between '2022-01-02' and '2022-01-08')
ORDER BY DataRezervimit desc

--SUBQUERY TE THJESHTA
--1. Shfaqni detajet e blerjes nga antarja e publikut Emily Baker
SELECT *
FROM Blerja b
WHERE b.Nr_Leternjoftimit = (SELECT p.Nr_Leternjoftimit
							 FROM Publiku p
							 WHERE p.Emri like 'Emily' and p.Mbiemri like 'Baker')

SELECT s.Emri, sh.Kategoria
FROM Stafi s, shoferi sh
WHERE s.StafiID = sh.ShoferiID

--2. Selektoni emrin, mbiemrin dhe gjininë e të gjithë klientëve që kanë blerë më shumë se 3 bileta:
SELECT Emri, Mbiemri, Gjinia
FROM Publiku
WHERE Nr_Leternjoftimit IN 
    (SELECT Nr_Leternjoftimit
    FROM Blerja
    WHERE NrBlerjeve > 3);

--3. Selektoni anetaret e publikut qe kane bere konfirmim 
SELECT *
FROM Publiku p
WHERE p.Nr_Leternjoftimit in ( SELECT k.Nr_Leternjoftimit
								FROM Konfirmimi k
								WHERE k.Nr_Leternjoftimit = p.Nr_Leternjoftimit)

--4. Shfaqni detajet e Menaxherit te Marketingut
SELECT Emri, Mbiemri, Email, Nr_Tel
FROM Stafi 
WHERE ID_Stafi IN (SELECT ID_Stafi 
					FROM Menaxheri_Marketingut);

--                               SUBQUERY TE AVANCUARA
--1. Shfaqni balerinet që kanë performuar në Skenen 001 dhe kanë më shumë Koreografi se mesatarja
WITH Mesatare AS (
  SELECT AVG(Nr_Koreografive) AS [AVG_Coreo]
  FROM Balerini
  WHERE ID_Skena = 001
)
SELECT p.*, Balerini.Nr_Koreografive
FROM Performuesi p
JOIN Balerini ON p.ID_Performuesi = Balerini.ID_Performuesi
JOIN Mesatare ON Balerini.Nr_Koreografive > [AVG_Coreo]
WHERE p.ID_Skena = 001;

--2. Selektoni numrin total te blerjeve nga gjinia mashkullore
WITH Blerjet AS (SELECT Nr_Leternjoftimit, SUM(NrBlerjeve) AS BlerjetTotale
FROM Blerja
GROUP BY Nr_Leternjoftimit)
SELECT SUM(BlerjetTotale)
FROM Blerjet
JOIN Publiku ON Blerjet.Nr_Leternjoftimit = Publiku.Nr_Leternjoftimit
WHERE Gjinia = 'M';

--3. Shfaqni emrat e antereve te publikut qe kane bere me shume se 2 blerje
SELECT Emri, Mbiemri
FROM Publiku
WHERE Nr_Leternjoftimit IN (SELECT Nr_Leternjoftimit
                            FROM Blerja
                            GROUP BY Nr_Leternjoftimit
                            HAVING SUM(NrBlerjeve) > 2);

--4. Zgjidhni Skenat me mesataren me te larte të Koreografive:
WITH AVG_INFO AS (
  SELECT ID_Skena, AVG(Nr_Koreografive) AS AVG_COREO
  FROM Balerini
  GROUP BY ID_Skena
)
SELECT ID_Skena
FROM AVG_INFO
WHERE AVG_COREO = (SELECT MAX(AVG_COREO) FROM AVG_INFO);


--4 QUERY ME ALGJEBREN RELACIONARE
--1. Listoni Kodin e Tiketave te personave qe jane nen moshen 20 vjecare, por jo edhe ata qe jane mbi kete moshe (Ndryshimi/Diferenca)
CREATE VIEW KufizimiMoshes AS
SELECT t.QR_Code
FROM Tiketa t
WHERE t.mosha < 20
EXCEPT
SELECT t.QR_Code
FROM Tiketa t
WHERE t.mosha > 21
select *
from KufizimiMoshes

--2. Te shfaqet emrin dhe mbiemrin e sigurimave te cilet kane poziten 'Entrance Security' ose 'Security Guard' (Unioni)
select s.Emri,s.Mbiemri
FROM Sigurimi s 
WHERE s.Pozita='Entrance Security'
UNION
select s.Emri,s.Mbiemri
FROM Sigurimi s 
WHERE s.Pozita='Monitoring Security'

--3. Shfaqni Rezervimet te cilat jane kryer me daten '2022-01-09', e poashtu ka ndodhur edhe pagesa me kete date (Prerja)
select r.ID_Rezervimi, p.ID_Rezervimi
from Rezervimi r inner join Pagesa p on
 r.ID_Rezervimi = p.ID_Rezervimi and r.DataRezervimit ='2022-01-09'
INTERSECT
select r.ID_Rezervimi, p.ID_Rezervimi
from Rezervimi r inner join Pagesa p on
r.ID_Rezervimi = p.ID_Rezervimi and p.DataEPageses ='2022-01-09'

--4. Listoni Skenat qe kane hapesire me te madhe se 500 metra katrore, por jo edhe ato qe kane me pak hapesire se numri i paracekur (Ndryshimi/Diferenca)
CREATE VIEW Skenat AS
SELECT s.ID_Skena
FROM Skena s
WHERE s.Hapesira > 500.00
EXCEPT
SELECT s.ID_Skena
FROM Skena s
WHERE s.Hapesira < 500.00
select *
from Skenat

--STORED PROCEDURES
--1. Krijoni një stored procedure qe shfaq Lokacionet ne baze te inputit qyteti. (Shfaqni Lokacionet nga Skopje .)
create procedure
getLocationByCity(@Qyteti varchar(30))
as 
begin
select *
from Lokacioni l
where l.Qyteti like @Qyteti
end

exec getLocationByCity 'Skopje'

--2. Stored Procedure me Input/Output qe tregon numrin e koreografive nga nje balerin, ne baze te ID's
CREATE PROCEDURE 
GetDancerChoreographies (@Id INT, @Count INT OUT)
AS
BEGIN
   SELECT @Count = Nr_Koreografive
   FROM Balerini
   WHERE ID_Performuesi = @Id
END

DECLARE @output_parameter INT;
EXEC GetDancerChoreographies '8', @output_parameter OUTPUT;
SELECT @output_parameter AS [Nr_Koreografive];


--3. Krijoni nje procedure e cila do beje update numrin e punetoreve te kompanive varesisht vlerave qe ti i jep
CREATE PROCEDURE UpdateNumriPuntoreve (@ID_EkipiNdertues INT, @NrPuntoreve INT)
AS
BEGIN
    IF EXISTS (SELECT * FROM Ekipi_Ndertues WHERE ID_EkipiNdertues = @ID_EkipiNdertues)
    BEGIN
        UPDATE Ekipi_Ndertues
        SET NrPuntoreve = @NrPuntoreve
        WHERE ID_EkipiNdertues = @ID_EkipiNdertues
    END
    ELSE
    BEGIN
        PRINT 'Kompania Ndertuese me ID: ' + CAST(@ID_EkipiNdertues AS VARCHAR(10)) + 'nuk ekziston.'
    END
END

EXEC UpdateNumriPuntoreve @ID_EkipiNdertues = 6, @NrPuntoreve = 300;

--4. Shfaqni Emailin dhe Numrin e telefonit te konfirmimit nga publiku varesisht ID's se rezervimit qe i jep ne input
CREATE PROCEDURE GetContact (@RezervimiID INT)
AS
BEGIN
    IF EXISTS (SELECT * FROM Rezervimi WHERE ID_Rezervimi = @RezervimiID)
    BEGIN
        SELECT Email, Nr_Kontaktues
        FROM Konfirmimi
        WHERE ID_Rezervimi = @RezervimiID
    END
    ELSE
    BEGIN
        PRINT 'Nuk u gjend Rezervim me kete id: ' + CAST(@RezervimiID AS VARCHAR(10))
    END
END

EXEC GetContact @RezervimiID = 25


--3. Beni update statusin VIP bazuar ne CR_Code qe i jepni
CREATE PROCEDURE UpdateVIP (@QR_Code INT, @VIP CHAR(1))
AS
BEGIN
  IF (@VIP NOT IN ('T', 'F'))
    RAISERROR ('Invalid VIP status', 16, 1)

  UPDATE Tiketa
  SET VIP = @VIP
  WHERE QR_Code = @QR_Code
END;

EXEC UpdateVIP @QR_Code = 1000, @VIP = 'F'


--4. Shfaqni detajet e pageses varesisht ID te rezervimtit qe i jepni si input 
CREATE PROCEDURE GetPagesa (@RezervimiID INT)
AS
BEGIN
    IF EXISTS (SELECT * FROM Pagesa WHERE ID_Rezervimi = @RezervimiID)
    BEGIN
        SELECT *
        FROM Pagesa
        WHERE ID_Rezervimi = @RezervimiID
    END
    ELSE
    BEGIN
        PRINT 'Nuk u gjend Rezervim me kete ID: ' + CAST(@RezervimiID AS VARCHAR(10))
    END
END

EXEC GetPagesa @RezervimiID = 8