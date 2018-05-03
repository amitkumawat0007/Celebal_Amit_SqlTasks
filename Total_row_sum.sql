select * from [dbo].[Revenue Target];
select * from [dbo].[in$];
select * from [dbo].[List of GMC];
--to find sum of whole row for individual id and F2 id anaplan id.
--testing to sync changes in file with github.
SELECT
    F2 as ID

,   SUM(jan+feb+mar+apr+may+jun+jul+aug+sep+oct+nov+dec) as total_row_sum
FROM [dbo].[in$]
GROUP BY F2 WITH ROLLUP