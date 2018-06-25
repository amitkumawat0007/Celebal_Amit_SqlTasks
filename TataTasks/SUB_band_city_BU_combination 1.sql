-----------------------------------------------------------------------------------------------------------------

select avg(case when( is_transfer=1 or is_surrender=1)then cost else [CTC $ - FY Exit] end) as AVGCOST,transfer_to_city,transfer_to_subBand,[BU/SSU] as BU from [dbo].[inprocess_simulation_AOP_CY_BUHR] 
where transfer_to_city is not null
group by [BU/SSU],transfer_to_city,transfer_to_subBand


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







select avg([CTC $ - FY Exit]) as AVGCOST,transfer_to_city,transfer_to_subBand,[BU/SSU] as BU from [dbo].[inprocess_simulation_AOP_CY_GMC] 
where transfer_to_city is not null
group by [BU/SSU],transfer_to_city,transfer_to_subBand



SELECT * from inprocess_simulation_AOP_CY_BUHR where transfer_to_region is null
