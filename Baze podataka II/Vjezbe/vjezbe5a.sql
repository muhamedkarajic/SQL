--1. Iz tabele Order Details u bazi Northwind prikazati narudžbe sa najmanjom i najvećom naručenom količinom, 
--ukupan broj narudžbi, ukupan broj naručenih proizvoda, te srednju vrijednost naručenih proizvoda.
use NORTHWND

select 
	min(Quantity) as Narudžbe, 
	max(Quantity), 
	count(*), 
	count(distinct ProductID), 
	avg(Quantity) 
from [Order Details]
--select * from [Order Details]



--2. Iz tabele Order Details u bazi Northwind prikazati narudžbe sa najmanjom i najvećom novačanom vrijednošću.*/
select *
from [Order Details]
where UnitPrice = (select min(UnitPrice) from [Order Details]) or UnitPrice = (select max(UnitPrice) from [Order Details])



--3. Iz tabele Order Details u bazi Northwind prikazati broj narudžbi sa odobrenim popustom.
select 
	count(OrderID) as 'Broj proizvoda sa popustom'
from [Order Details]
where Discount > 0
--select distinct Discount from [Order Details]



--4. Iz tabele Orders u bazi Northwind prikazati broj narudžbi u
--	a) kojima je unijeta regija kupovine.
select count(ShipRegion) as 'Narudzbe sa regijom kupovine' 
from Orders

--	b) kojima nije unijeta regija kupovine.
select count(*)-count(ShipRegion) as 'Narudzbe ber regije kupovine' 
from Orders
--select * from Orders



--5. Iz tabele Orders u bazi Northwind prikazati ukupan broj narudžbi u 1996. godini.
select 1996 as 'Godina', count(*) as 'Broj narudzbi'
from Orders
where year(OrderDate) = 1996



--6. Iz tabele Orders u bazi Northwind prikazati najniži i najviši trošak prevoza, 
--srednju vrijednost troškova prevoza, ukupnu vrijednost troškova prevoza i 
--ukupan broj prevoza robe u 1997. godini za robu koja se kupila u Njemačkoj.

select 
	min(Freight) as 'min',
	max(Freight) as 'max',
	avg(Freight) as 'prosjek',
	sum(Freight) as 'suma',
	count(Freight) as 'broj'
from Orders
where year(OrderDate) = 1997 and ShipCountry = 'Germany'



--7. Iz tabele Orders u bazi Northwind prikazati trošak prevoza ako je veći od 20000 
--za robu koja se kupila u Francuskoj, Njemačkoj ili Švicarskoj. Rezultate prikazati po državama.
select ShipCountry, sum(Freight) as TrosakPrevoza
from Orders
where ShipCountry IN('Franch', 'Germany', 'Switzerland')
group by ShipCountry
having sum(Freight) > 20000



--8. Iz tabele Orders u bazi Northwind prikazati trošak prevoza po državama u kojima je roba kupljena, 
--pri čemu će rezultat biti sortiran rastućim redoslijedom po vrijednosti troška prevoza.
select ShipCountry, sum(Freight) as 'Trosak prevoza'
from Orders
group by ShipCountry
order by 2



--9. Iz tabele Orders u bazi Northwind prikazati sve kupce po ID-u 
--kod kojih ukupni troškovi prevoza nisu prešli 7500 
--pri čemu se rezultat treba sortirati opadajućim redoslijedom po visini troškova prevoza.
select CustomerID, sum(Freight) as Trosak
from Orders
group by CustomerID
having sum(Freight) < 7500



--10. Iz tabele Orders u bazi Northwind prikazati ukupne troškove prevoza za 
--Belgiju, Brazil i SAD uz uslov da su troškovi prevoza bili veći od 5000.
select ShipCountry, sum(Freight)
from Orders
where ShipCountry IN('Belgium', 'Brazil', 'USA')
group by ShipCountry
having sum(Freight) > 5000