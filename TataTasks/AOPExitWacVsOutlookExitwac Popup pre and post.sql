

----------------------------------------------------------------------
Alter view [dbo].[AOPExitWACvsOutlookExitWAC_BUHR_pre]
as
select r.cost/headc as Cost,cost1/headc1 as Cost1,r.lob,r.mail,r.BU from (select * from(select sum(cast([AOP Exit CTC] as float))Cost,nullif(sum(cast([AOP Exit HC] as float)),0) as hc,[LOB   Segment] as lob,mail,[BU SSU (Label)] as BU
from [dbo].[V_AOP_BUHR]
group by [LOB   Segment],[BU SSU (Label)],mail
) as x
join (select nullif(sum(cast([AOP Exit HC] as float)),0) as headc,mail as email,[BU SSU (Label)] as BU1
from [dbo].[V_AOP_BUHR]
group by [BU SSU (Label)],mail) as y
on x.BU=y.BU1 and x.mail=y.email
) as r
join
(select * from(select sum(cast([CTC $ - FY Exit] as float))Cost1,nullif(sum(cast([FY Exit HC] as float)),0) as hc,[LOB/Segment] as lob,mail,[BU/SSU] as BU
from [dbo].V_simulation_CY_BUHR
group by [LOB/Segment],[BU/SSU],mail
) as x
join (select nullif(sum(cast([FY Exit HC] as float)),0) as headc1,mail as email,[BU/SSU] as BU1
from [dbo].V_simulation_CY_BUHR
group by [BU/SSU],mail) as y
on x.BU=y.BU1 and x.mail=y.email
) as w
 on r.bu=w.bu and r.lob=w.lob and r.mail=w.mail
--where r.BU='Human Resource' and r.mail = 'manil.kumar@tatacommunications.com' 
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


Alter view [dbo].[AOPExitWACvsOutlookExitWAC_BUHR_post]

as
select r.cost/headc as Cost,cost1/headc1 as Cost1,r.lob,r.mail,r.BU from (select * from(select sum(cast([AOP Exit CTC] as float))Cost,nullif(sum(cast([AOP Exit HC] as float)),0) as hc,[LOB   Segment] as lob,mail,[BU SSU (Label)] as BU
from [dbo].[V_AOP_BUHR]
group by [LOB   Segment],[BU SSU (Label)],mail
) as x
join (select nullif(sum(cast([AOP Exit HC] as float)),0) as headc,mail as email,[BU SSU (Label)] as BU1
from [dbo].[V_AOP_BUHR]
group by [BU SSU (Label)],mail) as y
on x.BU=y.BU1 and x.mail=y.email
) as r
join
(select * from(select sum(case  
			 when is_surrender = 1  then 0 
			 when is_transfer = 1  then CAST(Cost AS FLOAT)
			  else 
				CAST([CTC $ - FY Exit] AS FLOAT) end) Cost1,nullif(sum(cast([FY Exit HC] as float)),0) as hc,[LOB/Segment] as lob,mail,[BU/SSU] as BU
from [dbo].V_inprocess_BUHR
group by [LOB/Segment],[BU/SSU],mail
) as x
join (select nullif(sum(case when is_surrender=0 then CAST([FY Exit HC] AS FLOAT) else 0 end),0) as headc1,mail as email,[BU/SSU] as BU1
from [dbo].V_inprocess_BUHR
group by [BU/SSU],mail) as y
on x.BU=y.BU1 and x.mail=y.email
) as w
 on r.bu=w.bu and r.lob=w.lob and r.mail=w.mail
--where r.BU='Human Resource' and r.mail = 'manil.kumar@tatacommunications.com' 