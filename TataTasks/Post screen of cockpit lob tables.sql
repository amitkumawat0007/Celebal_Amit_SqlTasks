

create view [dbo].[AOPvsOutlook_BUHR_Post] as

select lob,cost,hc,cost1,hc1,mail,BU from 
(select [LOB   Segment] as lob, sum(cast([Prorated Budgeted Cost] as float)) as cost ,SUM(case when [AOP Budgeted Position?]='TRUE' then 1 else 0 end) as HC,mail,[BU SSU (Label)] as BU from AnaplanMay2018.[dbo].[V_AOP_BUHR]

group by [LOB   Segment],mail,[BU SSU (Label)]) as X1 join
(select [LOB/Segment] as lob2, 
SUM( case --when is_surrender = 1 and [Report Type] ='Headcount' then CAST(current_cost AS FLOAT)*2/12 
                when is_transfer = 1 and [Report Type] ='Headcount' then (CAST(current_cost AS FLOAT)-cast([Prospective Outlook (CY) USD] as float))+cast([CTC $ - FY Exit] as float)*1/12 + Cost *9/12
			when is_surrender = 1 and [Report Type] ='Headcount' then (CAST(current_cost AS FLOAT)-cast([Prospective Outlook (CY) USD] as float))+cast([Loaded Cost (USD) (AOP - FY)] as float)*1/12 
			 when is_surrender = 1 and [Report Type]  <>'Headcount' then 0 
			-- when is_transfer = 1 and [Report Type]  ='Headcount' then CAST(Cost AS FLOAT)*10/12 + CAST(current_cost AS FLOAT)*2/12 
			  when is_transfer = 1 and [Report Type]  <>'Headcount' then CAST(Cost AS FLOAT)*10/12 + 0   
			  else 
				CAST(Cost AS FLOAT)end)  as cost1,SUM(case when is_surrender=0 then CAST([Outlook-HC] AS FLOAT) else 0 end) as HC1,
mail as M,[BU/SSU]
from AnaplanMay2018.[dbo].V_inprocess_BUHR 
group by [LOB/Segment], mail,[BU/SSU] ) as X2 on X1.lob=X2.lob2 and X2.M=X1.mail  and X2.[BU/SSU]=X1.BU
		--where BU='Human Resource' and mail = 'Steve.Melamed@tatacommunications.com' 
GO


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
create view [dbo].[AOPYTDvsOutlookYTD_BUHR_post] as
select lob,Cost,HC,Cost1,HC1,X1.mail,BU
 from(
select SUM( CAST([YTD - AOP] AS FLOAT)) as cost , SUM( CAST([YTD AOP Exit HC] AS FLOAT)) as HC, [LOB   Segment] as lob,mail,[BU SSU (Label)] as BU
from [dbo].[V_AOP_BUHR] where  [YTD AOP Exit HC]='1'
group by [LOB   Segment],[BU SSU (Label)],mail) as X1
join			            
(select SUM(cast(cost as float)-cast([Prospective Outlook (CY) USD] as float)) as cost1, sum(cast([Occupied By HC] as int)) as HC1, [LOB/Segment], mail,[BU/SSU] 
from V_simulation_CY_BUHR -- where [Occupied By HC]='1'
group by [LOB/Segment],[BU/SSU],mail) as X2
on X1.lob=X2.[LOB/Segment] and X1.BU=X2.[BU/SSU] and X1.mail=X2.mail 
--where BU ='Human Resource' and X1.[mail] = 'Steve.Melamed@tatacommunications.com'
GO
---------------------------------------------------------------------------------------------------------------------------------------
create view [dbo].[AOPExitWACvsOutlookExitWAC_BUHR_post] as
select Cost,Cost1,lob,X1.mail,BU from 
(select sum(cast([AOP Exit CTC] as float))/nullif(sum(cast([AOP Exit HC] as float)),0) as cost,[LOB   Segment] as lob,mail,[BU SSU (Label)] as BU
from [dbo].[V_AOP_BUHR] 
group by [LOB   Segment],[BU SSU (Label)],mail
) as X1
join
(select sum(case  
			 when is_surrender = 1  then 0 
			 when is_transfer = 1  then CAST(Cost AS FLOAT)
			  else 
				CAST([CTC $ - FY Exit] AS FLOAT) end)/sum(case when is_surrender=0 then CAST([FY Exit HC] AS FLOAT) else 0 end) as cost1,  [LOB/Segment],mail,[BU/SSU] 
from [dbo].V_inprocess_BUHR 
group by [LOB/Segment],[BU/SSU],mail
) as X2
on X1.lob=X2.[LOB/Segment] and X1.BU=X2.[BU/SSU] and X1.mail=X2.mail
GO
---------------------------------------------------------------------------------------------------------------------------------------------------
create view [dbo].[PyramidEfficiencyReplament_BUHR_post] as 
select sum( Cost) as cost,sum(Cost1) as Cost1,lob,X1.mail,X2.BU from 
( 
select sum(cast(P.[Attiration Cost] as float)) as Cost, V.[LOB/Segment] as lob,[BU/SSU] as [BU],mail
from [PositionDetailsCurrentPeriodData] as P
join V_simulation_CY_BUHR as V
on P.[Position ID]=V.[Position ID]
group by V.[LOB/Segment],[BU/SSU],mail
) as X1


join
(  
select sum(cost1) as cost1,mail,BU,[LOB/Segment] from(
select SUM(cast(N.[Cost Saved] as float))/count(1) as cost1, count(1) as countsdfa,SUM(cast(N.[Cost Saved] as float)) as costsdjlk  ,mail,V.[BU/SSU] as BU ,
[LOB/Segment]
from NoOfDaysSaved n 
join V_simulation_CY_BUHR v 
on n.[Position ID] = v.[Position ID] 
where --mail='Aadesh.goyal@tatacommunications.com' and 
n.[Cost Saved] <>'0' --and [BU/SSU] ='Human Resource'
group by n.[Position ID], n.[Cost Saved] ,mail,[BU/SSU],[LOB/Segment]
) A
group by A.mail	,A.BU,a.[LOB/Segment]
) 
  X2  on  X1.lob=X2.[LOB/Segment] and X1.[BU]=X2.BU and X1.mail=X2.mail
 --where X1.BU ='Human Resource' and X1.[mail] = 'aadesh.goyal@tatacommunications.com'
group by X1.lob,X2.BU,X1.mail
GO


