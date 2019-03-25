--1. Kreirati bazu Agregatne.
create database Agregatne



--2. Kreirati šemu Funkcije.
use Agregatne
--create schema Funkcije



--3. Kreirati tabelu Odjel u šemi Funkcije koja će se sastojati od sljedećih polja:
--OdjelID, kratka cjelobrojna vrijednost, obavezan unos, primarni ključ sa početnom vrijednošću 1 i korakom povećanja 1
--Naziv, 50 UNICODE znakova, obavezan unos,
--NazivSektora, 50 UNICODE znakova, obavezan unos,
--DatumKreiranja, datumska varijabla za unos datuma
create table Funkcije.Odjel
(
	OdjelID smallint not null constraint PK_OdjelID primary key(OdjelID) identity(1,1),
	Naziv nvarchar(50) not null,
	NazivSektora nvarchar(50) not null,
	DatumKreiranja date not null
)
--delete from Funkcije.Odjel
--drop table Funkcije.Odjel



--4. U tabelu Odjel importovati one zapise iz tabele HumanResources.Department baze AdventureWorks2014 
--koji pripadaju ili sektoru Prodaja i marketing ili Istraživanje i razvoj. 
--Zapise prilikom importa sortirati prema nazivu sektora.
insert into Funkcije.Odjel

select Name, GroupName, convert(date, ModifiedDate)
from AdventureWorks2014.HumanResources.Department
where GroupName like '%Marketing%' or GroupName like '%Research and Development%'
order by GroupName
--select * from Funkcije.Odjel
--select * from AdventureWorks2014.HumanResources.Department



--5. U bazi Agregatne, šemi Funkcije kreirati tabelu AgrOdjel koja će se sastojati od polja:
--NazivSektora, 50 UNICODE karaktera,
--UkupnoSektor, cjelobrojna varijabla
create table Funkcije.AgrOdjel
(
	NazivSektora nvarchar(50) not null,
	UkupnoSektor int
)
--delete from Funkcije.AgrOdjel
--drop table Funkcije.AgrOdjel



 --6. Tabelu AgrOdjel popuniti tako što će se u nju unijeti agregirani podaci iz tabele HumanResources.Department. 
 --Agregacija će se sastojati od ukupnog broja odjela po sektorima.
insert into Funkcije.AgrOdjel
	select GroupName, count(*) as UkupnoSektora
	from AdventureWorks2014.HumanResources.Department
	group by GroupName



--7. Iz tabele HumanResources.Employee baze AdventureWorks2014 
--dati pregled broja uposlenika po godinama rođenja i godinama zaposlenja.

select 
	BusinessEntityID,
	year(BirthDate) as 'Godina rodjenja', 
	count(year(BirthDate)),
	year(HireDate) as 'Godina zaposljavanja',
	count(year(HireDate))
from AdventureWorks2014.HumanResources.Employee 
group by BusinessEntityID, year(BirthDate), year(HireDate)
order by year(BirthDate), year(HireDate) 

--select * from AdventureWorks2014.HumanResources.Employee



select 
	year(BirthDate) as 'Godina rodjenja', 
	year(HireDate) as 'Godina zaposljavanja'
from AdventureWorks2014.HumanResources.Employee 
group by year(BirthDate), year(HireDate)
order by year(BirthDate)
--select * from AdventureWorks2014.HumanResources.Employee



--8. Iz tabele HumanResources.Employee dati prikaz vrijednosti ukupnog broja po menadžerskim pozicijama. 
--Rezultat grupirati prema nazivima pozicija.

select JobTitle, count(*) as 'Broj zaposlenika'
from AdventureWorks2014.HumanResources.Employee 
where JobTitle like '%Manager%'
group by JobTitle
order by count(JobTitle) desc



--9. Potrebno je dati prikaz srednje vrijednosti broja izgubljenih radnih sati po osnovu bolesti. 
--Provjeriti da li dati SQL kod daje željeni rezultat.

select OrganizationLevel, avg(SickLeaveHours)
from AdventureWorks2014.HumanResources.Employee
group by OrganizationLevel



--10. Iz tabele HumanResource.EmployeePayHistory dati prikaz ukupnog broja pojedinih rata koje su veće od 10.
select count(Rate)
from AdventureWorks2014.HumanResources.EmployeePayHistory
where Rate > 10
group by Rate

select RateChangeDate, avg(Rate) as 'Prosjek rate', count(Rate) as 'Broj rate'
from AdventureWorks2014.HumanResources.EmployeePayHistory
where Rate > 10
group by RateChangeDate
order by count(Rate) desc



--11. Iz tabele HumanResource. EmployeePayHistory dati prikaz ukupnog broja pojedinih rata 
--pri čemu će se prikazati samo one rate čiji ukupni broj je veći od 10. 
--Rezultat sortirati u opadajućem redoslijedu po broju rata.
select count(Rate)
from AdventureWorks2014.HumanResources.EmployeePayHistory
group by Rate
having count(Rate) > 10



--12. U tabeli Production.ProductCostHistory se nalaze polja početnog i datuma modificiranja cijene. 
--Dati prikaz ukupnog broja zapisa po vrijednosti dana razlike između navedenih datuma. 
--Rezultat grupirati po vrijednosti dana razlike.

--select dateDiff(day, StartDate, ModifiedDate),
select convert(int, ModifiedDate - StartDate),
count(convert(int, ModifiedDate - StartDate))
from AdventureWorks2014.Production.ProductCostHistory
group by convert(int, ModifiedDate - StartDate)



--13. Product dati prikaz broja zapisa po slovnim oznakama polja ProductNumber. 
--Rezultat sortirati u opadajućem redoslijedu po brojaču i slovnoj oznaci.

select LEFT(ProductNumber, 2) as Slova, count(LEFT(ProductNumber, 2)) as Brojac
from AdventureWorks2014.Production.Product 
group by LEFT(ProductNumber, 2)
order by 2 desc, 1 desc--brojac desc, slova desc
--select distinct LEFT(ProductNumber, 2) from AdventureWorks2014.Production.Product 



--14. Iz tabele Production. Product dati prikaz broja zapisa po godinama početka prodaje. 
--Rezultat sortirati u opadajućem redoslijedu po godini i brojaču.

select year(SellStartDate) as Godina, count(*) as Brojac
from AdventureWorks2014.Production.Product
group by year(SellStartDate)
order by Brojac desc, Godina desc

--15. U bazi Agregatne kreirati tabelu CijenaGodine sa sljedećim poljima:
--Godina, cjelobrojna varijabla,
--Cijena, decimalna varijabla sa 2 decimalna mjesta,
--BrojacCijena, cjelobrojna varijabla
use Agregatne

create table CijenaGodina
(
	Godina int null,
	Cijena decimal(8,2) null,
	BrojacCijena int null,
)
--drop table CijenaGodina



--16. U tabelu CijenaGodine importovati podatke iz tabele Production.
--Product baze AdventureWorks2014 na sljedeći način:
--U polje Godina godinu početka prodaje,
--U polje Cijena standardnu cijenu,
--U polje BrojacCijena broj pojavljivanja pojedinačne cijene

insert into CijenaGodina
	select year(SellStartDate) as Godina, StandardCost, count(*) as 'Broj cijena'
	from AdventureWorks2014.Production.Product
	group by SellStartDate, StandardCost



--17. Iz tabele CijenaGodine dati prikaz minimalne, maksimalne, srednje vrijednosti i 
--zbira polja Cijena. Rezultat grupirati po godini.

select 
	Godina, 
	min(Cijena) as Najniza, 
	max(Cijena) as Najveca,
	avg(Cijena) as Prosjecna,
	sum(Cijena) as Zbir
from CijenaGodina
group by Godina



--18. Iz tabele CijenaGodine izbrojati po vrijednostima sadržaj kolone BrojacCijena. 
--Rezultat grupirati po godini i brojacu cijena. 
--Sortirati u rastućem redoslijedu po godini.

select Godina, BrojacCijena, count(BrojacCijena) as 'Zapisi po godinama'
from CijenaGodina
group by Godina, BrojacCijena
order by Godina



--19. Dodatno: uraditi Rate svih vrijednosti koji su iznad prosjeka.
select Rate
from AdventureWorks2014.HumanResources.EmployeePayHistory
where Rate > (select round(avg(rate), 0) from AdventureWorks2014.HumanResources.EmployeePayHistory)
group by Rate