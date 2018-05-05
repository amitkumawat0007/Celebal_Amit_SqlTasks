CREATE TABLE [NofoDaysSavingCurrentMonth] (
    [Time] varchar(50),
    [B1  BU] varchar(50),
    [Position ID] varchar(50),
    [Current Period] varchar(50),
    [Anaplan Code] varchar(50),
    [BU] varchar(50),
    [BU Filter] varchar(50),
    [Anaplan ID] varchar(50),
    [Position ID_] varchar(50),
    [Budgeted Positions] varchar(50),
    [Report Type] varchar(50),
    [Position Start Date] varchar(50),
    [Position End Date] varchar(50),
    [Start-Date] varchar(50),
    [Final End Date] varchar(50),
    [T-Job Req ID Ag PID] varchar(50),
    [JR Start Date] varchar(50),
    [Simulation Tag] varchar(50),
    [Simulation Date] varchar(50),
    [Effective Start Date] varchar(50),
    [Cal Start Date] varchar(50),
    [No of Days Saved] varchar(50),
    [Cost Saved] varchar(50)
)
BULK INSERT [NofoDaysSavingCurrentMonth]
FROM 'F:\Database excel\New folder\NofoDaysSavingCurrentMonth.txt'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR= '\t',
ROWTERMINATOR = '\n'
)