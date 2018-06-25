
select * from SUB_band_city_BU_combination

select avg(cost) as Avgcost_city,transfer_to_city,[BU/SSU]  from [dbo].[inprocess_simulation_AOP_CY_BUHR] 
where transfer_to_city is not null
group by [BU/SSU],transfer_to_city

drop table city_avg_cost
select distinct [city Cluster],sub_band, Avg_cost into city_avg_cost from
(select  [city Cluster],x.country,sub_band,Avg(total) as Avg_cost 
from [dbo].[GlobalSalaryRanges] as y
 join
(select distinct country,[city cluster] from [maaping_city_region]) as x
on x.country=y.country 
where [city cluster] ='London'
group by [city Cluster],x.country,sub_band
)Z




-----------------------------------------------------------------------------------------------------------------------------------------------------
