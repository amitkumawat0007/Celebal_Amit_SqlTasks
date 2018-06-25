


select distinct * from 
(select country,sub_band,AVG(TOTAL)as avg_cont_bnd from GlobalSalaryRanges
group by country,sub_band ) as e
join 
(
select distinct [final country],[city cluster] from [dbo].[Actual_simulation_AOP_CY_BUHR]
where [city cluster] is not null and [final country] is not null 
) as b
on country=[final country]


select * ,cost ,[current_cost]from inprocess_simulation_AOP_CY_BUHR where [Full name]='Anne  granik'


