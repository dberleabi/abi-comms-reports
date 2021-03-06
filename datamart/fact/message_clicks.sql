-- This data is uploaded incrementally
-- Data sources include:
-- Braze Events via Currents/Segment
-- Campaign Metadata via Braze Campaign Details API endpoint
-- Active users via WH.ANALYTICS
WITH 

    T_MAX_DATA AS (select to_date('2018-01-01') AS MAX_DATA),
  
REG_USERS AS (
SELECT DISTINCT
  CASE WHEN COUNTRY = 'Argentina' THEN 'AR'
     WHEN COUNTRY = 'Brazil' THEN 'BR'
     WHEN COUNTRY = 'Colombia' THEN 'CO'
     WHEN COUNTRY = 'Dominican Republic' THEN 'DO'
     WHEN COUNTRY = 'Ecuador' THEN 'EC'
     WHEN COUNTRY = 'Mexico' THEN 'MX'
     WHEN COUNTRY = 'Panama' THEN 'PA'
     WHEN COUNTRY = 'Peru' THEN 'PE'
     WHEN COUNTRY = 'Paraguay' THEN 'PY'
     WHEN COUNTRY = 'South Africa' THEN 'ZA'
     END COUNTRY, 
  USER_ID
FROM WH.ANALYTICS.T_GLOBAL_ACTIVE_USERS
WHERE COUNTRY IN ('Argentina', 'Brazil', 'Colombia', 'Ecuador',
                  'Mexico', 'Dominican Republic', 'Panama', 'Peru', 'Paraguay', 'South Africa')

),

-- Create a table with all Sends
-- Via Currents/Segment
BRAZE_CLICKS AS
(
SELECT 'AR' AS COUNTRY,'PUSH' AS CHANNEL, ID, COALESCE(CAMPAIGN_ID, CANVAS_ID) AS CAMPAIGN_ID,
COALESCE(CAMPAIGN_NAME, CANVAS_NAME) AS CAMPAIGN_NAME, USER_ID, SPLIT_PART(USER_ID, '_', 1) AS POC_ID, RECEIVED_AT
FROM SEGMENT_EVENTS.BRAZE_AR.PUSH_NOTIFICATION_TAPPED

UNION ALL
SELECT 'BR' AS COUNTRY,'PUSH' AS CHANNEL, ID, COALESCE(CAMPAIGN_ID, CANVAS_ID) AS CAMPAIGN_ID,
COALESCE(CAMPAIGN_NAME, CANVAS_NAME) AS CAMPAIGN_NAME, USER_ID, SPLIT_PART(USER_ID, '_', 1) AS POC_ID, RECEIVED_AT
FROM SEGMENT_EVENTS.BRAZE_BR.PUSH_NOTIFICATION_TAPPED

UNION ALL
SELECT 'CO' AS COUNTRY,'PUSH' AS CHANNEL, ID, COALESCE(CAMPAIGN_ID, CANVAS_ID) AS CAMPAIGN_ID,
COALESCE(CAMPAIGN_NAME, CANVAS_NAME) AS CAMPAIGN_NAME, USER_ID, 
LPAD(SPLIT_PART(USER_ID, '_', 1), 10, '0') AS POC_ID, RECEIVED_AT
FROM SEGMENT_EVENTS.BRAZE_CO.PUSH_NOTIFICATION_TAPPED

UNION ALL
SELECT 'DO' AS COUNTRY,'PUSH' AS CHANNEL, ID, COALESCE(CAMPAIGN_ID, CANVAS_ID) AS CAMPAIGN_ID,
COALESCE(CAMPAIGN_NAME, CANVAS_NAME) AS CAMPAIGN_NAME, USER_ID, SPLIT_PART(USER_ID, '_', 1) AS POC_ID, RECEIVED_AT
FROM SEGMENT_EVENTS.BRAZE.PUSH_NOTIFICATION_TAPPED

UNION ALL
SELECT 'EC' AS COUNTRY,'PUSH' AS CHANNEL, ID, COALESCE(CAMPAIGN_ID, CANVAS_ID) AS CAMPAIGN_ID,
COALESCE(CAMPAIGN_NAME, CANVAS_NAME) AS CAMPAIGN_NAME, USER_ID, SPLIT_PART(USER_ID, '_', 1) AS POC_ID, RECEIVED_AT
FROM SEGMENT_EVENTS.BRAZE_EC.PUSH_NOTIFICATION_TAPPED

UNION ALL
SELECT 'MX' AS COUNTRY,'PUSH' AS CHANNEL, ID, COALESCE(CAMPAIGN_ID, CANVAS_ID) AS CAMPAIGN_ID,
COALESCE(CAMPAIGN_NAME, CANVAS_NAME) AS CAMPAIGN_NAME, USER_ID, SPLIT_PART(USER_ID, '_', 1) AS POC_ID, RECEIVED_AT
FROM SEGMENT_EVENTS.BRAZE_MX.PUSH_NOTIFICATION_TAPPED

UNION ALL
SELECT 'PA' AS COUNTRY,'PUSH' AS CHANNEL, ID, CAMPAIGN_ID AS CAMPAIGN_ID,
CAMPAIGN_NAME AS CAMPAIGN_NAME, USER_ID, SPLIT_PART(USER_ID, '_', 1) AS POC_ID, RECEIVED_AT
FROM SEGMENT_EVENTS.BRAZE_PA.PUSH_NOTIFICATION_TAPPED

UNION ALL
SELECT 'PE' AS COUNTRY,'PUSH' AS CHANNEL, ID, COALESCE(CAMPAIGN_ID, CANVAS_ID) AS CAMPAIGN_ID,
COALESCE(CAMPAIGN_NAME, CANVAS_NAME) AS CAMPAIGN_NAME, USER_ID, SPLIT_PART(USER_ID, '_', 1) AS POC_ID, RECEIVED_AT
FROM SEGMENT_EVENTS.BRAZE_PE.PUSH_NOTIFICATION_TAPPED

UNION ALL
SELECT 'PY' AS COUNTRY,'PUSH' AS CHANNEL, ID, CAMPAIGN_ID AS CAMPAIGN_ID,
CAMPAIGN_NAME AS CAMPAIGN_NAME, USER_ID, SPLIT_PART(USER_ID, '_', 1) AS POC_ID, RECEIVED_AT
FROM SEGMENT_EVENTS.BRAZE_PY.PUSH_NOTIFICATION_TAPPED

UNION ALL
SELECT 'ZA' AS COUNTRY,'PUSH' AS CHANNEL, ID, CAMPAIGN_ID, CAMPAIGN_NAME, USER_ID, 
SPLIT_PART(USER_ID, '_', 1) AS POC_ID, RECEIVED_AT
FROM SEGMENT_EVENTS.BRAZE_ZA.PUSH_NOTIFICATION_TAPPED

UNION ALL
SELECT 'AR' AS COUNTRY,'IN-APP' AS CHANNEL, ID, COALESCE(CAMPAIGN_ID, CANVAS_ID) AS CAMPAIGN_ID,
COALESCE(CAMPAIGN_NAME, CANVAS_NAME) AS CAMPAIGN_NAME, USER_ID, SPLIT_PART(USER_ID, '_', 1) AS POC_ID, RECEIVED_AT
FROM SEGMENT_EVENTS.BRAZE_AR.IN_APP_MESSAGE_CLICKED

UNION ALL
SELECT 'BR' AS COUNTRY,'IN-APP' AS CHANNEL, ID, COALESCE(CAMPAIGN_ID, CANVAS_ID) AS CAMPAIGN_ID,
COALESCE(CAMPAIGN_NAME, CANVAS_NAME) AS CAMPAIGN_NAME, USER_ID, SPLIT_PART(USER_ID, '_', 1) AS POC_ID, RECEIVED_AT
FROM SEGMENT_EVENTS.BRAZE_BR.IN_APP_MESSAGE_CLICKED

UNION ALL
SELECT 'CO' AS COUNTRY,'IN-APP' AS CHANNEL, ID, CAMPAIGN_ID, CAMPAIGN_NAME, USER_ID, 
LPAD(SPLIT_PART(USER_ID, '_', 1), 10, '0') AS POC_ID, RECEIVED_AT
FROM SEGMENT_EVENTS.BRAZE_CO.IN_APP_MESSAGE_CLICKED

UNION ALL
SELECT 'DO' AS COUNTRY,'IN-APP' AS CHANNEL, ID, COALESCE(CAMPAIGN_ID, CANVAS_ID) AS CAMPAIGN_ID,
COALESCE(CAMPAIGN_NAME, CANVAS_NAME) AS CAMPAIGN_NAME, USER_ID, SPLIT_PART(USER_ID, '_', 1) AS POC_ID, RECEIVED_AT
FROM SEGMENT_EVENTS.BRAZE.IN_APP_MESSAGE_CLICKED

UNION ALL
SELECT 'EC' AS COUNTRY,'IN-APP' AS CHANNEL, ID, COALESCE(CAMPAIGN_ID, CANVAS_ID) AS CAMPAIGN_ID,
COALESCE(CAMPAIGN_NAME, CANVAS_NAME) AS CAMPAIGN_NAME, USER_ID, SPLIT_PART(USER_ID, '_', 1) AS POC_ID, RECEIVED_AT
FROM SEGMENT_EVENTS.BRAZE_EC.IN_APP_MESSAGE_CLICKED

UNION ALL
SELECT 'MX' AS COUNTRY,'IN-APP' AS CHANNEL, ID, COALESCE(CAMPAIGN_ID, CANVAS_ID) AS CAMPAIGN_ID,
COALESCE(CAMPAIGN_NAME, CANVAS_NAME) AS CAMPAIGN_NAME, USER_ID, SPLIT_PART(USER_ID, '_', 1) AS POC_ID, RECEIVED_AT
FROM SEGMENT_EVENTS.BRAZE_MX.IN_APP_MESSAGE_CLICKED

UNION ALL
SELECT 'PA' AS COUNTRY,'IN-APP' AS CHANNEL, ID, CAMPAIGN_ID AS CAMPAIGN_ID,
CAMPAIGN_NAME AS CAMPAIGN_NAME, USER_ID, SPLIT_PART(USER_ID, '_', 1) AS POC_ID, RECEIVED_AT
FROM SEGMENT_EVENTS.BRAZE_PA.IN_APP_MESSAGE_CLICKED

UNION ALL
SELECT 'PE' AS COUNTRY,'IN-APP' AS CHANNEL, ID, COALESCE(CAMPAIGN_ID, CANVAS_ID) AS CAMPAIGN_ID,
COALESCE(CAMPAIGN_NAME, CANVAS_NAME) AS CAMPAIGN_NAME, USER_ID, SPLIT_PART(USER_ID, '_', 1) AS POC_ID, RECEIVED_AT
FROM SEGMENT_EVENTS.BRAZE_PE.IN_APP_MESSAGE_CLICKED

UNION ALL
SELECT 'PY' AS COUNTRY,'IN-APP' AS CHANNEL, ID, CAMPAIGN_ID AS CAMPAIGN_ID,
CAMPAIGN_NAME AS CAMPAIGN_NAME, USER_ID, SPLIT_PART(USER_ID, '_', 1) AS POC_ID, RECEIVED_AT
FROM SEGMENT_EVENTS.BRAZE_PY.IN_APP_MESSAGE_CLICKED

UNION ALL
SELECT 'ZA' AS COUNTRY,'IN-APP' AS CHANNEL, ID, CAMPAIGN_ID, CAMPAIGN_NAME, USER_ID, 
SPLIT_PART(USER_ID, '_', 1) AS POC_ID, RECEIVED_AT
FROM SEGMENT_EVENTS.BRAZE_ZA.IN_APP_MESSAGE_CLICKED
)

SELECT clicks.COUNTRY,
      CHANNEL,
      clicks.CAMPAIGN_ID,
      ID AS MESSAGE_ID,
      campaign_types.NAME AS CAMPAIGN_NAME,
      CAMPAIGN_TYPE,
      CAMPAIGN_SUBTYPE,
      clicks.USER_ID,
      POC_ID,
      RECEIVED_AT
FROM BRAZE_CLICKS clicks
-- Campaign metadata from campaign layer via Braze API
LEFT JOIN WH.datamarts_digital_comms.dim_global_campaign_types campaign_types
    ON clicks.CAMPAIGN_ID = campaign_types.CAMPAIGN_ID
    AND clicks.COUNTRY = campaign_types.COUNTRY
INNER JOIN REG_USERS -- Filter out bad USER_IDs by JOINing to REG_USERS cte
  ON clicks.USER_ID = REG_USERS.USER_ID
  AND clicks.COUNTRY = REG_USERS.COUNTRY
