-- Create the table that contains the campaign types associated with communications campaigns in a long format

SELECT COUNTRY,
    CAMPAIGN_ID,
    PRIMARY_TAG,
    SECONDARY_TAG,
    ORIGINAL_TAGS,
    CASE WHEN PRIMARY_TAG LIKE '%sales%' THEN 'Sales'
               WHEN PRIMARY_TAG LIKE '%algo%' THEN 'Algo'
               WHEN PRIMARY_TAG LIKE '%marketplace%' THEN 'Marketplace'
               WHEN PRIMARY_TAG LIKE '%logistics%' THEN 'Logistics'
               WHEN PRIMARY_TAG LIKE '%rewards%' THEN 'Rewards'
               WHEN PRIMARY_TAG LIKE '%satisfaction%' THEN 'Satisfaction'
               WHEN PRIMARY_TAG LIKE '%survey%' THEN 'Survey'
         ELSE 'Uncategorized' END AS campaign_type
FROM {{ ref('campaign_tags' )}}
WHERE CAMPAIGN_TYPE LIKE ANY ('Sales', 'Algo', 'Marketplace', 'Logistics', 'Rewards', 'Satisfaction', 'Survey')
