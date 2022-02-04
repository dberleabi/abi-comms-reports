SELECT COUNTRY,
    CAMPAIGN_ID,
    CHANNEL,
    'Sales' AS CONVERSION_TYPE,
    COUNT(DISTINCT POC_ID) AS POCS_CONVERTED,
    COUNT(DISTINCT USER_ID) AS USERS_CONVERTED,
    COUNT(DISTINCT SEND_ID) AS CONVERSIONS,
    COUNT(DISTINCT ORDER_ID) AS DISTINCT_ORDERS
FROM {{ ref('background_sales_conversions' )}}
GROUP BY COUNTRY,
    CAMPAIGN_ID,
    CHANNEL