select
	*
from
	CustomerPurchases.purchases;
    
-- 1. Which loyalty status makes the most purchases? done
select
	count(purchase_amount) as purchases,
    loyalty_status
from
	CustomerPurchases.purchases
group by loyalty_status
order by purchases desc;
-- 2. What gender and age group spends the most money? done
select
	gender,
    count(purchase_amount) as purchases,
	case
		when age < 18 then 'under 18'
        when age between 18 and 24 then '18-24'
        when age between 25 and 34 then '25-24'
        when age between 35 and 44 then '35-44'
        else '45+'
	end as age_group
	from
		CustomerPurchases.purchases
	group by gender, age_group
    order by purchases desc;

-- 3. What are top 3 categories with the highest average satisfaction? done

select
	product_category,
    avg(satisfaction_score) as avg_score
from
	CustomerPurchases.purchases
group by product_category
order by avg_score desc limit 3;

-- 4. What are the purchase percentages based on education level? not done
WITH sales_percentage AS (
    SELECT
        education,
        SUM(purchase_amount) AS purchase_total
    FROM
        CustomerPurchases.purchases
    GROUP BY education
), total_sales AS (
    SELECT
        SUM(purchase_amount) AS total_purchase_amount
    FROM
        CustomerPurchases.purchases
)
SELECT
    sales_percentage.education,
    sales_percentage.purchase_total,
    (sales_percentage.purchase_total / total_sales.total_purchase_amount) * 100 AS purchase_percentage
FROM
    sales_percentage
JOIN total_sales ON 1 = 1;
-- 5. What are the most popular categories based on region? DONE

SELECT
    region,
    product_category,
    purchase_count
FROM (
    SELECT
        region,
        product_category,
        COUNT(purchase_amount) AS purchase_count,
        RANK() OVER (PARTITION BY region ORDER BY COUNT(purchase_amount) DESC) AS ranking
    FROM
        CustomerPurchases.purchases
    GROUP BY
        region, product_category
) AS ranked_categories
WHERE
    ranking = 1;
-- 6. Which income level makes the most purchases? done
select
    case
		when income < 10000 then 'less than 10K'
        when income between 10001 and 20000 then '10-20K'
        when income between 20001 and 30000 then '20-30K'
        when income between 30001 and 40000 then '30-40K'
        when income between 40001 and 50000 then '40-50K'
        when income between 50001 and 50000 then '50-60K'
        else 'over 60k'
        end as income_level,
	count(purchase_amount) as purchases_made
from        
	CustomerPurchases.purchases
group by income_level
order by purchases_made desc limit 1;
-- 7. What is the promotion count by gender? done
select
	gender,
    count(promotion_usage) as promotion_count
from
	CustomerPurchases.purchases
group by gender;

-- 8. Which what are the top purchase categories based on education level? not DONE

WITH sales_percentage AS (
    SELECT
        education,
        SUM(purchase_amount) AS purchase_total
    FROM
        CustomerPurchases.purchases
    GROUP BY education
), total_sales AS (
    SELECT
        SUM(purchase_amount) AS total_purchase_amount
    FROM
        CustomerPurchases.purchases
)
SELECT
    sales_percentage.education,
    sales_percentage.purchase_total,
    (sales_percentage.purchase_total / total_sales.total_purchase_amount) * 100 AS purchase_percentage
FROM
    sales_percentage
JOIN total_sales ON 1 = 1;

-- 9. What categories does each gender purchase more? done
select
	gender,
    product_category,
    count(purchase_amount) as money_spent
from
	CustomerPurchases.purchases
group by gender, product_category
order by money_spent desc
limit 2;

-- 10. What is the average income per age group? done
select
	avg(income) as avg_income,
    case
		when age < 18 then 'under 18'
        when age between 18 and 24 then '18-24'
        when age between 25 and 34 then '25-34'
        when age between 35 and 44 then '35-44'
        else '45+'
        end as age_group
from
	CustomerPurchases.purchases
group by age_group
order by age_group;

-- 11. What is the average income by education level? done
select
	avg(income) as avg_income,
    education
from
	CustomerPurchases.purchases
group by education
order by education;
        
	