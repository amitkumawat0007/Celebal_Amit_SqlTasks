-------------------------------------------------------------------------------------------------------------------------------------------

CREATE TRIGGER surrender ON [AnaplanAutomateProcess].dbo.[inprocess_simulation_AOP_CY_BUHR] 
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
select @ReportType=i.[Report type] from [inprocess_simulation_AOP_CY_BUHR] i where [Anaplan ID]=@anaplanCode ;	

select @simulationTag=case when [Report Type]='Headcount' then 'Exit w/o Replacement' when transfer_to_subBand<>original_subBand then 'Reclassify Attributes'
 else 'Surrendered Position' end 
	from inserted i;


select @simulationEfectiveDate=case when [Report Type]='Headcount' then 
	cast(CONVERT(VARCHAR(10),(SELECT DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,(select getdate()))+1,0))),101)as date)
	 when @simulationTag='Reclassify Attributes' then cast(CONVERT(VARCHAR(10),(SELECT DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,(select getdate()))+1,0))),101)as date) else null end
	 from inserted i;


select @PostTagCountry=i.country   from maaping_city_region i join [inprocess_simulation_AOP_CY_BUHR] on transfer_to_city=i.[city cluster];
select i.Facility   from maaping_city_region i join [inprocess_simulation_AOP_CY_BUHR] on transfer_to_city=i.[city cluster];
select @PostTagSubBand=i.[transfer_to_subBand] from inserted i;
select @PostTagOTE=i.[CTC $ - FY Exit]   from  [inprocess_simulation_AOP_CY_BUHR] i where [Anaplan ID]=@anaplanCode;	

	insert into [inprocess_simulation_AOP_CY_BUHR_update] ([Anaplan Code],[Report Type],[Simulation Tag],[Simulation Effective Date],[Post Tag Country],
	[Post Tag Facility],[Post Tag Sub Band],[Post Tag OTE Override (Local Currency)]) 
	values(@anaplanCode,@ReportType,@simulationTag,@simulationEfectiveDate,@PostTagCountry,@PostTagFacility,@PostTagSubBand,@PostTagOTE);

	


----------------------------------------------------------------------------------------------------------------------------------------

	select top 10 * from [inprocess_simulation_AOP_CY_BUHR] ;
	select top 10 * from maaping_city_region
