-- 1. Iz tabela Employees, EmployeeTerritories, Territories i Region baze Northwind 
-- prikazati prezime i ime uposlenika kao polje ime i prezime, teritoriju i regiju 
-- koju pokrivaju i stariji su od 30 godina.
use NORTHWND

select DATEDIFF(year, e.BirthDate, GETDATE()) as years, FirstName, LastName, r.RegionDescription, t.TerritoryDescription
from Employees as e
inner join EmployeeTerritories as et
on et.EmployeeID = e.EmployeeID
inner join Territories as t
on t.TerritoryID = et.TerritoryID
inner join Region as r
on r.RegionID = t.RegionID
where DATEDIFF(year, e.BirthDate, GETDATE()) > 30



-- 2. Iz tabela Employee, Order Details i Orders baze Northwind prikazati 
-- ime i prezime uposlenika kao polje ime i prezime, jediničnu cijenu, količinu i 
-- ukupnu vrijednost pojedinačne narudžbe kao polje ukupno za sve narudžbe u 1997. godini, 
-- pri čemu će se rezultati sortirati prema novokreiranom polju ukupno.

select FirstName + ' ' + LastName as 'Ime i prezime', UnitPrice, Quantity,  discount,
(UnitPrice-(UnitPrice*Discount))*Quantity as 'Ukupno' 
from Employees as e
inner join Orders as o
on o.EmployeeID = e.EmployeeID
inner join [Order Details] as od
on o.OrderID = od.OrderID
where year(OrderDate) = 1997
order by Ukupno



-- 3. Iz tabela Employee, Order Details i Orders baze Northwind 
-- prikazati ime uposlenika i ukupnu vrijednost svih narudžbi koje je taj uposlenik 
-- napravio u 1997. godini ako je ukupna vrijednost veća od 50000, 
-- pri čemu će se rezultati sortirati uzlaznim redoslijedom prema polju ime. 
-- Vrijednost sume zaokružiti na dvije decimale.

select FirstName, round(sum((UnitPrice-(UnitPrice*Discount))*Quantity), 2) as 'Ukupno'
from Employees as e
inner join Orders as o
on o.EmployeeID = e.EmployeeID
inner join [Order Details] as od
on o.OrderID = od.OrderID
where year(o.OrderDate) = 1997
group by FirstName
having sum((UnitPrice-(UnitPrice*Discount))*Quantity) > 50000
order by 1



-- 4. Iz tabela Categories, Products i Suppliers baze Northwind prikazati naziv isporučitelja (dobavljača), 
-- mjesto i državu isporučitelja (dobavljača) i naziv(e) proizvoda iz kategorije napitaka (pića) 
-- kojih na stanju ima više od 30 jedinica. 
-- Rezultat upita sortirati po državi.

select s.CompanyName, s.Country, s.City, c.CategoryName
from Categories as c
inner join Products as p
on c.CategoryID = p.CategoryID
inner join Suppliers as s
on p.SupplierID = s.SupplierID
where UnitsInStock > 30 and c.CategoryID = 1
order by 2



-- 5. U tabeli Customers baze Northwind ID kupca je primarni ključ. 
-- U tabeli Orders baze Northwind ID kupca je vanjski ključ. Dati izvještaj:

-- a) koliko je ukupno kupaca evidentirano u bazi Northwind (u obje tabele)
select CustomerID from Customers
union
select CustomerID from Orders

-- b) da li su svi kupci obavili narudžbu
select CustomerID from Customers
intersect 
select CustomerID from Orders

-- c) koji kupci nisu napravili narudžbu*/
select CustomerID from Customers
except
select CustomerID from Orders



-- 6.
-- a) Provjeriti u koliko zapisa (slogova) tabele Orders nije unijeta vrijednost u polje regija kupovine.
select ShipRegion from Orders
where ShipRegion IS NULL

-- b) Upotrebom tabela Customers i Orders baze Northwind prikazati ID kupca 
-- pri čemu u polje regija kupovine nije unijeta vrijednost, 
-- uz uslov da je kupac obavio narudžbu (kupac iz tabele Customers postoji u tabeli Orders). 
--Rezultat sortirati u rastućem redoslijedu.

select CustomerID 
from Customers
intersect
select CustomerID 
from Orders
where ShipRegion IS NULL
order by CustomerID asc

-- c) Upotrebom tabela Customers i Orders baze Northwind prikazati ID kupca 
-- pri čemu u polje regija kupovine nije unijeta vrijednost i 
-- kupac nije obavio ni jednu narudžbu (kupac iz tabele Customers ne postoji u tabeli Orders).
-- Rezultat sortirati u rastućem redoslijedu.

select CustomerID 
from Customers
except
select CustomerID 
from Orders
where ShipRegion IS NULL
order by CustomerID asc



-- 7. Iz tabele HumanResources.Employee baze AdventureWorks2014 prikazati po 5 najstarijih zaposlenika muškog, 
-- odnosno, ženskog pola uz navođenje sljedećih podataka: 
-- radno mjesto na kojem se nalazi, datum rođenja, korisnicko ime i godine starosti. 
-- Korisničko ime je dio podatka u LoginID. 
-- Rezultate sortirati prema polu uzlaznim, a zatim prema godinama starosti silaznim redoslijedom.

use AdventureWorks2014


select	TOP 5 JobTitle, BirthDate, RIGHT(LoginID, LEN(LoginID) - 16) as 'User name', 
		DATEDIFF(YEAR,BirthDate, GETDATE()) as 'Godine Starosti', Gender
from HumanResources.Employee
where Gender = 'M'
UNION
select	TOP 5 JobTitle, BirthDate, RIGHT(LoginID, LEN(LoginID) - 16) as 'User name', 
		DATEDIFF(YEAR,BirthDate, GETDATE()) as 'Godine Starosti', Gender
from HumanResources.Employee
where Gender = 'F'
order by 5, 4 desc



-- 8. Iz tabele HumanResources.Employee baze AdventureWorks2014 prikazati po 3 zaposlenika sa 
-- najdužim stažom bez obzira da li su u braku i obavljaju poslove inžinjera uz navođenje sljedećih podataka: 
-- radno mjesto na kojem se nalazi, datum zaposlenja i bračni status. 
-- Ako osoba nije u braku plaća dodatni porez,inače ne plaća. 
-- Rezultate sortirati prema bračnom statusu uzlaznim, a zatim prema stažu silaznim redoslijedom.

select TOP 3 JobTitle, HireDate, MaritalStatus, 
			 DATEDIFF(YEAR, HireDate, GETDATE()),
			 '' as Porez
from HumanResources.Employee
where MaritalStatus = 'M' and
JobTitle like '%engineer%' and JobTitle not like '%engineering%'
UNION
select TOP 3 JobTitle, HireDate, MaritalStatus, 
			 DATEDIFF(YEAR, HireDate, GETDATE()),
			 'Dodatni porez!' as Porez
from HumanResources.Employee
where MaritalStatus = 'S' and
JobTitle like '%engineer%' and JobTitle not like '%engineering%'
order by 3, 4 desc



/*ZADATAK 9
Iz tabela HumanResources.Employee i Person.Person prikazati po 5 osoba koje se nalaze na 1, odnosno, 4.  organizacionom nivou, uposlenici su i žele primati email ponude od AdventureWorksa uz navođenje sljedećih polja: ime i prezime osobe kao jedinstveno polje, organizacijski nivo na kojem se nalazi i da li prima email promocije. Pored ovih uvesti i polje koje će sadržavati poruke: Ne prima, Prima selektirane i Prima. Sadržaj novog polja ovisi o vrijednosti polja EmailPromotion. Rezultat sortirati prema organizacijskom nivou i dodatno uvedenom polju.*/


