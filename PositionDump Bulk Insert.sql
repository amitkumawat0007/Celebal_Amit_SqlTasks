DROP table PositionsDump;

CREATE TABLE PositionsDump
(
        [Anaplan ID] NVARCHAR(500),
        [Position ID] NVARCHAR(500),
        [Parent Position Position ID] NVARCHAR(500),
        [Cost Center] NVARCHAR(500),
        [BU/SSU (Label)] NVARCHAR(500),
        [LOB / Segment] NVARCHAR(500),
        [Vertical (Label)] NVARCHAR(500),
        [Sub Vertical (Label)] NVARCHAR(500),
        [Entity] NVARCHAR(500),
        [Job Family] NVARCHAR(500),
        [Bonus Plan Name] NVARCHAR(500),
        [Variable Pay Plan Type] NVARCHAR(500),
        [Currency (code)] NVARCHAR(500),
        [Budgeted Allowance] NVARCHAR(500),
        [Budgeted Base] float,
        [Budgeted Benefits] float,
        [Budgeted OTE] NVARCHAR(500),
        [Budgeted Retirals] float,
        [Budgeted Variable] float,
        [Budgeted Loaded Cost] NVARCHAR(500),
        [Country] NVARCHAR(500),
        [Employee Sub Band] NVARCHAR(500),
        [jobLevel (Picklist Label)] NVARCHAR(500),
        [Designation] NVARCHAR(500),
        [Career Path] NVARCHAR(500),
        [Internal Specialisation] NVARCHAR(500),
        [Effective Date] NVARCHAR(500),
        [Employee Class (Picklist Label)] NVARCHAR(500),
        [Employee Type (Picklist Label)] NVARCHAR(500),
        [Geozone (Name)] NVARCHAR(500),
        [jobCode (Job Code)] NVARCHAR(500),
        [Is Growth Business?] NVARCHAR(500),
        [Position Start Date] NVARCHAR(500),
        [Position End Date] NVARCHAR(500),
        [AOP Budgeted Position?] NVARCHAR(500),
        [Prorated Budget (USD)] float,
        [AOP Budgeted Country (Picklist Label)] NVARCHAR(500),
        [positionTitle] NVARCHAR(500),
        [effectiveStatus] NVARCHAR(500),
        [FTE] float,
        [BU/SSU (BU / SSU)] NVARCHAR(500),
        [LOB/Segment (LOB / Segment )] NVARCHAR(500),
        [Vertical (Vertical Code)] NVARCHAR(500),
        [Sub Vertical (Sub Vertical)] NVARCHAR(500),
        [Legal Entity (Entity)] NVARCHAR(500),
        [TA Lead] NVARCHAR(500),
        [TA Lead (First Name)] NVARCHAR(500),
        [TA Lead (Last Name)] NVARCHAR(500),
        [BU HR (Position ID)] NVARCHAR(500),
        [mdfSystemRecordStatus] NVARCHAR(500),
        [Name] NVARCHAR(500)
)


Bulk insert PositionsDump
from 'F:\11\positionDump.txt' with
(
   fieldterminator='\t',
   rowterminator='\n',
   firstrow=2
)


select * from PositionsDump;
