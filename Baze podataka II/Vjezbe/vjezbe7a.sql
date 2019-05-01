-- 1. Iz tabela Employees, EmployeeTerritories, Territories i Region baze Northwind 
-- prikazati prezime i ime uposlenika kao polje ime i prezime, teritoriju i regiju 
-- koju pokrivaju i stariji su od 30 godina.

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



