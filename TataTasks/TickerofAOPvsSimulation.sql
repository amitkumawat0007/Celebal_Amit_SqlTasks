----------------------BUHR----------------------
--select Distinct aa.* from (select distinct W.*, BU from (select X.* from

--(select l.t2,actual_diff,per_diff,l.cost,l.budget,k.[Full Name] as fullname from (

--sel
-- select SUM(cast(b.[Prorated Budgeted Cost] as float)) as budget
--ect a.t2,(budget-cost) as actual_diff,(budget-cost)*100/nullif(budget,0) as per_diff,cost,budget from (

--,a.t2

--from hierarchy_level_emp_temp  a

--join AOP13 b

--on a.t10=b.[Position ID]

--where a.t1=(select [Position ID] from GMC_List where mail='Steve.Melamed@tatacommunications.com' )

--group by a.t2

--) a

--join(

--select

-- SUM(cast(c.cost as float)) as cost

--,a.t2

--from hierarchy_level_emp_temp  a

--join Actual_simulation_AOP_CY_GMC  c

--on c.[Position ID]=a.t10

--where a.t1=(select [Position ID] from GMC_List where mail='Steve.Melamed@tatacommunications.com' ) 
----and mail='Steve.Melamed@tatacommunications.com'

--group by a.t2) b

--on a.t2=b.t2 ) l

--join

--Actual_simulation_AOP_CY_BUHR k

--on l.t2=k.[Position ID] where [Full Name] is not null

-- and Status ='Active'

 

--  ) as X

 

-- join

-- (

--  select *

--from T_hierarchy_on_positions_wo_nulls

--where steps in  ('1','2','3')--or

----or steps='2'

----where [EmployeeName] = 'Steven H. Melamed'

----and [managerBU] = 'MD & CEO''s Office'

--and [Employee ID] in (select distinct([Reporting Manager ID]) from T_hierarchy_on_positions_wo_nulls)

--) as Y

--on Y.emp_position_id=X.t2) as W

--join

--(select Distinct [BU SSU] as BU,[Position ID] from Actual_simulation_AOP_CY_GMC) as V on V.[Position ID]=W.t2) aa

--Join
--(select * from WFS_BUHR_Access) bb on aa.BU=bb.[BU/SSU Description]
--where BU='Human Resource'




------------------------GMC-------------------------------


--select distinct W.*, BU from (select X.* from

--(select l.t2,actual_diff,per_diff,l.cost,l.budget,k.[Full Name] as fullname from (

--select a.t2,(budget-cost) as actual_diff,(budget-cost)*100/nullif(budget,0) as per_diff,cost,budget from (

-- select SUM(cast(b.[Prorated Budgeted Cost] as float)) as budget

--,a.t2

--from hierarchy_level_emp_temp  a

--join AOP13 b

--on a.t10=b.[Position ID]

--where a.t1=(select [Position ID] from GMC_List where mail='Steve.Melamed@tatacommunications.com' )

--group by a.t2

--) a

--join(

--select

-- SUM(cast(c.cost as float)) as cost

--,a.t2

--from hierarchy_level_emp_temp  a

--join Actual_simulation_AOP_CY_GMC  c

--on c.[Position ID]=a.t10

--where a.t1=(select [Position ID] from GMC_List where mail='Steve.Melamed@tatacommunications.com' ) 
----and mail='Steve.Melamed@tatacommunications.com'

--group by a.t2) b

--on a.t2=b.t2 ) l

--join

--Actual_simulation_AOP_CY_BUHR k

--on l.t2=k.[Position ID] where [Full Name] is not null

-- and Status ='Active'

 

--  ) as X

 

-- join

-- (

--  select *

--from T_hierarchy_on_positions_wo_nulls

--where steps in  ('1','2','3')--or

----or steps='2'

----where [EmployeeName] = 'Steven H. Melamed'

----and [managerBU] = 'MD & CEO''s Office'

--and [Employee ID] in (select distinct([Reporting Manager ID]) from T_hierarchy_on_positions_wo_nulls)

--) as Y

--on Y.emp_position_id=X.t2) as W

--join

--(select Distinct [BU SSU] as BU,[Position ID] from Actual_simulation_AOP_CY_GMC) as V on V.[Position ID]=W.t2

--where BU='Human Resource'

---------------------------------------------------------------------
--select * from WFS_BUHR_Access
--select * from [dbo].[WFS_BUHR_Access]
-- -----------------------------------------------------------------------------------------------------------------------------------


--select top(10)* from V_AOP_GMC_1 where [position ID]='P900031'
--select sum(cost) from V_simulation_CY_GMC_1 
--where [mail] in (select t10 from hierarchy_level_emp_temp where t1='P900031')





--select a.t2,(budget-cost) as actual_diff,(budget-cost)*100/nullif(budget,0) as per_diff,cost,budget,mail from (	
-- select SUM(cast(b.[Prorated Budgeted Cost] as float)) as budget
--,a.t2
--from hierarchy_level_emp_temp  a
--join V_AOP_GMC_1 b
--on a.t10=b.[Position ID]
--where a.t1=(select [Position ID] from GMC_List where mail='Steve.Melamed@tatacommunications.com' )
--and mail = 'Steve.Melamed@tatacommunications.com'
--group by a.t2
--) a
--join(
-- select 
-- SUM(cast(c.cost as float)) as cost
--,a.t2,mail
--from hierarchy_level_emp_temp  a
--join V_simulation_CY_GMC_1  c
--on c.[Position ID]=a.t10
--where a.t1=(select [Position ID] from GMC_List where mail='Steve.Melamed@tatacommunications.com' ) 
--and mail='Steve.Melamed@tatacommunications.com'
--group by a.t2,mail) b
--on a.t2=b.t2 
---------------------------------------for buhr gmc, gmc-1 upper ticker---------------------------------------------------------------------------------------
create View V_All_GMC_Ticker as 
select Distinct W.*, BU from (select X.* from
(select l.t2,actual_diff,per_diff,l.cost,l.budget,k.[Full Name] as fullname from (
select a.t2,(budget-cost) as actual_diff,(budget-cost)*100/nullif(budget,0) as per_diff,cost,budget from (
select SUM(cast(b.[Prorated Budgeted Cost] as float)) as budget
,a.t2
from hierarchy_level_emp_temp  a
join AOP13 b
on a.t10=b.[Position ID]
where a.t1 in (select [Position ID] from GMC_List --where mail='Steve.Melamed@tatacommunications.com' 
)
group by a.t2
) a
join(
select
SUM(cast(c.cost as float)) as cost
,a.t2
from hierarchy_level_emp_temp  a
join Actual_simulation_AOP_CY_GMC  c
on c.[Position ID]=a.t10
where a.t1 in (select [Position ID] from GMC_List 
--where mail='Steve.Melamed@tatacommunications.com'
) --and mail='Steve.Melamed@tatacommunications.com'
group by a.t2) b
on a.t2=b.t2 ) l
join
Actual_simulation_AOP_CY_BUHR k
on l.t2=k.[Position ID] where [Full Name] is not null
and Status ='Active'
  ) as X
join
(
  select *
from T_hierarchy_on_positions_wo_nulls
where steps in  ('1','2','3')--or
--or steps='2'
--where [EmployeeName] = 'Steven H. Melamed'
--and [managerBU] = 'MD & CEO''s Office'
and [Employee ID] in (select distinct([Reporting Manager ID]) from T_hierarchy_on_positions_wo_nulls)
) as Y
on Y.emp_position_id=X.t2) as W
join
(select Distinct [BU SSU] as BU,[Position ID] from V_simulation_CY_GMC_1) as V on V.[Position ID]=W.t2
--where BU='Human Resource'

 select * from [WFS_BUHR_Access] where [Business  Email Information Email Address]='allwyn.dsilva@tatacommunications.com' and [BU/SSU Description]='Customer Service & Operations';
 select * from V_All_GMC_Ticker join [WFS_BUHR_Access] on BU=[BU/SSU Description]
  where [Business  Email Information Email Address]='allwyn.dsilva@tatacommunications.com' and BU='Customer Service & Operations'
 
 ------------------------------ V_All_GMC_Ticker_Below---------------------------------------------------------------------------------
  create View V_All_GMC_Ticker_Below as select  count(1) as HC, sum(CONVERT(float, P.[Planned Not Hired Amount (USD)])) as PlanNotAmount,  H.t2,V.[Full Name]  as name,G.mail, [BU SSU] as BU
from PlanYetOpen_CurrentPeriod P
join hierarchy_level_emp_temp_BKP H  ------added because while creating heirearchy atbel we are not taking terminated employee
on H.t10 = P.[Planned Not Hire Position] 
join T_GMCList G
on G.emp_position_id=H.t1
join V_simulation_CY_GMC_1 V
on V.[Position ID] = H.t2
where --G.mail='aadesh.goyal@tatacommunications.com' and 
v.[Full Name] is not null
group by G.EmployeeName,H.t2,v.[Full Name], G.mail,[BU SSU]


 select * from V_All_GMC_Ticker_Below join [WFS_BUHR_Access] on BU=[BU/SSU Description]
  where [Business  Email Information Email Address]='allwyn.dsilva@tatacommunications.com' and BU='Global Technology Network & Operation Group'
  select * from V_simulation_CY_GMC_1;