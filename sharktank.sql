use [Shark Tank];
select  * from stdata

/* 1. How many entrepreneurs appeared on the show? */
select count(distinct brand_name) as total_entrepreneurs
from stdata

/*2. Which brand received the highest total funding?*/
select brand_name,sum(deal_amount) as total_funding
from stdata
group by brand_name
order by total_funding desc

/*3. How many deals were successful vs. unsuccessful? */
select sum(case when deal = 1 then 1 else 0 end) as successfull_deal,
sum(case when deal = 0 then 1 else 0 end) as unsuccessfull_deal
from stdata

/*4. How many pitchers had a higher deal valuation than their ask valuation? */
SELECT COUNT(*) AS pitchers_with_higher_deal_valuation
FROM stdata
WHERE deal_valuation > ask_valuation;

/*5. How many pitchers had multiple sharks invest in their idea, and what were their respective pitch numbers? */
with pitcher_multiple_sharks as (
select brand_name, total_sharks_invested as total_sharks_invested
from stdata
where total_sharks_invested>1
),
pitch_nums as (
select brand_name,pitch_number 
from stdata)

select p1.brand_name,p1.pitch_number,p2.total_sharks_invested
from pitch_nums as p1 join pitcher_multiple_sharks as p2
on p1.brand_name=p2.brand_name

/*6. Write a SQL query to find the total amount invested by each shark in all deals. */
Select Name,sum(deal_amount) as total_Amount_invested_by_Sharks from(
SELECT 'Ashneer' AS Name, deal_amount FROM stdata WHERE ashneer_deal = 1
    UNION ALL
    SELECT 'Anupam' AS Name, deal_amount FROM stdata WHERE anupam_deal = 1
    UNION ALL
    SELECT 'Aman' AS Name, deal_amount FROM stdata WHERE aman_deal = 1
    UNION ALL
    SELECT 'Namita' AS Name, deal_amount FROM stdata WHERE namita_deal = 1
    UNION ALL
    SELECT 'Vineeta' AS Name, deal_amount FROM stdata WHERE vineeta_deal = 1
    UNION ALL
    SELECT 'Peyush' AS Name, deal_amount FROM stdata WHERE peyush_deal = 1
    UNION ALL
    SELECT 'Ghazal' AS Name, deal_amount FROM stdata WHERE ghazal_deal = 1) as temp
group by Name
order by total_Amount_invested_by_Sharks desc

/*7. Provide the top 5 deals with the highest deal amounts made in Shark Tank. */
SELECT Top 5
  CONCAT(
    CASE WHEN ashneer_deal = 1 THEN 'Ashneer ' ELSE '' END,
    CASE WHEN anupam_deal = 1 THEN 'Anupam ' ELSE '' END,
    CASE WHEN aman_deal = 1 THEN 'Aman ' ELSE '' END,
    CASE WHEN namita_deal = 1 THEN 'Namita ' ELSE '' END,
    CASE WHEN vineeta_deal = 1 THEN 'Vineeta ' ELSE '' END,
    CASE WHEN peyush_deal = 1 THEN 'Peyush ' ELSE '' END,
    CASE WHEN ghazal_deal = 1 THEN 'Ghazal ' ELSE '' END
  ) AS sharks_present,brand_name,
  deal_amount
FROM stdata
ORDER BY deal_amount DESC

/*8. What is the average deal equity percentage of sharks and how many pitchers asked for an
equity percentage higher than the average equity percentage ? */

with avg_equity as (SELECT  pitch_number,ask_equity,AVG(deal_equity) AS avg_equity_of_shark
    FROM stdata
	group by pitch_number,ask_equity)
select count(pitch_number) as no_of_pitches
from avg_equity
where ask_equity>avg_equity_of_shark


/*9. Retrieve the brand names and the corresponding deal valuation for pitches where the deal valuation 
is at least three times the ask valuation.Include the brand names and deal valuation for pitches where
the deal valuation is less than the ask valuation. Sort the results in descending order of the deal valuation.*/

select brand_name,deal_valuation
from stdata
where deal_valuation>(3*ask_valuation)
union 
select brand_name, deal_valuation
FROM stdata
WHERE deal_valuation < ask_valuation
ORDER BY deal_valuation DESC

/*10. Retrieve the brand names and the corresponding ask valuation for pitches
  where the ask valuation is higher than the average ask valuation of pitches presented by Ashneer and resulted in a deal.*/

SELECT brand_name, ask_valuation
FROM stdata
WHERE deal=1 and  ask_valuation > (
    SELECT AVG(ask_valuation)
    FROM stdata
    WHERE ashneer_present = 1)

