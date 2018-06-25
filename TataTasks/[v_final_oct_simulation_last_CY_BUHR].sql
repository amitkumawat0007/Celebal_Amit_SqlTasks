
ALTER view [dbo].[v_final_oct_simulation_last_CY_BUHR]
as

select D.*, D.Headcount*Attrition*AVGCOST*0.01*remaining_months/12 as Savings_on_rep, 
((Cast(D.BalAOP_Open_Count as decimal)+Cast(HC_Offered_Count as decimal)) / (nullif(D.BalAOP_Open_Count_TOTAL + D.HC_Offered_Count_Total,0))) * (D.AVGCOST-D.Average_low_cost) as Geo_mix,--geomix
(Cast(HC_Offered_Count as decimal) / nullif(D.HC_Offered_Count_Total,0)) * (D.AVGCOST-D.Average_low_cost) as geo_mix_offered,
((Cast(D.BalAOP_Open_Count as decimal)+Cast(HC_Offered_Count as decimal)) / (nullif(D.BalAOP_Open_Count_TOTAL + D.HC_Offered_Count_Total,0))) * (D.AVGCOST) as surrendered,
(Cast(HC_Offered_Count as decimal) / nullif(D.HC_Offered_Count_Total,0)) * (D.AVGCOST) as surrendered_offered,
(Cast(D.Unbudgeted_Count as decimal) / nullif(D.Unbudgeted_Count_Total,0)) * (D.avgdef_cost_per_day) as deferred,
(Cast(D.B15Tcount as decimal) / nullif(D.B15sum,0)) * (Bottom15) as Bottom15,
Span_of_control,
sam_band_cnt,
SUM_AOPCOST
from (
Select * from (select inprocess_simulation_AOP_CY_BUHR.[BU/SSU] as bu, 
inprocess_simulation_AOP_CY_BUHR.[Job Level] as JL, 
inprocess_simulation_AOP_CY_BUHR.[Job Family Cluster],
inprocess_simulation_AOP_CY_BUHR.mapped_region as internal,
inprocess_simulation_AOP_CY_BUHR.[Position Job Family],
case when inprocess_simulation_AOP_CY_BUHR.[Job Level] = 'JM' or [Job Level] ='NM' then 'JM' when inprocess_simulation_AOP_CY_BUHR.[Job Level] = 'MM' or [Job Level] = 'TM'  or [Job Level] ='SM' then 'MM+' end as Super_JOBLevel,
case when inprocess_simulation_AOP_CY_BUHR.mapped_region = 'India' then 'LC' else 'HC' end as Cost_Location,
AVG(cast(COST as float)) as AVGCOST, 
AVG(cast(COST as float)/case when datediff(day,cast([Start Date] as date),Convert(datetime, '2019-04-01')) <=365 
	then datediff(day,cast([Start Date] as date),Convert(datetime, '2019-04-01')) else 365 end)  as avgdef_cost_per_day ,
(case when 16-MONTH(GETDATE()) < 12 then 16-MONTH(GETDATE()) else 3-MONTH(GETDATE()) end ) as remaining_months, 
SUM(case when inprocess_simulation_AOP_CY_BUHR.[Report Type] = 'Headcount' then 1 else 0 end) as Headcount,
SUM(case when [Report Type] = 'Balanced AOP' or [Report Type] = 'TA Hold/Open'  then 1 else 0 end) as BalAOP_Open_Count,
SUM(case when [Report Type] = 'Headcount' or [Report Type] = 'TA Offered'  then 1 else 0 end) as HC_Offered_Count,
SUM(case when [Report Type] = 'Unbudgeted' then 1 else 0 end) as Unbudgeted_Count,
SUM(case when [Report Type] = 'Unbudgeted' and cast([Start Date] as date) > Convert(datetime, '2017-04-01' ) then 1 else 0 end) as Unbudgeted_Count_NY,
SUM(case when [Stack Rank Final] = 'Bottom 15%' and [Report Type] = 'Headcount' then 1 else 0 end)  as B15Tcount,
0.133 as Attrition
from inprocess_simulation_AOP_CY_BUHR 
where [job level] is not null and [fy exit hc]=1
group by   inprocess_simulation_AOP_CY_BUHR.[BU/SSU] , inprocess_simulation_AOP_CY_BUHR.[Job Level] ,inprocess_simulation_AOP_CY_BUHR.[Job Family Cluster], inprocess_simulation_AOP_CY_BUHR.mapped_region ,
inprocess_simulation_AOP_CY_BUHR.[Position Job Family], 
case when inprocess_simulation_AOP_CY_BUHR.[Job Level] = 'JM' or [Job Level] ='NM' then 'JM' when inprocess_simulation_AOP_CY_BUHR.[Job Level] = 'MM' or [Job Level] = 'TM'  or [Job Level] ='SM' then 'MM+' end,
case when inprocess_simulation_AOP_CY_BUHR.mapped_region = 'India' then 'LC' else 'HC' end) A 
left outer join
(select 
[Job Level] as [Job Level],[BU/SSU],[position job family] as PJF_LowCost,
inprocess_simulation_AOP_CY_BUHR.[Job Family Cluster] as jfc,
AVG(cast(cost as float)) as Average_low_cost
from inprocess_simulation_AOP_CY_BUHR
where mapped_region='India' and [job level] is not null

group by 
[Job Level],[BU/SSU],[position job family], inprocess_simulation_AOP_CY_BUHR.[Job Family Cluster] )C
ON C.[BU/SSU]=A.bu and C.[Job Level]=A.JL and C.[PJF_LowCost] = A.[Position Job Family] and A.[Job Family Cluster]=C.jfc
left outer join
(
select case when inprocess_simulation_AOP_CY_BUHR.[Job Level] = 'JM' or [Job Level] ='NM' then 'JM' when inprocess_simulation_AOP_CY_BUHR.[Job Level] = 'MM' or [Job Level] = 'TM' or [Job Level] ='SM' then 'MM+' end as Super_JOBLevelb, 
case when inprocess_simulation_AOP_CY_BUHR.mapped_region = 'India' then 'LC' else 'HC' end as Cost_Location_b,
inprocess_simulation_AOP_CY_BUHR.[BU/SSU] as bu_h, 
inprocess_simulation_AOP_CY_BUHR.[Job Family Cluster] as jfc_l,
SUM(case when inprocess_simulation_AOP_CY_BUHR.[Report Type] = 'Headcount' then 1 else 0 end) as Headcount_Total,
SUM(case when [Report Type] = 'Balanced AOP' or [Report Type] = 'TA Hold/Open'  then 1 else 0 end) as BalAOP_Open_Count_Total,
SUM(case when [Report Type] = 'Headcount' or [Report Type] = 'TA Offered'  then 1 else 0 end) as HC_Offered_Count_Total,
SUM(case when [Report Type] = 'Unbudgeted' then 1 else 0 end) as Unbudgeted_Count_Total,
SUM(case when [Stack Rank Final] = 'Bottom 15%' and [Report Type] = 'Headcount' then 1 else 0 end)  as B15sum
from inprocess_simulation_AOP_CY_BUHR
where [job level] is not null and [fy exit hc]=1
group by case when inprocess_simulation_AOP_CY_BUHR.[Job Level] = 'JM' or [Job Level] ='NM' then 'JM' when inprocess_simulation_AOP_CY_BUHR.[Job Level] = 'MM' or [Job Level] = 'TM' or [Job Level] ='SM' then 'MM+' end,
case when inprocess_simulation_AOP_CY_BUHR.mapped_region = 'India' then 'LC' else 'HC' end,
inprocess_simulation_AOP_CY_BUHR.[BU/SSU],inprocess_simulation_AOP_CY_BUHR.[Job Family Cluster]
) B on A.Super_JOBLevel=B.Super_JOBLevelb and A.Cost_Location=B.Cost_Location_b and A.bu=B.bu_h and A.[Job Family Cluster]=B.jfc_l) D

left outer join(
select 
bu,
JL,
internal,
Cost_Location,
[Position Job Family],
[Job Family Cluster],
count(employeeid) as Span_of_control
from
(select * from (select [BU/SSU] as bu, 
[Job Level] as JL, 
mapped_region as internal,
[Position Job Family],
[Job Family Cluster],
case when mapped_region = 'India' then 'LC' else 'HC' end as Cost_Location,
cast([employee id] as varchar(100)) as employeeid,[Reporting Manager ID], [Employee Sub Band] from inprocess_simulation_AOP_CY_BUHR where [Report Type]='Headcount') as X JOIN
(
select  count(1) as cnt, [Reporting Manager ID] as rmid from inprocess_simulation_AOP_CY_BUHR where [Report Type]='Headcount'
group by [Reporting Manager ID])Y
ON X.employeeid=Y.rmid and (Y.cnt=1 or Y.cnt=2)
) W
    group by bu,JL,internal,[Position Job Family],Cost_Location,[Job Family Cluster]) M on
	M.bu=D.bu and
    M.JL=D.JL and
    M.internal = D.internal and
    M.Cost_Location = D.Cost_Location and
    M.[Position Job Family] = D.[Position Job Family] and
	M.[Job Family Cluster] = D.[Job Family Cluster] 

left outer join
(
Select
bu,
JL,
internal,
Cost_Location,
[Position Job Family],
[Job Family Cluster],
count(1) as sam_band_cnt
from
(select [BU/SSU] as bu, 
[Job Level] as JL, 
mapped_region as internal,
[Position Job Family],
case when mapped_region = 'India' then 'LC' else 'HC' end as Cost_Location,[Job Family Cluster],
cast([employee id] as varchar(100)) as employeeid,[Reporting Manager ID], [Employee Sub Band] from inprocess_simulation_AOP_CY_BUHR)  X JOIN
(select [Employee Sub Band], cast([employee id] as varchar(100)) as manager_id from inprocess_simulation_AOP_CY_BUHR)Y
ON X.[Reporting Manager ID] = Y. manager_id
AND  X.[Employee Sub Band]=Y.[Employee Sub Band] and 0 < ( Select count(1) from inprocess_simulation_AOP_CY_BUHR U where U.[Reporting Manager ID]=X.employeeid)
group by 
bu,
JL,
internal,
Cost_Location,
[Position Job Family],
[Job Family Cluster]
)  P on 
	P.bu=D.bu and
    P.JL=D.JL and
    P.internal = D.internal and
    P.Cost_Location = D.Cost_Location and
    P.[Position Job Family] = D.[Position Job Family] and
	P.[Job Family Cluster] = D.[Job Family Cluster] 

left outer join
(
select 
[BU/SSU] as bu, 
[Job Level] as JL, 
mapped_region as internal,
[Position Job Family],
case when mapped_region = 'India' then 'LC' else 'HC' end as Cost_Location,[Job Family Cluster], 
SUM(cast(COST as float)) as SUM_AOPCOST from inprocess_simulation_AOP_CY_BUHR group by 
[BU/SSU],
[Job Level],
mapped_region,
[Position Job Family],
[Job Family Cluster]) K on
K.bu=D.bu and
    K.JL=D.JL and
    K.internal = D.internal and
    K.Cost_Location = D.Cost_Location and
    K.[Position Job Family] = D.[Position Job Family] and
	K.[Job Family Cluster] = D.[Job Family Cluster]
left outer join
(select 
[BU/SSU] as bu, 
[Job Level] as JL, 
mapped_region as internal,
[Position Job Family],
case when mapped_region = 'India' then 'LC' else 'HC' end as Cost_Location,[Job Family Cluster], 
AVG(cast(COST as float)) as Bottom15 from inprocess_simulation_AOP_CY_BUHR where [Stack Rank Final] = 'Bottom 15%' and [Report Type] = 'Headcount' group by 
[BU/SSU],
[Job Level],
mapped_region,
[Position Job Family],
[Job Family Cluster]) G on
G.bu=D.bu and
    G.JL=D.JL and
    G.internal = D.internal and
    G.Cost_Location = D.Cost_Location and
    G.[Position Job Family] = D.[Position Job Family] and
    G.[Job Family Cluster] = D.[Job Family Cluster]









GO

