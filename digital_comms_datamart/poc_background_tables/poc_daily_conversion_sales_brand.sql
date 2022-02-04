WITH ALGO_CONV AS (
SELECT COUNTRY,
    POC_ID,
    DATE_TRUNC('DAY', IMPRESSION_TIME) AS DAY,
    CHANNEL,
    COUNT(DISTINCT SEND_ID) AS ALGO_CONVERSIONS
FROM {{ ref('background_sales_brand_conversions' )}}
GROUP BY COUNTRY,
    POC_ID,
    DAY,
    CHANNEL
)

SELECT COUNTRY,
    POC_ID,
    DAY,
    CHANNEL,
    ALGO_CONVERSIONS,
    CONCAT(COUNTRY, '-', POC_ID, '-', DAY, '-', CHANNEL) AS UID,
    CURRENT_TIMESTAMP AS LOADED_AT
FROM ALGO_CONV
