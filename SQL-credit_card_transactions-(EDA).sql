--download credit card transactions dataset from below link :
--https://www.kaggle.com/datasets/thedevastator/analyzing-credit-card-spending-habits-in-india


select * from credit_card_transcations;

--1. write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends 

with cte1 as
(select city, sum(amount) as total_spend from credit_card_transcations
group by city)
,cte2 as
(select sum(amount) as total_amount from credit_card_transcations)
select top 5 cte1.*,round(total_spend/total_amount*100,2) as percentage_contribution from cte1, cte2 
order by total_spend desc;

--2. write a query to print highest spend month and amount spent in that month for each card type

with cte1 as
(select card_type, DATEPART(year,transaction_date) as yr, DATEPART(month,transaction_date) as mon, sum(amount) as total_spend
from credit_card_transcations
group by card_type, DATEPART(year,transaction_date), DATEPART(month,transaction_date))
select card_type, mon, total_spend from (select *, rank() over (partition by card_type order by total_spend desc) as rn from cte1) A
where rn=1;

--3- write a query to print the transaction details(all columns from the table) for each card type when
--it reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type)

with cte1 as
(select *, sum(amount) over (partition by card_type order by transaction_date,transaction_id) as total_spend 
from credit_card_transcations)
select * from (select *, rank() over (partition by card_type order by total_spend) as rn from cte1 where total_spend>= 1000000) A
where rn=1;

--4. write a query to find city which had lowest percentage spend for gold card type

with cte1 as
(select city,card_type, sum(amount) as total_spend, sum(case when card_type='Gold' then amount end) as Gold_amount 
from credit_card_transcations
group by city,card_type)
select top 1 city, sum(Gold_amount)/sum(total_spend)*100 as gold_card_ratio from cte1
group by city
having sum(Gold_amount) is not null
order by gold_card_ratio;

--5. write a query to print 3 columns:  city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)

with cte1 as
(select city, exp_type, sum(amount) as total_spend from credit_card_transcations
group by city, exp_type)
select city,max(case when rn_desc=1 then exp_type end) as highest_expense_type,
max(case when rn_asc=1 then exp_type end) as lowest_expense_type
from
(select *, rank() over (partition by city order by total_spend desc) as rn_desc,
rank() over (partition by city order by total_spend) as rn_asc from cte1) A
group by city;

--6. write a query to find percentage contribution of spends by females for each expense type

select exp_type,round(sum(case when gender='F' then amount else 0 end)/sum(amount)*100,2) as percentage_female_spend
from credit_card_transcations
group by exp_type;

--7. which card and expense type combination saw highest month over month growth in Jan-2014

with cte1 as
(select card_type, exp_type,
DATEPART(year,transaction_date) as yr, DATEPART(month,transaction_date) as mon, sum(amount) as total_spend
from credit_card_transcations
group by card_type, exp_type,DATEPART(year,transaction_date),DATEPART(month,transaction_date))
select top 1*, (total_spend-prev_mon_amount)/prev_mon_amount*100 as mom_growth from
(select *, lag(total_spend) over (partition by card_type, exp_type order by yr,mon) as prev_mon_amount 
from cte1) A
where yr=2014 and mon=1
order by mom_growth desc;

--8. during weekends which city has highest total spend to total no of transcations ratio

select top 1 city, sum(amount)/count(amount) as ratio from
credit_card_transcations
where DATEPART(weekday,transaction_date) in (1,7)
group by city
order by ratio desc;

--9. which city took least number of days to reach its 500th transaction after the first transaction in that city

with cte1 as
(select *,
ROW_NUMBER() over (partition by city order by transaction_date) as rn
from credit_card_transcations)
select top 1 city, datediff(day,min(transaction_date),max(transaction_date)) as date_difference from cte1
where rn=1 or rn=500
group by city
having count(1)=2
order by date_difference;

