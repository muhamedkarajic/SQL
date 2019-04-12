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
select * 
from AdventureWorks2014.HumanResources.EmployeeDepartmentHistory
select * 
from AdventureWorks2014.HumanResources.Employee



--7. Iz tabela Production.Product, Production.ProductInventory i Product.Location 
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

select v.Name, poh.OrderDate, pod.OrderQty, pod.UnitPrice
from AdventureWorks2014.Purchasing.PurchaseOrderDetail as pod
inner join AdventureWorks2014.Purchasing.PurchaseOrderHeader as poh
on pod.PurchaseOrderID = poh.PurchaseOrderID
inner join AdventureWorks2014.Purchasing.Vendor as v
on v.BusinessEntityID = poh.VendorID
where (pod.OrderQty * pod.UnitPrice) > 10
order by pod.OrderQty * pod.UnitPrice



--8. U bazi Join kreirati tabelu JoinTabela4 koja će se sastojati od sljedećih polja:
--NarudzbaID cjelobrojna vrijednost, obavezan unos, primarni ključ,
--NazivKompanije 50 UNICODE karaktera,
--KupacID 5 karaktera
--UposlenikID cjelobrojna vrijednost,
--Grad 20 karaktera
--Drzava 4 karaktera

create table JoinTabela4(
	NarudzbaID int constraint PK_NarudzbaID primary key(NarudzbaID),
	NazivKompanije nvarchar(50),
	KupacID char(5),
	UposlenikID int not null,
	Grad char(20),
	Drzava char(4)
)--drop table JoinTabela4
--select * from JoinTabela4



--9. U tabelu JoinTabela4 importovati kolone OrderID, CompanyName, CustomerID, EmployeeID, City i Country 
--iz tabela Orders, Customers i Employees baze Northwind.

insert into JoinTabela4
select o.OrderID, c.CompanyName, c.CustomerID, e.EmployeeID, e.City, e.Country
from NORTHWND.dbo.Orders as o
inner join NORTHWND.dbo.Customers as c
on o.CustomerID = c.CustomerID
inner join NORTHWND.dbo.Employees as e
on o.EmployeeID = e.EmployeeID



--10. U bazi Join kreirati tabelu JoinTabela5 koja će se sastojati od sljedećih polja:
--PrimarniKljuc cjelobrojna vrijednost, primarni ključ, automatsko punjenje sa korakom 1
--NarudzbaID cjelobrojna vrijednost, obavezan unos,
--JedCijena decimalni broj sa dvije decimale, obavezan unos,
--Kolicina cjelobrojna vrijednost, obavezan unos,
--NazivProizvoda 50 UNICIODE karaktera, 
--DobavljacID cjelobrojna vrijednost, obavezan unos,
--Ukupno decimalni broj sa dvije decimale, obavezan unos

--Polje NarudzbaID je spoljni ključ prema tabeli JoinTabela4.

create table JoinTabela5(
	PrimarniKljuc int identity(1,1) constraint PK_PrimarniKljuc primary key(PrimarniKljuc), 
	NarudzbaID int not null,
	JedCijena decimal(8,2) not null,
	Kolicina int not null,
	NazivProizvoda nvarchar(50), 
	DobavljacID int not null,
	Ukupno decimal(8,2) not null
	constraint NarudzbaID foreign key(NarudzbaID) references JoinTabela4(NarudzbaID)
)--drop table JoinTabela5



--11. U tabelu JoinTabela5 importovati podatke iz kolona OrderID, UnitPrice, Quantity, ProductName i SupplierID 
--tabela Order Details i Products. Polje Ukupno je izračunato polje.

insert into JoinTabela5
select OrderID, od.UnitPrice, Quantity, ProductName, SupplierID, od.UnitPrice * od.Quantity as Ukupno
from NORTHWND.dbo.[Order Details] as od
inner join NORTHWND.dbo.Products as p
on od.ProductID = p.ProductID
--select * from JoinTabela5



--12. Iz tabela JoinTabela4 i JoinTabela5 dati prikaz sume Ukupno 
--pri čemu će rezultat biti grupiran po nazivu kompanije i ID narudžbe.
select NazivKompanije, j5.NarudzbaID, sum(j5.Ukupno)
from JoinTabela4 as j4
inner join JoinTabela5 as j5 
on j4.NarudzbaID = j5.NarudzbaID 
group by NazivKompanije, j5.NarudzbaID



--13. Iz tabela JoinTabela4 i JoinTabela5 dati prikaz ukupnog broja ostvarenih narudžbi 
--uz uslov da je ukupan broj narudžbi bio veći od 3 
--pri čemu će rezultat biti grupiran po nazivu kompanije i ID narudžbe.
--Također kolicina treba da bude veća od 10.

select j4.NazivKompanije, j4.KupacID, j5.NarudzbaID, count(*) as 'Broj narudzba'
from JoinTabela4 as j4
inner join JoinTabela5 as j5
on j4.NarudzbaID = j5.NarudzbaID
where j5.Kolicina > 10
group by j4.NazivKompanije, j4.KupacID, j5.NarudzbaID
having count(*) > 3
order by KupacID



--14. Iz tabela PurchaseOrderDetail, PurchaseOrderHeader i Vendor dati prikaz polja Name, OrderDate, OrderQty i UnitPrice. 
--Također dati prikaz ukupne vrijednosti narudžbe. 
--Rezultat sortirati po ukupnoj vrijednosti narudžbe.*/

select Name, OrderDate, OrderQty, UnitPrice, pod.OrderQty * pod.UnitPrice  as Ukupno
from AdventureWorks2014.Purchasing.PurchaseOrderDetail as pod
inner join AdventureWorks2014.Purchasing.PurchaseOrderHeader  as poh
on pod.PurchaseOrderID = poh.PurchaseOrderID
inner join AdventureWorks2014.Purchasing.Vendor as v
on v.BusinessEntityID = poh.VendorID
where pod.OrderQty * pod.UnitPrice > 10
order by pod.OrderQty * pod.UnitPrice 



--15. Iz tabela PurchaseOrderDetail, PurchaseOrderHeader i Vendor dati prikaz polja Name, OrderQty i UnitPrice. 
--Također dati prikaz ukupne vrijednosti narudžbe i ukupan broj pojedinih ukupnih vrijednosti narudžbi. 
--Rezultat sortirati ukupnom broju pojedinih ukupnih vrijednosti narudžbe.*/


select Name, OrderQty, UnitPrice, pod.OrderQty * pod.UnitPrice  as Ukupno, count(*)
from AdventureWorks2014.Purchasing.PurchaseOrderDetail as pod
inner join AdventureWorks2014.Purchasing.PurchaseOrderHeader  as poh
on pod.PurchaseOrderID = poh.PurchaseOrderID
inner join AdventureWorks2014.Purchasing.Vendor as v
on v.BusinessEntityID = poh.VendorID
where pod.OrderQty * pod.UnitPrice > 10
group by v.BusinessEntityID, pod.PurchaseOrderID
order by pod.OrderQty * pod.UnitPrice 


select * from AdventureWorks2014.Purchasing.PurchaseOrderHeader