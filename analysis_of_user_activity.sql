/*
 * The query combines account metrics (by creation/session date)
 * and email metrics (by sent date),
 * then calculates total sums and country rankings,
 * using UNION to avoid conflicts between different time axes (date).
 */


-- CTE 1: Collecting account data and its dimensions
WITH account_data AS(
    SELECT
        s.date,                    -- Session / account creation date (first time axis)
        sp.country,
        acc.send_interval,
        acc.is_verified,
        acc.is_unsubscribed,
        COUNT(*) AS account_cnt    -- Number of created accounts
    FROM `DA.account` acc
    JOIN `DA.account_session` acs ON acc.id = acs.account_id
    JOIN `DA.session` s ON acs.ga_session_id = s.ga_session_id
    JOIN `DA.session_params` sp ON s.ga_session_id = sp.ga_session_id
    -- Aggregation by 5 dimensions (date, country, interval, verification, unsubscribe)
    GROUP BY 1, 2, 3, 4, 5
),


-- CTE 2: Collecting email metrics
email_metrics AS(
    SELECT
        sp.country,
        -- Calculating actual sent date (second time axis)
        DATE_ADD(s.date, INTERVAL es.sent_date DAY) AS sent_date,
        acc.send_interval,
        acc.is_verified,
        acc.is_unsubscribed,
        COUNT(DISTINCT es.id_message) AS sent_msg,
        COUNT(DISTINCT eo.id_message) AS open_msg,
        COUNT(DISTINCT ev.id_message) AS visit_msg
    FROM `DA.email_sent` es
    LEFT JOIN `DA.email_open` eo ON es.id_message = eo.id_message
    LEFT JOIN `DA.email_visit` ev ON es.id_message = ev.id_message
    -- JOINs to get dimensions (country, creation date)
    JOIN `DA.account` acc ON es.id_account = acc.id
    JOIN `DA.account_session` acs ON acc.id = acs.account_id
    JOIN `DA.session` s ON acs.ga_session_id = s.ga_session_id
    JOIN `DA.session_params` sp ON s.ga_session_id = sp.ga_session_id
    -- Adjustments made to aggregation
    GROUP BY 1, 2, 3, 4, 5
),


-- CTE 3: Combining data (UNION ALL) to create a unified structure
-- This allows preserving data aggregated by different dates (creation date vs sent date),
-- and correctly summing them in the next step.
union_data AS(
    -- Part 1: Account data (fill email metrics with NULL/0)
    SELECT
        date,
        country,
        send_interval,
        is_verified,
        is_unsubscribed,
        account_cnt,       -- Account metric is populated
        0 AS sent_msg,
        0 AS open_msg,
        0 AS visit_msg
    FROM account_data


    UNION ALL
   
    -- Part 2: Email data (fill account metrics with NULL/0)
    SELECT
        sent_date AS date, -- Using sent date
        country,
        -- Replacing missing account details with zeros (for type compatibility)
        send_interval,
        is_verified,
        is_unsubscribed,
        0 AS account_cnt,
        sent_msg,          -- Email metrics are populated
        open_msg,
        visit_msg
    FROM email_metrics
),


-- CTE 4: Calculating total sums and country rankings
-- Here we aggregate union_data only by country. SUM ignores zeros,
-- correctly summing account_cnt from Part 1 and sent_msg from Part 2.
country_ranking AS (
    SELECT
        country,
        SUM(account_cnt) AS total_country_account_cnt, -- Total accounts per country
        SUM(sent_msg) AS total_country_sent_cnt        -- Total emails per country
    FROM union_data
    GROUP BY country
),


ranking AS(
    SELECT
        country,
        total_country_account_cnt,
        total_country_sent_cnt,
        -- Ranking countries by number of accounts (DENSE_RANK assigns same rank for equal values)
        DENSE_RANK() OVER (ORDER BY total_country_account_cnt DESC) AS rank_total_country_account_cnt,
        -- Ranking countries by number of sent emails
        DENSE_RANK() OVER (ORDER BY total_country_sent_cnt DESC) AS rank_total_country_sent_cnt
    FROM country_ranking
    GROUP BY country, total_country_account_cnt, total_country_sent_cnt
)

-- Final SELECT: Combining detailed data with aggregated rankings
SELECT
    date,
    ud.country,
    ud.send_interval,
    ud.is_verified,
    ud.is_unsubscribed,
    ud.account_cnt,
    ud.sent_msg,
    ud.open_msg,
    ud.visit_msg,
   
    -- Joining total metrics and rankings
    r.total_country_account_cnt,
    r.total_country_sent_cnt,
    r.rank_total_country_account_cnt,
    r.rank_total_country_sent_cnt
   
FROM union_data ud
JOIN ranking r ON ud.country = r.country

-- Filtering results to keep only Top-10 countries by any ranking
WHERE r.rank_total_country_account_cnt <= 10
   OR r.rank_total_country_sent_cnt <= 10

ORDER BY rank_total_country_account_cnt, rank_total_country_sent_cnt, country, date;
