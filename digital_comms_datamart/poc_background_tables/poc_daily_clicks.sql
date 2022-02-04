SELECT C.COUNTRY,
  POC_ID,
  DATE_TRUNC('DAY', RECEIVED_AT) AS DAY,
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
  SUM(CASE WHEN CAMPAIGN_SUBTYPE = 'Order Visibility' AND CHANNEL = 'PUSH' THEN 1 ELSE 0 END) AS PUSH_ORDER_VIS_CLICKS,
  CONCAT(C.COUNTRY, '-', POC_ID, '-', DAY) AS UID,
  CURRENT_TIMESTAMP AS LOADED_AT
FROM {{ ref('tracks_global_messages' )}} C
LEFT JOIN {{ ref('global_campaign_metadata' )}} M
    ON C.COUNTRY = M.COUNTRY
    AND C.CAMPAIGN_ID = M.CAMPAIGN_ID
WHERE EVENT IN ('in_app_message_clicked', 'push_notification_tapped')
GROUP BY C.COUNTRY, POC_ID, DAY
