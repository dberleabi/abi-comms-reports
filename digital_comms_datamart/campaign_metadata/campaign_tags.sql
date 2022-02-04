-- Create the table that contains the tags associated with communications campaigns in a long format

SELECT 
		COUNTRY
		,CAMPAIGN_ID
		,TRIM(SPLIT_PART(sp.value, '/', 1)) AS PRIMARY_TAG
		,TRIM(SPLIT_PART(sp.value, '/', 2)) AS SECONDARY_TAG
		,TAGS AS ORIGINAL_TAGS
		,CURRENT_TIMESTAMP() AS LAST_UPDATED 
	FROM
		{{ ref('global_campaign_metadata' )}},
		LATERAL SPLIT_TO_TABLE(TAGS, ',') sp
