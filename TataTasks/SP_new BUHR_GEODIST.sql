Alter PROCEDURE [dbo].[SP_GeoDistJF_BUHR] @mail nvarchar(100),@BU nvarchar(200)
as


select [job family cluster],isnull( HC_LC_ratio_india, 0 )as HC_LC_ratio_india,isnull( HC_LC_ratio_int, 0 ) HC_LC_ratio_int,isnull( current_status_india, 0 ) current_status_india,isnull( current_status_int, 0 ) current_status_int,
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

select  X1.[Job Family Cluster],X2.[Job Family Cluster (Current JF)],X1.HC_LC_Ratio,case when X2.current_status is null then 0 else X2.current_status end as current_status,X1.desired_output ,X1.BU,
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

select  X1.[Job Family Cluster],X2.[Job Family Cluster (Current JF)],X1.HC_LC_Ratio,case when X2.current_status is null then 0 else X2.current_status end as current_status,X1.desired_output ,X1.BU,
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
) as R;


