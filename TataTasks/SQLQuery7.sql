 select l.t2,actual_diff,per_diff,l.cost,l.budget,l.mail,k.[Full Name] as fullname from (
select a.t2,(budget-cost) as actual_diff,(budget-cost)*100/nullif(budget,0) as per_diff,cost,budget,mail from (	
 select SUM(cast(b.[Prorated Budgeted Cost] as float)) as budget
,a.t2
from hierarchy_level_emp_temp  a
join AOP13 b
on a.t10=b.[Position ID]
where a.t1 in (select distinct [emp_position_id] from [dbo].[T_GMCList] 
--where mail='Steve.Melamed@tatacommunications.com' 
)
group by a.t2
) a
join(
 select 
 SUM(cast(c.cost as float)) as cost
,a.t2,mail
from hierarchy_level_emp_temp  a
join V_simulation_CY_GMC_1  c
on c.[Position ID]=a.t10
where a.t1 in (select distinct [emp_position_id] from [dbo].[T_GMCList]  
--where mail='Steve.Melamed@tatacommunications.com' 
)
-- and mail='Steve.Melamed@tatacommunications.com'
group by a.t2,mail) b
on a.t2=b.t2 ) l
join
Actual_simulation_AOP_CY_BUHR k
on l.t2=k.[Position ID] where [Full Name] is not null 
 and Status ='Active'
 
--------------------------------------------------------
 select * 
from T_hierarchy_on_positions_wo_nulls
where steps = '1'
and [Reporting Manager ID] = 'T35286'
and [Employee ID] in (select distinct([Reporting Manager ID]) from T_hierarchy_on_positions_wo_nulls)