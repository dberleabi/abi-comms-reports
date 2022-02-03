-- Create the table that contains the brands associated with communications campaigns

SELECT 
		COUNTRY
		,CAMPAIGN_ID
		,REGEXP_REPLACE(REGEXP_REPLACE(TRIM(sp.VALUE), '(sku )', '999'), '(sku(/|s/|:))', 'sku/') AS TAG
		,CASE WHEN TAG LIKE ANY ('sku/%', 'deal/%') THEN REGEXP_REPLACE(TAG, '(sku/)|(deal/)', '') END AS PRODUCT
		,CASE WHEN TAG LIKE 'deal/%' THEN 1 ELSE 0 END AS COMBO_BOOLEAN
		,TAGS AS ORIGINAL_TAGS
		,CURRENT_TIMESTAMP() AS LAST_UPDATED 
	FROM
		{{ ref('global_campaign_metadata' )}},
		LATERAL SPLIT_TO_TABLE(TAGS, ',') sp
	WHERE TAG LIKE ANY ('sku/%', 'deal/%')
