
ALTER PROCEDURE [dbo].[SP_GeoDistJF_BUHR_post] @mail nvarchar(100),@BU nvarchar(200)
as
select [job family cluster]
,case when HC_LC_ratio_india is null and HC_LC_ratio_int is null then 0
else case when (isnull(HC_LC_ratio_india,0)+isnull(HC_LC_ratio_int,0))=100 then isnull(HC_LC_ratio_india,0) 
     else case when isnull(HC_LC_ratio_india,0)=0 then 100-isnull(HC_LC_ratio_int,0) 
	      else  isnull(HC_LC_ratio_india,0) end
 end end as HC_LC_ratio_india,
 case when HC_LC_ratio_int is null and HC_LC_ratio_india is null then 0
 else case when (isnull(HC_LC_ratio_india,0)+isnull(HC_LC_ratio_int,0))=100 then isnull(HC_LC_ratio_int,0) 
     else case when isnull(HC_LC_ratio_int,0)=0 then 100-isnull(HC_LC_ratio_india,0)
	      else isnull(HC_LC_ratio_int,0) end end end as HC_LC_ratio_int,
 
 
case when Current_status_india is null and Current_status_int is null then 0
else case when (isnull(Current_status_india,0)+isnull(Current_status_int,0))=100 then isnull(Current_status_india,0) 
     else case when isnull(Current_status_india,0)=0 then 100-isnull(Current_status_int,0) 
	      else isnull(Current_status_india,0) end
 end end as Current_status_india,
 case when Current_status_int is null and Current_status_india is null then 0
 else case when (isnull(Current_status_india,0)+isnull(Current_status_int,0))=100 then isnull(Current_status_int,0) 
     else case when isnull(Current_status_int,0)=0 then 100-isnull(Current_status_india,0)
	      else isnull(Current_status_int,0) end end end as Current_status_int,
 
case when (desired_output_india+desired_output_int)=100 then desired_output_india 
     else case when desired_output_india=0 then 100-desired_output_int 
	      else desired_output_india end
 end as desired_output_india,
 case when (desired_output_india+desired_output_int)=100 then desired_output_int 
     else case when desired_output_int=0 then 100-desired_output_india
	      else desired_output_int end end as desired_output_int 
 from (
select [job family cluster], HC_LC_ratio_india, HC_LC_ratio_int, current_status_india, current_status_int,
isnull( desired_output_india, 0 ) desired_output_india,isnull( desired_output_int, 0 ) desired_output_int
from(
select * 
from (select [col_reg], col1 as [job family cluster], value 
from ( 
select *
from
(
  select [Job Family Cluster],col +  '_' + [Region] as col_reg, value
  from (select t1.[Job Family Cluster], [HC_LC_Ratio], [desired_output], [current_status], t1.[Region] from 
(select distinct [Job Family Cluster], [current_status], [Region] from (



----------------------------------------------------------------------------------------------------
select  X1.[Job Family Cluster],X2.[Job Family Cluster (Current JF)],X1.HC_LC_Ratio,X2.current_status ,X1.desired_output ,X1.BU,
case when X1.mail is null then X2.mail else X1.mail end mail,X1.OutlooktRegion,X2.Region from
(
select distinct tE.[Job Family Cluster],tE.OutlooktRegion,tE.mail as mail, HC_LC_Ratio,
--current_status,
D.desired_output ,V.[BU/SSU] as BU
from
(
SELECT tC.*
FROM (
               SELECT tA.*,(tA.Cost/nullif(tB.Denom_Cost,0)) * 100 as HC_LC_Ratio--, tA.Current_Cost*100/nullif(tB.Denom_Current_Cost,0) as current_status
                FROM (
                               SELECT  [Job Family Cluster],[mail],SUM( case when is_transfer = 1 then CAST([Cost] AS FLOAT)*11/12
																		when is_surrender = 1 then CAST([Cost] AS FLOAT)  
																		else [CTC $ - FY Exit] end)  AS Cost, 
							   case when transfer_to_region='India' or transfer_to_region='Sri Lanka' then 'India' else 'Int' end as OutlooktRegion,
							   [BU/SSU] as BU
                                FROM [dbo].V_inprocess_BUHR 
                                GROUP BY [Job Family Cluster],case when transfer_to_region='India' or transfer_to_region='Sri Lanka' then 'India' else 'Int' end ,mail,[BU/SSU]
                               ) tA

                JOIN (
                                SELECT  [Job Family Cluster],[mail],SUM( case when is_transfer = 1 then CAST([Cost] AS FLOAT)*11/12 when is_surrender = 1 then CAST([Cost] AS FLOAT)  else [CTC $ - FY Exit] end)  AS Denom_Cost, [BU/SSU] as BU                                                                                                                           
                                FROM [dbo].V_inprocess_BUHR
                                GROUP BY [Job Family Cluster],[mail],[BU/SSU]
                                HAVING [Job Family Cluster] IS NOT NULL
                                ) tB ON tA.[Job Family Cluster] = tB.[Job Family Cluster] and tA.BU = tB.BU
                                AND tA.mail = tB.mail
                ) AS tC
) tE
join desiredOutputINReutersTable D
on D.JobFamily = tE.[Job Family Cluster] and tE.OutlooktRegion = D.Location 
and tE.BU = D.BU
join V_inprocess_BUHR V
on V.[Job Family Cluster] = tE.[Job Family Cluster] and V.mail = tE.mail and V.Region = tE.OutlooktRegion 
and V.[BU/SSU] = tE.BU
 where V.mail=@mail and D.BU=@BU) as X1
  full outer join
  -------------------------------------------------------current job cluster--------------------

( 
select distinct tE.[Job Family Cluster (Current JF)],tE.Region,tE.mail as mail,
current_status,D.desired_output ,V.[BU/SSU] as BU
from
(
SELECT tC.*
FROM (
                SELECT tA.*,tA.Current_Cost*100/nullif(tB.Denom_Current_Cost,0) as current_status
                FROM (
				             SELECT  [Job Family Cluster (Current JF)],[mail],
                                sum(case when [Report Type]='Headcount' then cast([Loaded Cost (USD)] as float)  else 0 end)  AS Current_Cost, 
								case when [Final Country]='India' or [Final Country]='Sri Lanka' then 'India' else 'Int' end as Region,[BU/SSU]
                                FROM [dbo].V_inprocess_BUHR --where [Report Type]='Headcount'
                                GROUP BY [Job Family Cluster (Current JF)],case when [Final Country]='India' or [Final Country]='Sri Lanka' then 'India' else 'Int' end ,[mail],[BU/SSU]
                                ) tA

                JOIN (

                                SELECT  [Job Family Cluster (Current JF)],[mail],
                                sum(case when [Report Type]='Headcount' then cast([Loaded Cost (USD)] as float)  else 0 end)  AS Denom_Current_Cost,
								[BU/SSU]
                                FROM [dbo].V_inprocess_BUHR --where [Report Type]='Headcount'
                                GROUP BY [Job Family Cluster (Current JF)],[mail],[BU/SSU]
                                HAVING [Job Family Cluster (Current JF)] IS NOT NULL
                                ) tB ON tA.[Job Family Cluster (Current JF)] = tB.[Job Family Cluster (Current JF)] and tA.[BU/SSU]=tB.[BU/SSU]
                                AND tA.mail = tB.mail
                ) AS tC
) tE
join desiredOutputINReutersTable D
on D.JobFamily = tE.[Job Family Cluster (Current JF)] and tE.Region = D.Location 
and tE.[BU/SSU] = D.BU
join V_inprocess_BUHR V
on V.[Job Family Cluster (Current JF)] = tE.[Job Family Cluster (Current JF)] and V.mail = tE.mail and V.Region = tE.Region 
and V.[BU/SSU]=tE.[BU/SSU]
where V.mail=@mail and D.BU=@BU) as X2 on X1.OutlooktRegion=X2.Region and X1.BU=X2.BU and X1.[Job Family Cluster]=X2.[Job Family Cluster (Current JF)] and X1.BU = X2.BU
where X1.mail=X2.mail and X1.BU = X2.BU 

------------------------------------------------------------------------------------------------------------------------------------------------

)as h )t1 join (
select distinct [Job Family Cluster], [HC_LC_Ratio], cast([desired_output] as float) as [desired_output], [OutlooktRegion] as [Region] from(



---------------------------------------------------------------------------------------------------------------------
select  X1.[Job Family Cluster],X2.[Job Family Cluster (Current JF)],X1.HC_LC_Ratio,X2.current_status ,X1.desired_output ,X1.BU,
case when X1.mail is null then X2.mail else X1.mail end mail,X1.OutlooktRegion,X2.Region from
(
select distinct tE.[Job Family Cluster],tE.OutlooktRegion,tE.mail as mail, HC_LC_Ratio,
--current_status,
D.desired_output ,V.[BU/SSU] as BU
from
(
SELECT tC.*
FROM (
               SELECT tA.*,(tA.Cost/nullif(tB.Denom_Cost,0)) * 100 as HC_LC_Ratio--, tA.Current_Cost*100/nullif(tB.Denom_Current_Cost,0) as current_status
                FROM (
                               SELECT  [Job Family Cluster],[mail],SUM( case when is_transfer = 1 then CAST([Cost] AS FLOAT)*11/12  
																		when is_surrender = 1 then CAST([Cost] AS FLOAT)
																		else [CTC $ - FY Exit] end)  AS Cost, 
							   case when transfer_to_region='India' or transfer_to_region='Sri Lanka' then 'India' else 'Int' end as OutlooktRegion,
							   [BU/SSU] as BU
                                FROM [dbo].V_inprocess_BUHR 
                                GROUP BY [Job Family Cluster],case when transfer_to_region='India' or transfer_to_region='Sri Lanka' then 'India' else 'Int' end ,mail,[BU/SSU]
                               ) tA

                JOIN (
                                SELECT  [Job Family Cluster],[mail],SUM( case when is_transfer = 1 then CAST([Cost] AS FLOAT)*11/12 when is_surrender = 1 then CAST([Cost] AS FLOAT)  else [CTC $ - FY Exit] end)  AS Denom_Cost, [BU/SSU] as BU                                                                                                                           
                                FROM [dbo].V_inprocess_BUHR
                                GROUP BY [Job Family Cluster],[mail],[BU/SSU]
                                HAVING [Job Family Cluster] IS NOT NULL
                                ) tB ON tA.[Job Family Cluster] = tB.[Job Family Cluster] and tA.BU = tB.BU
                                AND tA.mail = tB.mail
                ) AS tC
) tE
join desiredOutputINReutersTable D
on D.JobFamily = tE.[Job Family Cluster] and tE.OutlooktRegion = D.Location 
and tE.BU = D.BU
join V_inprocess_BUHR V
on V.[Job Family Cluster] = tE.[Job Family Cluster] and V.mail = tE.mail and V.Region = tE.OutlooktRegion 
and V.[BU/SSU] = tE.BU
 where V.mail=@mail and D.BU=@BU) as X1
  full outer join
  -------------------------------------------------------current job cluster--------------------

( 
select distinct tE.[Job Family Cluster (Current JF)],tE.Region,tE.mail as mail,
current_status,D.desired_output ,V.[BU/SSU] as BU
from
(
SELECT tC.*
FROM (
                SELECT tA.*,tA.Current_Cost*100/nullif(tB.Denom_Current_Cost,0) as current_status
                FROM (
				             SELECT  [Job Family Cluster (Current JF)],[mail],
                                sum(case when [Report Type]='Headcount' then cast([Loaded Cost (USD)] as float)  else 0 end)  AS Current_Cost, 
								case when [Final Country]='India' or [Final Country]='Sri Lanka' then 'India' else 'Int' end as Region,[BU/SSU]
                                FROM [dbo].V_inprocess_BUHR --where [Report Type]='Headcount'
                                GROUP BY [Job Family Cluster (Current JF)],case when [Final Country]='India' or [Final Country]='Sri Lanka' then 'India' else 'Int' end ,[mail],[BU/SSU]
                                ) tA

                JOIN (

                                SELECT  [Job Family Cluster (Current JF)],[mail],
                                sum(case when [Report Type]='Headcount' then cast([Loaded Cost (USD)] as float)  else 0 end)  AS Denom_Current_Cost,
								[BU/SSU]
                                FROM [dbo].V_inprocess_BUHR --where [Report Type]='Headcount'
                                GROUP BY [Job Family Cluster (Current JF)],[mail],[BU/SSU]
                                HAVING [Job Family Cluster (Current JF)] IS NOT NULL
                                ) tB ON tA.[Job Family Cluster (Current JF)] = tB.[Job Family Cluster (Current JF)] and tA.[BU/SSU]=tB.[BU/SSU]
                                AND tA.mail = tB.mail
                ) AS tC
) tE
join desiredOutputINReutersTable D
on D.JobFamily = tE.[Job Family Cluster (Current JF)] and tE.Region = D.Location 
and tE.[BU/SSU] = D.BU
join V_inprocess_BUHR V
on V.[Job Family Cluster (Current JF)] = tE.[Job Family Cluster (Current JF)] and V.mail = tE.mail and V.Region = tE.Region 
and V.[BU/SSU]=tE.[BU/SSU]
where V.mail=@mail and D.BU=@BU) as X2 on X1.OutlooktRegion=X2.Region and X1.BU=X2.BU and X1.[Job Family Cluster]=X2.[Job Family Cluster (Current JF)] and X1.BU = X2.BU
where X1.mail=X2.mail and X1.BU = X2.BU 

----------------------------------------------------------------------




 )as f)t2
 on t1.[Job Family Cluster]= t2.[Job Family Cluster] and t1.[Region]=t2.[Region]) as x
   unpivot
  (
    value
    for col in ([HC_LC_Ratio], [current_status],[desired_output])
  ) unpiv
) src
pivot
(
  max(value)
  for [Job Family Cluster] in ("HR & Corp Services", "Engineering", "Others","BE","Finance","Legal","Marketing","Operations","Product Management","Sales","Sales Support","Strategy")
) piv)
b
unpivot 
(
value 
for col1 in ([HR & Corp Services],[Engineering],[Others],[BE],[Finance],[Legal],[Marketing],[Operations],[Product Management],[Sales],[Sales Support],[Strategy] ))unpiv1)src1
pivot
(max(value)
for [col_reg] in (HC_LC_Ratio_India, HC_LC_Ratio_Int, current_status_India, current_status_Int, desired_output_India, desired_output_Int))
piv
) as R
) as K


--==============================================================================================================================================================================


ALTER PROCEDURE [dbo].[SP_GeoDistJF_BUHR] @mail nvarchar(100),@BU nvarchar(200) as

 select [job family cluster]
,case when HC_LC_ratio_india is null and HC_LC_ratio_int is null then 0
else case when (isnull(HC_LC_ratio_india,0)+isnull(HC_LC_ratio_int,0))=100 then isnull(HC_LC_ratio_india,0) 
     else case when isnull(HC_LC_ratio_india,0)=0 then 100-isnull(HC_LC_ratio_int,0) 
	      else  isnull(HC_LC_ratio_india,0) end
 end end as HC_LC_ratio_india,
 case when HC_LC_ratio_int is null and HC_LC_ratio_india is null then 0
 else case when (isnull(HC_LC_ratio_india,0)+isnull(HC_LC_ratio_int,0))=100 then isnull(HC_LC_ratio_int,0) 
     else case when isnull(HC_LC_ratio_int,0)=0 then 100-isnull(HC_LC_ratio_india,0)
	      else isnull(HC_LC_ratio_int,0) end end end as HC_LC_ratio_int,
 
 
case when Current_status_india is null and Current_status_int is null then 0
else case when (isnull(Current_status_india,0)+isnull(Current_status_int,0))=100 then isnull(Current_status_india,0) 
     else case when isnull(Current_status_india,0)=0 then 100-isnull(Current_status_int,0) 
	      else isnull(Current_status_india,0) end
 end end as Current_status_india,
 case when Current_status_int is null and Current_status_india is null then 0
 else case when (isnull(Current_status_india,0)+isnull(Current_status_int,0))=100 then isnull(Current_status_int,0) 
     else case when isnull(Current_status_int,0)=0 then 100-isnull(Current_status_india,0)
	      else isnull(Current_status_int,0) end end end as Current_status_int,
 
case when (desired_output_india+desired_output_int)=100 then desired_output_india 
     else case when desired_output_india=0 then 100-desired_output_int 
	      else desired_output_india end
 end as desired_output_india,
 case when (desired_output_india+desired_output_int)=100 then desired_output_int 
     else case when desired_output_int=0 then 100-desired_output_india
	      else desired_output_int end end as desired_output_int  
 from (
select [job family cluster], HC_LC_ratio_india, HC_LC_ratio_int, current_status_india, current_status_int,
isnull( desired_output_india, 0 ) desired_output_india,isnull( desired_output_int, 0 ) desired_output_int
from(
select * 
from (select [col_reg], col1 as [job family cluster], value 
from ( 
select *
from
(
  select [Job Family Cluster],col +  '_' + [Region] as col_reg, value
  from (select t1.[Job Family Cluster], [HC_LC_Ratio], [desired_output], [current_status], t1.[Region] from 
(select distinct [Job Family Cluster], [current_status], [Region] from (



----------------------------------------------------------------------------------------------------

select  X1.[Job Family Cluster],X2.[Job Family Cluster (Current JF)],X1.HC_LC_Ratio,X2.current_status ,X1.desired_output ,X1.BU,
case when X1.mail is null then X2.mail else X1.mail end mail,X1.OutlooktRegion,X2.Region from
(
select distinct tE.[Job Family Cluster],tE.OutlooktRegion,tE.mail as mail, HC_LC_Ratio,
--current_status,
D.desired_output ,V.[BU/SSU] as BU
from
(
SELECT tC.*
FROM (
               SELECT tA.*,(tA.Cost/nullif(tB.Denom_Cost,0)) * 100 as HC_LC_Ratio--, tA.Current_Cost*100/nullif(tB.Denom_Current_Cost,0) as current_status
                FROM (
                               SELECT  [Job Family Cluster],[mail],SUM([CTC $ - FY Exit]) AS Cost, 
							   case when [Final Country]='India' or [Final Country]='Sri Lanka' then 'India' else 'Int' end as OutlooktRegion,
							   [BU/SSU] as BU
                                FROM [dbo].[V_simulation_CY_BUHR] 
                                GROUP BY [Job Family Cluster],case when [Final Country]='India' or [Final Country]='Sri Lanka' then 'India' else 'Int' end ,mail,[BU/SSU]
                               ) tA

                JOIN (
                                SELECT  [Job Family Cluster],[mail],SUM([CTC $ - FY Exit]) AS Denom_Cost, [BU/SSU] as BU                                                                                                                           
                                FROM [dbo].[V_simulation_CY_BUHR]
                                GROUP BY [Job Family Cluster],[mail],[BU/SSU]
                                HAVING [Job Family Cluster] IS NOT NULL
                                ) tB ON tA.[Job Family Cluster] = tB.[Job Family Cluster] and tA.BU = tB.BU
                                AND tA.mail = tB.mail
                ) AS tC
) tE
join desiredOutputINReutersTable D
on D.JobFamily = tE.[Job Family Cluster] and tE.OutlooktRegion = D.Location and tE.BU = D.BU
join [V_simulation_CY_BUHR] V
on V.[Job Family Cluster] = tE.[Job Family Cluster] and V.mail = tE.mail and V.Region = tE.OutlooktRegion and V.[BU/SSU] = tE.BU
 where V.mail=@mail and D.BU=@BU
 ) as X1
  full outer join
  -------------------------------------------------------current job cluster--------------------

( 
select distinct tE.[Job Family Cluster (Current JF)],tE.Region,tE.mail as mail,
current_status,D.desired_output ,V.[BU/SSU] as BU
from
(
SELECT tC.*
FROM (
                SELECT tA.*,tA.Current_Cost*100/nullif(tB.Denom_Current_Cost,0) as current_status
                FROM (
				             SELECT  [Job Family Cluster (Current JF)],[mail],
                                sum(case when [Report Type]='Headcount' then cast([Loaded Cost (USD)] as float)  else 0 end)  AS Current_Cost, 
								Region,[BU/SSU]
                                FROM [dbo].[V_simulation_CY_BUHR] --where [Report Type]='Headcount'
                                GROUP BY [Job Family Cluster (Current JF)],Region,[mail],[BU/SSU]
                                ) tA

                JOIN (

                                SELECT  [Job Family Cluster (Current JF)],[mail],
                                sum(case when [Report Type]='Headcount' then cast([Loaded Cost (USD)] as float)  else 0 end)  AS Denom_Current_Cost,
								[BU/SSU]
                                FROM [dbo].[V_simulation_CY_BUHR] --where [Report Type]='Headcount'
                                GROUP BY [Job Family Cluster (Current JF)],[mail],[BU/SSU]
                                HAVING [Job Family Cluster (Current JF)] IS NOT NULL
                                ) tB ON tA.[Job Family Cluster (Current JF)] = tB.[Job Family Cluster (Current JF)] and tA.[BU/SSU]=tB.[BU/SSU]
                                AND tA.mail = tB.mail
                ) AS tC
) tE
join desiredOutputINReutersTable D
on D.JobFamily = tE.[Job Family Cluster (Current JF)] and tE.Region = D.Location and tE.[BU/SSU] = D.BU
join [V_simulation_CY_BUHR] V
on V.[Job Family Cluster (Current JF)] = tE.[Job Family Cluster (Current JF)] and V.mail = tE.mail and V.Region = tE.Region and V.[BU/SSU]=tE.[BU/SSU]
 where V.mail=@mail and D.BU=@BU
) as X2 on X1.OutlooktRegion=X2.Region and X1.BU=X2.BU and X1.[Job Family Cluster]=X2.[Job Family Cluster (Current JF)] and X1.BU = X2.BU
where X1.mail=X2.mail and X1.BU = X2.BU 

------------------------------------------------------------------------------------------------------------------------------------------------

)as h )t1 join (
select distinct [Job Family Cluster], [HC_LC_Ratio], cast([desired_output] as float) as [desired_output], [OutlooktRegion] as [Region] from(



---------------------------------------------------------------------------------------------------------------------

select  X1.[Job Family Cluster],X2.[Job Family Cluster (Current JF)],X1.HC_LC_Ratio,X2.current_status,X1.desired_output ,X1.BU,
case when X1.mail is null then X2.mail else X1.mail end mail,X1.OutlooktRegion,X2.Region from
(
select distinct tE.[Job Family Cluster],tE.OutlooktRegion,tE.mail as mail, HC_LC_Ratio,
--current_status,
D.desired_output ,V.[BU/SSU] as BU
from
(
SELECT tC.*
FROM (
               SELECT tA.*,(tA.Cost/nullif(tB.Denom_Cost,0)) * 100 as HC_LC_Ratio--, tA.Current_Cost*100/nullif(tB.Denom_Current_Cost,0) as current_status
                FROM (
                               SELECT  [Job Family Cluster],[mail],SUM([CTC $ - FY Exit]) AS Cost, 
							   case when [Final Country]='India' or [Final Country]='Sri Lanka' then 'India' else 'Int' end as OutlooktRegion,
							   [BU/SSU] as BU
                                FROM [dbo].[V_simulation_CY_BUHR] 
                                GROUP BY [Job Family Cluster],case when [Final Country]='India' or [Final Country]='Sri Lanka' then 'India' else 'Int' end ,mail,[BU/SSU]
                               ) tA

                JOIN (
                                SELECT  [Job Family Cluster],[mail],SUM([CTC $ - FY Exit]) AS Denom_Cost, [BU/SSU] as BU                                                                                                                           
                                FROM [dbo].[V_simulation_CY_BUHR]
                                GROUP BY [Job Family Cluster],[mail],[BU/SSU]
                                HAVING [Job Family Cluster] IS NOT NULL
                                ) tB ON tA.[Job Family Cluster] = tB.[Job Family Cluster] and tA.BU = tB.BU
                                AND tA.mail = tB.mail
                ) AS tC
) tE
join desiredOutputINReutersTable D
on D.JobFamily = tE.[Job Family Cluster] and tE.OutlooktRegion = D.Location and tE.BU = D.BU
join [V_simulation_CY_BUHR] V
on V.[Job Family Cluster] = tE.[Job Family Cluster] and V.mail = tE.mail and V.Region = tE.OutlooktRegion and V.[BU/SSU] = tE.BU
 where V.mail=@mail and D.BU=@BU
 ) as X1
  full outer join
  -------------------------------------------------------current job cluster--------------------

( 
select distinct tE.[Job Family Cluster (Current JF)],tE.Region,tE.mail as mail,
current_status,D.desired_output ,V.[BU/SSU] as BU
from
(
SELECT tC.*
FROM (
                SELECT tA.*,tA.Current_Cost*100/nullif(tB.Denom_Current_Cost,0) as current_status
                FROM (
				             SELECT  [Job Family Cluster (Current JF)],[mail],
                                sum(case when [Report Type]='Headcount' then cast([Loaded Cost (USD)] as float)  else 0 end)  AS Current_Cost, 
								Region,[BU/SSU]
                                FROM [dbo].[V_simulation_CY_BUHR] --where [Report Type]='Headcount'
                                GROUP BY [Job Family Cluster (Current JF)],Region,[mail],[BU/SSU]
                                ) tA

                JOIN (

                                SELECT  [Job Family Cluster (Current JF)],[mail],
                                sum(case when [Report Type]='Headcount' then cast([Loaded Cost (USD)] as float)  else 0 end)  AS Denom_Current_Cost,
								[BU/SSU]
                                FROM [dbo].[V_simulation_CY_BUHR] --where [Report Type]='Headcount'
                                GROUP BY [Job Family Cluster (Current JF)],[mail],[BU/SSU]
                                HAVING [Job Family Cluster (Current JF)] IS NOT NULL
                                ) tB ON tA.[Job Family Cluster (Current JF)] = tB.[Job Family Cluster (Current JF)] and tA.[BU/SSU]=tB.[BU/SSU]
                                AND tA.mail = tB.mail
                ) AS tC
) tE
join desiredOutputINReutersTable D
on D.JobFamily = tE.[Job Family Cluster (Current JF)] and tE.Region = D.Location and tE.[BU/SSU] = D.BU
join [V_simulation_CY_BUHR] V
on V.[Job Family Cluster (Current JF)] = tE.[Job Family Cluster (Current JF)] and V.mail = tE.mail and V.Region = tE.Region and V.[BU/SSU]=tE.[BU/SSU]
 where V.mail=@mail and D.BU=@BU
) as X2 on X1.OutlooktRegion=X2.Region and X1.BU=X2.BU and X1.[Job Family Cluster]=X2.[Job Family Cluster (Current JF)] and X1.BU = X2.BU
where X1.mail=X2.mail and X1.BU = X2.BU 

----------------------------------------------------------------------




 )as f)t2
 on t1.[Job Family Cluster]= t2.[Job Family Cluster] and t1.[Region]=t2.[Region]) as x
   unpivot
  (
    value
    for col in ([HC_LC_Ratio], [current_status],[desired_output])
  ) unpiv
) src
pivot
(
  max(value)
  for [Job Family Cluster] in ("HR & Corp Services", "Engineering", "Others","BE","Finance","Legal","Marketing","Operations","Product Management","Sales","Sales Support","Strategy")
) piv)
b
unpivot 
(
value 
for col1 in ([HR & Corp Services],[Engineering],[Others],[BE],[Finance],[Legal],[Marketing],[Operations],[Product Management],[Sales],[Sales Support],[Strategy] ))unpiv1)src1
pivot
(max(value)
for [col_reg] in (HC_LC_Ratio_India, HC_LC_Ratio_Int, current_status_India, current_status_Int, desired_output_India, desired_output_Int))
piv
) as R

) as K


--=========================================================================================================================================================================


ALTER PROCEDURE [dbo].[SP_GeoDistJF_GMC] @mail nvarchar(100),@BU nvarchar(200)
as
select [job family cluster]
,case when HC_LC_ratio_india is null and HC_LC_ratio_int is null then 0
else case when (isnull(HC_LC_ratio_india,0)+isnull(HC_LC_ratio_int,0))=100 then isnull(HC_LC_ratio_india,0) 
     else case when isnull(HC_LC_ratio_india,0)=0 then 100-isnull(HC_LC_ratio_int,0) 
	      else  isnull(HC_LC_ratio_india,0) end
 end end as HC_LC_ratio_india,
 case when HC_LC_ratio_int is null and HC_LC_ratio_india is null then 0
 else case when (isnull(HC_LC_ratio_india,0)+isnull(HC_LC_ratio_int,0))=100 then isnull(HC_LC_ratio_int,0) 
     else case when isnull(HC_LC_ratio_int,0)=0 then 100-isnull(HC_LC_ratio_india,0)
	      else isnull(HC_LC_ratio_int,0) end end end as HC_LC_ratio_int,
 
 
case when Current_status_india is null and Current_status_int is null then 0
else case when (isnull(Current_status_india,0)+isnull(Current_status_int,0))=100 then isnull(Current_status_india,0) 
     else case when isnull(Current_status_india,0)=0 then 100-isnull(Current_status_int,0) 
	      else isnull(Current_status_india,0) end
 end end as Current_status_india,
 case when Current_status_int is null and Current_status_india is null then 0
 else case when (isnull(Current_status_india,0)+isnull(Current_status_int,0))=100 then isnull(Current_status_int,0) 
     else case when isnull(Current_status_int,0)=0 then 100-isnull(Current_status_india,0)
	      else isnull(Current_status_int,0) end end end as Current_status_int,
 
case when (desired_output_india+desired_output_int)=100 then desired_output_india 
     else case when desired_output_india=0 then 100-desired_output_int 
	      else desired_output_india end
 end as desired_output_india,
 case when (desired_output_india+desired_output_int)=100 then desired_output_int 
     else case when desired_output_int=0 then 100-desired_output_india
	      else desired_output_int end end as desired_output_int 
 from (
select [job family cluster], HC_LC_ratio_india, HC_LC_ratio_int, current_status_india,current_status_int,
isnull( desired_output_india, 0 ) desired_output_india,isnull( desired_output_int, 0 ) desired_output_int
from(
select * 
from (select [col_reg], col1 as [job family cluster], value 
from ( 
select *
from
(
  select [Job Family Cluster],col +  '_' + [Region] as col_reg, value
  from (select t1.[Job Family Cluster], [HC_LC_Ratio], [desired_output], [current_status], t1.[Region] from 
(select distinct [Job Family Cluster], [current_status], [Region] from (



----------------------------------------------------------------------------------------------------

select  X1.[Job Family Cluster],X2.[Job Family Cluster (Current JF)],X1.HC_LC_Ratio, X2.current_status ,X1.desired_output ,X1.BU,
case when X1.mail is null then X2.mail else X1.mail end mail,X1.OutlooktRegion,X2.Region from
(
select distinct tE.[Job Family Cluster],tE.OutlooktRegion,tE.mail as mail, HC_LC_Ratio,
--current_status,
D.desired_output ,V.[BU/SSU] as BU
from
(
SELECT tC.*
FROM (
               SELECT tA.*,(tA.Cost/nullif(tB.Denom_Cost,0)) * 100 as HC_LC_Ratio--, tA.Current_Cost*100/nullif(tB.Denom_Current_Cost,0) as current_status
                FROM (
                               SELECT  [Job Family Cluster],[mail],SUM([CTC $ - FY Exit]) AS Cost, 
							   case when [Final Country]='India' or [Final Country]='Sri Lanka' then 'India' else 'Int' end as OutlooktRegion,
							   [BU/SSU] as BU
                                FROM [dbo].[V_simulation_CY_GMC_1] 
                                GROUP BY [Job Family Cluster],case when [Final Country]='India' or [Final Country]='Sri Lanka' then 'India' else 'Int' end ,mail,[BU/SSU]
                               ) tA

                JOIN (
                                SELECT  [Job Family Cluster],[mail],SUM([CTC $ - FY Exit]) AS Denom_Cost, [BU/SSU] as BU                                                                                                                           
                                FROM [dbo].[V_simulation_CY_GMC_1]
                                GROUP BY [Job Family Cluster],[mail],[BU/SSU]
                                HAVING [Job Family Cluster] IS NOT NULL
                                ) tB ON tA.[Job Family Cluster] = tB.[Job Family Cluster] and tA.BU = tB.BU
                                AND tA.mail = tB.mail
                ) AS tC
) tE
join desiredOutputINReutersTable D
on D.JobFamily = tE.[Job Family Cluster] and tE.OutlooktRegion = D.Location and tE.BU = D.BU
join [V_simulation_CY_GMC_1] V
on V.[Job Family Cluster] = tE.[Job Family Cluster] and V.mail = tE.mail and V.Region = tE.OutlooktRegion and V.[BU/SSU] = tE.BU
  where V.mail=@mail and D.BU=@BU
 ) as X1
  full outer join
  -------------------------------------------------------current job cluster--------------------

( 
select distinct tE.[Job Family Cluster (Current JF)],tE.Region,tE.mail as mail,
current_status,D.desired_output ,V.[BU/SSU] as BU
from
(
SELECT tC.*
FROM (
                SELECT tA.*,tA.Current_Cost*100/nullif(tB.Denom_Current_Cost,0) as current_status
                FROM (
				             SELECT  [Job Family Cluster (Current JF)],[mail],
                                sum(case when [Report Type]='Headcount' then cast([Loaded Cost (USD)] as float)  else 0 end)  AS Current_Cost, 
								Region,[BU/SSU]
                                FROM [dbo].[V_simulation_CY_GMC_1] where [Report Type]='Headcount'
                                GROUP BY [Job Family Cluster (Current JF)],Region,[mail],[BU/SSU]
                                ) tA

                JOIN (

                                SELECT  [Job Family Cluster (Current JF)],[mail],
                                sum(case when [Report Type]='Headcount' then cast([Loaded Cost (USD)] as float)  else 0 end)  AS Denom_Current_Cost,
								[BU/SSU]
                                FROM [dbo].[V_simulation_CY_GMC_1] where [Report Type]='Headcount'
                                GROUP BY [Job Family Cluster (Current JF)],[mail],[BU/SSU]
                                HAVING [Job Family Cluster (Current JF)] IS NOT NULL
                                ) tB ON tA.[Job Family Cluster (Current JF)] = tB.[Job Family Cluster (Current JF)] and tA.[BU/SSU]=tB.[BU/SSU]
                                AND tA.mail = tB.mail
                ) AS tC
) tE
join desiredOutputINReutersTable D
on D.JobFamily = tE.[Job Family Cluster (Current JF)] and tE.Region = D.Location and tE.[BU/SSU] = D.BU
join [V_simulation_CY_GMC_1] V
on V.[Job Family Cluster (Current JF)] = tE.[Job Family Cluster (Current JF)] and V.mail = tE.mail and V.Region = tE.Region and V.[BU/SSU]=tE.[BU/SSU]
  where V.mail=@mail and D.BU=@BU
) as X2 on X1.OutlooktRegion=X2.Region and 
X1.BU=X2.BU and X1.[Job Family Cluster]=X2.[Job Family Cluster (Current JF)] and X1.BU = X2.BU
where X1.mail=X2.mail and X1.BU = X2.BU


------------------------------------------------------------------------------------------------------------------------------------------------

)as h )t1 join (
select distinct [Job Family Cluster], [HC_LC_Ratio], cast([desired_output] as float) as [desired_output], [OutlooktRegion] as [Region] from(



---------------------------------------------------------------------------------------------------------------------

select  X1.[Job Family Cluster],X2.[Job Family Cluster (Current JF)],X1.HC_LC_Ratio, X2.current_status ,X1.desired_output ,X1.BU,
case when X1.mail is null then X2.mail else X1.mail end mail,X1.OutlooktRegion,X2.Region from
(
select distinct tE.[Job Family Cluster],tE.OutlooktRegion,tE.mail as mail, HC_LC_Ratio,
--current_status,
D.desired_output ,V.[BU/SSU] as BU
from
(
SELECT tC.*
FROM (
               SELECT tA.*,(tA.Cost/nullif(tB.Denom_Cost,0)) * 100 as HC_LC_Ratio--, tA.Current_Cost*100/nullif(tB.Denom_Current_Cost,0) as current_status
                FROM (
                               SELECT  [Job Family Cluster],[mail],SUM([CTC $ - FY Exit]) AS Cost, 
							   case when [Final Country]='India' or [Final Country]='Sri Lanka' then 'India' else 'Int' end as OutlooktRegion,
							   [BU/SSU] as BU
                                FROM [dbo].[V_simulation_CY_GMC_1] 
                                GROUP BY [Job Family Cluster],case when [Final Country]='India' or [Final Country]='Sri Lanka' then 'India' else 'Int' end ,mail,[BU/SSU]
                               ) tA

                JOIN (
                                SELECT  [Job Family Cluster],[mail],SUM([CTC $ - FY Exit]) AS Denom_Cost, [BU/SSU] as BU                                                                                                                           
                                FROM [dbo].[V_simulation_CY_GMC_1]
                                GROUP BY [Job Family Cluster],[mail],[BU/SSU]
                                HAVING [Job Family Cluster] IS NOT NULL
                                ) tB ON tA.[Job Family Cluster] = tB.[Job Family Cluster] and tA.BU = tB.BU
                                AND tA.mail = tB.mail
                ) AS tC
) tE
join desiredOutputINReutersTable D
on D.JobFamily = tE.[Job Family Cluster] and tE.OutlooktRegion = D.Location and tE.BU = D.BU
join [V_simulation_CY_GMC_1] V
on V.[Job Family Cluster] = tE.[Job Family Cluster] and V.mail = tE.mail and V.Region = tE.OutlooktRegion and V.[BU/SSU] = tE.BU
  where V.mail=@mail and D.BU=@BU
 ) as X1
  full outer join
  -------------------------------------------------------current job cluster--------------------

( 
select distinct tE.[Job Family Cluster (Current JF)],tE.Region,tE.mail as mail,
current_status,D.desired_output ,V.[BU/SSU] as BU
from
(
SELECT tC.*
FROM (
                SELECT tA.*,tA.Current_Cost*100/nullif(tB.Denom_Current_Cost,0) as current_status
                FROM (
				             SELECT  [Job Family Cluster (Current JF)],[mail],
                                sum(case when [Report Type]='Headcount' then cast([Loaded Cost (USD)] as float)  else 0 end)  AS Current_Cost, 
								Region,[BU/SSU]
                                FROM [dbo].[V_simulation_CY_GMC_1] where [Report Type]='Headcount'
                                GROUP BY [Job Family Cluster (Current JF)],Region,[mail],[BU/SSU]
                                ) tA

                JOIN (

                                SELECT  [Job Family Cluster (Current JF)],[mail],
                                sum(case when [Report Type]='Headcount' then cast([Loaded Cost (USD)] as float)  else 0 end)  AS Denom_Current_Cost,
								[BU/SSU]
                                FROM [dbo].[V_simulation_CY_GMC_1] where [Report Type]='Headcount'
                                GROUP BY [Job Family Cluster (Current JF)],[mail],[BU/SSU]
                                HAVING [Job Family Cluster (Current JF)] IS NOT NULL
                                ) tB ON tA.[Job Family Cluster (Current JF)] = tB.[Job Family Cluster (Current JF)] and tA.[BU/SSU]=tB.[BU/SSU]
                                AND tA.mail = tB.mail
                ) AS tC
) tE
join desiredOutputINReutersTable D
on D.JobFamily = tE.[Job Family Cluster (Current JF)] and tE.Region = D.Location and tE.[BU/SSU] = D.BU
join [V_simulation_CY_GMC_1] V
on V.[Job Family Cluster (Current JF)] = tE.[Job Family Cluster (Current JF)] and V.mail = tE.mail and V.Region = tE.Region and V.[BU/SSU]=tE.[BU/SSU]
  where V.mail=@mail and D.BU=@BU
) as X2 on X1.OutlooktRegion=X2.Region and 
X1.BU=X2.BU and X1.[Job Family Cluster]=X2.[Job Family Cluster (Current JF)] and X1.BU = X2.BU
where X1.mail=X2.mail and X1.BU = X2.BU

----------------------------------------------------------------------




 )as f)t2
 on t1.[Job Family Cluster]= t2.[Job Family Cluster] and t1.[Region]=t2.[Region]) as x
   unpivot
  (
    value
    for col in ([HC_LC_Ratio], [current_status],[desired_output])
  ) unpiv
) src
pivot
(
  max(value)
  for [Job Family Cluster] in ("HR & Corp Services", "Engineering", "Others","BE","Finance","Legal","Marketing","Operations","Product Management","Sales","Sales Support","Strategy")
) piv)
b
unpivot 
(
value 
for col1 in ([HR & Corp Services],[Engineering],[Others],[BE],[Finance],[Legal],[Marketing],[Operations],[Product Management],[Sales],[Sales Support],[Strategy] ))unpiv1)src1
pivot
(max(value)
for [col_reg] in (HC_LC_Ratio_India, HC_LC_Ratio_Int, current_status_India, current_status_Int, desired_output_India, desired_output_Int))
piv
) as R
)as K

--=================================================================================================================================================================


ALTER PROCEDURE [dbo].[SP_GeoDistJF_GMC_post] @mail nvarchar(100),@BU nvarchar(200)
as

select [job family cluster]
,case when HC_LC_ratio_india is null and HC_LC_ratio_int is null then 0
else case when (isnull(HC_LC_ratio_india,0)+isnull(HC_LC_ratio_int,0))=100 then isnull(HC_LC_ratio_india,0) 
     else case when isnull(HC_LC_ratio_india,0)=0 then 100-isnull(HC_LC_ratio_int,0) 
	      else  isnull(HC_LC_ratio_india,0) end
 end end as HC_LC_ratio_india,
 case when HC_LC_ratio_int is null and HC_LC_ratio_india is null then 0
 else case when (isnull(HC_LC_ratio_india,0)+isnull(HC_LC_ratio_int,0))=100 then isnull(HC_LC_ratio_int,0) 
     else case when isnull(HC_LC_ratio_int,0)=0 then 100-isnull(HC_LC_ratio_india,0)
	      else isnull(HC_LC_ratio_int,0) end end end as HC_LC_ratio_int,
 
 
case when Current_status_india is null and Current_status_int is null then 0
else case when (isnull(Current_status_india,0)+isnull(Current_status_int,0))=100 then isnull(Current_status_india,0) 
     else case when isnull(Current_status_india,0)=0 then 100-isnull(Current_status_int,0) 
	      else isnull(Current_status_india,0) end
 end end as Current_status_india,
 case when Current_status_int is null and Current_status_india is null then 0
 else case when (isnull(Current_status_india,0)+isnull(Current_status_int,0))=100 then isnull(Current_status_int,0) 
     else case when isnull(Current_status_int,0)=0 then 100-isnull(Current_status_india,0)
	      else isnull(Current_status_int,0) end end end as Current_status_int,
 
case when (desired_output_india+desired_output_int)=100 then desired_output_india 
     else case when desired_output_india=0 then 100-desired_output_int 
	      else desired_output_india end
 end as desired_output_india,
 case when (desired_output_india+desired_output_int)=100 then desired_output_int 
     else case when desired_output_int=0 then 100-desired_output_india
	      else desired_output_int end end as desired_output_int 
 from (
select [job family cluster], HC_LC_ratio_india, HC_LC_ratio_int, current_status_india, current_status_int,
 isnull(desired_output_india,0) as desired_output_india , isnull(desired_output_int,0) desired_output_int
from(
select * 
from (select [col_reg], col1 as [job family cluster], value 
from ( 
select *
from
(
  select [Job Family Cluster],col +  '_' + [Region] as col_reg, value
  from (select t1.[Job Family Cluster], [HC_LC_Ratio], [desired_output], [current_status], t1.[Region] from 
(select distinct [Job Family Cluster], [current_status], [Region] from (



----------------------------------------------------------------------------------------------------

select  X1.[Job Family Cluster],X2.[Job Family Cluster (Current JF)],X1.HC_LC_Ratio, X2.current_status,X1.desired_output ,X1.BU,
case when X1.mail is null then X2.mail else X1.mail end mail,X1.OutlooktRegion,X2.Region from
(
select distinct tE.[Job Family Cluster],tE.OutlooktRegion,tE.mail as mail, HC_LC_Ratio,
--current_status,
D.desired_output ,V.[BU/SSU] as BU
from
(
SELECT tC.*
FROM (
               SELECT tA.*,(tA.Cost/nullif(tB.Denom_Cost,0)) * 100 as HC_LC_Ratio--, tA.Current_Cost*100/nullif(tB.Denom_Current_Cost,0) as current_status
                FROM (
                               SELECT  [Job Family Cluster],[mail],SUM( case when is_transfer = 1 then CAST([Cost] AS FLOAT)*11/12 
																		when is_surrender = 1 then CAST([Cost] AS FLOAT)
																		else [CTC $ - FY Exit] end)  AS Cost, 
							   case when transfer_to_region='India' or transfer_to_region='Sri Lanka' then 'India' else 'Int' end as OutlooktRegion,
							   [BU/SSU] as BU
                                FROM [dbo].V_inprocess_GMC_1 
                                GROUP BY [Job Family Cluster],case when transfer_to_region='India' or transfer_to_region='Sri Lanka' then 'India' else 'Int' end ,mail,[BU/SSU]
                               ) tA

                JOIN (
                                SELECT  [Job Family Cluster],[mail],SUM( case when is_transfer = 1 then CAST([Cost] AS FLOAT)*11/12  else [CTC $ - FY Exit] end)  AS Denom_Cost, [BU/SSU] as BU                                                                                                                           
                                FROM [dbo].V_inprocess_GMC_1
                                GROUP BY [Job Family Cluster],[mail],[BU/SSU]
                                HAVING [Job Family Cluster] IS NOT NULL
                                ) tB ON tA.[Job Family Cluster] = tB.[Job Family Cluster] and tA.BU = tB.BU
                                AND tA.mail = tB.mail
                ) AS tC
) tE
join desiredOutputINReutersTable D
on D.JobFamily = tE.[Job Family Cluster] and tE.OutlooktRegion = D.Location and tE.BU = D.BU
join V_inprocess_GMC_1 V
on V.[Job Family Cluster] = tE.[Job Family Cluster] and V.mail = tE.mail and V.Region = tE.OutlooktRegion and V.[BU/SSU] = tE.BU
 where V.mail=@mail and D.BU=@BU
 ) as X1
  full outer join
  -------------------------------------------------------current job cluster--------------------

( 
select distinct tE.[Job Family Cluster (Current JF)],tE.Region,tE.mail as mail,
current_status,D.desired_output ,V.[BU/SSU] as BU
from
(
SELECT tC.*
FROM (
                SELECT tA.*,tA.Current_Cost*100/nullif(tB.Denom_Current_Cost,0) as current_status
                FROM (
				             SELECT  [Job Family Cluster (Current JF)],[mail],
                                sum(case when [Report Type]='Headcount' then cast([Loaded Cost (USD)] as float)   end)  AS Current_Cost, 
								case when [Final Country]='India' or [Final Country]='Sri Lanka' then 'India' else 'Int' end as Region,[BU/SSU]
                                FROM [dbo].V_inprocess_GMC_1 --where [Report Type]='Headcount'
                                GROUP BY [Job Family Cluster (Current JF)],case when [Final Country]='India' or [Final Country]='Sri Lanka' then 'India' else 'Int' end ,[mail],[BU/SSU]
                                ) tA

                JOIN (

                                SELECT  [Job Family Cluster (Current JF)],[mail],
                                sum(case when [Report Type]='Headcount' then cast([Loaded Cost (USD)] as float) end)  AS Denom_Current_Cost,
								[BU/SSU]
                                FROM [dbo].V_inprocess_GMC_1 --where [Report Type]='Headcount'
                                GROUP BY [Job Family Cluster (Current JF)],[mail],[BU/SSU]
                                HAVING [Job Family Cluster (Current JF)] IS NOT NULL
                                ) tB ON tA.[Job Family Cluster (Current JF)] = tB.[Job Family Cluster (Current JF)] and tA.[BU/SSU]=tB.[BU/SSU]
                                AND tA.mail = tB.mail
                ) AS tC
) tE
join desiredOutputINReutersTable D
on D.JobFamily = tE.[Job Family Cluster (Current JF)] and tE.Region = D.Location and tE.[BU/SSU] = D.BU
join V_inprocess_GMC_1 V
on V.[Job Family Cluster (Current JF)] = tE.[Job Family Cluster (Current JF)] and V.mail = tE.mail and V.Region = tE.Region and V.[BU/SSU]=tE.[BU/SSU]
  --where V.mail='manil.kumar@tatacommunications.com' and D.BU='legal'
  where V.mail=@mail and D.BU=@BU
) as X2 on X1.OutlooktRegion=X2.Region and X1.BU=X2.BU and X1.[Job Family Cluster]=X2.[Job Family Cluster (Current JF)] and X1.BU = X2.BU
where X1.mail=X2.mail and X1.BU = X2.BU 
 


------------------------------------------------------------------------------------------------------------------------------------------------

)as h )t1 join (
select distinct [Job Family Cluster], [HC_LC_Ratio], cast([desired_output] as float) as [desired_output], [OutlooktRegion] as [Region] from(



---------------------------------------------------------------------------------------------------------------------


select  X1.[Job Family Cluster],X2.[Job Family Cluster (Current JF)],X1.HC_LC_Ratio, X2.current_status ,X1.desired_output ,X1.BU,
case when X1.mail is null then X2.mail else X1.mail end mail,X1.OutlooktRegion,X2.Region from
(
select distinct tE.[Job Family Cluster],tE.OutlooktRegion,tE.mail as mail, HC_LC_Ratio,
--current_status,
D.desired_output ,V.[BU/SSU] as BU
from
(
SELECT tC.*
FROM (
               SELECT tA.*,(tA.Cost/nullif(tB.Denom_Cost,0)) * 100 as HC_LC_Ratio--, tA.Current_Cost*100/nullif(tB.Denom_Current_Cost,0) as current_status
                FROM (
                               SELECT  [Job Family Cluster],[mail],SUM( case when is_transfer = 1 then CAST([Cost] AS FLOAT)*11/12 
																		when is_surrender = 1 then CAST([Cost] AS FLOAT)
																		else [CTC $ - FY Exit] end)  AS Cost, 
							   case when transfer_to_region='India' or transfer_to_region='Sri Lanka' then 'India' else 'Int' end as OutlooktRegion,
							   [BU/SSU] as BU
                                FROM [dbo].V_inprocess_GMC_1 
                                GROUP BY [Job Family Cluster],case when transfer_to_region='India' or transfer_to_region='Sri Lanka' then 'India' else 'Int' end ,mail,[BU/SSU]
                               ) tA

                JOIN (
                                SELECT  [Job Family Cluster],[mail],SUM( case when is_transfer = 1 then CAST([Cost] AS FLOAT)*11/12  else [CTC $ - FY Exit] end)  AS Denom_Cost, [BU/SSU] as BU                                                                                                                           
                                FROM [dbo].V_inprocess_GMC_1
                                GROUP BY [Job Family Cluster],[mail],[BU/SSU]
                                HAVING [Job Family Cluster] IS NOT NULL
                                ) tB ON tA.[Job Family Cluster] = tB.[Job Family Cluster] and tA.BU = tB.BU
                                AND tA.mail = tB.mail
                ) AS tC
) tE
join desiredOutputINReutersTable D
on D.JobFamily = tE.[Job Family Cluster] and tE.OutlooktRegion = D.Location and tE.BU = D.BU
join V_inprocess_GMC_1 V
on V.[Job Family Cluster] = tE.[Job Family Cluster] and V.mail = tE.mail and V.Region = tE.OutlooktRegion and V.[BU/SSU] = tE.BU
 where V.mail=@mail and D.BU=@BU) as X1
  full outer join
  -------------------------------------------------------current job cluster--------------------

( 
select distinct tE.[Job Family Cluster (Current JF)],tE.Region,tE.mail as mail,
current_status,D.desired_output ,V.[BU/SSU] as BU
from
(
SELECT tC.*
FROM (
                SELECT tA.*,tA.Current_Cost*100/nullif(tB.Denom_Current_Cost,0) as current_status
                FROM (
				             SELECT  [Job Family Cluster (Current JF)],[mail],
                                sum(case when [Report Type]='Headcount' then cast([Loaded Cost (USD)] as float)  end)  AS Current_Cost, 
								case when [Final Country]='India' or [Final Country]='Sri Lanka' then 'India' else 'Int' end as Region,[BU/SSU]
                                FROM [dbo].V_inprocess_GMC_1 --where [Report Type]='Headcount'
                                GROUP BY [Job Family Cluster (Current JF)],case when [Final Country]='India' or [Final Country]='Sri Lanka' then 'India' else 'Int' end ,[mail],[BU/SSU]
                                ) tA

                JOIN (

                                SELECT  [Job Family Cluster (Current JF)],[mail],
                                sum(case when [Report Type]='Headcount' then cast([Loaded Cost (USD)] as float)  end)  AS Denom_Current_Cost,
								[BU/SSU]
                                FROM [dbo].V_inprocess_GMC_1 --where [Report Type]='Headcount'
                                GROUP BY [Job Family Cluster (Current JF)],[mail],[BU/SSU]
                                HAVING [Job Family Cluster (Current JF)] IS NOT NULL
                                ) tB ON tA.[Job Family Cluster (Current JF)] = tB.[Job Family Cluster (Current JF)] and tA.[BU/SSU]=tB.[BU/SSU]
                                AND tA.mail = tB.mail
                ) AS tC --where mail='manil.kumar@tatacommunications.com' and [BU/SSU]='legal'
) tE
join desiredOutputINReutersTable D
on D.JobFamily = tE.[Job Family Cluster (Current JF)] and tE.Region = D.Location and tE.[BU/SSU] = D.BU
join V_inprocess_GMC_1 V
on V.[Job Family Cluster (Current JF)] = tE.[Job Family Cluster (Current JF)] and V.mail = tE.mail and V.Region = tE.Region and V.[BU/SSU]=tE.[BU/SSU]
-- where V.mail='manil.kumar@tatacommunications.com' and D.BU='legal' 
 where V.mail=@mail and D.BU=@BU

) as X2 on X1.OutlooktRegion=X2.Region and X1.BU=X2.BU and X1.[Job Family Cluster]=X2.[Job Family Cluster (Current JF)] and X1.BU = X2.BU
where X1.mail=X2.mail and X1.BU = X2.BU 


----------------------------------------------------------------------




 )as f)t2
 on t1.[Job Family Cluster]= t2.[Job Family Cluster] and t1.[Region]=t2.[Region]) as x
   unpivot
  (
    value
    for col in ([HC_LC_Ratio], [current_status],[desired_output])
  ) unpiv
) src
pivot
(
  max(value)
  for [Job Family Cluster] in ("HR & Corp Services", "Engineering", "Others","BE","Finance","Legal","Marketing","Operations","Product Management","Sales","Sales Support","Strategy")
) piv)
b
unpivot 
(
value 
for col1 in ([HR & Corp Services],[Engineering],[Others],[BE],[Finance],[Legal],[Marketing],[Operations],[Product Management],[Sales],[Sales Support],[Strategy] ))unpiv1)src1
pivot
(max(value)
for [col_reg] in (HC_LC_Ratio_India, HC_LC_Ratio_Int, current_status_India, current_status_Int, desired_output_India, desired_output_Int))
piv
) as R
) as K



exec [SP_GeoDistJF_GMC_post] @mail ='manil.kumar@tatacommunications.com' ,@BU='legal'