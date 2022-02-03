--This file contains a list of all Rewards Redemption Transactions, sourced from STAGE

WITH
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

SELECT COUNTRY,
    TYPE,
    ACCOUNT_ID,
    TRANSACTIONS_ID,
    AMOUNT,
    TIMESTAMP AS REDEMPTION_TIMESTAMP
FROM STAGE.REWARDS.REWARDS_TRANSACTIONS
WHERE TYPE = 'REDEMPTION' 
