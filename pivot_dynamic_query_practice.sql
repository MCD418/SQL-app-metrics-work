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




--- The code path

/*Declare Variable*/  
DECLARE @Pivot_Column [nvarchar](max);  
DECLARE @Query [nvarchar](max);  
  
/*Select Pivot Column*/  
SELECT @Pivot_Column= COALESCE(@Pivot_Column+',','')+ QUOTENAME(Year) FROM  
(SELECT DISTINCT [Year] FROM Employee)Tab  
  
/*Create Dynamic Query*/  
SELECT @Query='SELECT Name, '+@Pivot_Column+'FROM   
(SELECT Name, [Year] , Sales FROM Employee )Tab1  
PIVOT  
(  
SUM(Sales) FOR [Year] IN ('+@Pivot_Column+')) AS Tab2  
ORDER BY Tab2.Name'  
  
/*Execute Query*/  
EXEC  sp_executesql  @Query  

--2nd way
-- Import tablefunc
CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT * FROM CROSSTAB($$
  SELECT
    user_id,
    DATE_TRUNC('month', order_date) :: DATE AS delivr_month,
    SUM(meal_price * order_quantity) :: FLOAT AS revenue
  FROM meals
  JOIN orders ON meals.meal_id = orders.meal_id
 WHERE user_id IN (0, 1, 2, 3, 4)
   AND order_date < '2018-09-01'
 GROUP BY user_id, delivr_month
 ORDER BY user_id, delivr_month;
$$)
-- Select user ID and the months from June to August 2018
AS ct (user_id INT,
       "2018-06-01" FLOAT,
       "2018-07-01" FLOAT,
       "2018-08-01" FLOAT)
ORDER BY user_id ASC;


---THE END
