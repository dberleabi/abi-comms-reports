WITH CAMPAIGN_DETAILS AS (
SELECT T.* 
  --SK.PRODUCT
FROM WH.DATAMARTS_DIGITAL_COMMS.DIM_GLOBAL_CAMPAIGN_TYPES T
--JOIN WH.DATAMARTS_DIGITAL_COMMS.DIM_CAMPAIGN_SKUS SK ON SK.CAMPAIGN_ID = T.CAMPAIGN_ID
WHERE COUNTRY = 'BR' 
  AND CAMPAIGN_TYPE = 'Sales'
  AND BRAND != ''
)

-- Registered Users
,REG_USERS AS (
SELECT DISTINCT COUNTRY,  
  USER_ID 
FROM WH.DATAMARTS_DIGITAL_COMMS.DIM_REG_USERS_W_POCS
)

,SENDS AS (
SELECT DISTINCT S.COUNTRY,
    S.CHANNEL,
    S.CAMPAIGN_ID,
    S.CAMPAIGN_NAME,
    D.CAMPAIGN_TYPE,
    S.MESSAGE_ID,
    D.BRAND,
    S.USER_ID,
    S.POC_ID,
    S.RECEIVED_AT AS IMPRESSION_TIME
FROM WH.DATAMARTS_DIGITAL_COMMS.FACT_GLOBAL_MESSAGE_SENDS S
JOIN CAMPAIGN_DETAILS D
    ON S.COUNTRY = D.COUNTRY
    AND S.CAMPAIGN_ID = D.CAMPAIGN_ID
JOIN REG_USERS R
    ON S.COUNTRY = R.COUNTRY
    AND S.USER_ID = R.USER_ID
),

CLICKS AS (
SELECT C.COUNTRY,
    C.CHANNEL,
    C.CAMPAIGN_ID,
    C.CAMPAIGN_NAME,
    D.CAMPAIGN_TYPE,
    C.MESSAGE_ID AS CLICK_ID,
    D.BRAND,
    C.USER_ID,
    C.POC_ID,
    C.RECEIVED_AT AS CLICK_TIME
FROM WH.DATAMARTS_DIGITAL_COMMS.FACT_GLOBAL_MESSAGE_CLICKS C
JOIN CAMPAIGN_DETAILS D
    ON C.COUNTRY = D.COUNTRY
    AND C.CAMPAIGN_ID = D.CAMPAIGN_ID
JOIN REG_USERS R
    ON C.COUNTRY = R.COUNTRY
    AND C.USER_ID = R.USER_ID
),

CLICKS_JOINED AS (
SELECT DISTINCT A.COUNTRY,
    A.POC_ID,
    A.USER_ID,
    A.CAMPAIGN_ID,
    A.CAMPAIGN_NAME,
    A.CAMPAIGN_TYPE,
    --PRODUCT, -- Use the product from the campaign so that we are getting all the message sends for every SKU/Brand
    MESSAGE_ID,
    A.BRAND,
    A.CHANNEL,
    IMPRESSION_TIME,
    DATEDIFF(second, IMPRESSION_TIME, CLICK_TIME)/60 AS MIN_DIFF_CLICK,
    CLICK_TIME, 
    CLICK_ID,
    ROW_NUMBER() OVER (PARTITION BY A.COUNTRY, A.USER_ID, MESSAGE_ID, A.BRAND ORDER BY MIN_DIFF_CLICK) AS CLICK_RANK
FROM SENDS A
LEFT JOIN CLICKS B
    ON A.COUNTRY = B.COUNTRY
    AND A.USER_ID = B.USER_ID
    AND A.CAMPAIGN_ID = B.CAMPAIGN_ID

)

,PRODUCT_ADDED AS (
SELECT COUNTRY,
    PRODUCT_ADDED_ID,
    POC_ID,
    USER_ID, 
    LOWER(BRAND) AS L_BRAND,
    PRODUCT_SKU,
    RECEIVED_AT AS ADDED_AT 
FROM WH.DATAMARTS_DIGITAL_COMMS.FACT_GLOBAL_PRODUCT_ADDED
WHERE QUANTITY_ADDED > 0
    AND QUANTITY_ADDED IS NOT NULL
    AND L_BRAND IN (SELECT BRAND FROM CAMPAIGN_DETAILS)
)

,PRODUCT_ADDED_48H AS (
SELECT DISTINCT A.COUNTRY,
    A.USER_ID,
    A.POC_ID,
    CAMPAIGN_ID,
    CAMPAIGN_NAME,
    CAMPAIGN_TYPE,
    A.BRAND,
    CHANNEL,
    --A.PRODUCT,
    --A.PRODUCT_SKU,
    MESSAGE_ID,
    CLICK_ID,
    --PRODUCT_LIST_VIEWED_ID,
    IMPRESSION_TIME,
    CLICK_TIME,
    MIN_DIFF_CLICK,
    --VIEWED_AT,
    --MIN_DIFF_VIEW,
    DATEDIFF(second, IMPRESSION_TIME, ADDED_AT)/60 AS MIN_DIFF_ADDED,
    CASE WHEN MIN_DIFF_ADDED BETWEEN 0 AND 2880 THEN ADDED_AT ELSE NULL END AS ADDED_AT,
    CASE WHEN MIN_DIFF_ADDED BETWEEN 0 AND 2880 THEN PRODUCT_ADDED_ID ELSE NULL END AS PRODUCT_ADDED_ID,
    CASE WHEN MIN_DIFF_ADDED BETWEEN 0 AND 2880 THEN A.USER_ID ELSE NULL END AS PRODUCT_USER,
    ROW_NUMBER() OVER (PARTITION BY A.COUNTRY, A.USER_ID, MESSAGE_ID ORDER BY MIN_DIFF_ADDED) AS ADD_RANK
FROM CLICKS_JOINED A
LEFT JOIN PRODUCT_ADDED B
    ON A.COUNTRY = B.COUNTRY
    AND A.POC_ID = B.POC_ID
    AND A.USER_ID = B.USER_ID
    AND A.BRAND = B.L_BRAND
    --AND A.PRODUCT_SKU = B.PRODUCT_SKU
--WHERE MIN_DIFF_ADDED BETWEEN 0 AND 2880
)
--SELECT COUNT(DISTINCT MESSAGE_ID) FROM PRODUCT_ADDED_48H --14.28S, 270,638 RESULTS
,

ORDER_COMPLETED AS (
SELECT COUNTRY,
    ORDER_ITEM_ID,
    ORDER_ID,
    POC_ID,
    RECEIVED_AT AS ORDERED_AT,
    LOWER(PRODUCT_BRAND) AS BRAND,
    PRODUCT_QUANTITY,
    PRODUCT_REVENUE,
    PRODUCT_SKU,
    PRODUCT_NAME,
    PRODUCT_RECOMMENDATION_TYPE
FROM WH.DATAMARTS_DIGITAL_COMMS.FACT_GLOBAL_ORDER_ITEMS
),

-- SELECT only the columns needed, reduces duplicates
CLEAN_ORDER_COMPLETED_5D AS (
SELECT DISTINCT A.COUNTRY,
    A.POC_ID,
    A.USER_ID,
    CAMPAIGN_ID,
    CAMPAIGN_NAME,
    CAMPAIGN_TYPE,
    A.BRAND,
    CHANNEL,
    --A.PRODUCT,
    --A.PRODUCT_SKU,
    MESSAGE_ID,
    CLICK_ID,
    --PRODUCT_LIST_VIEWED_ID,
    PRODUCT_ADDED_ID,
    IMPRESSION_TIME,
    CLICK_TIME,
    --VIEWED_AT,
    ADDED_AT,
    --MIN_DIFF_VIEW,
    MIN_DIFF_CLICK,
    MIN_DIFF_ADDED,
    DATEDIFF(second, ADDED_AT, ORDERED_AT)/60 AS MIN_DIFF_ORDER,
    CASE WHEN MIN_DIFF_ORDER BETWEEN 0 AND 7200 THEN ORDERED_AT ELSE NULL END AS ORDERED_AT,
    CASE WHEN MIN_DIFF_ORDER BETWEEN 0 AND 7200 THEN ORDER_ID ELSE NULL END AS ORDER_ID,
    CASE WHEN MIN_DIFF_ORDER BETWEEN 0 AND 7200 THEN PRODUCT_QUANTITY ELSE NULL END AS PRODUCT_QUANTITY,
    CASE WHEN MIN_DIFF_ORDER BETWEEN 0 AND 7200 THEN PRODUCT_REVENUE ELSE NULL END AS PRODUCT_REVENUE,
    CASE WHEN MIN_DIFF_ORDER BETWEEN 0 AND 2880 THEN A.POC_ID ELSE NULL END AS ORDER_POC,
  PRODUCT_USER
FROM PRODUCT_ADDED_48H A
LEFT JOIN ORDER_COMPLETED B
    ON A.COUNTRY = B.COUNTRY
    AND A.POC_ID = B.POC_ID
    --AND A.PRODUCT_SKU = B.PRODUCT_SKU
    AND A.BRAND = B.BRAND
) 

SELECT DISTINCT COUNTRY,
    POC_ID,
    USER_ID,
    PRODUCT_USER,
    ORDER_POC,
    CAMPAIGN_ID,
    CAMPAIGN_NAME,
    CAMPAIGN_TYPE,
    BRAND,
    CHANNEL, 
    MESSAGE_ID,
    CLICK_ID,
    PRODUCT_ADDED_ID,
    ORDER_ID,
    PRODUCT_QUANTITY,
    PRODUCT_REVENUE,
    IMPRESSION_TIME,
    CLICK_TIME,
    ADDED_AT,
    ORDERED_AT
FROM CLEAN_ORDER_COMPLETED_5D