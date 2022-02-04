--This table contains purchase challenge conversions using challenge submitted as the event where the conversion event is within 2 days of the impression
{{
    config(
	incremental_strategy='delete+insert',
        unique_key='CONVERSION_ID'
    )
}}

WITH 
-- Create date filter for 2 days + 6 hours
{% if adapter.get_relation(this.database, this.schema, this.table) and not flags.FULL_REFRESH %}
T_MAX_DATA AS (select dateadd(HOUR, -54, max(SUBMITTED_DATE)) AS MAX_DATA from {{ this }}), 
{% else %}
    T_MAX_DATA AS (select to_date('2018-01-01') AS MAX_DATA),
{% endif %} 

-- Create campaign list
CAMPAIGN_DETAILS AS (
SELECT COUNTRY,
  CAMPAIGN_ID,
  NAME AS CAMPAIGN_NAME,
  CAMPAIGN_TYPE
FROM {{ ref('global_campaign_metadata')}} T
WHERE CAMPAIGN_TYPE = 'Rewards'
  AND CAMPAIGN_SUBTYPE = 'Purchase Challenge'
),

-- select braze events within the refresh period 
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

-- filter to sends
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

--filter to challenges in past 2 days + 6 hours
CHALLENGES AS (
SELECT 'AR' AS COUNTRY, *
FROM {{ ref('dim_ar_challenge_user_tracking')}} 
{% if adapter.get_relation(this.database, this.schema, this.table) and not flags.FULL_REFRESH %}
--WHERE a.RECEIVED_AT > (select max(RECEIVED_AT) from {{ this }})
       WHERE SUBMITTED_DATE > (select MAX_DATA from T_MAX_DATA)
{% endif %}   

UNION ALL  
SELECT 'BR' AS COUNTRY, *
FROM {{ ref('dim_br_challenge_user_tracking')}} 
{% if adapter.get_relation(this.database, this.schema, this.table) and not flags.FULL_REFRESH %}
--WHERE a.RECEIVED_AT > (select max(RECEIVED_AT) from {{ this }})
       WHERE SUBMITTED_DATE > (select MAX_DATA from T_MAX_DATA)
{% endif %} 
  
UNION ALL  
SELECT 'CO' AS COUNTRY, *
FROM {{ ref('dim_co_challenge_user_tracking')}} 
{% if adapter.get_relation(this.database, this.schema, this.table) and not flags.FULL_REFRESH %}
--WHERE a.RECEIVED_AT > (select max(RECEIVED_AT) from {{ this }})
       WHERE SUBMITTED_DATE > (select MAX_DATA from T_MAX_DATA)
{% endif %} 
  
UNION ALL  
SELECT 'DO' AS COUNTRY, *
FROM {{ ref('dim_do_challenge_user_tracking')}} 
{% if adapter.get_relation(this.database, this.schema, this.table) and not flags.FULL_REFRESH %}
--WHERE a.RECEIVED_AT > (select max(RECEIVED_AT) from {{ this }})
       WHERE SUBMITTED_DATE > (select MAX_DATA from T_MAX_DATA)
{% endif %} 
  
UNION ALL  
SELECT 'EC' AS COUNTRY, *
FROM {{ ref('dim_ec_challenge_user_tracking')}} 
{% if adapter.get_relation(this.database, this.schema, this.table) and not flags.FULL_REFRESH %}
--WHERE a.RECEIVED_AT > (select max(RECEIVED_AT) from {{ this }})
       WHERE SUBMITTED_DATE > (select MAX_DATA from T_MAX_DATA)
{% endif %} 
  
UNION ALL  
SELECT 'MX' AS COUNTRY, *
FROM {{ ref('dim_mx_challenge_user_tracking')}} 
{% if adapter.get_relation(this.database, this.schema, this.table) and not flags.FULL_REFRESH %}
--WHERE a.RECEIVED_AT > (select max(RECEIVED_AT) from {{ this }})
       WHERE SUBMITTED_DATE > (select MAX_DATA from T_MAX_DATA)
{% endif %} 
  
UNION ALL  
SELECT 'PE' AS COUNTRY, *
FROM {{ ref('dim_pe_challenge_user_tracking')}} 
{% if adapter.get_relation(this.database, this.schema, this.table) and not flags.FULL_REFRESH %}
--WHERE a.RECEIVED_AT > (select max(RECEIVED_AT) from {{ this }})
       WHERE SUBMITTED_DATE > (select MAX_DATA from T_MAX_DATA)
{% endif %} 
  
UNION ALL  
SELECT 'PY' AS COUNTRY, *
FROM {{ ref('dim_py_challenge_user_tracking')}} 
{% if adapter.get_relation(this.database, this.schema, this.table) and not flags.FULL_REFRESH %}
--WHERE a.RECEIVED_AT > (select max(RECEIVED_AT) from {{ this }})
       WHERE SUBMITTED_DATE > (select MAX_DATA from T_MAX_DATA)
{% endif %} 
  
UNION ALL  
SELECT 'SV' AS COUNTRY, *
FROM {{ ref('dim_sv_challenge_user_tracking')}} 
{% if adapter.get_relation(this.database, this.schema, this.table) and not flags.FULL_REFRESH %}
--WHERE a.RECEIVED_AT > (select max(RECEIVED_AT) from {{ this }})
       WHERE SUBMITTED_DATE > (select MAX_DATA from T_MAX_DATA)
{% endif %} 
  
UNION ALL  
SELECT 'ZA' AS COUNTRY, *
FROM {{ ref('dim_za_challenge_user_tracking')}} 
{% if adapter.get_relation(this.database, this.schema, this.table) and not flags.FULL_REFRESH %}
--WHERE a.RECEIVED_AT > (select max(RECEIVED_AT) from {{ this }})
       WHERE SUBMITTED_DATE > (select MAX_DATA from T_MAX_DATA)
{% endif %} 

),

-- filter to purchase challenges that have been submitted
PURCHASE_CHALLENGES AS (
SELECT *
FROM CHALLENGES
WHERE USER_ENGAGED = '1'
AND EXECUTION_METHOD LIKE '%PURCHASE%'
)

-- join submitted challenges to impressions, filter to a 2 day conversion window
SELECT DISTINCT PC.COUNTRY,
    PC.POC_ID,
    USER_ID,
    CAMPAIGN_ID,
    CHANNEL,
    SEND_ID,
    IMPRESSION_TIME,
    CHALLENGE_ID,
    SUBMITTED_DATE,
    CONCAT(SEND_ID, CHALLENGE_ID) AS CONVERSION_ID,
    CURRENT_TIMESTAMP AS UPDATED_AT
FROM PURCHASE_CHALLENGES PC
JOIN SENDS S
    ON PC.COUNTRY = S.COUNTRY
    AND PC.POC_ID = S.POC_ID
WHERE DATEDIFF(SECONDS, IMPRESSION_TIME, SUBMITTED_DATE) BETWEEN 0 AND 172800
