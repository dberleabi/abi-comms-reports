-- Create the table that contains the brands associated with communications campaigns
SELECT COUNTRY, 
    CAMPAIGN_ID, 
    PRIMARY_TAG AS PRIMARY_TAG,
    SECONDARY_TAG AS BRAND,
    ORIGINAL_TAGS,
    CURRENT_TIMESTAMP() AS LAST_UPDATED
FROM {{ ref('campaign_tags' )}}
WHERE PRIMARY_TAG = 'brand'
