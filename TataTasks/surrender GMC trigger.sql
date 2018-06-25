-------------------------------------------------------------------------------------------------------------------------------------------

CREATE TRIGGER surrender_GMC ON AnaplanMay2018.dbo.[inprocess_simulation_AOP_CY_GMC] 
FOR UPDATE
AS
	declare @anaplanCode nvarchar(500);
	declare @simulationTag nvarchar(500);
	declare @simulationEfectiveDate date;
	declare @PostTagCountry nvarchar(500);
	declare @PostTagFacility nvarchar(500);
	declare @PostTagSubBand nvarchar(500);
	declare @PostTagOTE nvarchar(500);
	declare @ReportType nvarchar(500);





select @anaplanCode=i.[Anaplan ID] from inserted i;
select @ReportType=i.[Report type] from [inprocess_simulation_AOP_CY_GMC] i where [Anaplan ID]=@anaplanCode ;	

select @simulationTag=case when [Report Type]='Headcount' then 'Exit w/o Replacement' when transfer_to_subBand<>original_subBand then 'Reclassify Attributes'
 else 'Surrendered Position' end 
	from inserted i;


select @simulationEfectiveDate=case when [Report Type]='Headcount' then 
	cast(CONVERT(VARCHAR(10),(SELECT DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,(select getdate()))+1,0))),101)as date)
	 when @simulationTag='Reclassify Attributes' then cast(CONVERT(VARCHAR(10),(SELECT DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,(select getdate()))+1,0))),101)as date) else null end
	 from inserted i;


select @PostTagCountry= i.country   from maaping_city_region i join [inprocess_simulation_AOP_CY_GMC] on transfer_to_city=i.[city cluster] and [Anaplan ID]=@anaplanCode;
select @PostTagFacility=i.Facility   from maaping_city_region i join [inprocess_simulation_AOP_CY_GMC] on transfer_to_city=i.[city cluster]  and [Anaplan ID]=@anaplanCode;
select @PostTagSubBand=i.[transfer_to_subBand] from inserted i;
select @PostTagOTE=i.[CTC $ - FY Exit]   from  [inprocess_simulation_AOP_CY_GMC] i where [Anaplan ID]=@anaplanCode;	

delete from [inprocess_simulation_AOP_CY_GMC_update] where [Anaplan Code]=@anaplanCode


	insert into [inprocess_simulation_AOP_CY_GMC_update] ([Anaplan Code],[Report Type],[Simulation Tag],[Simulation Effective Date],[Post Tag Country],
	[Post Tag Facility],[Post Tag Sub Band],[Post Tag OTE Override (Local Currency)]) 
	values(@anaplanCode,@ReportType,@simulationTag,@simulationEfectiveDate,@PostTagCountry,@PostTagFacility,@PostTagSubBand,@PostTagOTE);

	-----------------------------------------------------------------------------------------------------------------------------------------------

	update [AnaplanMay2018].[dbo].[inprocess_simulation_AOP_CY_GMC] SET 
[user_name] = 'manil.kumar@tatacommunications.com', 
[is_surrender] = '1' 
WHERE [AID] = '6012537-P912099-477078' and [BU SSU] = 'Business Collaboration , Mobility & IoT Solutions'

select * from [inprocess_simulation_AOP_CY_GMC_update];

