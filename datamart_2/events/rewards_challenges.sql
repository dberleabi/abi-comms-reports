--This file contains a list of all Rewards Redemption Transactions, sourced from STAGE
--Select fields from challenge user tracking

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

