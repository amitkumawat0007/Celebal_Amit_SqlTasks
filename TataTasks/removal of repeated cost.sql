select sum(cost) as cost,mail,BU from(
select SUM(cast(N.[Cost Saved] as float))/count(1) as cost,mail,V.[BU SSU] as BU 
from NoOfDaysSaved n 
join V_simulation_CY_BUHR v 
on n.[Position ID] = v.[Position ID] 
where --mail='Aadesh.goyal@tatacommunications.com' and 
n.[Cost Saved] <>'0'
group by n.[Position ID], n.[Cost Saved] ,mail,[BU SSU]
) A
group by A.mail	,A.BU



-------------------------------------------------------------------------------
select sum(Cost)/count(1),sum(Cost1)/count(1),lob,X1.mail,X2.BU from 
( 
select sum(cast([Attiration Cost] as float))/count(1) as Cost, V.[LOB Segment] as lob,[BU SSU] as [BU],mail
from [PositionDetailsCurrentPeriodData] as P
join V_simulation_CY_GMC_1 as V
on P.[Position ID]=V.[Position ID]
group by V.[LOB Segment],[BU SSU],mail
) as X1

join
(  
select sum(cost) as cost1,mail,BU,[LOB Segment] from(
select SUM(cast(N.[Cost Saved] as float))/count(1) as cost, count(1) as countsdfa,SUM(cast(N.[Cost Saved] as float)) as costsdjlk  ,mail,V.[BU SSU] as BU ,
[LOB Segment]
from NoOfDaysSaved n 
join V_simulation_CY_GMC_1 v 
on n.[Position ID] = v.[Position ID] 
where --mail='Aadesh.goyal@tatacommunications.com' and 
n.[Cost Saved] <>'0' --and [BU SSU] ='Human Resource'
group by n.[Position ID], n.[Cost Saved] ,mail,[BU SSU],[LOB Segment]
) A
group by A.mail	,A.BU,a.[LOB Segment]
) 
  X2  on  X1.lob=X2.[LOB Segment] and X1.[BU]=X2.BU and X1.mail=X2.mail
 --where X1.BU ='Human Resource' and X1.[mail] = 'aadesh.goyal@tatacommunications.com'
group by X1.lob,X2.BU,X1.mail
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
select sum(Cost),sum(Cost1),lob,X1.mail,X2.BU from 
( 
select sum(cast([Attiration Cost] as float))/count(1) as Cost, V.[LOB Segment] as lob,[BU SSU] as [BU],mail
from [PositionDetailsCurrentPeriodData] as P
join V_simulation_CY_GMC_1 as V
on P.[Position ID]=V.[Position ID]
group by V.[LOB Segment],[BU SSU],mail
) as X1

join
(  
select sum(cost) as cost1,mail,BU,[LOB Segment] from(
select SUM(cast(N.[Cost Saved] as float))/count(1) as cost, count(1) as countsdfa,SUM(cast(N.[Cost Saved] as float)) as costsdjlk  ,mail,V.[BU SSU] as BU ,
[LOB Segment]
from NoOfDaysSaved n 
join V_simulation_CY_GMC_1 v 
on n.[Position ID] = v.[Position ID] 
where --mail='Aadesh.goyal@tatacommunications.com' and 
n.[Cost Saved] <>'0' --and [BU SSU] ='Human Resource'
group by n.[Position ID], n.[Cost Saved] ,mail,[BU SSU],[LOB Segment]
) A
group by A.mail	,A.BU,a.[LOB Segment]
) 
  X2  on  X1.lob=X2.[LOB Segment] and X1.[BU]=X2.BU and X1.mail=X2.mail
 --where X1.BU ='Human Resource' and X1.[mail] = 'aadesh.goyal@tatacommunications.com'
 group by X1.lob,X2.BU,X1.mail

