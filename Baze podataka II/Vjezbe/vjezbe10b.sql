--Iz tabela HumanResources.Employee i Person.Person baze AdventureWokrs2014 kreirati pogled (view) koji će sadržavati sljedeća polja:
--* BusinessEntityID		imenovati kao ZaposlenikID
--* FirstName							imenovati kao Ime
--* LastName								imenovati kao Prezime
--Rezultat sortirati prema ZaposlenikID.

use AdventureWorks2014

go
create view EmployeePeronView as
select p.BusinessEntityID as ZaposlenikID, p.FirstName as Ime, p.LastName as Prezime 
from HumanResources.Employee as e inner join Person.Person as p
on p.BusinessEntityID = e.BusinessEntityID

select * from EmployeePeronView
order by ZaposlenikID



--U bazi AdventurerWorks2014 kreirati tabele Uposlenik i Osoba. 

--Tabela Uposlenik će sadržavati sljedeća polja: 
-- UposlenikID			numeričko polje,
-- NacionalniID		znakovno polje dužine 15, obavezan unos
-- LoginID					znakovno polje dužine 256 znakova, obavezan unos
-- RadnoMjesto			znakovno polje dužine 50 znakova, obavezan unos
 
create table Uposlenik (
	UposlenikID int not null,
	NacionalniID char(15) not null,
	LoginID	char(256) not null,
	RadnoMjesto	char(50) not null
)



--Tabela Osoba će sadržavati sljedeća polja
--- OsobaID						numeričko polje
--- VrstaUposlenika	znakovno polja dužine 2 znaka, obavezan unos
--- Prezime						znakovno polje dužine 50 znakova, obavezan unos
--- Ime									znakovno polje dužine 50 znakova, obavezan unos

create table Osoba (
	OsobaID int not null,
	VrstaUposlenika char(2) not null,
	Prezime	char(50) not null,
	Ime	char(50) not null
)



--Nakon kreiranja tabela u tabelu Uposlenik kopirati odgovarajuće zapise iz tabele HumanResources.Employee uposlenika koji su zaposleni kao menadžeri. 
--U tabelu Osoba kopirati odgovarajuće podatke iz tabele Person.Person osoba koji su evidentirani kao uposlenik. (VrstaUposlenika je EM).
insert into Uposlenik(UposlenikID, LoginID, NacionalniID, RadnoMjesto)
select BusinessEntityID, LoginID, NationalIDNumber, JobTitle
from HumanResources.Employee
where JobTitle like '% Man%'

select * from Uposlenik

insert into Osoba(OsobaID, VrstaUposlenika, Prezime, Ime)
select BusinessEntityID, PersonType, LastName, FirstName
from Person.Person
where PersonType like 'EM'



--Kreirati pogled (view) nad tabelama Uposlenik i Osoba koji će sadržavati sva polja obje tabele. 
--UposlenikID i OsobaID su polja koja sadržavaju iste vrijednosti.
go
create view UposlenikOsoba_view as
select UposlenikID, Prezime, Ime, RadnoMjesto, VrstaUposlenika, NacionalniID, LoginID
from Uposlenik as u
inner join Osoba as o
on o.OsobaID = u.UposlenikID



--Koristeći tabele Employees, EmployeeTerritories, Territories i Region baze Northwind kreirati pogled view_Employee 
--koji će sadržavati prezime i ime uposlenika kao polje ime i prezime, teritoriju i regiju koju pokrivaju i stariji su od 30 godina.
use NORTHWND

go
create view EmployeeTerritoriesRegion30 as
select LastName, FirstName, t.TerritoryDescription, r.RegionDescription
from Employees as e
	inner join EmployeeTerritories as et
	on e.EmployeeID = et.EmployeeID
	inner join Territories as t
	on t.TerritoryID = et.TerritoryID
	inner join Region as r
	on r.RegionID = t.RegionID
where DATEDIFF(year, e.BirthDate, getdate()) > 30


--Koristeći tabele Employee, Order Details i Orders baze Northwind kreirati pogled view_Employee1 koji će sadržavati ime i prezime 
--uposlenika kao polje ime i prezime, jediničnu cijenu, količinu i ukupnu vrijednost pojedinačne narudžbe kao polje ukupno za sve narudžbe u 1997. godini.
select FirstName + ' ' + LastName as 'Ime i prezime', od.UnitPrice, od.Quantity, od.UnitPrice * od.Quantity as 'Ukupno'
from Employees as e
	inner join Orders as o
	on o.EmployeeID = e.EmployeeID
	inner join [Order Details] od
	on od.OrderID = o.OrderID
where year(o.OrderDate) = 1997


--Koristeći tabele Employee, Order Details i Orders baze Northwind kreirati pogled view_Employee2 koji će sadržavati ime uposlenika i 
--ukupnu vrijednost svih narudžbi koje je taj uposlenik napravio u 1996. godini ako je ukupna vrijednost veća od 50000, 
--pri čemu će se rezultati sortirati uzlaznim redoslijedom prema polju ime. Vrijednost sume zaokružiti na dvije decimale.



--Koristeći tabele Categories, Products i Suppliers baze Northwind kreirati pogled view_Categories koji će sadržavati naziv isporučitelja (dobavljača), 
--mjesto i državu isporučitelja (dobavljača) i naziv(e) proizvoda iz kategorije napitaka (pića) kojih na stanju ima više od 30 jedinica.

go
create view CategoriesProductsSuppliers_view as
select s.ContactName, s.Country, s.City, p.ProductName 
from Categories as c
	inner join Products as p
	on c.CategoryID = p.CategoryID
	inner join Suppliers as s
	on s.SupplierID = p.SupplierID
where p.UnitsInStock > 30 and c.CategoryName = 'Beverages'



--Kreirati tabele UposlenikZDK i UposlenikHNK koje će formirati pogled view_part_UposlenikKantoni. 
--Obje tabele će sadržavati polja UposlenikID, NacionalniID, LoginID, RadnoMjesto i Kanton. Sva polja su obavezan unos. 
--Tabela UposlenikZDK će se označiti brojem 1, a tabela UposlenikHNK brojem 2.

USE AdventureWorks2014
CREATE TABLE UposlenikZDK
(
	UposlenikID	INT NOT NULL, 
	NacionalniID	NVARCHAR (15) NOT NULL,
	LoginID		NVARCHAR (256) NOT NULL, 
	RadnoMjesto	NVARCHAR (50) NOT NULL,
	Kanton		SMALLINT NOT NULL CONSTRAINT CK_Kanton_K1 CHECK (Kanton = 1)
	CONSTRAINT PK_Kantoni_K1 PRIMARY KEY (UposlenikID, Kanton)
)

USE AdventureWorks2014
CREATE TABLE UposlenikHNK
(
	UposlenikID	INT NOT NULL, 
	NacionalniID	NVARCHAR (15) NOT NULL,
	LoginID		NVARCHAR (256) NOT NULL, 
	RadnoMjesto	NVARCHAR (50) NOT NULL,
	Kanton		SMALLINT NOT NULL CONSTRAINT CK_Kanton_K2 CHECK (Kanton = 2)
	CONSTRAINT PK_Kantoni_K2 PRIMARY KEY (UposlenikID, Kanton)
)

--Kreirati dijeljeni pogled (partitioned view) view_part_UposlenikKantoni koji će podatke koji se unose u njega distribuirati u tabele UposlenikZDK i UposlenikHNK. 
--Nakon kreiranja u pogled ubaciti 4 podatka, po dva za svaku od tabela. (Tabela UposlenikZDK ima oznaku 1, a UposlenikHNK oznaku 2).
GO
CREATE VIEW dbo.view_part_UposlenikKantoni AS
SELECT		UposlenikID, NacionalniID, LoginID, RadnoMjesto, Kanton FROM dbo.UposlenikZDK
UNION ALL
SELECT		UposlenikID, NacionalniID, LoginID, RadnoMjesto, Kanton FROM dbo.UposlenikHNK

insert into dbo.view_part_UposlenikKantoni
	values(100, 'zdk1', 'ze1', 'domacin_zdk1', 1)
insert into view_part_UposlenikKantoni
	values(101, 'zdk2', 'ze2', 'domacin_zdk2', 1)
insert into view_part_UposlenikKantoni
	values(10, 'hnk1', 'hn1', 'domacin_hnk1', 2)
insert into view_part_UposlenikKantoni
	values(11, 'hnk1', 'hn1', 'domacin_hnk1', 2)


SELECT * FROM dbo.view_part_UposlenikKantoni

SELECT * FROM UposlenikZDK

SELECT * FROM UposlenikHNK
