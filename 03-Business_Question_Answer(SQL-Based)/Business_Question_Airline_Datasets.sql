/*
 * Commercial & Revenue Questions:
 * How many total flights and passengers are there by 
 * customer gender across each province?
*/

SELECT 
cld.province,
cld.gender,
SUM(fd.total_flights) AS total_flights,
COUNT(DISTINCT fd.loyalty_number) AS total_customer
FROM flight_data fd 
LEFT JOIN customer_loyalty_data cld ON fd.loyalty_number = cld.loyalty_number
GROUP BY cld.province,
cld.gender
ORDER BY total_flights DESC;



/*
 * Which provinces generate the highest revenue per flight,
 * and how does this differ by customer loyalty card type?
 */

SELECT 
cld.province,
cld.loyalty_card,
SUM(fd.total_flights) AS total_flight,
COUNT(DISTINCT fd.loyalty_number) AS total_customer,
SUM(fd.total_flights)::NUMERIC / COUNT( DISTINCT fd.loyalty_number)::NUMERIC AS flight_per_customer
FROM flight_data fd
LEFT JOIN customer_loyalty_data cld ON fd.loyalty_number = cld.loyalty_number
GROUP BY cld.province,
cld.loyalty_card
ORDER BY flight_per_customer DESC;


/*
 * How does average ticket revenue vary by education level 
 * and marital status?
 */
SELECT 
cld.education,
cld.marital_status, 
AVG(fd.total_flights) AS average_revenue,
COUNT(DISTINCT fd.loyalty_number) AS total_customer
FROM flight_data fd
LEFT JOIN customer_loyalty_data cld ON fd.loyalty_number = cld.loyalty_number
GROUP BY cld.education,
cld.marital_status
ORDER BY average_revenue DESC;

/*
 * Which gender contribute to the most revenue?
 */

SELECT 
cld.gender,
SUM(fd.total_flights) AS total_flights,
COUNT(DISTINCT fd.loyalty_number) AS total_customer
FROM flight_data fd 
LEFT JOIN customer_loyalty_data cld ON fd.loyalty_number = cld.loyalty_number
GROUP BY 
cld.gender
ORDER BY total_flights DESC;

/*
 * Customer & Loyalty Intelligence

What is the distribution of active vs cancelled customers gender, and province?
 */

/* Accuracy Fix: Use the Customer table only to avoid losing 
   cancelled customers who no longer have flight records */
SELECT
    gender,
    province,
    COUNT(*) FILTER(WHERE customer_status = 'Active') AS active_count,
    COUNT(*) FILTER(WHERE customer_status = 'Cancelled') AS cancelled_count,
    ROUND(COUNT(*) FILTER(WHERE customer_status = 'Cancelled')::NUMERIC / COUNT(*), 2) as churn_rate
FROM customer_loyalty_data 
GROUP BY gender, province;

/*
 * Which customer segments (education, loyalty card) 
 * have the highest customer lifetime value (CLV)?
 */
WITH segment_totals AS (
    SELECT 
        education,
        loyalty_card,
        ROUND(SUM(clv)::NUMERIC, 2) AS total_clv
    FROM customer_loyalty_data
    GROUP BY 1, 2
)
SELECT *,
       RANK() OVER(PARTITION BY loyalty_card ORDER BY total_clv DESC) as rank_within_card
FROM segment_totals;


/*
 * Which customer segments should be prioritized 
 * for retention campaigns based on flight frequency, CLV, and cancellation trends?
 */
WITH customer_behavior AS (
    SELECT 
        cld.loyalty_number,
        cld.education,
        cld.loyalty_card,
        cld.clv,
        cld.customer_status,
        -- Calculate flight frequency from the flight table
        COUNT(fd.loyalty_number) AS total_flights_taken,
        -- Use NTILE to create 10 groups based on CLV (10 = Top 10%)
        NTILE(10) OVER(ORDER BY cld.clv DESC) AS clv_percentile
    FROM customer_loyalty_data cld
    LEFT JOIN flight_data fd ON cld.loyalty_number = fd.loyalty_number
    GROUP BY 1, 2, 3, 4, 5
),
segment_analysis AS (
    SELECT *,
        CASE 
            WHEN clv_percentile = 1 AND total_flights_taken < 5 AND customer_status = 'Active' THEN 'P1: VIP at Risk'
            WHEN clv_percentile = 1 AND customer_status = 'Cancelled' THEN 'P2: High-Value Churn'
            WHEN clv_percentile BETWEEN 2 AND 4 AND total_flights_taken < 3 THEN 'P3: Potential Growth'
            ELSE 'Standard'
        END AS retention_priority
    FROM customer_behavior
)
SELECT 
    retention_priority,
    education,
    loyalty_card,
    COUNT(*) AS customer_count,
    ROUND(AVG(clv)::NUMERIC, 2) AS avg_clv,
    ROUND(AVG(total_flights_taken)::NUMERIC, 1) AS avg_flights
FROM segment_analysis
WHERE retention_priority != 'Standard'
GROUP BY 1, 2, 3
ORDER BY retention_priority ASC, avg_clv DESC;