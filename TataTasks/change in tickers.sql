
 select V_All_GMC_Ticker.* from V_All_GMC_Ticker join [WFS_BUHR_Access] on BU=[BU/SSU Description]
  where [Business  Email Information Email Address]='manil.kumar@tatacommunications.com' 
  and BU='Human Resource'
  ---------------------------------changes in tickers----------------------below ticker-----------------------------
  
  select  count(1) as HC, sum(CONVERT(float, P.[Planned Not Hired Amount (USD)])) as PlanNotAmount,  H.t2,V.[Full Name]  as name,G.mail, [BU SSU] as BU
from PlanYetOpen_CurrentPeriod P
join hierarchy_level_emp_temp H  ------added because while creating heirearchy atbel we are not taking terminated employee
on H.t10 = P.[Planned Not Hire Position] 
join T_GMCList G
on G.emp_position_id=H.t1
join V_simulation_CY_GMC_1 V
on V.[Position ID] = H.t2
where --G.mail='aadesh.goyal@tatacommunications.com' and 
v.[Full Name] is not null and
 G.mail=v.mail
group by G.EmployeeName,H.t2,v.[Full Name], G.mail,[BU SSU]



--------------------------------------------------------------------upper ticker------------------------------------------
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





select  * from hierarchy_level_emp_temp
select  * from T_GMCList
select  * from PlanYetOpen_CurrentPeriod
select  * from V_simulation_CY_GMC_1
select  * from [dbo].[Actual_simulation_AOP_CY_GMC]

89275