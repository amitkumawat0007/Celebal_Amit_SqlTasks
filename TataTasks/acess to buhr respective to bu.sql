drop table tbltemphierarchy select * into tbltemphierarchy from (select * from [dbo].[hierarchy_level_emp_temp]
 where t1='P900069' and t2 in (select  [Position ID] from Actual_simulation_AOP_CY_BUHR where [BU/SSU] in (select [BU/SSU Description]
  from WFS_BUHR_Access where Username='T3238') and [Position ID] is not null)) as x
  
delete from [hierarchy_level_emp_temp]
where  t1='P900069'

insert into [hierarchy_level_emp_temp] select * from tbltemphierarchy

drop table tbltemphierarchy select * into tbltemphierarchy from (select * from [dbo].[hierarchy_level_emp_temp] 
where t1='P900118' and t2 in (select  [Position ID] from Actual_simulation_AOP_CY_BUHR where [BU/SSU] in (select [BU/SSU Description]
 from WFS_BUHR_Access where Username='6010874') and [Position ID] is not null)) as x


delete from [hierarchy_level_emp_temp]
where  t1='P900118'

insert into [hierarchy_level_emp_temp] select * from tbltemphierarchy

drop table tbltemphierarchy select * into tbltemphierarchy from (select * from [dbo].[hierarchy_level_emp_temp] where
 t1='P903418' and t2 in (select  [Position ID] from Actual_simulation_AOP_CY_BUHR where [BU/SSU] in (select [BU/SSU Description] 
 from WFS_BUHR_Access where Username='T36104') and [Position ID] is not null)) as x
 
delete from [hierarchy_level_emp_temp]
where  t1='P903418'

insert into [hierarchy_level_emp_temp] select * from tbltemphierarchy

drop table tbltemphierarchy select * into tbltemphierarchy from (select * from [dbo].[hierarchy_level_emp_temp] 
where t1='P907106' and t2 in (select  [Position ID] from Actual_simulation_AOP_CY_BUHR where [BU/SSU] in (select [BU/SSU Description]
 from WFS_BUHR_Access where Username='6014412') and [Position ID] is not null)) as x
 
delete from [hierarchy_level_emp_temp]
where  t1='P907106'


insert into [hierarchy_level_emp_temp] select * from tbltemphierarchy
drop table tbltemphierarchy select * into tbltemphierarchy from (select * from [dbo].[hierarchy_level_emp_temp] 
where t1='P902714' and t2 in (select  [Position ID] from Actual_simulation_AOP_CY_BUHR where [BU/SSU] in (select [BU/SSU Description] 
from WFS_BUHR_Access where Username='T34825') and [Position ID] is not null)) as x

delete from [hierarchy_level_emp_temp]
where  t1='P902714'


insert into [hierarchy_level_emp_temp] select * from tbltemphierarchy
drop table tbltemphierarchy select * into tbltemphierarchy from (select * from [dbo].[hierarchy_level_emp_temp] where
 t1='P905344' and t2 in (select  [Position ID] from Actual_simulation_AOP_CY_BUHR where [BU/SSU] in (select [BU/SSU Description] 
 from WFS_BUHR_Access where Username='6012067') and [Position ID] is not null)) as x
 
delete from [hierarchy_level_emp_temp]
where  t1='P905344'

insert into [hierarchy_level_emp_temp] select * from tbltemphierarchy

drop table tbltemphierarchy select * into tbltemphierarchy from (select * from [dbo].[hierarchy_level_emp_temp]
 where t1='P900440' and t2 in (select  [Position ID] from Actual_simulation_AOP_CY_BUHR where [BU/SSU] in (select [BU/SSU Description] 
 from WFS_BUHR_Access where Username='T4339') and [Position ID] is not null)) as x
 
delete from [hierarchy_level_emp_temp]
where  t1='P900440'

insert into [hierarchy_level_emp_temp] select * from tbltemphierarchy

drop table tbltemphierarchy select * into tbltemphierarchy from (select * from [dbo].[hierarchy_level_emp_temp]
 where t1='P903416' and t2 in (select  [Position ID] from Actual_simulation_AOP_CY_BUHR where [BU/SSU] in (select [BU/SSU Description] 
 from WFS_BUHR_Access where Username='6013048') and [Position ID] is not null)) as x
 
delete from [hierarchy_level_emp_temp]
where  t1='P903416'

insert into [hierarchy_level_emp_temp] select * from tbltemphierarchy

drop table tbltemphierarchy select * into tbltemphierarchy from (select * from [dbo].[hierarchy_level_emp_temp] 
where t1='P905475' and t2 in (select  [Position ID] from Actual_simulation_AOP_CY_BUHR where [BU/SSU] in (select [BU/SSU Description]
 from WFS_BUHR_Access where Username='6004343') and [Position ID] is not null)) as x
 
delete from [hierarchy_level_emp_temp]
where  t1='P905475'

insert into [hierarchy_level_emp_temp] select * from tbltemphierarchy

drop table tbltemphierarchy select * into tbltemphierarchy from (select * from [dbo].[hierarchy_level_emp_temp]
 where t1='P900507' and t2 in (select  [Position ID] from Actual_simulation_AOP_CY_BUHR where [BU/SSU] in (select [BU/SSU Description] 
 from WFS_BUHR_Access where Username='6007333') and [Position ID] is not null)) as x
 
delete from [hierarchy_level_emp_temp]
where  t1='P900507'

insert into [hierarchy_level_emp_temp] select * from tbltemphierarchy

drop table tbltemphierarchy select * into tbltemphierarchy from (select * from [dbo].[hierarchy_level_emp_temp]
 where t1='P904308' and t2 in (select  [Position ID] from Actual_simulation_AOP_CY_BUHR where [BU/SSU] in (select [BU/SSU Description] 
 from WFS_BUHR_Access where Username='6010370') and [Position ID] is not null)) as x
 
delete from [hierarchy_level_emp_temp]
where  t1='P904308'

insert into [hierarchy_level_emp_temp] select * from tbltemphierarchy

drop table tbltemphierarchy select * into tbltemphierarchy from (select * from [dbo].[hierarchy_level_emp_temp] 
where t1='P901096' and t2 in (select  [Position ID] from Actual_simulation_AOP_CY_BUHR where [BU/SSU] in (select [BU/SSU Description]
 from WFS_BUHR_Access where Username='T12104') and [Position ID] is not null)) as x
 
delete from [hierarchy_level_emp_temp]
where  t1='P901096'

insert into [hierarchy_level_emp_temp] select * from tbltemphierarchy

drop table tbltemphierarchy select * into tbltemphierarchy from (select * from [dbo].[hierarchy_level_emp_temp]
 where t1='P912044' and t2 in (select  [Position ID] from Actual_simulation_AOP_CY_BUHR where [BU/SSU] in (select [BU/SSU Description]
  from WFS_BUHR_Access where Username='6006689') and [Position ID] is not null)) as x
  
delete from [hierarchy_level_emp_temp]
where  t1='P912044'

insert into [hierarchy_level_emp_temp] select * from tbltemphierarchy

drop table tbltemphierarchy select * into tbltemphierarchy from (select * from [dbo].[hierarchy_level_emp_temp]
 where t1='P905168' and t2 in (select  [Position ID] from Actual_simulation_AOP_CY_BUHR where [BU/SSU] in (select [BU/SSU Description]
  from WFS_BUHR_Access where Username='6003865') and [Position ID] is not null)) as x
  
delete from [hierarchy_level_emp_temp]
where  t1='P905168'

insert into [hierarchy_level_emp_temp] select * from tbltemphierarchy

drop table tbltemphierarchy select * into tbltemphierarchy from (select * from [dbo].[hierarchy_level_emp_temp]
 where t1='P904481' and t2 in (select  [Position ID] from Actual_simulation_AOP_CY_BUHR where [BU/SSU] in (select [BU/SSU Description] 
 from WFS_BUHR_Access where Username='6010718') and [Position ID] is not null)) as x
 
delete from [hierarchy_level_emp_temp]
where  t1='P904481'

insert into [hierarchy_level_emp_temp] select * from tbltemphierarchy

drop table tbltemphierarchy select * into tbltemphierarchy from (select * from [dbo].[hierarchy_level_emp_temp] 
where t1='P905103' and t2 in (select  [Position ID] from Actual_simulation_AOP_CY_BUHR where [BU/SSU] in (select [BU/SSU Description] 
from WFS_BUHR_Access where Username='6003771') and [Position ID] is not null)) as x

delete from [hierarchy_level_emp_temp]
where  t1='P905103'

insert into [hierarchy_level_emp_temp] select * from tbltemphierarchy

drop table tbltemphierarchy select * into tbltemphierarchy from (select * from [dbo].[hierarchy_level_emp_temp] 
where t1='P905387' and t2 in (select  [Position ID] from Actual_simulation_AOP_CY_BUHR where [BU/SSU] in (select [BU/SSU Description] 
from WFS_BUHR_Access where Username='6012639') and [Position ID] is not null)) as x

delete from [hierarchy_level_emp_temp]
where  t1='P905387'

insert into [hierarchy_level_emp_temp] select * from tbltemphierarchy

drop table tbltemphierarchy select * into tbltemphierarchy from (select * from [dbo].[hierarchy_level_emp_temp]
 where t1='P906235' and t2 in (select  [Position ID] from Actual_simulation_AOP_CY_BUHR where [BU/SSU] in (select [BU/SSU Description] 
 from WFS_BUHR_Access where Username='6005512') and [Position ID] is not null)) as x
 
delete from [hierarchy_level_emp_temp]
where  t1='P906235'

insert into [hierarchy_level_emp_temp] select * from tbltemphierarchy

drop table tbltemphierarchy select * into tbltemphierarchy from (select * from [dbo].[hierarchy_level_emp_temp]
 where t1='P900437' and t2 in (select  [Position ID] from Actual_simulation_AOP_CY_BUHR where [BU/SSU] in (select [BU/SSU Description]
  from WFS_BUHR_Access where Username='T36753') and [Position ID] is not null)) as x

delete from [hierarchy_level_emp_temp]
where  t1='P900437'

insert into [hierarchy_level_emp_temp] select * from tbltemphierarchy

drop table tbltemphierarchy select * into tbltemphierarchy from (select * from [dbo].[hierarchy_level_emp_temp]
 where t1='P907745' and t2 in (select  [Position ID] from Actual_simulation_AOP_CY_BUHR where [BU/SSU] in (select [BU/SSU Description]
  from WFS_BUHR_Access where Username='6007561') and [Position ID] is not null)) as x

delete from [hierarchy_level_emp_temp]
where  t1='P907745'

insert into [hierarchy_level_emp_temp] select * from tbltemphierarchy

drop table tbltemphierarchy select * into tbltemphierarchy from (select * from [dbo].[hierarchy_level_emp_temp]
 where t1='P905588' and t2 in (select  [Position ID] from Actual_simulation_AOP_CY_BUHR where [BU/SSU] in (select [BU/SSU Description]
  from WFS_BUHR_Access where Username='6004128') and [Position ID] is not null)) as x

delete from [hierarchy_level_emp_temp]
where  t1='P905588'

insert into [hierarchy_level_emp_temp] select * from tbltemphierarchy

drop table tbltemphierarchy select * into tbltemphierarchy from (select * from [dbo].[hierarchy_level_emp_temp]
 where t1='P900008' and t2 in (select  [Position ID] from Actual_simulation_AOP_CY_BUHR where [BU/SSU] in (select [BU/SSU Description]
  from WFS_BUHR_Access where Username='T35286') and [Position ID] is not null)) as x

delete from [hierarchy_level_emp_temp]
where  t1='P900008'

insert into [hierarchy_level_emp_temp] select * from tbltemphierarchy


