
CREATE CLUSTERED INDEX CI_PID ON [dbo].[Actual_simulation_AOP_CY_BUHR]([Position ID])

CREATE NONCLUSTERED INDEX NCI_BUSSU ON [dbo].[Actual_simulation_AOP_CY_BUHR]([BU SSU]) 

CREATE NONCLUSTERED INDEX NCI_LOB ON [dbo].[Actual_simulation_AOP_CY_BUHR]([LOB Segment]) 

CREATE CLUSTERED INDEX CI_PID ON [dbo].[Actual_simulation_AOP_CY_GMC]([Position ID])

CREATE NONCLUSTERED INDEX NCI_BUSSU ON [dbo].[Actual_simulation_AOP_CY_GMC]([BU SSU]) 

CREATE NONCLUSTERED INDEX NCI_LOB ON [dbo].[Actual_simulation_AOP_CY_GMC]([LOB Segment]) 

CREATE NONCLUSTERED INDEX NCI_PID ON  [dbo].[AOP13]([Position ID])
--CREATE NONCLUSTERED INDEX NCI_BUSSU ON  [dbo].[AOP13]([LOB   Segment])

-------------------------------------------------------------------------------------------
create nonclustered index  NCI_MAIL_BUHR ON [dbo].[T_GMCList](mail) 
create nonclustered index  NCI_JFC_CJF_BUHR ON [dbo].[Actual_simulation_AOP_CY_BUHR]([Job Family Cluster (Current JF)]) 
create nonclustered index  NCI_JFC_BUHR ON [dbo].[Actual_simulation_AOP_CY_BUHR]([Job Family Cluster]) 
create nonclustered index  NCI_REGION_BUHR ON [dbo].[Actual_simulation_AOP_CY_BUHR](Region) 
create nonclustered index  NCI_CUREGION_BUHR ON [dbo].[Actual_simulation_AOP_CY_BUHR](CurrentRegion) 
create nonclustered index  NCI_JFC_CJF_GMC ON [dbo].[Actual_simulation_AOP_CY_GMC]([Job Family Cluster (Current JF)]) 
create nonclustered index  NCI_JFC_GMC ON [dbo].[Actual_simulation_AOP_CY_GMC]([Job Family Cluster]) 
create nonclustered index  NCI_REGION_GMC ON [dbo].[Actual_simulation_AOP_CY_GMC](Region) 
create nonclustered index  NCI_CUREGION_GMC ON [dbo].[Actual_simulation_AOP_CY_GMC](CurrentRegion) 

 ------------------------------------------------------------------------------------------

CREATE CLUSTERED COLUMNSTORE INDEX CCI_t on  [dbo].[hierarchy_level_emp_temp]
CREATE NONCLUSTERED  INDEX CCI_t1 on  [dbo].[hierarchy_level_emp_temp](t1)
CREATE NONCLUSTERED  INDEX CCI_t10 on  [dbo].[hierarchy_level_emp_temp](t10)

CREATE CLUSTERED COLUMNSTORE INDEX CCI_h on  [dbo].[T_hierarchy_on_positions_wo_nulls]
CREATE NONCLUSTERED  INDEX CCI_m on  [dbo].[T_hierarchy_on_positions_wo_nulls]([manager_position_id])
CREATE NONCLUSTERED  INDEX CCI_e on  [dbo].[T_hierarchy_on_positions_wo_nulls]([emp_position_id])
CREATE NONCLUSTERED  INDEX CCI_s on  [dbo].[T_hierarchy_on_positions_wo_nulls](steps)

CREATE CLUSTERED COLUMNSTORE INDEX CCI_EID on [dbo].[userDetails]

CREATE CLUSTERED COLUMNSTORE INDEX CCI_WFSBUHRA on [dbo].[WFS_BUHR_Access]

CREATE CLUSTERED COLUMNSTORE INDEX CCI_map on [dbo].[maaping_city_region]


---------------------------------------DROP Indexes --------------------------------------------------------


drop index CI_PID ON [dbo].[Actual_simulation_AOP_CY_BUHR]
drop index NCI_REGION_BUHR ON [dbo].[Actual_simulation_AOP_CY_BUHR]
drop index NCI_JFC_BUHR ON [dbo].[Actual_simulation_AOP_CY_BUHR]
drop index NCI_JFC_CJF_BUHR ON [dbo].[Actual_simulation_AOP_CY_BUHR]
drop index NCI_CUREGION_BUHR ON [dbo].[Actual_simulation_AOP_CY_BUHR]
drop index NCI_MAIL_BUHR ON [dbo].[T_GMCList]
drop index NCI_REGION_GMC ON [dbo].[Actual_simulation_AOP_CY_GMC]
drop index NCI_JFC_GMC ON [dbo].[Actual_simulation_AOP_CY_GMC]
drop index NCI_JFC_CJF_GMC ON [dbo].[Actual_simulation_AOP_CY_GMC]
drop index NCI_CUREGION_GMC ON [dbo].[Actual_simulation_AOP_CY_GMC]

drop index NCI_BUSSU ON [dbo].[Actual_simulation_AOP_CY_BUHR]

drop index NCI_LOB ON [dbo].[Actual_simulation_AOP_CY_BUHR]

drop index CI_PID ON [dbo].[Actual_simulation_AOP_CY_GMC]

drop index NCI_BUSSU ON [dbo].[Actual_simulation_AOP_CY_GMC]

drop index NCI_LOB ON [dbo].[Actual_simulation_AOP_CY_GMC]

drop index NCI_PID ON  [dbo].[AOP13]
--drop index NCI_lob ON  [dbo].[AOP13]
 

drop index CCI_t on  [dbo].[hierarchy_level_emp_temp]
drop index CCI_t1 on  [dbo].[hierarchy_level_emp_temp]
drop index CCI_t10 on  [dbo].[hierarchy_level_emp_temp]

drop index CCI_h on  [dbo].[T_hierarchy_on_positions_wo_nulls]
drop index CCI_m on  [dbo].[T_hierarchy_on_positions_wo_nulls]
drop index CCI_e on  [dbo].[T_hierarchy_on_positions_wo_nulls]
drop index CCI_s on  [dbo].[T_hierarchy_on_positions_wo_nulls]

drop index CCI_EID on [dbo].[userDetails]

drop index CCI_WFSBUHRA on [dbo].[WFS_BUHR_Access]

drop index CCI_map on [dbo].[maaping_city_region]
--------------------------------------------------------------------------------------------------------------------------------------------------
