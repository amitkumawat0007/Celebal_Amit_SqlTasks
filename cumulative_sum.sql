
select * from [dbo].[in$];

--cumulative sum of April 

select t1.F2, t1.Apr, SUM(t2.Apr) as sum
from [dbo].[in$] t1
inner join [dbo].[in$] t2 on t1.F2 >= t2.F2
group by t1.F2, t1.Apr
order by t1.F2