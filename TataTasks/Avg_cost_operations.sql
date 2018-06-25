select * from [dbo].[GlobalSalaryRanges]


----------------------------------------------------------------------------------------------

drop table city_avg_cost
select distinct [city Cluster],sub_band, Avg_cost into city_avg_cost from
(select  [city Cluster],x.country,sub_band,avg(total) as Avg_cost 
from [dbo].[GlobalSalaryRanges] as y
 join
(select distinct country,[city cluster] from [maaping_city_region]) as x
on x.country=y.country group by [city Cluster],x.country,sub_band)Z
---------------------------------------------------------------------------------------

use AnaplanMay2018
drop table SUB_band_city_BU_combination
select * into SUB_band_city_BU_combination from (select distinct * from (select [BU/SSU], x.*,t.*
from inprocess_simulation_AOP_CY_BUHR as r 
 cross join 
(select distinct [City cluster] from inprocess_simulation_AOP_CY_BUHR 
where [City cluster] is not null) as x 

 cross join 
(select distinct [Employee sub band] from inprocess_simulation_AOP_CY_BUHR 
where [Employee sub band] is not null) as t)
 as y  where [BU/SSU] is not null) as k
-------------------------------------------------------------------------------------------------
ALTER view [dbo].[Avg_cost_geo_mix_lvl3_BUHR]
as
select Y.*,
case when X.AVGCOST_bnd is null then Z.Avg_cost else X.AVGCOST_bnd end as AVGCOST 
 from SUB_band_city_BU_combination AS Y left outer join
(select avg([CTC $ - FY Exit]) as AVGCOST_bnd,transfer_to_city,transfer_to_subBand,[BU/SSU] as BU from [dbo].[inprocess_simulation_AOP_CY_BUHR] 
--where transfer_to_city is not null and transfer_to_city='London' and transfer_to_subBand='B2-2'
group by [BU/SSU],transfer_to_city,
transfer_to_subBand
--order by 2
) AS X 
ON transfer_to_subBand=[Employee sub band] and  transfer_to_city = [City cluster] 
and X.BU=Y.[BU/SSU]
left outer join 
(select  [city cluster], sub_band,avg( Avg_cost) as Avg_cost
from city_avg_cost 
--where [City Cluster]='Other - Americas'
group by [city cluster], sub_band 
) as z
ON z.[city cluster] = y.[city cluster] and Z.sub_band=Y.[Employee sub band]
--where [BU/SSU]='Human Resource'and z.[city cluster]='London' and [Employee Sub Band]='B2-2'

select * from [Avg_cost_geo_mix_lvl3_BUHR] where [BU/SSU]='Human Resource' and [city cluster]='Other - Americas' and [employee sub band]= 'B5-1'