use prihodi

select o.OsobaID, vp.IznosVanrednogPrihoda, rp.Neto
from VanredniPrihodi as vp
full outer join Osoba as o
on o.OsobaID = vp.OsobaID
full outer join RedovniPrihodi as rp
on vp.OsobaID = rp.OsobaID
order by o.OsobaID

select distinct OsobaID from Osoba
select distinct OsobaID from VanredniPrihodi
select distinct OsobaID from RedovniPrihodi

use prihodi
select Osoba.OsobaID, 
sum(ISNULL(VanredniPrihodi.IznosVanrednogPrihoda, 0)), sum(ISNULL(RedovniPrihodi.Bruto, 0)) 
from Osoba
full join RedovniPrihodi
on RedovniPrihodi.OsobaID = Osoba.OsobaID
full join VanredniPrihodi
on VanredniPrihodi.OsobaID = Osoba.OsobaID
group by Osoba.OsobaID

select distinct Osoba.OsobaID from Osoba
full join VanredniPrihodi
on Osoba.OsobaID = VanredniPrihodi.OsobaID



select Osoba.OsobaID, IznosVanrednogPrihoda, Bruto, DatumIsplate from Osoba
left join RedovniPrihodi
on RedovniPrihodi.OsobaID = Osoba.OsobaID
left join VanredniPrihodi
on VanredniPrihodi.OsobaID = Osoba.OsobaID
group by Osoba.OsobaID,IznosVanrednogPrihoda, Bruto, DatumIsplate
