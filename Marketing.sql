select
	*
from
	CustomerPurchases.purchases;
    
-- 1. Which loyalty status makes the most purchases?
SELECT 
    COUNT(purchase_amount) AS purchases, loyalty_status
FROM
    CustomerPurchases.purchases
GROUP BY loyalty_status
ORDER BY purchases DESC;
-- 2. What gender and age group spends the most money?
SELECT 
    gender,
    COUNT(purchase_amount) AS purchases,
    CASE
        WHEN age < 18 THEN 'under 18'
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-24'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        ELSE '45+'
    END AS age_group
FROM
    CustomerPurchases.purchases
GROUP BY gender , age_group
ORDER BY purchases DESC;

-- 3. What are top 3 categories with the highest average satisfaction?

SELECT 
    product_category, AVG(satisfaction_score) AS avg_score
FROM
    CustomerPurchases.purchases
GROUP BY product_category
ORDER BY avg_score DESC
LIMIT 3;

-- 4. What are the purchase percentages based on education level?

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
-- 5. What are the most popular categories based on region?

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
-- 6. Which income level makes the most purchases?
SELECT 
    CASE
        WHEN income < 10000 THEN 'less than 10K'
        WHEN income BETWEEN 10001 AND 20000 THEN '10-20K'
        WHEN income BETWEEN 20001 AND 30000 THEN '20-30K'
        WHEN income BETWEEN 30001 AND 40000 THEN '30-40K'
        WHEN income BETWEEN 40001 AND 50000 THEN '40-50K'
        WHEN income BETWEEN 50001 AND 50000 THEN '50-60K'
        ELSE 'over 60k'
    END AS income_level,
    COUNT(purchase_amount) AS purchases_made
FROM
    CustomerPurchases.purchases
GROUP BY income_level
ORDER BY purchases_made DESC
LIMIT 1;
-- 7. What is the promotion count by gender?
SELECT 
    gender, COUNT(promotion_usage) AS promotion_count
FROM
    CustomerPurchases.purchases
GROUP BY gender;

-- 8. Which what are the top purchase categories based on education level?

SELECT
    education,
    product_category,
    purchase_count
FROM (
    SELECT
        education,
        product_category,
        COUNT(purchase_amount) AS purchase_count,
        RANK() OVER (PARTITION BY education ORDER BY COUNT(purchase_amount) DESC) AS ranking
    FROM
        CustomerPurchases.purchases
    GROUP BY
        education, product_category
) AS ranked_categories
WHERE
    ranking = 1;

-- 9. What categories does each gender purchase more?
SELECT 
    gender,
    product_category,
    COUNT(purchase_amount) AS money_spent
FROM
    CustomerPurchases.purchases
GROUP BY gender , product_category
ORDER BY money_spent DESC
LIMIT 2;

-- 10. What is the average income per age group?
SELECT 
    AVG(income) AS avg_income,
    CASE
        WHEN age < 18 THEN 'under 18'
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        ELSE '45+'
    END AS age_group
FROM
    CustomerPurchases.purchases
GROUP BY age_group
ORDER BY age_group;

-- 11. What is the average income by education level?
SELECT 
    AVG(income) AS avg_income, education
FROM
    CustomerPurchases.purchases
GROUP BY education
ORDER BY education;
        
	