--1.
--Kreirati bazu Joini.

--U bazi kreirati tabelu JoinTabela1 sa sljedećim poljima:
--OsobaID, cjelobrojna vrijednost, primarni ključ sa automatskim punjenjem i korakom 1
--TipOsobe, 2 karaktera, obavezan unos,
--Prezime 50 karaktera,
--Ime 50 karaktera, obavezan unos,
--BrTel, 25 karaktera, obavezan unos,
--Lozinka, 128 karaktera, obavezan unos

create database Joini

create table JoinTabela1(
	OsobaID int identity(1,1) constraint PK_OsobaID primary key (OsobaID),
	TipOsobe nchar(2) not null,
	Prezime nvarchar(50) null,
	Ime nvarchar(50) not null,
	BrTel nvarchar(25) not null,
	Lozinka nvarchar(128) not null
)

use Joini



--2. U tabelu JoinTabela1 importovati podatke iz kolona 
--PersonType, FirstName, LastName, PhoneNumber i PasswordHash 
--tabela Password, Person i PersonPhone baze AdventureWorks2014.

insert into JoinTabela1 (TipOsobe, Prezime, Ime, BrTel, Lozinka)
select pers.PersonType, pers.FirstName, pers.LastName, phone.PhoneNumber, pass.PasswordHash
from AdventureWorks2014.Person.Password as pass
inner join AdventureWorks2014.Person.Person as pers
on pass.BusinessEntityID = pers.BusinessEntityID
inner join AdventureWorks2014.Person.PersonPhone as phone
on pers.BusinessEntityID = phone.BusinessEntityID



--3. U bazi Join Kreirati tabelu JoinTabela2 koja će se sastojati od polja:
--ProizvodID, cjelobrojna vrijednost, primarni ključ sa automatskim punjenjem i korakom 1
--BrProizvoda, 20 karaktera, obavezan unos,
--Velicina 5 karaktera, 
--Tezina decimalni broj sa 2 decimalna mjesta,
--BrDanaZaProizv cjelobrojna vrijednost, obavezan unos,
--Kolicina cjelobrojna vrijednost, obavezan unos,
--Naziv 50 karaktera

create table JoinTable2(
	ProizvodID int identity(1,1) constraint PK_ProizvodID primary key(ProizvodID),
	BrProizvoda nchar(20) not null,
	Velicina nchar(5) null, 
	Tezina decimal(8,2) null,
	BrDanaZaProizv int not null,
	Kolicina int not null,
	Naziv nchar(50) null,
)
--delete JoinTable2
--drop table JoinTable2



--4. U tabelu JoinTabela2 imporovati podatke iz kolona 
--ProductNumber, Size, Weight, DaysToManufacture, Quantity i Name 
--tabela Location, ProductInventory i Product baze AdventureWorks2014.

insert into JoinTable2 (BrProizvoda, Velicina, Tezina, BrDanaZaProizv, Kolicina, Naziv)
select p.ProductNumber, p.Size, p.Weight, p.DaysToManufacture, pi.Quantity, l.Name
from AdventureWorks2014.Production.ProductInventory as pi
inner join AdventureWorks2014.Production.Product as p
on pi.ProductID = p.ProductID
inner join AdventureWorks2014.Production.Location as l
on pi.LocationID = l.LocationID
-- select * from JoinTable2



--5. U bazi Join kreirati tabelu JoinTabela3 koja će se sastojati od polja:
--KljucID cjelobrojna vrijednost, primarni ključ sa automatskim punjenjem i korakom 1
--DatumRodjenja datumska varijabla, obavezan unos,
--DatumZaposlenja datumska varijabla,
--Resume XML varijabla, obavezan unos,
--OdjelID 3 karaktera

create table JoinTabla3(
	KljucID int constraint PK_KljucID primary key(KljucID),
	DatumRodjenja date not null,
	DatumZaposlenja date not null,
	Resume XML not null,
	OdjelID nchar(3),
)



--6. U tabelu JoinTabela3 importovati podatke iz kolona 
--BirthDate, HireDate, Resume i DepartmentID 
--tabela EmployeeDepartmentHistory, Employee, JobCandidate baze AdventureWorks2014.



--Iz tabela Production.Product, Production.ProductInventory i Product.Location 
--u tabelu JoinTabela2 importovati sve zapise u kojima se ispred, iza ili i ispred i iza dvije cifre nalazi bilo koji znak (karakter)
--Primjeri: aa12 ili 12aa ili a12a ili 12a ili a12*/

insert into JoinTable2
select p.ProductNumber, p.Size, p.Weight, p.DaysToManufacture, pi.Quantity, l.Name
from AdventureWorks2014.Production.ProductInventory as pi
inner join AdventureWorks2014.Production.Product as p
on pi.ProductID = p.ProductID
inner join AdventureWorks2014.Production.Location as l
on pi.LocationID = l.LocationID
where	p.ProductNumber like ('%[A-Z][0-9][0-9][A-Z]%') OR
		p.ProductNumber like ('%[A-Z][0-9][0-9]%') OR
		p.ProductNumber like ('%[0-9][0-9][A-Z]%')
--460



--7.1. Iz tabele PurchaseOrderDetail, PurchaseOrderHeader, Vendor dati prikaz polja
--Name, OrderDate, OrderQty, i UnitPrice. Također dati prikaz ukupne vrijednosti narudžbe.
--Rezultat sortirati po ukupnoj vrijednosti narudžbe.

select v.Name, poh.OrderDate, pod.OrderQty, pod.UnitPrice
from AdventureWorks2014.Purchasing.PurchaseOrderDetail as pod
inner join AdventureWorks2014.Purchasing.PurchaseOrderHeader as poh
on pod.PurchaseOrderID = poh.PurchaseOrderID
inner join AdventureWorks2014.Purchasing.Vendor as v
on v.BusinessEntityID = poh.VendorID
where (pod.OrderQty * pod.UnitPrice) > 10
order by pod.OrderQty * pod.UnitPrice



--7.2. Iz tabele PurchaseOrderDetail, PurchaseOrderHeader, Vendor dati prikaz polja
--Name, OrderDate, OrderQty, i UnitPrice. Također dati prikaz ukupne vrijednosti narudžbe i
--ukupan broj pojedinih ukupan broj pojedinih ukupnih vrijednosti narudžbi. 
--Rezultat sortirati po ukupnom broju pojedinih ukupnih vrijednosti narudžbe.
--340
select v.Name, poh.OrderDate, pod.OrderQty, pod.UnitPrice
from AdventureWorks2014.Purchasing.PurchaseOrderDetail as pod
inner join AdventureWorks2014.Purchasing.PurchaseOrderHeader as poh
on pod.PurchaseOrderID = poh.PurchaseOrderID
inner join AdventureWorks2014.Purchasing.Vendor as v
on v.BusinessEntityID = poh.VendorID
where (pod.OrderQty * pod.UnitPrice) > 10
order by pod.OrderQty * pod.UnitPrice



