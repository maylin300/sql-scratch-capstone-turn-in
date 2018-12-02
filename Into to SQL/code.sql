{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf100
{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 /*\
Here's the first-touch query, in case you need it\
*/\
SELECT COUNT(DISTINCT utm_campaign) AS 'campaign'\
FROM page_visits;\
SELECT DISTINCT utm_source\
FROM page_visits;\
SELECT COUNT(DISTINCT utm_source) AS 'source'\
FROM page_visits;\
\
SELECT COUNT(DISTINCT utm_campaign) AS Campaign, COUNT(DISTINCT utm_source) AS Source\
FROM page_visits;\
\
SELECT DISTINCT utm_campaign, utm_source\
FROM page_visits;\
\
SELECT DISTINCT page_name\
FROM page_visits;\
\
WITH first_touch AS (\
    SELECT user_id,\
        MIN(timestamp) as first_touch_at\
    FROM page_visits\
    GROUP BY user_id),\
\
ft_attr AS (\
  SELECT ft.user_id,\
         ft.first_touch_at,\
    		 pv.utm_source,\
		     pv.utm_campaign\
FROM first_touch ft\
JOIN page_visits pv\
    ON ft.user_id = pv.user_id\
    AND ft.first_touch_at = pv.timestamp\
)\
SELECT ft_attr.utm_source AS 'source', ft_attr.utm_campaign AS 'campaign', COUNT(*) AS 'total first touch' , 100 * COUNT(*) / (SELECT COUNT(DISTINCT user_id) FROM page_visits) AS 'percent total users'\
FROM ft_attr\
GROUP BY 1, 2\
ORDER BY 3 DESC;\
\
\
\
--last touch\
WITH last_touch AS (\
    SELECT user_id,\
        MAX(timestamp) as last_touch_at\
    FROM page_visits\
    GROUP BY user_id),\
\
lt_attr AS (\
  SELECT lt.user_id,\
         lt.last_touch_at,\
         pv.utm_source,\
         pv.utm_campaign,\
         pv.page_name\
  FROM last_touch lt\
  JOIN page_visits pv\
    ON lt.user_id = pv.user_id\
    AND lt.last_touch_at = pv.timestamp\
)\
SELECT lt_attr.utm_source AS 'source',\
       lt_attr.utm_campaign AS 'campagin',\
       COUNT(*) AS 'total last touch',  ROUND(100 * COUNT(*) / 1979) AS 'percent total users'\
FROM lt_attr\
GROUP BY 1, 2\
ORDER BY 3 DESC;\
\
--Customers who made a purchase\
SELECT COUNT(DISTINCT user_id) AS 'customers who purchased'\
FROM page_visits\
WHERE page_name = '4 - purchase';\
\
SELECT COUNT(DISTINCT user_id) AS 'distinct customers'\
FROM page_visits;\
\
--How many last touches on the purchase page is each campaign responsible for?\
WITH last_touch AS (\
    SELECT user_id,\
        MAX(timestamp) as last_touch_at\
    FROM page_visits\
    WHERE page_name = '4 - purchase'\
    GROUP BY user_id),\
\
lt_attr AS (\
  SELECT lt.user_id,\
         lt.last_touch_at,\
         pv.utm_source,\
         pv.utm_campaign,\
         pv.page_name\
  FROM last_touch lt\
  JOIN page_visits pv\
    ON lt.user_id = pv.user_id\
    AND lt.last_touch_at = pv.timestamp\
)\
SELECT lt_attr.utm_source AS 'source',\
       lt_attr.utm_campaign AS 'campagin',\
       COUNT(*) AS 'total last touch'\
FROM lt_attr\
GROUP BY 1, 2\
ORDER BY 3 DESC;\
\
\
 \
}