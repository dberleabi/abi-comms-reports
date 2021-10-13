SELECT DATE_TRUNC('MONTH', SENT_AT) as MONTH,
    COUNTRY,
    SUM(TOTAL_MESSAGES) AS MESSAGES,
    SUM(N_IN_APP_MESSAGES) AS IN_APP,
    SUM(N_PUSH_MESSAGES) AS PUSH,
    COUNT(DISTINCT POC_ID) AS POCS,
    MESSAGES / POCS AS TOTAL_FREQUENCY,
    IN_APP / POCS AS IN_APP_FREQUENCY,
    PUSH / POCS AS PUSH_FREQUENCY
FROM WH.DATAMARTS_DIGITAL_COMMS.DIM_POC_MESSAGE_FREQUENCY
GROUP BY MONTH, COUNTRY
