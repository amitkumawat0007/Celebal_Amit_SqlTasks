select count(*) from [dbo].[hierarchy_level_emp_temp]


select * into xyz from (select * from  [hierarchy_level_emp_temp] where t1='P900001') as x


update xyz
set t1='P915461'
where t1='P900001'

insert into [hierarchy_level_emp_temp] select distinct * from  xyz 


select * from [dbo].[Actual_simulation_AOP_CY_BUHR] where [position id]='P915461'

