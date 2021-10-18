-- AGG PUSH USERS BY COUNTRY AND MONTH
WITH AGG_PUSH AS (
SELECT COUNTRY,
    MONTH,
    COUNT(DISTINCT USER_ID) AS REACH_PUSH_USERS,
    COUNT(DISTINCT POC_ID) AS REACH_PUSH_POCS
FROM WH.DATAMARTS_DIGITAL_COMMS.DIM_MONTHLY_BRAZE_USERS
WHERE CHANNEL = 'PUSH'
GROUP BY COUNTRY, MONTH
),
-- AGG IN APP USERS BY COUNTRY AND MONTH
AGG_APP AS (
SELECT COUNTRY,
    MONTH,
    COUNT(DISTINCT USER_ID) AS REACH_IN_APP_USERS,
    COUNT(DISTINCT POC_ID) AS REACH_IN_APP_POCS
FROM WH.DATAMARTS_DIGITAL_COMMS.DIM_MONTHLY_BRAZE_USERS
WHERE CHANNEL = 'IN-APP'
GROUP BY COUNTRY, MONTH
),
-- AGG ALL USERS BY COUNTRY AND MONTH
AGG_ALL AS (
SELECT COUNTRY,
    MONTH,
    COUNT(DISTINCT USER_ID) AS REACH_ALL_USERS,
    COUNT(DISTINCT POC_ID) AS REACH_ALL_POCS
FROM WH.DATAMARTS_DIGITAL_COMMS.DIM_MONTHLY_BRAZE_USERS
GROUP BY COUNTRY, MONTH
),

AGG_MOBILE_POCS AS (
SELECT COUNTRY,
    MONTH,
    COUNT(DISTINCT POC_ID) AS MOBILE_POCS
FROM WH.DATAMARTS_DIGITAL_COMMS.DIM_POCS_W_PLATFORM_MONTHLY
WHERE PLATFORM IN ('android', 'ios')
GROUP BY COUNTRY, MONTH
),

AGG_MOBILE_USERS AS (
SELECT COUNTRY,
    MONTH,
    COUNT(DISTINCT USER_ID) AS MOBILE_USERS
FROM WH.DATAMARTS_DIGITAL_COMMS.DIM_USERS_W_PLATFORM_MONTHLY
WHERE PLATFORM IN ('android', 'ios')
GROUP BY COUNTRY, MONTH
),

-- CREATE AGG TABLE TO BE USED IN SUM FOR GLOBAL COUNTRY
AGG_REACH AS (
SELECT A.COUNTRY,
    A.MONTH,
    A.REACH_ALL_USERS,
    A.REACH_ALL_POCS,
    P.REACH_PUSH_USERS,
    P.REACH_PUSH_POCS,
    AP.REACH_IN_APP_USERS,
    AP.REACH_IN_APP_POCS,
    MP.MOBILE_POCS,
    MU.MOBILE_USERS
FROM AGG_ALL A
LEFT JOIN AGG_PUSH P
    ON A.COUNTRY = P.COUNTRY
    AND A.MONTH = P.MONTH
LEFT JOIN AGG_APP AP
    ON A.COUNTRY = AP.COUNTRY