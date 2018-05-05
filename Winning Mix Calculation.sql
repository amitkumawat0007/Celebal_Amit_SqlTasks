CREATE TABLE [Winning Mix Calculation] (
    [Time] varchar(50),
    [Vertical Subset Except Default] varchar(max),
    [Current Headcount] int,
    [New Hires in Current FY] int,
    [New Hires in Current FY (female)] int,
    [Current Offers] int,
    [Current Headcount (Females)] int,
    [Current Offers (Females)] int,
    [Current Winning Mix] float,
    [New Hire Winning Mix Outlook] float,
    [Target Winning Mix (New Hires)] varchar(50),
    [No  of Opportunities - Winning Mix] int,
    [Number of Females to be hired to meet Goal] int,
    [AOP Vacant Positions] int,
    [Winning Mix] varchar(50),
    [Sub Grp Vertical] varchar(50)
)



BULK INSERT [Winning Mix Calculation]
FROM 'F:\Database excel\New folder\Winning Mix Calculation.txt'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR= '\t',
ROWTERMINATOR = '\n'
)
select * from [Winning Mix Calculation];