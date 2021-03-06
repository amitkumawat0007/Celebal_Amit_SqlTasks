USE [AnaplanMay2018]
GO
/****** Object:  Trigger [dbo].[surrender_BUHR]    Script Date: 14-06-2018 16:39:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER [dbo].[surrender_BUHR] ON [AnaplanMay2018].[dbo].[inprocess_simulation_AOP_CY_BUHR] 
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
		declare @mail nvarchar(500);



select @anaplanCode=i.[Anaplan Code] from inserted i where token_ID is  not null;
select @mail=i.[user_name] from [inprocess_simulation_AOP_CY_BUHR] i where [Anaplan code]=@anaplanCode
select @ReportType=i.[Report type] from [inprocess_simulation_AOP_CY_BUHR] i where [Anaplan Code]=@anaplanCode and token_ID is  not null;	

select @simulationTag=case 
when [Report Type]='Headcount' and is_surrender=1 then 'Exit w/o Replacement' 
when transfer_to_subBand<>original_subBand or transfer_to_city<>original_region then 'Reclassify Attributes' 
when [Report Type]<>'Headcount' and is_surrender=1 then 'Surrendered Position'
 --else 'Surrendered Position' 
 end
	from inserted i where token_ID is  not null;


select @simulationEfectiveDate=case 
when [Report Type]='Headcount' and is_surrender=1 then cast(CONVERT(VARCHAR(10),(SELECT DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,(select getdate()))+1,0))),101)as date)
when [Report Type]='Headcount' and (transfer_to_subBand<>original_subBand or transfer_to_city<>original_region) then cast(CONVERT(VARCHAR(10),(SELECT DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,(select getdate()))+1,0))),101)as date) 
when [Report Type]<>'Headcount' and (transfer_to_subBand<>original_subBand or transfer_to_city<>original_region) then cast(CONVERT(VARCHAR(10),(SELECT DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,(select getdate()))+1,0))+1),101)as date) 
when [Report Type]<>'Headcount' and is_surrender=1 then null
--else null 
end
from inserted i where token_ID is  not null;


select @PostTagCountry =case when is_surrender='1' then null
      when is_transfer='1' then i.country end  
	   from maaping_city_region i join [inprocess_simulation_AOP_CY_BUHR] on transfer_to_city=i.[city cluster] where [Anaplan Code]=@anaplanCode and token_ID is  not null;
select  @PostTagFacility =case when is_surrender='1' then null
      when is_transfer='1' then i.Facility end  
	   from maaping_city_region i join [inprocess_simulation_AOP_CY_BUHR] on transfer_to_city=i.[city cluster]  where [Anaplan Code]=@anaplanCode and token_ID is  not null;
select  @PostTagSubBand =case when is_surrender='1' then null
      when is_transfer='1' then i.[transfer_to_subBand] end 
	  from inserted i where [Anaplan Code]=@anaplanCode and token_ID is  not null;
select @PostTagOTE =case when is_surrender='1' then null
      when is_transfer='1' then i.Cost end 
     from  [inprocess_simulation_AOP_CY_BUHR] i where [Anaplan Code]=@anaplanCode and token_ID is  not null;	

delete from [inprocess_simulation_AOP_CY_BUHR_update] where [Anaplan Code]=@anaplanCode or [Anaplan Code] is not null


	insert into [inprocess_simulation_AOP_CY_BUHR_update] ([Anaplan Code],[Report Type],[Simulation Tag],[Simulation Effective Date],[Post Tag Country],
	[Post Tag Facility],[Post Tag Sub Band],[Post Tag OTE Override (Local Currency)],mail) 
	values(@anaplanCode,@ReportType,@simulationTag,@simulationEfectiveDate,@PostTagCountry,@PostTagFacility,@PostTagSubBand,@PostTagOTE,@mail);

	