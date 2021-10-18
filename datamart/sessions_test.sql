{{
    config(
		incremental_strategy='delete+insert',
        unique_key='ID'
    )
}}
-- grab list of user_ids for active users
WITH 
T_MAX_DATA AS (select dateadd(HOUR, -6, max(RECEIVED_AT)) AS MAX_DATA from {{ ref('fact_ar_tracks') }}),
MAX_USER_SESSION AS(
   SELECT USER_ID, 
   			MAX(USER_SESSION_ID) AS MAX_USER_SESSION_ID, 
   			MAX(RECEIVED_AT) AS MAX_RECEIVED_AT
   			FROM  wh.segment.dim_ar_sessions
			{% if adapter.get_relation(this.database, this.schema, this.table) and not flags.FULL_REFRESH %}
				  --WHERE RECEIVED_AT <= (select dateadd(HOUR, -6, max(RECEIVED_AT)) from {{ ref('fact_ar_tracks') }})
   				  WHERE  RECEIVED_AT <= (select MAX_DATA from T_MAX_DATA)
			{% else %}
				  WHERE 1 = 2 
			{% endif %}
   GROUP BY  USER_ID
)

,MAX_GLOBAL_SESSION AS(
SELECT MAX(GLOBAL_SESSION_ID) AS MAX_GLOBAL_SESSION_ID
FROM  wh.segment.dim_ar_sessions
			{% if adapter.get_relation(this.database, this.schema, this.table) and not flags.FULL_REFRESH %}
				  --WHERE RECEIVED_AT <= (select dateadd(HOUR, -6, max(RECEIVED_AT)) from {{ ref('fact_ar_tracks') }})
   				  WHERE  RECEIVED_AT <= (select MAX_DATA from T_MAX_DATA)
			{% else %}
				  WHERE 1 = 2 
			{% endif %}
)
, active_users AS (
 SELECT T1.USER_ID,
			  T1.IS_ACTIVE,
			  T2.MAX_RECEIVED_AT,
			  T2.MAX_USER_SESSION_ID
	  FROM {{ ref('dim_ar_active_users') }} T1
	  LEFT JOIN MAX_USER_SESSION T2 ON (T1.USER_ID  = T2.USER_ID)
)
-- grab the previous event occurred_at -- assign a flag for new sessions
, all_tracks AS (
  SELECT  T1.CONTEXT_LIBRARY_NAME,
					T1.ID,
					T1.USER_ID,
					T1.RECEIVED_AT,
					T1.UUID_TS,
					T1.EVENT,
  			        T2.MAX_USER_SESSION_ID,
  			        T2.MAX_RECEIVED_AT
  FROM {{ ref('fact_ar_tracks') }} AS T1
	  JOIN active_users T2 ON  (T1.USER_ID  = T2.USER_ID AND T1.RECEIVED_AT > ifnull(T2.MAX_RECEIVED_AT,'1970-01-01 00:00:00') AND T2.is_active = 1)
  	where EVENT NOT IN ('push_notification_received', 'push_notification_tapped')
  	UNION ALL
  SELECT  T1.CONTEXT_LIBRARY_NAME,
					T1.ID,
					T1.USER_ID,
					T1.RECEIVED_AT,
					T1.UUID_TS,
					T1.EVENT,
  			        T2.MAX_USER_SESSION_ID,
  			        T2.MAX_RECEIVED_AT
FROM SEGMENT_EVENTS.BRAZE_AR.TRACKS T1
  	  JOIN active_users T2 ON  (T1.USER_ID  = T2.USER_ID AND T1.RECEIVED_AT > ifnull(T2.MAX_RECEIVED_AT,'1970-01-01 00:00:00') AND T2.is_active = 1)
  	  )
, new_session_flag AS (
  SELECT  T1.CONTEXT_LIBRARY_NAME,
					T1.ID,
					T1.USER_ID,
					T1.RECEIVED_AT,
					T1.UUID_TS,
					T1.EVENT,
          T1.MAX_USER_SESSION_ID,
		  ifnull(LAG(T1.RECEIVED_AT,1) OVER (PARTITION BY T1.USER_ID ORDER BY T1.RECEIVED_AT),T1.MAX_RECEIVED_AT) AS last_event_occurred_at,
          CASE
			WHEN ifnull(LAG(T1.RECEIVED_AT,1) OVER (PARTITION BY T1.USER_ID ORDER BY T1.RECEIVED_AT),T1.MAX_RECEIVED_AT) IS NULL
			OR DATEDIFF(s, '1970-01-01 00:00:00', T1.received_at) - DATEDIFF(s, '1970-01-01 00:00:00', ifnull(LAG(T1.RECEIVED_AT,1) OVER (PARTITION BY T1.USER_ID ORDER BY T1.RECEIVED_AT),T1.MAX_RECEIVED_AT)) >= (30*60)
			THEN 1 ELSE 0 END AS IS_NEW_SESSION
  FROM all_tracks T1
  )
SELECT context_library_name,
       user_id,
       received_at,
	   UUID_TS,
       event,
       id,
       ifnull((SELECT MAX_GLOBAL_SESSION_ID FROM MAX_GLOBAL_SESSION),0) + SUM(is_new_session) OVER (ORDER BY user_id, received_at) AS global_session_id,
       ifnull(MAX_USER_SESSION_ID,0) + SUM(is_new_session) OVER (PARTITION BY user_id ORDER BY received_at) AS user_session_id
FROM new_session_flag
