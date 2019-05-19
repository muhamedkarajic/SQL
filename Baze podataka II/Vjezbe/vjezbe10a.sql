USE BrojIndeksa

-- Unutar baze podataka BrojIndeksa kreirati tabelu Komisija sa sljedećim poljima:
--	Ime					polje za unos 30 karaktera (obavezan unos)
--	Prezime		polje za unos 30 karaktera (obavezan unos)
--	Titula			polje za unos 15 karaktera,
--	Telefon		polje za unos 20 karaktera,
--	Email			polje za unos 50 karaktera.
-- Tabelu kreirati bez primarnog ključa.

create table Komisija(
Ime		char(30) not null,
Prezime	char(30) not null,	
Titula	char(30) not null,	
Telefon	char(30),	
Email	char(30)	
)
--drop table Komisija
--delete Komisija



--U tabelu Komisija importovati 10000 osoba iz tabela Person.Person, Person.PersonPhone i Person.PersonEmailAddress baze podataka AdventureWorks2014. 
--Iz kolone PhoneNumber izdvojiti 7 znakova kao broj telefona.
--NULL vrijednost u tabeli Person.Person zamijeniti vrijednošću nepoznat. 
--Uključiti opciju aktuelni plan izvršenja kako bi se dobio prikaz plana izvršenja upita.

use AdventureWorks2014
insert into BrojIndeksa.dbo.Komisija(Ime, Prezime, Titula, Telefon, Email)
select top 10000 P.FirstName, P.LastName, isnull(p.Title, 'N/A'), left(pp.PhoneNumber, 7), ea.EmailAddress
from Person.Person as P inner join Person.PersonPhone as pp
on p.BusinessEntityID = pp.BusinessEntityID
inner join Person.EmailAddress as ea
on p.BusinessEntityID = ea.BusinessEntityID



--U tabelu Komisija dodati primarni ključ pod nazivom ClanKomisijeID (automatsko generiranje vrijednosti sa inkrementom 1), 
--te provjeriti aktualni plan izvršenja.

alter table Komisija
add ClanKomisijeID int constraint PK_Komisija primary key identity(1,1)



--Kreirati prosti nonclustered indeks na polju telefon tabele Komisija i insert upitom analizirati aktualni plan izvršenja.
go
create nonclustered index IX_Telefon on Komisija(
	Telefon asc
)



--Kreirati kompozitni nonclustered indeks sastavljen od kolona (polja) ime i prezime i 
--insert upitom testirati primjenu indeksa, provjeravajući aktualni plan izvršenja.
create nonclustered index IX_ImePrezime on Komisija(
	Ime asc,
	Prezime asc
)



--Kreirati unique nonclustered indeks nad tabelom Komisija, polje Email. 
--Insert komandom testirati funkcionalnost prethodno kreiranog indeksa, provjeravajući aktualni plan izvršenja.
create unique nonclustered index UQ_Email on Komisija
(
	Email asc
)



-- U tabeli discount baze pubs izvršiti unos podataka stor_id. Za popust od 10.50 stor_id postaviti na 7067, 
-- a za 6.70 postaviti na 7131. Provjeriti aktuelni plan izvršenja.
use pubs

update discounts
set discount = 10.5
where stor_id = 7067

update discounts
set discount = 6.7
where stor_id = 7131



-- Kreirati upit koji će iz tabela discounts, sales, stores i titles baze pubs na osnovu informacije 
-- o visini popusta (discount) prikazati sljedeća polja: tip popusta, naziv trgovine, grad, datum narudžbe, 
-- količinu, naziv djela i književni žanr djela - tip. 
-- Popust je veći od 5. 
-- Rezultat sortirati po književnom žanru. 
-- Evidentirati aktuelni plan izvršenja.

select d.discounttype, st.stor_name, st.city, sa.ord_date, sa.qty, t.title, t.type, d.discount
from discounts as d
	inner join sales as sa
	on d.stor_id = sa.stor_id
	inner join stores as st
	on st.stor_id = d.stor_id
	inner join titles as t
	on t.title_id = sa.title_id
where d.discount <= 5
order by t.type



-- Nad bazom podataka Northwind kreirati 5 složenijih upita primjenom različitih elemenata SELECT komande. 
-- Uključiti prikaz plana izvršenja i analizirati komentare. Primjenom alata SQL Server Profiler kreirati novi trace, 
-- izvršiti kreirane upite te dobiveni rezultat sačuvati.	
-- Iz tabela Customers i Orders u bazi Northwind za narudžbe izvršene u 1997. godini prikazati ime naručitelja (kupca) i 
-- ukupnu vrijednost troška prevoza po naručitelju.
use NORTHWND

select c.CompanyName, sum(o.Freight) as 'Prijevoz'
from Customers as c
	inner join Orders as o
	on o.CustomerID = c.CustomerID
where year(o.OrderDate) = 1997
group by c.CompanyName



-- Iz tabela Employees, EmployeeTerritories, Territories i Region baze Northwind prikazati prezime i ime uposlenika 
-- kao polje ime i prezime, teritoriju i regiju koju pokrivaju i stariji su od 30 godina.

select e.FirstName + ' ' + e.LastName 'Ime i prezime', t.TerritoryDescription, r.RegionDescription
from Employees e
	inner join EmployeeTerritories et
	on et.EmployeeID = e.EmployeeID
	inner join Territories t
	on t.TerritoryID = et.TerritoryID
	inner join Region r
	on r.RegionID = t.RegionID
where datediff(year, e.BirthDate, getdate()) > 30



-- Iz tabela Employee, Order Details i Orders baze Northwind prikazati ime i prezime uposlenika kao polje ime i prezime, 
-- jediničnu cijenu, količinu i ukupnu vrijednost pojedinačne narudžbe kao polje ukupno za sve narudžbe u 1997. godini, 
-- pri čemu će se rezultati sortirati prema novokreiranom polju ukupno.
select	e.FirstName + ' ' + e.LastName 'Ime i prezime', e.FirstName, e.LastName, 
		od.UnitPrice - od.UnitPrice * od.Discount 'Cijena', od.Quantity 'Kolicina', 
		od.Quantity*(od.UnitPrice - od.UnitPrice * od.Discount) 'Ukupno'
from Employees e
	inner join Orders o
	on e.EmployeeID = o.EmployeeID
	inner join [Order Details] od
	on od.OrderID = o.OrderID
where year(o.OrderDate) = 1997
order by 'Ukupno'



-- Iz tabela Employee, Order Details i Orders baze Northwind prikazati ime uposlenika i ukupnu vrijednost svih narudžbi 
-- koje je taj uposlenik napravio u 1996. godini ako je ukupna vrijednost veća od 50000, pri čemu će se rezultati 
-- sortirati uzlaznim redoslijedom prema polju ime. Vrijednost sume zaokružiti na dvije decimale.

select	e.FirstName, sum(od.Quantity * (od.UnitPrice - od.Discount * od.UnitPrice)) 'Ukupno'
from Employees e
	inner join Orders o
	on e.EmployeeID = o.EmployeeID
	inner join [Order Details] od
	on od.OrderID = o.OrderID
where year(o.OrderDate) = 1997
group by e.EmployeeID, e.FirstName, e.LastName
having  sum(od.Quantity * (od.UnitPrice - od.Discount * od.UnitPrice)) > 50000
order by e.FirstName



-- Iz tabela Categories, Products i Suppliers baze Northwind prikazati naziv isporučitelja (dobavljača), 
-- mjesto i državu isporučitelja (dobavljača) i naziv(e) proizvoda iz kategorije napitaka (pića) kojih na stanju 
-- ima više od 30 jedinica. Rezultat upita sortirati po državi.

select s.CompanyName, s.Country, s.City, p.ProductName 
from Categories c
	inner join Products p
	on c.CategoryID = p.CategoryID
	inner join Suppliers s
	on p.SupplierID = s.SupplierID
where c.CategoryID = 1 and p.UnitsInStock > 30
