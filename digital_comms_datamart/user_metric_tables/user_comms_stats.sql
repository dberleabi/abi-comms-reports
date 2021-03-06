WITH USERS_PUSH AS (
SELECT COUNTRY,
    USER_ID,
    PUSH_FLAG
FROM {{ ref('dim_user_push_enroll' )}}
),

USERS_SENDS AS (
SELECT S.COUNTRY,
  USER_ID,
  SUM(CASE WHEN CHANNEL = 'PUSH' THEN 1 ELSE 0 END) AS PUSH_IMPRESSIONS,
  SUM(CASE WHEN CHANNEL = 'IN-APP' THEN 1 ELSE 0 END) AS IN_APP_IMPRESSIONS,
  COUNT(ID) AS TOTAL_IMPRESSIONS,
  --Sales
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Sales' AND CHANNEL = 'IN-APP' THEN 1 ELSE 0 END) AS IN_APP_SALES_IMPRESSIONS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Sales' AND CHANNEL = 'PUSH' THEN 1 ELSE 0 END) AS PUSH_SALES_IMPRESSIONS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Sales' THEN 1 ELSE 0 END) AS SALES_IMPRESSIONS,
  --Algo
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Algo' AND CHANNEL = 'IN-APP' THEN 1 ELSE 0 END) AS IN_APP_ALGO_IMPRESSIONS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Algo' AND CHANNEL = 'PUSH' THEN 1 ELSE 0 END) AS PUSH_ALGO_IMPRESSIONS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Algo' THEN 1 ELSE 0 END) AS ALGO_IMPRESSIONS,
  --Rewards
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Rewards' AND CHANNEL = 'IN-APP' AND CAMPAIGN_SUBTYPE = 'Photo Challenge' THEN 1 ELSE 0 END) AS IN_APP_REWARDS_PHOTO_IMPRESSIONS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Rewards' AND CHANNEL = 'PUSH' AND CAMPAIGN_SUBTYPE = 'Photo Challenge' THEN 1 ELSE 0 END) AS PUSH_REWARDS_PHOTO_IMPRESSIONS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Rewards' AND CAMPAIGN_SUBTYPE = 'Photo Challenge' THEN 1 ELSE 0 END) AS REWARDS_PHOTO_IMPRESSIONS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Rewards' AND CHANNEL = 'IN-APP' AND CAMPAIGN_SUBTYPE = 'Purchase Challenge' THEN 1 ELSE 0 END) AS IN_APP_REWARDS_PURCHASE_IMPRESSIONS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Rewards' AND CHANNEL = 'PUSH' AND CAMPAIGN_SUBTYPE = 'Purchase Challenge' THEN 1 ELSE 0 END) AS PUSH_REWARDS_PURCHASE_IMPRESSIONS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Rewards' AND CAMPAIGN_SUBTYPE = 'Purchase Challenge' THEN 1 ELSE 0 END) AS REWARDS_PURCHASE_IMPRESSIONS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Rewards' AND CHANNEL = 'IN-APP' AND CAMPAIGN_SUBTYPE = 'Redemption' THEN 1 ELSE 0 END) AS IN_APP_REWARDS_REDEMPTION_IMPRESSIONS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Rewards' AND CHANNEL = 'PUSH' AND CAMPAIGN_SUBTYPE = 'Redemption' THEN 1 ELSE 0 END) AS PUSH_REWARDS_REDEMPTION_IMPRESSIONS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Rewards' AND CAMPAIGN_SUBTYPE = 'Redemption' THEN 1 ELSE 0 END) AS REWARDS_REDEMPTION_IMPRESSIONS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Rewards' AND CHANNEL = 'IN-APP' THEN 1 ELSE 0 END) AS IN_APP_REWARDS_IMPRESSIONS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Rewards' AND CHANNEL = 'PUSH' THEN 1 ELSE 0 END) AS PUSH_REWARDS_IMPRESSIONS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Rewards' THEN 1 ELSE 0 END) AS REWARDS_IMPRESSIONS,
  --Marketplace
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Marketplace' AND CHANNEL = 'IN-APP' THEN 1 ELSE 0 END) AS IN_APP_MARKETPLACE_IMPRESSIONS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Marketplace' AND CHANNEL = 'PUSH' THEN 1 ELSE 0 END) AS PUSH_MARKETPLACE_IMPRESSIONS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Marketplace' THEN 1 ELSE 0 END) AS MARKETPLACE_IMPRESSIONS,
  --Satisfaction
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Satisfaction' AND CHANNEL = 'IN-APP' THEN 1 ELSE 0 END) AS IN_APP_SATISFACTION_IMPRESSIONS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Satisfaction' AND CHANNEL = 'PUSH' THEN 1 ELSE 0 END) AS PUSH_SATISFACTION_IMPRESSIONS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Satisfaction' THEN 1 ELSE 0 END) AS SATISFACTION_IMPRESSIONS,
  --Survey
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Survey' AND CHANNEL = 'IN-APP' THEN 1 ELSE 0 END) AS IN_APP_SURVEY_IMPRESSIONS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Survey' AND CHANNEL = 'PUSH' THEN 1 ELSE 0 END) AS PUSH_SURVEY_IMPRESSIONS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Survey' THEN 1 ELSE 0 END) AS SURVEY_IMPRESSIONS,
  --Logistics
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Logistics' AND CAMPAIGN_SUBTYPE != 'Order Visibility' AND CHANNEL = 'IN-APP' THEN 1 ELSE 0 END) AS IN_APP_LOGISTICS_IMPRESSIONS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Logistics' AND CAMPAIGN_SUBTYPE != 'Order Visibility' AND CHANNEL = 'PUSH' THEN 1 ELSE 0 END) AS PUSH_LOGISTICS_IMPRESSIONS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Logistics' AND CAMPAIGN_SUBTYPE != 'Order Visibility' THEN 1 ELSE 0 END) AS LOGISTICS_IMPRESSIONS,
  --Order Viz
  SUM(CASE WHEN CAMPAIGN_SUBTYPE = 'Order Visibility' THEN 1 ELSE 0 END) AS ORDER_VIS_IMPRESSIONS,
  SUM(CASE WHEN CAMPAIGN_SUBTYPE = 'Order Visibility' AND CHANNEL = 'IN-APP' THEN 1 ELSE 0 END) AS IN_APP_ORDER_VIS_IMPRESSIONS,
  SUM(CASE WHEN CAMPAIGN_SUBTYPE = 'Order Visibility' AND CHANNEL = 'PUSH' THEN 1 ELSE 0 END) AS PUSH_ORDER_VIS_IMPRESSIONS
FROM {{ ref('tracks_global_messages' )}} S
LEFT JOIN {{ ref('global_campaign_metadata' )}} M
    ON S.COUNTRY = M.COUNTRY
    AND S.CAMPAIGN_ID = M.CAMPAIGN_ID
WHERE EVENT IN ('in_app_message_viewed', 'push_notification_sent')
GROUP BY S.COUNTRY, USER_ID
),

USERS_CLICKS AS (
SELECT C.COUNTRY,
  USER_ID,
  SUM(CASE WHEN CHANNEL = 'PUSH' THEN 1 ELSE 0 END) AS PUSH_CLICKS,
  SUM(CASE WHEN CHANNEL = 'IN-APP' THEN 1 ELSE 0 END) AS IN_APP_CLICKS,
  COUNT(ID) AS TOTAL_CLICKS,
  --Sales
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Sales' AND CHANNEL = 'IN-APP' THEN 1 ELSE 0 END) AS IN_APP_SALES_CLICKS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Sales' AND CHANNEL = 'PUSH' THEN 1 ELSE 0 END) AS PUSH_SALES_CLICKS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Sales' THEN 1 ELSE 0 END) AS SALES_CLICKS,
  --Algo
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Algo' AND CHANNEL = 'IN-APP' THEN 1 ELSE 0 END) AS IN_APP_ALGO_CLICKS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Algo' AND CHANNEL = 'PUSH' THEN 1 ELSE 0 END) AS PUSH_ALGO_CLICKS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Algo' THEN 1 ELSE 0 END) AS ALGO_CLICKS,
  --Rewards
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Rewards' AND CHANNEL = 'IN-APP' AND CAMPAIGN_SUBTYPE = 'Photo Challenge' THEN 1 ELSE 0 END) AS IN_APP_REWARDS_PHOTO_CLICKS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Rewards' AND CHANNEL = 'PUSH' AND CAMPAIGN_SUBTYPE = 'Photo Challenge' THEN 1 ELSE 0 END) AS PUSH_REWARDS_PHOTO_CLICKS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Rewards' AND CAMPAIGN_SUBTYPE = 'Photo Challenge' THEN 1 ELSE 0 END) AS REWARDS_PHOTO_CLICKS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Rewards' AND CHANNEL = 'IN-APP' AND CAMPAIGN_SUBTYPE = 'Purchase Challenge' THEN 1 ELSE 0 END) AS IN_APP_REWARDS_PURCHASE_CLICKS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Rewards' AND CHANNEL = 'PUSH' AND CAMPAIGN_SUBTYPE = 'Purchase Challenge' THEN 1 ELSE 0 END) AS PUSH_REWARDS_PURCHASE_CLICKS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Rewards' AND CAMPAIGN_SUBTYPE = 'Purchase Challenge' THEN 1 ELSE 0 END) AS REWARDS_PURCHASE_CLICKS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Rewards' AND CHANNEL = 'IN-APP' AND CAMPAIGN_SUBTYPE = 'Redemption' THEN 1 ELSE 0 END) AS IN_APP_REWARDS_REDEMPTION_CLICKS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Rewards' AND CHANNEL = 'PUSH' AND CAMPAIGN_SUBTYPE = 'Redemption' THEN 1 ELSE 0 END) AS PUSH_REWARDS_REDEMPTION_CLICKS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Rewards' AND CAMPAIGN_SUBTYPE = 'Redemption' THEN 1 ELSE 0 END) AS REWARDS_REDEMPTION_CLICKS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Rewards' AND CHANNEL = 'IN-APP' THEN 1 ELSE 0 END) AS IN_APP_REWARDS_CLICKS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Rewards' AND CHANNEL = 'PUSH' THEN 1 ELSE 0 END) AS PUSH_REWARDS_CLICKS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Rewards' THEN 1 ELSE 0 END) AS REWARDS_CLICKS,
  --Marketplace
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Marketplace' AND CHANNEL = 'IN-APP' THEN 1 ELSE 0 END) AS IN_APP_MARKETPLACE_CLICKS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Marketplace' AND CHANNEL = 'PUSH' THEN 1 ELSE 0 END) AS PUSH_MARKETPLACE_CLICKS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Marketplace' THEN 1 ELSE 0 END) AS MARKETPLACE_CLICKS,
  --Satisfaction
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Satisfaction' AND CHANNEL = 'IN-APP' THEN 1 ELSE 0 END) AS IN_APP_SATISFACTION_CLICKS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Satisfaction' AND CHANNEL = 'PUSH' THEN 1 ELSE 0 END) AS PUSH_SATISFACTION_CLICKS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Satisfaction' THEN 1 ELSE 0 END) AS SATISFACTION_CLICKS,
  --Survey
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Survey' AND CHANNEL = 'IN-APP' THEN 1 ELSE 0 END) AS IN_APP_SURVEY_CLICKS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Survey' AND CHANNEL = 'PUSH' THEN 1 ELSE 0 END) AS PUSH_SURVEY_CLICKS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Survey' THEN 1 ELSE 0 END) AS SURVEY_CLICKS,
  --Logistics
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Logistics' AND CAMPAIGN_SUBTYPE != 'Order Visibility' AND CHANNEL = 'IN-APP' THEN 1 ELSE 0 END) AS IN_APP_LOGISTICS_CLICKS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Logistics' AND CAMPAIGN_SUBTYPE != 'Order Visibility' AND CHANNEL = 'PUSH' THEN 1 ELSE 0 END) AS PUSH_LOGISTICS_CLICKS,
  SUM(CASE WHEN CAMPAIGN_TYPE = 'Logistics' AND CAMPAIGN_SUBTYPE != 'Order Visibility' THEN 1 ELSE 0 END) AS LOGISTICS_CLICKS,
  --Order Viz
  SUM(CASE WHEN CAMPAIGN_SUBTYPE = 'Order Visibility' THEN 1 ELSE 0 END) AS ORDER_VIS_CLICKS,
  SUM(CASE WHEN CAMPAIGN_SUBTYPE = 'Order Visibility' AND CHANNEL = 'IN-APP' THEN 1 ELSE 0 END) AS IN_APP_ORDER_VIS_CLICKS,
  SUM(CASE WHEN CAMPAIGN_SUBTYPE = 'Order Visibility' AND CHANNEL = 'PUSH' THEN 1 ELSE 0 END) AS PUSH_ORDER_VIS_CLICKS
FROM {{ ref('tracks_global_messages' )}} C
LEFT JOIN WH.DM_DIGITAL_COMMS.GLOBAL_CAMPAIGN_METADATA M
    ON C.COUNTRY = M.COUNTRY
    AND C.CAMPAIGN_ID = M.CAMPAIGN_ID
WHERE EVENT IN ('in_app_message_clicked', 'push_notification_tapped')
GROUP BY C.COUNTRY, USER_ID
),

PUSH_TTC AS (
SELECT COUNTRY,
    USER_ID,
    AVG(SECONDS_DIFF) AS AVG_PUSH_SECONDS_TO_CLICK
FROM {{ ref('background_time_to_click_events' )}}
WHERE CHANNEL = 'PUSH'
GROUP BY COUNTRY,
    USER_ID
),

IN_APP_TTC AS (
SELECT COUNTRY,
    USER_ID,
    AVG(SECONDS_DIFF) AS AVG_IN_APP_SECONDS_TO_CLICK
FROM {{ ref('background_time_to_click_events' )}}
WHERE CHANNEL = 'IN-APP'
GROUP BY COUNTRY,
    USER_ID
),

SALES_CONV AS (
SELECT COUNTRY,
    USER_ID,
    COUNT(DISTINCT SEND_ID) AS SALES_CONVERSIONS
FROM {{ ref('background_sales_conversions' )}}
GROUP BY COUNTRY,
    USER_ID
),

SALES_SKU_CONV AS (
SELECT COUNTRY,
    USER_ID,
    COUNT(DISTINCT SEND_ID) AS SALES_SKU_CONVERSIONS
FROM {{ ref('background_sales_sku_conversions' )}}
GROUP BY COUNTRY,
    USER_ID
),

ALGO_CONV AS (
SELECT COUNTRY,
    USER_ID,
    COUNT(DISTINCT SEND_ID) AS ALGO_CONVERSIONS
FROM {{ ref('background_algo_conversions' )}}
GROUP BY COUNTRY,
    USER_ID
),

REWARDS_PHOTO_CONV AS (
SELECT COUNTRY,
    USER_ID,
    COUNT(DISTINCT SEND_ID) AS PHOTO_CHALLENGE_CONVERSIONS
FROM {{ ref('background_rewards_photo_challenge_conversions' )}}
GROUP BY COUNTRY,
    USER_ID
),

REWARDS_PURCHASE_CONV AS (
SELECT COUNTRY,
    USER_ID,
    COUNT(DISTINCT SEND_ID) AS PURCHASE_CHALLENGE_CONVERSIONS
FROM {{ ref('background_rewards_purchase_challenge_conversions' )}}
GROUP BY COUNTRY,
    USER_ID
),

REWARDS_REDEMPTION_CONV AS (
SELECT COUNTRY,
    USER_ID,
    COUNT(DISTINCT SEND_ID) AS REDEMPTION_CONVERSIONS
FROM {{ ref('background_rewards_redemption_conversions' )}}
GROUP BY COUNTRY,
    USER_ID
)

SELECT S.COUNTRY,
    S.USER_ID,
    P.PUSH_FLAG,
    --Impressions
    IFNULL(PUSH_IMPRESSIONS, 0) AS PUSH_IMPRESSIONS,
    IFNULL(IN_APP_IMPRESSIONS, 0) AS IN_APP_IMPRESSIONS,
    IFNULL(TOTAL_IMPRESSIONS, 0) AS TOTAL_IMPRESSIONS,
    --SALES
    IFNULL(PUSH_SALES_IMPRESSIONS, 0) AS PUSH_SALES_IMPRESSIONS,
    IFNULL(IN_APP_SALES_IMPRESSIONS, 0) AS IN_APP_SALES_IMPRESSIONS,
    IFNULL(SALES_IMPRESSIONS, 0) AS SALES_IMPRESSIONS,
    --ALGO
    IFNULL(PUSH_ALGO_IMPRESSIONS, 0) AS PUSH_ALGO_IMPRESSIONS,
    IFNULL(IN_APP_ALGO_IMPRESSIONS, 0) AS IN_APP_ALGO_IMPRESSIONS,
    IFNULL(ALGO_IMPRESSIONS, 0) AS ALGO_IMPRESSIONS,
    --REWARDS
    IFNULL(PUSH_REWARDS_PHOTO_IMPRESSIONS, 0) AS PUSH_REWARDS_PHOTO_IMPRESSIONS,
    IFNULL(IN_APP_REWARDS_PHOTO_IMPRESSIONS, 0) AS IN_APP_REWARDS_PHOTO_IMPRESSIONS,
    IFNULL(REWARDS_PHOTO_IMPRESSIONS, 0) AS REWARDS_PHOTO_IMPRESSIONS,
    IFNULL(PUSH_REWARDS_PURCHASE_IMPRESSIONS, 0) AS PUSH_REWARDS_PURCHASE_IMPRESSIONS,
    IFNULL(IN_APP_REWARDS_PURCHASE_IMPRESSIONS, 0) AS IN_APP_REWARDS_PURCHASE_IMPRESSIONS,
    IFNULL(REWARDS_PURCHASE_IMPRESSIONS, 0) AS REWARDS_PURCHASE_IMPRESSIONS,
    IFNULL(PUSH_REWARDS_REDEMPTION_IMPRESSIONS, 0) AS PUSH_REWARDS_REDEMPTION_IMPRESSIONS,
    IFNULL(IN_APP_REWARDS_REDEMPTION_IMPRESSIONS, 0) AS IN_APP_REWARDS_REDEMPTION_IMPRESSIONS,
    IFNULL(REWARDS_REDEMPTION_IMPRESSIONS, 0) AS REWARDS_REDEMPTION_IMPRESSIONS,
    IFNULL(PUSH_REWARDS_IMPRESSIONS, 0) AS PUSH_REWARDS_IMPRESSIONS,
    IFNULL(IN_APP_REWARDS_IMPRESSIONS, 0) AS IN_APP_REWARDS_IMPRESSIONS,
    IFNULL(REWARDS_IMPRESSIONS, 0) AS REWARDS_IMPRESSIONS,
    --Marketplace
    IFNULL(IN_APP_MARKETPLACE_IMPRESSIONS, 0) AS IN_APP_MARKETPLACE_IMPRESSIONS,
    IFNULL(PUSH_MARKETPLACE_IMPRESSIONS, 0) AS PUSH_MARKETPLACE_IMPRESSIONS,
    IFNULL(MARKETPLACE_IMPRESSIONS, 0) AS MARKETPLACE_IMPRESSIONS,
    --SATISFACTION
    IFNULL(IN_APP_SATISFACTION_IMPRESSIONS, 0) AS IN_APP_SATISFACTION_IMPRESSIONS,
    IFNULL(PUSH_SATISFACTION_IMPRESSIONS, 0) AS PUSH_SATISFACTION_IMPRESSIONS,
    IFNULL(SATISFACTION_IMPRESSIONS, 0) AS SATISFACTION_IMPRESSIONS,
    --SURVEY
    IFNULL(IN_APP_SURVEY_IMPRESSIONS, 0) AS IN_APP_SURVEY_IMPRESSIONS,
    IFNULL(PUSH_SURVEY_IMPRESSIONS, 0) AS PUSH_SURVEY_IMPRESSIONS,
    IFNULL(SURVEY_IMPRESSIONS, 0) AS SURVEY_IMPRESSIONS,
    --LOGISTICS
    IFNULL(IN_APP_LOGISTICS_IMPRESSIONS, 0) AS IN_APP_LOGISTICS_IMPRESSIONS,
    IFNULL(PUSH_LOGISTICS_IMPRESSIONS, 0) AS PUSH_LOGISTICS_IMPRESSIONS,
    IFNULL(LOGISTICS_IMPRESSIONS, 0) AS LOGISTICS_IMPRESSIONS,
    --Order Viz
    IFNULL(PUSH_ORDER_VIS_IMPRESSIONS, 0) AS PUSH_ORDER_VIS_IMPRESSIONS,
    IFNULL(IN_APP_ORDER_VIS_IMPRESSIONS, 0) AS IN_APP_ORDER_VIS_IMPRESSIONS,
    IFNULL(ORDER_VIS_IMPRESSIONS, 0) AS ORDER_VIS_IMPRESSIONS,
    --Clicks
    IFNULL(PUSH_CLICKS, 0) AS PUSH_CLICKS,
    IFNULL(IN_APP_CLICKS, 0) AS IN_APP_CLICKS,
    IFNULL(TOTAL_CLICKS, 0) AS TOTAL_CLICKS,
    --SALES
    IFNULL(PUSH_SALES_CLICKS, 0) AS PUSH_SALES_CLICKS,
    IFNULL(IN_APP_SALES_CLICKS, 0) AS IN_APP_SALES_CLICKS,
    IFNULL(SALES_CLICKS, 0) AS SALES_CLICKS,
    --ALGO
    IFNULL(PUSH_ALGO_CLICKS, 0) AS PUSH_ALGO_CLICKS,
    IFNULL(IN_APP_ALGO_CLICKS, 0) AS IN_APP_ALGO_CLICKS,
    IFNULL(ALGO_CLICKS, 0) AS ALGO_CLICKS,
    --REWARDS
    IFNULL(PUSH_REWARDS_PHOTO_CLICKS, 0) AS PUSH_REWARDS_PHOTO_CLICKS,
    IFNULL(IN_APP_REWARDS_PHOTO_CLICKS, 0) AS IN_APP_REWARDS_PHOTO_CLICKS,
    IFNULL(REWARDS_PHOTO_CLICKS, 0) AS REWARDS_PHOTO_CLICKS,
    IFNULL(PUSH_REWARDS_PURCHASE_CLICKS, 0) AS PUSH_REWARDS_PURCHASE_CLICKS,
    IFNULL(IN_APP_REWARDS_PURCHASE_CLICKS, 0) AS IN_APP_REWARDS_PURCHASE_CLICKS,
    IFNULL(REWARDS_PURCHASE_CLICKS, 0) AS REWARDS_PURCHASE_CLICKS,
    IFNULL(PUSH_REWARDS_REDEMPTION_CLICKS, 0) AS PUSH_REWARDS_REDEMPTION_CLICKS,
    IFNULL(IN_APP_REWARDS_REDEMPTION_CLICKS, 0) AS IN_APP_REWARDS_REDEMPTION_CLICKS,
    IFNULL(REWARDS_REDEMPTION_CLICKS, 0) AS REWARDS_REDEMPTION_CLICKS,
    IFNULL(PUSH_REWARDS_CLICKS, 0) AS PUSH_REWARDS_CLICKS,
    IFNULL(IN_APP_REWARDS_CLICKS, 0) AS IN_APP_REWARDS_CLICKS,
    IFNULL(REWARDS_CLICKS, 0) AS REWARDS_CLICKS,
    --Marketplace
    IFNULL(IN_APP_MARKETPLACE_CLICKS, 0) AS IN_APP_MARKETPLACE_CLICKS,
    IFNULL(PUSH_MARKETPLACE_CLICKS, 0) AS PUSH_MARKETPLACE_CLICKS,
    IFNULL(MARKETPLACE_CLICKS, 0) AS MARKETPLACE_CLICKS,
    --SATISFACTION
    IFNULL(IN_APP_SATISFACTION_CLICKS, 0) AS IN_APP_SATISFACTION_CLICKS,
    IFNULL(PUSH_SATISFACTION_CLICKS, 0) AS PUSH_SATISFACTION_CLICKS,
    IFNULL(SATISFACTION_CLICKS, 0) AS SATISFACTION_CLICKS,
    --SURVEY
    IFNULL(IN_APP_SURVEY_CLICKS, 0) AS IN_APP_SURVEY_CLICKS,
    IFNULL(PUSH_SURVEY_CLICKS, 0) AS PUSH_SURVEY_CLICKS,
    IFNULL(SURVEY_CLICKS, 0) AS SURVEY_CLICKS,
    --LOGISTICS
    IFNULL(IN_APP_LOGISTICS_CLICKS, 0) AS IN_APP_LOGISTICS_CLICKS,
    IFNULL(PUSH_LOGISTICS_CLICKS, 0) AS PUSH_LOGISTICS_CLICKS,
    IFNULL(LOGISTICS_CLICKS, 0) AS LOGISTICS_CLICKS,
    --ORDER VIZ
    IFNULL(PUSH_ORDER_VIS_CLICKS, 0) AS PUSH_ORDER_VIS_CLICKS,
    IFNULL(IN_APP_ORDER_VIS_CLICKS, 0) AS IN_APP_ORDER_VIS_CLICKS,
    IFNULL(ORDER_VIS_CLICKS, 0) AS ORDER_VIS_CLICKS,
    --CONVERSIONS
    IFNULL(SALES_CONVERSIONS, 0) AS SALES_CONVERSIONS,
    IFNULL(SALES_SKU_CONVERSIONS, 0) AS SALES_SKU_CONVERSIONS,
    IFNULL(ALGO_CONVERSIONS, 0) AS ALGO_CONVERSIONS,
    IFNULL(PHOTO_CHALLENGE_CONVERSIONS, 0) AS PHOTO_CHALLENGE_CONVERSIONS,
    IFNULL(PURCHASE_CHALLENGE_CONVERSIONS, 0) AS PURCHASE_CHALLENGE_CONVERSIONS,
    IFNULL(REDEMPTION_CONVERSIONS, 0) AS REDEMPTION_CONVERSIONS,
    --TIME TO CLICK
    IFNULL(AVG_PUSH_SECONDS_TO_CLICK, 0) AS AVG_PUSH_SECONDS_TO_CLICK,
    IFNULL(AVG_IN_APP_SECONDS_TO_CLICK, 0) AS AVG_IN_APP_SECONDS_TO_CLICK
FROM USERS_SENDS S
LEFT JOIN USERS_PUSH P
    ON S.COUNTRY = P.COUNTRY
    AND S.USER_ID = P.USER_ID
LEFT JOIN USERS_CLICKS C
    ON S.COUNTRY = C.COUNTRY
    AND S.USER_ID = C.USER_ID
LEFT JOIN SALES_CONV SC
    ON S.COUNTRY = SC.COUNTRY
    AND S.USER_ID = SC.USER_ID
LEFT JOIN SALES_SKU_CONV SSC
    ON S.COUNTRY = SSC.COUNTRY
    AND S.USER_ID = SSC.USER_ID
LEFT JOIN ALGO_CONV AC
    ON S.COUNTRY = AC.COUNTRY
    AND S.USER_ID = AC.USER_ID
LEFT JOIN REWARDS_PHOTO_CONV PHO
    ON S.COUNTRY = PHO.COUNTRY
    AND S.USER_ID = PHO.USER_ID
LEFT JOIN REWARDS_PURCHASE_CONV PUR
    ON S.COUNTRY = PUR.COUNTRY
    AND S.USER_ID = PUR.USER_ID
LEFT JOIN REWARDS_REDEMPTION_CONV RED
    ON S.COUNTRY = RED.COUNTRY
    AND S.USER_ID = RED.USER_ID
LEFT JOIN PUSH_TTC PTTC
    ON S.COUNTRY = PTTC.COUNTRY
    AND S.USER_ID = PTTC.USER_ID
LEFT JOIN IN_APP_TTC IATTC
    ON S.COUNTRY = IATTC.COUNTRY
    AND S.USER_ID = IATTC.USER_ID
