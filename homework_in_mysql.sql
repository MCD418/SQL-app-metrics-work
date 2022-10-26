SELECT * FROM newschema.metric;

#--Cau 1 Top 3 ngay Impression cao nhat--
Select rank() OVER(ORDER BY impression DESC) as rank_num,
		date, impression
From newschema.metric
order by Impression desc
limit 3;

#Cau 2: chi tieu tot nhat cao nhat
Select max(impression) as top_1_impression_per_day
from newschema.metric;

#Cau 3: tang net cua Impressions
with impression_changes as 
	(SELECT impression,
			date,
			LAG(impression) OVER() as pre_imp
	FROM newschema.metric)
    
Select date, impression - pre_imp as net_increase_per_day
From impression_changes;

#--Thang nao/ ngay nao co chi tieu tot nhat--
SELECT extract(MONTH FROM date) as best_month, sum(impression) as best_performance
from newschema.metric
group by extract(MONTH FROM date)
order by best_performance DESC
LIMIT 1;

#--ngay nao chi tieu tot nhat
SELECT extract(DAY FROM date) as Day_of_month, 
		sum(impression) as best_performance
from newschema.metric
group by extract(DAY FROM date)
order by best_performance DESC
LIMIT 1;

