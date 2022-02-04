--Not created yet

SELECT COUNTRY,
    CAMPAIGN_ID,
    CHANNEL,
    DATE_TRUNC('DAY', IMPRESSION_TIME) AS DAY_MESSAGE_SENT,
    'Sales - Brand' AS CONVERSION_TYPE,
    'Order Completed - 7 Days' AS CONVERSION_LOGIC,
    COUNT(DISTINCT POC_ID) AS POCS_CONVERTED,
    COUNT(DISTINCT USER_ID) AS USERS_CONVERTED,
    COUNT(DISTINCT SEND_ID) AS CONVERSIONS,
    COUNT(DISTINCT ORDER_ID) AS DISTINCT_ORDERS
FROM {{ ref('background_sales_brand_conversions' )}}
GROUP BY COUNTRY,
    CAMPAIGN_ID,
    CHANNEL,
    DAY_MESSAGE_SENT

UNION ALL
SELECT COUNTRY,
    CAMPAIGN_ID,
    CHANNEL,
    DATE_TRUNC('DAY', IMPRESSION_TIME) AS DAY_MESSAGE_SENT,
    'Sales - Brand' AS CONVERSION_TYPE,
    'Order Completed - 2 Days' AS CONVERSION_LOGIC,
    COUNT(DISTINCT POC_ID) AS POCS_CONVERTED,
    COUNT(DISTINCT USER_ID) AS USERS_CONVERTED,
    COUNT(DISTINCT SEND_ID) AS CONVERSIONS,
    COUNT(DISTINCT ORDER_ID) AS DISTINCT_ORDERS
FROM {{ ref('background_sales_brand_conversions_oc_2d' )}}
GROUP BY COUNTRY,
    CAMPAIGN_ID,
    CHANNEL,
    DAY_MESSAGE_SENT

UNION ALL
SELECT COUNTRY,
    CAMPAIGN_ID,
    CHANNEL,
    DATE_TRUNC('DAY', IMPRESSION_TIME) AS DAY_MESSAGE_SENT,
    'Sales - Brand' AS CONVERSION_TYPE,
    'Order Completed - 1 Day' AS CONVERSION_LOGIC,
    COUNT(DISTINCT POC_ID) AS POCS_CONVERTED,
    COUNT(DISTINCT USER_ID) AS USERS_CONVERTED,
    COUNT(DISTINCT SEND_ID) AS CONVERSIONS,
    COUNT(DISTINCT ORDER_ID) AS DISTINCT_ORDERS
FROM {{ ref('background_sales_brand_conversions_oc_1d' )}}
GROUP BY COUNTRY,
    CAMPAIGN_ID,
    CHANNEL,
    DAY_MESSAGE_SENT

UNION ALL
SELECT COUNTRY,
    CAMPAIGN_ID,
    CHANNEL,
    DATE_TRUNC('DAY', IMPRESSION_TIME) AS DAY_MESSAGE_SENT,
    'Sales - background_sales_sku_conversions_oc_2d' AS CONVERSION_TYPE,
    'Order Completed - 30 Minutes' AS CONVERSION_LOGIC,
    COUNT(DISTINCT POC_ID) AS POCS_CONVERTED,
    COUNT(DISTINCT USER_ID) AS USERS_CONVERTED,
    COUNT(DISTINCT SEND_ID) AS CONVERSIONS,
    COUNT(DISTINCT ORDER_ID) AS DISTINCT_ORDERS
FROM {{ ref('background_sales_brand_conversions_oc_30m' )}}
GROUP BY COUNTRY,
    CAMPAIGN_ID,
    CHANNEL,
    DAY_MESSAGE_SENT