WITH STG AS (
SELECT COUNTRY,
    POC_ID,
    DATE_TRUNC('DAY', CLICK_TIME) AS DAY,
    CHANNEL,
    AVG(SECONDS_DIFF) AS AVG_IN_APP_SECONDS_TO_CLICK
FROM {{ ref('background_time_to_click_events' )}}
GROUP BY COUNTRY,
    POC_ID,
    DAY,
    CHANNEL
)

SELECT COUNTRY,
    POC_ID,
    DAY,
    CHANNEL,
    AVG_IN_APP_SECONDS_TO_CLICK,
    CONCAT(COUNTRY, '-', POC_ID, '-', DAY) AS UID,
    CURRENT_TIMESTAMP AS LOADED_AT
FROM STG
WHERE CHANNEL = 'IN-APP'
