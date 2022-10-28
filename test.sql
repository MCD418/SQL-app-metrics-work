Select count(distinct Country)
FROM newtestzone..details;

Select date
FROM newtestzone..VSFCC;

--test
with ae as (Select date,country,details.[iPhone Users],details.[iPad Users]
FROM newtestzone..details as details)

--add d? li?u name 1
drop view  if exists test
create view test as 
Select n2.date,n2.country,n2.[iPhone Users], concat(n1.country,'_','iPhone_Users') as name1
From newtestzone..details as n1
right join newtestzone..details as n2
on n1.date = n2.date and n1.country = n2.country
--

GO
DECLARE @cols AS NVARCHAR(MAX),
    @query  AS NVARCHAR(MAX);

select @cols = STUFF((SELECT distinct ',' + QUOTENAME(name1) 
                    from test
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

set @query = 'SELECT date, ' + @cols + ' 
            from 
            (
              select date,	name1, [iPhone Users]
              from test
            ) x
            pivot 
            (
                max([iPhone Users])
                for name1 in (' + @cols + ')
            ) p 
			order by date'

execute sp_executesql @query; 
