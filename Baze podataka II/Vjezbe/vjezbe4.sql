--1. Kreirati bazu podataka Radna

create database Radna

use Radna



--2. Kreirati tabelu Autori koja će se sastojati od sljedećih polja:
--AutorID, 11 karaktera, primarni ključ, obavezan unos,
--Prezime, 40 karaktera, obavezan unos,
--Ime, 20 karaktera, obavezan unos,
--Telefon, 12 karaktera, obavezan unos,
--Adresa, 40 karaktera,
--Grad, 20 karaktera, 
--Drzava, 2 karaktera,
--PostanskiBroj, 5 karaktera,
--StanjeUgovora, bit polje

create table Autori(
	AutorID varchar(11) constraint PK_AutorID primary key(AutorID),
	Prezime varchar(40) not null,
	Ime varchar(20) not null,
	Telefon char(12) not null,
	Adresa varchar(40) null,
	Grad varchar(20) null, 
	Drzava char(2) null,
	PostanskiBroj char(5) null,
	StanjeUgovora bit not null,
)
--drop table Autori



--3. Importovati u tabelu Autori podatke iz tabele authors baze pubs  
--uz uslov da ID autora započinje brojevima 1, 2 ili 3 i da autor ima zaključen ugovor.

insert into Autori

select *
from pubs.dbo.authors as a
where a.au_id LIKE '[123]%'
--select * from Autori
--delete Autori



--4. U tabelu Autori iz tabele authors baze pubs importovati vrijednosti 
--iz polja au_id, au_lname, au_fname, phone i address 
--pri čemu adresa počinje cifrom 3 i na trećem mjestu se nalazi cifra 1. 
--Uzeti da svi autori imaju potpisan ugovor.

insert into Autori

select au_id, au_lname, au_fname, phone, address, null, null, null, 1
from pubs.dbo.authors as a
where a.address LIKE '3_1%' AND a.contract = 1
--select * from Autori



--5. Iz tabele Autori obrisati sve autore čiji broj telefona počinje sa 40 ili 70.

delete Autori
--select * from Autori
where Telefon like '40%' or Telefon like '70%'



--6. U tabeli Autori izvršiti izmjenu svih NULL odgovarajućim vrijednostima.

update Autori
SET Drzava = 'BH', PostanskiBroj = 77230, Grad = 'Velika Kladusa'
WHERE Drzava is null AND PostanskiBroj is null AND Grad is null
--select * from Autori



--7. Izbrisati sve podatke iz tabele Autori i importovati sve podatke iz tabele authors baze pubs.
delete from Autori

insert into Autori
select * from pubs.dbo.authors



--8. Kreirati tabelu Djelo koja će se sastojati od polja:
--DjeloID, 6 karaktera, primarni ključ, obavezan unos,
--NazivDjela, 80 karaktera, obavezan unos,
--Zanr, 12 karaktera, obavezan unos,
--IzdavacID, 4 karaktera, 
--Cijena, novčana varijabla,
--Dobit, novčana varijabla,
--Klasifikacija, cjelobrojna varijabla,
--GodisnjaProdaja, cjelobrojna varijabla,
--Biljeska, 200 karaktera,
--DatumIzdavanja, datumska varijabla, obavezan unos,
--VrijemIzdavanja, vremenska varijabla, obavezan unos

create table Djelo(
	DjeloID char(6) constraint PK_DjeloID primary key(DjeloID),
	NazivDjela char(80) not null,
	Zanr char(12) not null,
	IzdavacID char(4),
	Cijena money,
	Dobit money,
	Klasifikacija int,
	GodisnjaProdaja int,
	Biljeska char(200),
	DatumIzdavanja date not null,
	VrijemIzdavanja time not null,
)
--drop table Djelo



--9. Importovati u tabelu Djelo podatke iz svih polja tabele titles baze pubs 
--uz uslov da vrijednsot polja price bude NULL. 
--Voditi računa o načinu punjenja polja DatumIzdavanja i VrijemeIzdavanja.

insert into Djelo

select title_id, title, type, pub_id, price, 
	advance, royalty, ytd_sales, notes, 
	CONVERT(date, pubdate), CONVERT(time, pubdate) 
from pubs.dbo.titles
--delete from Djelo



--10. Trenutno je u toku akcija na prodaju svih djela. Potrebno je u tabelu Djela 
--importovati podatke iz svih polja tabela titles baze pubs  
--pri čemu će cijena biti korigovana na sljedeći način:

--a) djela čija je cijena veća ili jednaka 15 KM cijenu smanjiti za 20%
insert into Djelo
select title_id, title, type, pub_id, price - (price*15/100), 
	advance, royalty, ytd_sales, notes, 
	CONVERT(date, pubdate), CONVERT(time, pubdate) 
from pubs.dbo.titles
where price >= 15
--select Cijena, Cijena - (Cijena*20/100) as 'Nova Cijena' from Djelo where Cijena > 15
--(8 rows affected)

--b) djela čija je cijena manja od 15 KM cijenu smanjiti za 15%
insert into Djelo
select title_id, title, type, pub_id, ISNULL((price - (price*20/100)), 0), 
	advance, royalty, ytd_sales, notes, 
	CONVERT(date, pubdate), CONVERT(time, pubdate) 
from pubs.dbo.titles
where price < 15 OR price is null



--11. U tabeli Djelo zamijeniti NULL odgovarjućim vrijednostima u svim poljima u kojima nije postavljen zanr djela.
update Djelo
set Zanr = 'popular_comp'
where Zanr = 'UNDECIDED'
--select * from Djelo



--12. Iz tabele Djelo obrisati sve zapise u kojima je u bilo kojem polju NULL vrijednost ili je cijena manja od 5 KM.
delete from Djelo
where Cijena < 5 OR Cijena is null
--(4 rows affected)



--13. Obrisati sve zapise iz tabele Djelo i importovati sve zapise iz tabele titleauthor 
--uz vođenje računa da se ispravno popune sva polja tabele Djelo.
delete from Djelo

insert into Djelo
	select distinct t.title_id, t.title, t.type, t.pub_id, t.price, 
		t.advance, t.royalty, t.ytd_sales, t.notes, 
		CONVERT(date, t.pubdate), CONVERT(time, t.pubdate) 
	from pubs.dbo.titleauthor as ta left join pubs.dbo.titles as t
	on t.title_id = ta.title_id
--insert into Djelo
--select title_id, title, type, pub_id, price, 
--	advance, royalty, ytd_sales, notes, 
--	CONVERT(date, pubdate), CONVERT(time, pubdate) 
--from pubs.dbo.titles

--select * from Djelo
--select * from pubs.dbo.titles



--14. Kreirati tabelu AutorDjelo koja će se sastojati od sljedećih polja:
--AutorID, 11 znakova, primarni ključ, obavezan unos, 
--DjeloID, 6 znakova, primarni kljuć, obavezan unos,
--RedBrAutora, kratka cjelobrojna varijabla,
--UdioAutPrava, cjelobrojna varijabla,
--ISBN, 25 znakova
--Polja AutorID i DjeloID su spoljni ključevi prema tabelama Autor i Djelo.

create table AutorDjelo(
	AutorID varchar(11) constraint FK_AutorID foreign key references Autori(AutorID) not null,
	DjeloID char(6) constraint FK_DjeloID foreign key references Djelo(DjeloID) not null,
	RedBrAutora int,
	UdioAutPrava int,
	ISBN char(25),
)
--drop table AutorDjelo



--15. Obrisati ograničenja spoljnih ključeva, a zatim ih ponovo uspostaviti.
alter table AutorDjelo
drop constraint FK_AutorID, FK_DjeloID



--16. U tabelu AutorDjelo importovati sve zapise iz tabele titleauthor baze pubs, pri čemu će se polje ISBN popunjavati na sljedeći način:
--iz polja title_id preuzeti cifre, te prije njih ubaciti riječ ISBN pri čemu između ISBN i cifara treba biti jedno prazno mjesto, 
--a poslije njih prazno mjesto i vrijednost polja au_id iz tabele titleauthor baze pubs.

insert into AutorDjelo
select 
	au_id, 
	title_id, 
	au_ord, 
	royaltyper, 
	'ISBN ' + substring(title_id,3, len(title_id)) + ' ' + au_id as 'ISBN'
from pubs.dbo.titleauthor
--select * from AutorDjelo



--17. Iz tabele AutorDjelo dati pregled 10 zapisa sa najmanjim udjelom autorskih prava. 
--Potrebno je dati prikaz svih polja.
select TOP 10 * 
from AutorDjelo
order by UdioAutPrava



--18. Kreirati bazu podataka RadnaBaza.
create database RadnaBaza

use RadnaBaza



--19. U bazi RadnaBaza kreirati tabelu Narudzbe koja će se sastojati od polja:
--NarudzbaID, cjelobrojna varijabla, primarni ključ
--NaruciteljID, 5 znakova,
--ZaposlenikID, cjelobrojna varijabla,
--DatumNarudbe, datumska varijabla,
--KrajnjiDatumIsporuke, datumska varijabla,
--DatumIsporuke, datumska varijabla,
--IsporuciteljID, cjelobrojna varijabla,
--CijenaPrevoza, novčana varijabla,
--NazivNarucitelja, 40 unicode karaktera,
--AdresaNarucitelja, 60 unicode karaktera,
--GradNarucitelja, 15 unicode karaktera,
--RegijaNarucitelja, 15 unicode karaktera,
--PostBrojNarucitelja, 10 unicode karaktera,
--DrzavaNarucitelja, 15 unicode karaktera

create table Narudzbe
(
	NarudzbaID int constraint PK_NarudzbaID primary key(NarudzbaID),
	NaruciteljID char(5) not null,						   
	ZaposlenikID int not null,			
	DatumNarudbe date not null,				
	KrajnjiDatumIsporuke date null,		
	DatumIsporuke date null,			   
	IsporuciteljID int,		   
	CijenaPrevoza money null,				
	NazivNarucitelja nvarchar(40) ,		   
	AdresaNarucitelja nvarchar(60),		
	GradNarucitelja nvarchar(15),		   
	RegijaNarucitelja nvarchar(15),		
	PostBrojNarucitelja nvarchar(10),	   
	DrzavaNarucitelja nvarchar(15)
)
--drop table Narudzbe
--delete from Narudzbe



--20. U tabelu Narudzbe importovati sve zapise iz tabele Orders baze Northwind kod kojih je cijena prevoza manja od 100 
--i prva dva znaka adrese su cifra ili prazno mjesto, a nakon toga slijede znaci koji nisu cifre. 
--U datumske varijable upisati samo datum (bez vremena). 
--Također, sve NULL vrijednosti polja ShipRegion zamijeniti sa BH. 

insert into Narudzbe
select *
from NORTHWND.dbo.Orders
where Freight > 100 and ShipAddress like '[a-z ][a-z ]%'

update Narudzbe
set RegijaNarucitelja = 'BH'
where RegijaNarucitelja is null
--select * from Narudzbe



--21. U tabeli Narudzbe kreirati novu kolonu Broj_u_Ulici u koju će se smjestiti broj iz kolone AdresaNarucitelja, 
--dok će u koloni AdresaNarucitelja biti preostali dio adrese.
alter table Narudzbe
add Broj_u_Ulici int null

--Za jednocifrene i dvocifrene (dio trocifrenih) brojeve
update Narudzbe 
set Broj_u_Ulici = convert(int, substring(AdresaNarucitelja, len(AdresaNarucitelja)-1, len(AdresaNarucitelja)))
where substring(AdresaNarucitelja, len(AdresaNarucitelja), len(AdresaNarucitelja)) like '[0-9]'
--Za trocifrene brojeve brojeve
update Narudzbe 
set Broj_u_Ulici = substring(AdresaNarucitelja, len(AdresaNarucitelja)-3, len(AdresaNarucitelja))
where 
substring(AdresaNarucitelja, len(AdresaNarucitelja)-2, len(AdresaNarucitelja)) like '[0-9][0-9][0-9]'
--select * from Narudzbe



--22. Iz tabele Orders baze Northwind ispisati prvu riječ naziva naručitelja 
--pri čemu treba izostaviti one čiji naziv predstavlja neprekinuti niz znakova.
select left(ShipName, charindex(' ', ShipName)) as 'Prva rijec', ShipName
from NORTHWND.dbo.Orders
where left(ShipName, charindex(' ', ShipName)) <> ''



--23. U tabeli Narudzba kreirati novu kolonu Lozinka. Kolonu popuniti koristeći polja LoginID i HireDate 
--iz tabele HumanResources.Employee baze AdventureWorks2014. 
--Lozinka se formira tako što se spoje datum zaposlenja i ime zaposlenika, te se tako dobijeni string obrne.
alter table Narudzbe
add Lozinka char(40) null


