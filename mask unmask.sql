select * from [dbo].[Revenue Target];
select * from [dbo].[in$];
select * from [dbo].[List of GMC];


---Add DEFAULT() masking function on the Name column
ALTER Table [dbo].[List of GMC]
ALTER COLUMN EID ADD MASKED WITH (FUNCTION='DEFAULT()')



--Create user reader
CREATE USER reader WITHout LOGIN
--Grant select permission to the user: reader
GRANT SELECT ON [dbo].[List of GMC] TO reader


EXECUTE AS USER = 'reader'
SELECT * FROM [dbo].[List of GMC]
REVERT

--Grant Unmask permission to the user: reader
GRANT UNMASK TO reader

EXECUTE AS USER = 'reader'
SELECT * FROM [dbo].[List of GMC]
REVERT

--Remove Unmask permission from the user: reader
REVOKE UNMASK TO reader

