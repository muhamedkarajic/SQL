create database BrojIndeksa on primary
(
	NAME = 'BrojIndeksa',
	FILENAME = 'C:\BP2\data\BrojIndeksa.mdf',
	SIZE = 5 MB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 10%
),
(
	NAME = 'BrojIndeksa_sek',
	FILENAME = 'C:\BP2\data\BrojIndeksa_sek.ndf',
	SIZE = 5 MB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 10%
)
LOG ON
(
	NAME = 'BrojIndeksa_log',
	FILENAME = 'C:\BP2\log\BrojIndeksa_log.ldf',
	SIZE = 2 MB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 5%
)

use BrojIndeksa

--Studenti
--	StudentID primarni ključ, početna vrijednost 170001, inkrement 1
--	Ime znakovni tip 15 karaktera (obavezan unos),
--	Prezime znakovni tip 20 karaktera (obavezan unos),
--	JMBG znakovni tip 13 karaktera (obavezan unos i jedinstvena vrijednost), 
--	DatumRod datumski tip (obavezan unos),
--	Email znakovni tip 40 karaktera (jedinstvena vrijednost).



create table Studenti
(
	StudentID int constraint PK_StudentID primary key(StudentID) identity(170001, 1),
	Ime nvarchar(15) not null,
	Prezime nvarchar(20) not null,
	JMBG nvarchar(13) not null
	constraint UQ_JMBG UNIQUE NONCLUSTERED CHECK (LEN(JMBG)=13),
	Email nvarchar(40) not null
	constraint UQ_EMAIL UNIQUE NONCLUSTERED
)

select * from Studenti



--Testovi
--	TestID primarni ključ, početna vrijednost 1, popunjava se sa inkrementom 1
--	Datum datumski tip za unos datuma i vremena (obavezan unos),
--	Naziv znakovni tip 50 karaktera (obavezan unos),
--	Oznaka znakovni tip 10 karaktera (obavezan unos i jedinstvena vrijednost),
--	Oblast znakovni tip 50 karaktera (obavezan unos),
--	MaksBrojBod cjelobrojni tip (obavezan unos),

create table Testovi(
	TestID int constraint PK_TestID primary key identity(1,1),
	Datum datetime not null,
	Naziv nvarchar(50) not null,
	Oznaka nvarchar(10) not null,
	Oblast nvarchar(50) not null,
	MaksBrojBod	int not null,
)



--RezultatiTesta
--	Polozio polje za unos ishoda testiranja – DA/NE (obavezan unos)
--	OsvBodovi polje za unos decimalnog broja (obavezan unos),
--	Napomena polje za unos 100 karaktera.
--Primarni ključ tabele RezultatiTesta formirati kao kombinaciju primarnih ključeva prve dvije tabele.

--Napomena: Student može polagati više testova i za svaki test ostvariti određene rezultate, pri čemu student ne može 2 puta polagati isti test. Isti test može polagati više studenata.

create table RezultatiTesta(
	Polozio bit not null,
	OsvBodovi decimal(18,2),
	Napomena nvarchar(100),
	TestID int not null constraint FK_RezultatiTesta_Testovi 
	foreign key(TestID) references Testovi(TestID),
	StudentID int not null constraint FK_RezultatiTesta_Studenti
	foreign key(StudentID) references Studenti(StudentID),
	constraint PK_RezultatiTesta primary key (StudentID, TestID)
)

--create table RezultatiTesta(
--	StudentID int not null,
--	TestID int not null,
--	Polozio bit not null,
--	OsvBodovi decimal(18,2),
--	Napomena nvarchar(100),
--	constraint PK_RezultatiTesta primary key(StudentID, TestID),
--	constraint FK_RezultatiTesta_Studenti foreign key(StudentID) references Studenti(StudentID),
--	constraint FK_RezultatiTesta_Testovi foreign key(TestID) references Testovi(TestID),
--)



--Kreirati referenciranu tabelu Gradovi koja će se referirati na tabelu Studenti i sadržavati polja GradID i NazivGrada. 
--Nakon kreiranja tabele Gradovi u tabeli Studenti dodati referencu prema tabeli Gradovi, te polje Adresa dužine 100 znakova.
create table Gradovi(
	GradID int constraint PK_GradID primary key,
	NazivGrada nvarchar(30) not null
)

alter table Studenti
add GradID int null constraint FK_Studenti_Gradovi
	foreign key(GradID) references Gradovi(GradID),
	Adresa nvarchar(100) null



--U tabelu Studenti importovati 10 kupaca iz baze podataka AdventureWorks2014 i to sljedeće kolone:
-- FirstName (Person) -> Ime,
-- LastName (Person) -> Prezime,
-- Zadnjih 13 karaktera kolone rowguid (Customer) - crticu zamijeniti brojem 0 -> JMBG,
-- EmailAddress (EmailAddress) -> Email.

--insert into Studenti
--select top 10 FirstName, LastName, right(rowguid, 13)
--from AdventureWorks2014.Person.Person

insert into Studenti(Ime, Prezime, JMBG, Email)
select top 10 p.FirstName, p.LastName, REPLACE(right(c.rowguid, 13), '-',0) , ea.EmailAddress
from AdventureWorks2014.Person.Person as p
	inner join AdventureWorks2014.Sales.Customer as c
	on p.BusinessEntityID = c.PersonID
	inner join AdventureWorks2014.Person.EmailAddress as ea
	on ea.BusinessEntityID = p.BusinessEntityID
--select * from Studenti



--a) U tabelu Testovi unijeti minimalno 3 zapisa
--set Studenti identity_insert off

insert into Testovi
values
('05.06.2015', 'MS Access', 'MSACC1', 'Baze podataka', 50),
('06.09.2015', 'SQL Server', 'SQLS1', 'Baze podataka', 70),
(GETDATE(), 'ASP.NET', 'ASPNET1', 'Web programiranje', 80)

--b) U tabelu RezultatiTesta unijeti 10 zapisa.
insert into RezultatiTesta(StudentID, TestID, Polozio, OsvBodovi)
values
(170001, 1, 1, 42),
(170002, 1, 0, 18),
(170003, 1, 1, 26),
(170002, 2, 1, 68),
(170003, 2, 0, 20),
(170002, 3, 1, 72),
(170003, 3, 1, 67),
(170005, 3, 0, 27),
(170006, 3, 1, 72),
(170007, 3, 0, 38)



--Kreirati upit koji prikazuje rezultate testiranja za određeni test (ASPNET1). 
--Kao rezultat upita prikazati sljedeće kolone: Ime i Prezime, jmbg studenta, Datum, Naziv, Oznaku, Oblast i maksimalan broj bodova na testu, 
--te polje položio, osvojene bodove i procentualni rezultat testa.

select Ime, Prezime, JMBG, Datum, Naziv, Oznaka, Oblast, MaksBrojBod, OsvBodovi, convert(decimal(18,2), round((OsvBodovi/MaksBrojBod)*100, 2)) as 'Procenat'
from Studenti as s 
inner join RezultatiTesta as rt
on rt.StudentID = s.StudentID
inner join Testovi as t
on rt.TestID = t.TestID
where Oznaka = 'ASPNET1'
--select * from Testovi



--Uz upotrebu podupita kreirati upit koji prikazuje Naziv testa, Datum održavanja, ukupan broj studenata koji su položili i 
--ukupan broj studenata koji nisu položili test. Uzeti u obzir samo testove na kojima su minimalno dva studenata položila.

select Naziv, Datum,
(select count(*) from RezultatiTesta where TestID = t.TestID and Polozio = 0) as Pali,
(select count(*) from RezultatiTesta where TestID = t.TestID and Polozio = 1) as Polozili
from Testovi as t
where (select count(*) from RezultatiTesta where TestID = t.TestID and Polozio = 1) > 1



--Izmijeniti rezultate testiranja svim Studentima koji su položili određeni test (ASPNET1). 
--Svim studentima koji su položili test broj osvojenih bodova uvećati za 5.

select Naziv, Oznaka, OsvBodovi, OsvBodovi + 5 
from RezultatiTesta rt
inner join Testovi t
on t.TestID = rt.TestID
where Oznaka = 'ASPNET1' and Polozio = 1



--Obrisati jedan test i ostvarene rezultate na testu (MSACC1).
delete from RezultatiTesta
from RezultatiTesta rt inner join Testovi t
on t.TestID = rt.TestID
where Oznaka = 'MSACC1'



--Obrisati tabelu Gradovi i ukloniti polja GradID i Adresa u tabeli Studenti.
alter table Studenti
drop constraint FK_Studenti_Gradovi

alter table Studenti
drop column GradID, Adresa

drop table Gradovi