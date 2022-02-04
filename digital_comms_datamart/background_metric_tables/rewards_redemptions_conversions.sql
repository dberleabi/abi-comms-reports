--This table contains rewards redemptions conversions using redemption transactions as the event where the conversion event is within 7 days of the impression
{{
    config(
	incremental_strategy='delete+insert',
        unique_key='CONVERSION_ID'
    )
}}

WITH 
-- Create date filter for 7 days + 6 hours
{% if adapter.get_relation(this.database, this.schema, this.table) and not flags.FULL_REFRESH %}
T_MAX_DATA AS (select dateadd(HOUR, -174, max(REDEMPTION_TIMESTAMP)) AS MAX_DATA from {{ this }}), 
{% else %}
    T_MAX_DATA AS (select to_date('2018-01-01') AS MAX_DATA),
{% endif %} 

CAMPAIGN_DETAILS AS (
SELECT COUNTRY,
  CAMPAIGN_ID,
  NAME AS CAMPAIGN_NAME,
  CAMPAIGN_TYPE
FROM {{ ref('global_campaign_metadata')}} T
WHERE CAMPAIGN_TYPE = 'Rewards'
  AND CAMPAIGN_SUBTYPE = 'Redemption'
),

BRAZE_EVENTS AS (
SELECT DISTINCT S.COUNTRY,
    S.CHANNEL,
    S.CAMPAIGN_ID,
    D.CAMPAIGN_NAME,
    D.CAMPAIGN_TYPE,
    S.ID AS SEND_ID,
    EVENT,
    S.USER_ID,
    S.POC_ID,
    S.RECEIVED_AT AS IMPRESSION_TIME
FROM {{ ref('tracks_global_messages')}} S
JOIN CAMPAIGN_DETAILS D
    ON S.COUNTRY = D.COUNTRY
    AND S.CAMPAIGN_ID = D.CAMPAIGN_ID
{% if adapter.get_relation(this.database, this.schema, this.table) and not flags.FULL_REFRESH %}
--WHERE a.RECEIVED_AT > (select max(RECEIVED_AT) from {{ this }})
       WHERE RECEIVED_AT > (select MAX_DATA from T_MAX_DATA)
{% endif %}
),

SENDS AS (
SELECT DISTINCT COUNTRY,
    CHANNEL,
    CAMPAIGN_ID,
    CAMPAIGN_NAME,
    CAMPAIGN_TYPE,
    SEND_ID,
    USER_ID,
    POC_ID,
    IMPRESSION_TIME
FROM BRAZE_EVENTS
WHERE EVENT IN ('in_app_message_viewed', 'push_notification_sent')
),

RECENT_REWARDS AS (
SELECT COUNTRY,
    TYPE,
    ACCOUNT_ID,
    TRANSACTIONS_ID,
    AMOUNT,
    TIMESTAMP
FROM STAGE.REWARDS.REWARDS_TRANSACTIONS
{% if adapter.get_relation(this.database, this.schema, this.table) and not flags.FULL_REFRESH %}
--WHERE a.RECEIVED_AT > (select max(RECEIVED_AT) from {{ this }})
       WHERE TIMESTAMP > (select MAX_DATA from T_MAX_DATA)
{% endif %}
),

REDEMPTIONS AS (
SELECT COUNTRY,
    TYPE,
    ACCOUNT_ID,
    TRANSACTIONS_ID,
    AMOUNT,
    TIMESTAMP AS REDEMPTION_TIMESTAMP
FROM STAGE.REWARDS.REWARDS_TRANSACTIONS
WHERE TYPE = 'REDEMPTION' 
)

SELECT DISTINCT R.COUNTRY,
    R.ACCOUNT_ID AS POC_ID,
    USER_ID,
    CAMPAIGN_ID,
    CHANNEL,
    SEND_ID,
    IMPRESSION_TIME,
    TRANSACTIONS_ID,
    REDEMPTION_TIMESTAMP,
    CONCAT(SEND_ID, TRANSACTIONS_ID) AS CONVERSION_ID,
    CURRENT_TIMESTAMP AS UPDATED_AT
FROM REDEMPTIONS R
JOIN SENDS S
    ON R.COUNTRY = S.COUNTRY
    AND R.ACCOUNT_ID = S.POC_ID
WHERE DATEDIFF(SECONDS, IMPRESSION_TIME, REDEMPTION_TIMESTAMP) BETWEEN 0 AND 604800
