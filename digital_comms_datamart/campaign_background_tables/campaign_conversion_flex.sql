SELECT COUNTRY,
    CAMPAIGN_ID,
    CHANNEL,
    'Flex' AS CONVERSION_TYPE,
    COUNT(DISTINCT POC_ID) AS POCS_CONVERTED,
    COUNT(DISTINCT USER_ID) AS USERS_CONVERTED,
    COUNT(DISTINCT SEND_ID) AS CONVERSIONS
FROM {{ ref('background_flex_conversions' )}}
GROUP BY COUNTRY,
    CAMPAIGN_ID,
    CHANNEL