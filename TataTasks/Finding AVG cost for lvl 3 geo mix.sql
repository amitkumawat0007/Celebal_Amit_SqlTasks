Alter view dbo.Avg_cost_geo_mix_lvl3_BUHR
as
select Y.*,case when X.AVGCOST_bnd is null then Z.Avg_cost else X.AVGCOST_bnd end as AVGCOST  from SUB_band_city_BU_combination AS Y left outer join
(select avg(cost) as AVGCOST_bnd,transfer_to_city,transfer_to_subBand,[BU/SSU] as BU from [dbo].[inprocess_simulation_AOP_CY_BUHR] 
where transfer_to_city is not null
group by [BU/SSU],transfer_to_city,transfer_to_subBand) AS X 
ON transfer_to_subBand=[Employee sub band]and  transfer_to_city = [City cluster] and X.BU=Y.[BU/SSU]
left outer join 
(select [City cluster], sub_band ,Avg_cost from city_avg_cost
) as z
ON z.[City cluster] = y.[City cluster] and Z.sub_band=Y.[Employee sub band]




select * from SUB_band_city_BU_combination

select avg(cost) as Avgcost_city,transfer_to_city,[BU/SSU]  from [dbo].[inprocess_simulation_AOP_CY_BUHR] join [dbo].[maaping_city_region]
where transfer_to_city is not null
group by [BU/SSU],transfer_to_city

select * into city_avg_cost from
(select  [city Cluster],x.country,sub_band,total as Avg_cost 
from [dbo].[GlobalSalaryRanges] as y join

(select distinct country,[city cluster] from [maaping_city_region]) as x
on x.country=y.country) as z




select * from [inprocess_simulation_AOP_CY_BUHR]
where [position id]='P910119'


update [inprocess_simulation_AOP_CY_BUHR]
set transfer_to_subBand='B3-1'
where transfer_to_subBand='B2-2'
 and  [position id]='P910119'
