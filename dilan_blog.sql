--group first reads by country, source, topic
SELECT country, source, topic, COUNT(user_id) 
FROM dilan_first_read
GROUP BY country, source, topic
ORDER BY COUNT(user_id) DESC;

--group first reads by country
SELECT country, COUNT(user_id) 
FROM dilan_first_read
GROUP BY country
ORDER BY COUNT(user_id) DESC;

--group first reads by source, topic
SELECT source, topic, COUNT(user_id) 
FROM dilan_first_read
GROUP BY source, topic
ORDER BY COUNT(user_id) DESC;

--group first reads by source
SELECT source, COUNT(user_id) 
FROM dilan_first_read
GROUP BY source
ORDER BY COUNT(user_id) DESC;

--group first reads by topic
SELECT topic, COUNT(user_id) 
FROM dilan_first_read
GROUP BY topic
ORDER BY COUNT(user_id) DESC;

--group returning reads by country, topic
SELECT country, topic, COUNT(user_id) 
FROM dilan_returning_read
GROUP BY country, topic
ORDER BY COUNT(user_id) DESC;

--group returning reads by country
SELECT country, COUNT(user_id) 
FROM dilan_returning_read
GROUP BY country
ORDER BY COUNT(user_id) DESC;

--group returning reads by topic
SELECT topic, COUNT(user_id) 
FROM dilan_returning_read
GROUP BY topic
ORDER BY COUNT(user_id) DESC;

--number of reads / users
SELECT user_id, COUNT(*)
FROM
(SELECT date_time, event_type, country, user_id, topic
FROM dilan_first_read
UNION
SELECT *
FROM dilan_returning_read) AS subquery
GROUP BY user_id
ORDER BY COUNT(*) DESC;

--number of reads by country, topic
SELECT country, topic, COUNT(*)
FROM
(SELECT date_time, event_type, country, user_id, topic
FROM dilan_first_read
UNION
SELECT *
FROM dilan_returning_read) AS subquery
GROUP BY country, topic
ORDER BY COUNT(*) DESC;

--e-book or video course: number of purchases and revenue
SELECT price AS type_of_purchase, COUNT(*) AS num_of_purchases, SUM(price) AS sum_of_purchases 
FROM dilan_buy 
GROUP BY price;

--e-book or video course: number of purchases and revenue by country, source, topic
SELECT country, source, topic, COUNT(*), SUM(price)
FROM dilan_first_read
JOIN dilan_buy
ON dilan_first_read.user_id = dilan_buy.user_id
GROUP BY country, source, topic
ORDER BY COUNT(*) DESC;

--e-book or video course: number of purchases and revenue by source, topic
SELECT source, topic, COUNT(*), SUM(price)
FROM dilan_first_read
JOIN dilan_buy
ON dilan_first_read.user_id = dilan_buy.user_id
GROUP BY source, topic
ORDER BY COUNT(*) DESC;

--e-book or video course: number of purchases and revenue by source
SELECT source, COUNT(*), SUM(price)
FROM dilan_first_read
JOIN dilan_buy
ON dilan_first_read.user_id = dilan_buy.user_id
GROUP BY source
ORDER BY COUNT(*) DESC;

--select all read (first+returning)
SELECT date_time, event_type, country, user_id, topic
FROM dilan_first_read
UNION
SELECT *
FROM dilan_returning_read;

--number of subscribes by country, source
SELECT country, source, COUNT(*)
FROM dilan_first_read
JOIN dilan_subscribe
ON dilan_first_read.user_id = dilan_subscribe.user_id
GROUP BY country, source
ORDER BY COUNT(*) DESC;

--number of subscribes by source
SELECT source, COUNT(*)
FROM dilan_first_read
JOIN dilan_subscribe
ON dilan_first_read.user_id = dilan_subscribe.user_id
GROUP BY source
ORDER BY COUNT(*) DESC;

--funnel
SELECT *
FROM
(SELECT COUNT(*)
FROM dilan_first_read
UNION
SELECT COUNT(*)
FROM
(SELECT user_id, COUNT(*)
FROM dilan_returning_read
GROUP BY user_id) AS subquery
UNION
SELECT COUNT(*)
FROM dilan_subscribe
UNION
SELECT COUNT(*)
FROM
(SELECT user_id, COUNT(*)
FROM dilan_buy
GROUP BY user_id) AS subquery) as funnel
ORDER BY count DESC;

--creating file for cohort by countries
SELECT date_time, country, user_id
FROM dilan_first_read
UNION
SELECT date_time, country, user_id
FROM dilan_returning_read;