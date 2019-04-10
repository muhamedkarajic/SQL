
--1. Iz tabela discount i stores baze pubs prikazati naziv popusta, ID i naziv prodavnice
use pubs

select d.discounttype, s.stor_id, stor_name, discount from
pubs.dbo.discounts as d
inner join pubs.dbo.stores as s
on d.stor_id = s.stor_id



--2. Iz tabela employee i jobs baze pubs prikazati ID i ime uposlenika, ID posla i naziv posla koji obavlja.
select e.emp_id, e.fname, j.job_id, j.job_id, j.job_desc
from employee as e
inner join jobs as j
on j.job_id = e.job_id



--3. Modificirati prethodni zadatak tako da se upotrijebi right outer join.
select e.emp_id, e.fname, j.job_id, j.job_id, j.job_desc
from employee as e
right join jobs as j
on j.job_id = e.job_id



--4. Iz tabela Customers i Orders baze Northwind prikazati kontakt ime, id kupca i broj narudžbe.
use NORTHWND

select c.ContactName, c.CustomerID, o.OrderID
from Customers as c
inner join Orders as o
on c.CustomerID = o.CustomerID



--5. Modificirati prethodni zadatak tako da se upotrijebe left i right outer join.
select c.ContactName, c.CustomerID, o.OrderID
from Customers as c
left join Orders as o
on c.CustomerID = o.CustomerID

select c.ContactName, c.CustomerID, o.OrderID
from Customers as c
right join Orders as o
on c.CustomerID = o.CustomerID



--6. Upotrebom right outer join naredbe iz tabela employee i pub_info baze pubs prikazati ID i ime uposlenika, ID publikacije i opis publikacije.*/
use pubs
select e.emp_id, e.fname, pi.pub_id, pi.pr_info
from employee as e
inner join pub_info as pi
on e.pub_id = pi.pub_id



--7. Upotrebom right outer join naredbe iz tabela employee i pub_info baze pubs prikazati ID i ime uposlenika, ID publikacije i opis publikacije.*/
select e.emp_id, e.fname, pi.pub_id, pi.pr_info
from employee as e
right outer join pub_info as pi
on e.pub_id = pi.pub_id


