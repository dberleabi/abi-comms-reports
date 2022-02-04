-- Create a table containing key metadata from BRAZE_PRD.CAMPAIGN_DETAILS
-- Create logic that sets campaign type

WITH global_campaign_details AS (
  SELECT 'AR' AS country,
    campaign_id,
    name,
    message_channel,
    created_at,
    first_sent,
    last_sent,
    ARRAY_TO_STRING(tags, ', ') AS str_tags, -- flattens the TAGS array
    lower(str_tags) AS lower_tags, -- Makes all characters lowercase for easier matching in future CASE WHEN statement
    split_part(lower_tags, 'brand/', 2) as split_brand,
    split_part(split_brand, ',', 1) AS lower_brand, -- Pulls the brand from the tag in lower case
    split_part(lower_tags, 'skus/', 2) AS SKU1_STG,
    split_part(SKU1_STG, ',', 1) as SKU1_STG1,
    CASE WHEN SKU1_STG1 LIKE '%, ' THEN LEFT(SKU1_STG1, LENGTH(SKU1_STG1)-2)
    ELSE SKU1_STG1 END AS SKU1,
    split_part(lower_tags, 'skus/', 3) AS SKU2_STG,
    split_part(SKU2_STG, ',', 1) AS SKU2_STG1,
    CASE WHEN SKU2_STG1 LIKE '%, ' THEN LEFT(SKU2_STG1, LENGTH(SKU2_STG1)-2)
    ELSE SKU2_STG1 END AS SKU2,
    SPLIT_PART(lower_tags, 'skus/', 4) AS SKU3_STG,
    SPLIT_PART(SKU3_STG, ',', 1) AS SKU3_STG1,
    CASE WHEN SKU3_STG1 LIKE '%, ' THEN LEFT(SKU3_STG1, LENGTH(SKU3_STG1)-2)
    ELSE SKU3_STG1 END AS SKU3,
    SPLIT_PART(lower_tags, 'skus/', 5) AS SKU4_STG,
    SPLIT_PART(SKU4_STG, ',', 1) AS SKU4_STG1,
    CASE WHEN SKU4_STG1 LIKE '%, ' THEN LEFT(SKU4_STG1, LENGTH(SKU4_STG1)-2)
    ELSE SKU4_STG1 END AS SKU4,
    split_part(lower_tags, 'sku/', 2) AS SKU_STG,
    split_part(SKU_STG, ',', 1) as SKU_STG1,
    CASE WHEN SKU_STG1 LIKE '%, ' THEN LEFT(SKU_STG1, LENGTH(SKU_STG1)-2)
    ELSE SKU_STG1 END AS SKU
FROM BRAZE_PRD.CAMPAIGN_DETAILS.AR_CAMPAIGN_DETAILS

UNION ALL
SELECT 'BR' AS country,
    campaign_id,
    name,
    message_channel,
    created_at,
    first_sent,
    last_sent,
    ARRAY_TO_STRING(tags, ', ') AS str_tags, -- flattens the TAGS array
    lower(str_tags) AS lower_tags, -- Makes all characters lowercase for easier matching in future CASE WHEN statement
    split_part(lower_tags, 'brand/', 2) as split_brand,
    split_part(split_brand, ',', 1) AS lower_brand, -- Pulls the brand from the tag in lower case
    split_part(lower_tags, 'skus/', 2) AS SKU1_STG,
    split_part(SKU1_STG, ',', 1) as SKU1_STG1,
    CASE WHEN SKU1_STG1 LIKE '%, ' THEN LEFT(SKU1_STG1, LENGTH(SKU1_STG1)-2)
    ELSE SKU1_STG1 END AS SKU1,
    split_part(lower_tags, 'skus/', 3) AS SKU2_STG,
    split_part(SKU2_STG, ',', 1) AS SKU2_STG1,
    CASE WHEN SKU2_STG1 LIKE '%, ' THEN LEFT(SKU2_STG1, LENGTH(SKU2_STG1)-2)
    ELSE SKU2_STG1 END AS SKU2,
    SPLIT_PART(lower_tags, 'skus/', 4) AS SKU3_STG,
    SPLIT_PART(SKU3_STG, ',', 1) AS SKU3_STG1,
    CASE WHEN SKU3_STG1 LIKE '%, ' THEN LEFT(SKU3_STG1, LENGTH(SKU3_STG1)-2)
    ELSE SKU3_STG1 END AS SKU3,
    SPLIT_PART(lower_tags, 'skus/', 5) AS SKU4_STG,
    SPLIT_PART(SKU4_STG, ',', 1) AS SKU4_STG1,
    CASE WHEN SKU4_STG1 LIKE '%, ' THEN LEFT(SKU4_STG1, LENGTH(SKU4_STG1)-2)
    ELSE SKU4_STG1 END AS SKU4,
    split_part(lower_tags, 'sku/', 2) AS SKU_STG,
    split_part(SKU_STG, ',', 1) as SKU_STG1,
    CASE WHEN SKU_STG1 LIKE '%, ' THEN LEFT(SKU_STG1, LENGTH(SKU_STG1)-2)
    ELSE SKU_STG1 END AS SKU
FROM BRAZE_PRD.CAMPAIGN_DETAILS.BR_CAMPAIGN_DETAILS

UNION ALL
SELECT 'CA' AS country,
    campaign_id,
    name,
    message_channel,
    created_at,
    first_sent,
    last_sent,
    ARRAY_TO_STRING(tags, ', ') AS str_tags, -- flattens the TAGS array
    lower(str_tags) AS lower_tags, -- Makes all characters lowercase for easier matching in future CASE WHEN statement
    split_part(lower_tags, 'brand/', 2) as split_brand,
    split_part(split_brand, ',', 1) AS lower_brand, -- Pulls the brand from the tag in lower case
    split_part(lower_tags, 'skus/', 2) AS SKU1_STG,
    split_part(SKU1_STG, ',', 1) as SKU1_STG1,
    CASE WHEN SKU1_STG1 LIKE '%, ' THEN LEFT(SKU1_STG1, LENGTH(SKU1_STG1)-2)
    ELSE SKU1_STG1 END AS SKU1,
    split_part(lower_tags, 'skus/', 3) AS SKU2_STG,
    split_part(SKU2_STG, ',', 1) AS SKU2_STG1,
    CASE WHEN SKU2_STG1 LIKE '%, ' THEN LEFT(SKU2_STG1, LENGTH(SKU2_STG1)-2)
    ELSE SKU2_STG1 END AS SKU2,
    SPLIT_PART(lower_tags, 'skus/', 4) AS SKU3_STG,
    SPLIT_PART(SKU3_STG, ',', 1) AS SKU3_STG1,
    CASE WHEN SKU3_STG1 LIKE '%, ' THEN LEFT(SKU3_STG1, LENGTH(SKU3_STG1)-2)
    ELSE SKU3_STG1 END AS SKU3,
    SPLIT_PART(lower_tags, 'skus/', 5) AS SKU4_STG,
    SPLIT_PART(SKU4_STG, ',', 1) AS SKU4_STG1,
    CASE WHEN SKU4_STG1 LIKE '%, ' THEN LEFT(SKU4_STG1, LENGTH(SKU4_STG1)-2)
    ELSE SKU4_STG1 END AS SKU4,
    split_part(lower_tags, 'sku/', 2) AS SKU_STG,
    split_part(SKU_STG, ',', 1) as SKU_STG1,
    CASE WHEN SKU_STG1 LIKE '%, ' THEN LEFT(SKU_STG1, LENGTH(SKU_STG1)-2)
    ELSE SKU_STG1 END AS SKU
FROM BRAZE_PRD.CAMPAIGN_DETAILS.CA_CAMPAIGN_DETAILS

UNION ALL
SELECT 'CO' AS country,
    campaign_id,
    name,
    message_channel,
    created_at,
    first_sent,
    last_sent,
    ARRAY_TO_STRING(tags, ', ') AS str_tags, -- flattens the TAGS array
    lower(str_tags) AS lower_tags, -- Makes all characters lowercase for easier matching in future CASE WHEN statement
    split_part(lower_tags, 'brand/', 2) as split_brand,
    split_part(split_brand, ',', 1) AS lower_brand, -- Pulls the brand from the tag in lower case
    split_part(lower_tags, 'skus/', 2) AS SKU1_STG,
    split_part(SKU1_STG, ',', 1) as SKU1_STG1,
    CASE WHEN SKU1_STG1 LIKE '%, ' THEN LEFT(SKU1_STG1, LENGTH(SKU1_STG1)-2)
    ELSE SKU1_STG1 END AS SKU1,
    split_part(lower_tags, 'skus/', 3) AS SKU2_STG,
    split_part(SKU2_STG, ',', 1) AS SKU2_STG1,
    CASE WHEN SKU2_STG1 LIKE '%, ' THEN LEFT(SKU2_STG1, LENGTH(SKU2_STG1)-2)
    ELSE SKU2_STG1 END AS SKU2,
    SPLIT_PART(lower_tags, 'skus/', 4) AS SKU3_STG,
    SPLIT_PART(SKU3_STG, ',', 1) AS SKU3_STG1,
    CASE WHEN SKU3_STG1 LIKE '%, ' THEN LEFT(SKU3_STG1, LENGTH(SKU3_STG1)-2)
    ELSE SKU3_STG1 END AS SKU3,
    SPLIT_PART(lower_tags, 'skus/', 5) AS SKU4_STG,
    SPLIT_PART(SKU4_STG, ',', 1) AS SKU4_STG1,
    CASE WHEN SKU4_STG1 LIKE '%, ' THEN LEFT(SKU4_STG1, LENGTH(SKU4_STG1)-2)
    ELSE SKU4_STG1 END AS SKU4,
    split_part(lower_tags, 'sku/', 2) AS SKU_STG,
    split_part(SKU_STG, ',', 1) as SKU_STG1,
    CASE WHEN SKU_STG1 LIKE '%, ' THEN LEFT(SKU_STG1, LENGTH(SKU_STG1)-2)
    ELSE SKU_STG1 END AS SKU
FROM BRAZE_PRD.CAMPAIGN_DETAILS.CO_CAMPAIGN_DETAILS

UNION ALL
SELECT 'DO' AS country,
    campaign_id,
    name,
    message_channel,
    created_at,
    first_sent,
    last_sent,
    ARRAY_TO_STRING(tags, ', ') AS str_tags, -- flattens the TAGS array
    lower(str_tags) AS lower_tags, -- Makes all characters lowercase for easier matching in future CASE WHEN statement
    split_part(lower_tags, 'brand/', 2) as split_brand,
    split_part(split_brand, ',', 1) AS lower_brand, -- Pulls the brand from the tag in lower case
    split_part(lower_tags, 'skus/', 2) AS SKU1_STG,
    split_part(SKU1_STG, ',', 1) as SKU1_STG1,
    CASE WHEN SKU1_STG1 LIKE '%, ' THEN LEFT(SKU1_STG1, LENGTH(SKU1_STG1)-2)
    ELSE SKU1_STG1 END AS SKU1,
    split_part(lower_tags, 'skus/', 3) AS SKU2_STG,
    split_part(SKU2_STG, ',', 1) AS SKU2_STG1,
    CASE WHEN SKU2_STG1 LIKE '%, ' THEN LEFT(SKU2_STG1, LENGTH(SKU2_STG1)-2)
    ELSE SKU2_STG1 END AS SKU2,
    SPLIT_PART(lower_tags, 'skus/', 4) AS SKU3_STG,
    SPLIT_PART(SKU3_STG, ',', 1) AS SKU3_STG1,
    CASE WHEN SKU3_STG1 LIKE '%, ' THEN LEFT(SKU3_STG1, LENGTH(SKU3_STG1)-2)
    ELSE SKU3_STG1 END AS SKU3,
    SPLIT_PART(lower_tags, 'skus/', 5) AS SKU4_STG,
    SPLIT_PART(SKU4_STG, ',', 1) AS SKU4_STG1,
    CASE WHEN SKU4_STG1 LIKE '%, ' THEN LEFT(SKU4_STG1, LENGTH(SKU4_STG1)-2)
    ELSE SKU4_STG1 END AS SKU4,
    split_part(lower_tags, 'sku/', 2) AS SKU_STG,
    split_part(SKU_STG, ',', 1) as SKU_STG1,
    CASE WHEN SKU_STG1 LIKE '%, ' THEN LEFT(SKU_STG1, LENGTH(SKU_STG1)-2)
    ELSE SKU_STG1 END AS SKU
FROM BRAZE_PRD.CAMPAIGN_DETAILS.DO_CAMPAIGN_DETAILS

UNION ALL
SELECT 'EC' AS country,
    campaign_id,
    name,
    message_channel,
    created_at,
    first_sent,
    last_sent,
    ARRAY_TO_STRING(tags, ', ') AS str_tags, -- flattens the TAGS array
    lower(str_tags) AS lower_tags, -- Makes all characters lowercase for easier matching in future CASE WHEN statement
    split_part(lower_tags, 'brand/', 2) as split_brand,
    split_part(split_brand, ',', 1) AS lower_brand, -- Pulls the brand from the tag in lower case
    split_part(lower_tags, 'skus/', 2) AS SKU1_STG,
    split_part(SKU1_STG, ',', 1) as SKU1_STG1,
    CASE WHEN SKU1_STG1 LIKE '%, ' THEN LEFT(SKU1_STG1, LENGTH(SKU1_STG1)-2)
    ELSE SKU1_STG1 END AS SKU1,
    split_part(lower_tags, 'skus/', 3) AS SKU2_STG,
    split_part(SKU2_STG, ',', 1) AS SKU2_STG1,
    CASE WHEN SKU2_STG1 LIKE '%, ' THEN LEFT(SKU2_STG1, LENGTH(SKU2_STG1)-2)
    ELSE SKU2_STG1 END AS SKU2,
    SPLIT_PART(lower_tags, 'skus/', 4) AS SKU3_STG,
    SPLIT_PART(SKU3_STG, ',', 1) AS SKU3_STG1,
    CASE WHEN SKU3_STG1 LIKE '%, ' THEN LEFT(SKU3_STG1, LENGTH(SKU3_STG1)-2)
    ELSE SKU3_STG1 END AS SKU3,
    SPLIT_PART(lower_tags, 'skus/', 5) AS SKU4_STG,
    SPLIT_PART(SKU4_STG, ',', 1) AS SKU4_STG1,
    CASE WHEN SKU4_STG1 LIKE '%, ' THEN LEFT(SKU4_STG1, LENGTH(SKU4_STG1)-2)
    ELSE SKU4_STG1 END AS SKU4,
    split_part(lower_tags, 'sku/', 2) AS SKU_STG,
    split_part(SKU_STG, ',', 1) as SKU_STG1,
    CASE WHEN SKU_STG1 LIKE '%, ' THEN LEFT(SKU_STG1, LENGTH(SKU_STG1)-2)
    ELSE SKU_STG1 END AS SKU
FROM BRAZE_PRD.CAMPAIGN_DETAILS.EC_CAMPAIGN_DETAILS

UNION ALL
SELECT 'MX' AS country,
    campaign_id,
    name,
    message_channel,
    created_at,
    first_sent,
    last_sent,
    ARRAY_TO_STRING(tags, ', ') AS str_tags, -- flattens the TAGS array
    lower(str_tags) AS lower_tags, -- Makes all characters lowercase for easier matching in future CASE WHEN statement
    split_part(lower_tags, 'brand/', 2) as split_brand,
    split_part(split_brand, ',', 1) AS lower_brand, -- Pulls the brand from the tag in lower case
    split_part(lower_tags, 'skus/', 2) AS SKU1_STG,
    split_part(SKU1_STG, ',', 1) as SKU1_STG1,
    CASE WHEN SKU1_STG1 LIKE '%, ' THEN LEFT(SKU1_STG1, LENGTH(SKU1_STG1)-2)
    ELSE SKU1_STG1 END AS SKU1,
    split_part(lower_tags, 'skus/', 3) AS SKU2_STG,
    split_part(SKU2_STG, ',', 1) AS SKU2_STG1,
    CASE WHEN SKU2_STG1 LIKE '%, ' THEN LEFT(SKU2_STG1, LENGTH(SKU2_STG1)-2)
    ELSE SKU2_STG1 END AS SKU2,
    SPLIT_PART(lower_tags, 'skus/', 4) AS SKU3_STG,
    SPLIT_PART(SKU3_STG, ',', 1) AS SKU3_STG1,
    CASE WHEN SKU3_STG1 LIKE '%, ' THEN LEFT(SKU3_STG1, LENGTH(SKU3_STG1)-2)
    ELSE SKU3_STG1 END AS SKU3,
    SPLIT_PART(lower_tags, 'skus/', 5) AS SKU4_STG,
    SPLIT_PART(SKU4_STG, ',', 1) AS SKU4_STG1,
    CASE WHEN SKU4_STG1 LIKE '%, ' THEN LEFT(SKU4_STG1, LENGTH(SKU4_STG1)-2)
    ELSE SKU4_STG1 END AS SKU4,
    split_part(lower_tags, 'sku/', 2) AS SKU_STG,
    split_part(SKU_STG, ',', 1) as SKU_STG1,
    CASE WHEN SKU_STG1 LIKE '%, ' THEN LEFT(SKU_STG1, LENGTH(SKU_STG1)-2)
    ELSE SKU_STG1 END AS SKU
FROM BRAZE_PRD.CAMPAIGN_DETAILS.MX_CAMPAIGN_DETAILS

UNION ALL
SELECT 'PA' AS country,
    campaign_id,
    name,
    message_channel,
    created_at,
    first_sent,
    last_sent,
    ARRAY_TO_STRING(tags, ', ') AS str_tags, -- flattens the TAGS array
    lower(str_tags) AS lower_tags, -- Makes all characters lowercase for easier matching in future CASE WHEN statement
    split_part(lower_tags, 'brand/', 2) as split_brand,
    split_part(split_brand, ',', 1) AS lower_brand, -- Pulls the brand from the tag in lower case
    split_part(lower_tags, 'skus/', 2) AS SKU1_STG,
    split_part(SKU1_STG, ',', 1) as SKU1_STG1,
    CASE WHEN SKU1_STG1 LIKE '%, ' THEN LEFT(SKU1_STG1, LENGTH(SKU1_STG1)-2)
    ELSE SKU1_STG1 END AS SKU1,
    split_part(lower_tags, 'skus/', 3) AS SKU2_STG,
    split_part(SKU2_STG, ',', 1) AS SKU2_STG1,
    CASE WHEN SKU2_STG1 LIKE '%, ' THEN LEFT(SKU2_STG1, LENGTH(SKU2_STG1)-2)
    ELSE SKU2_STG1 END AS SKU2,
    SPLIT_PART(lower_tags, 'skus/', 4) AS SKU3_STG,
    SPLIT_PART(SKU3_STG, ',', 1) AS SKU3_STG1,
    CASE WHEN SKU3_STG1 LIKE '%, ' THEN LEFT(SKU3_STG1, LENGTH(SKU3_STG1)-2)
    ELSE SKU3_STG1 END AS SKU3,
    SPLIT_PART(lower_tags, 'skus/', 5) AS SKU4_STG,
    SPLIT_PART(SKU4_STG, ',', 1) AS SKU4_STG1,
    CASE WHEN SKU4_STG1 LIKE '%, ' THEN LEFT(SKU4_STG1, LENGTH(SKU4_STG1)-2)
    ELSE SKU4_STG1 END AS SKU4,
    split_part(lower_tags, 'sku/', 2) AS SKU_STG,
    split_part(SKU_STG, ',', 1) as SKU_STG1,
    CASE WHEN SKU_STG1 LIKE '%, ' THEN LEFT(SKU_STG1, LENGTH(SKU_STG1)-2)
    ELSE SKU_STG1 END AS SKU
FROM BRAZE_PRD.CAMPAIGN_DETAILS.PA_CAMPAIGN_DETAILS

UNION ALL
SELECT 'PE' AS country,
    campaign_id,
    name,
    message_channel,
    created_at,
    first_sent,
    last_sent,
    ARRAY_TO_STRING(tags, ', ') AS str_tags, -- flattens the TAGS array
    lower(str_tags) AS lower_tags, -- Makes all characters lowercase for easier matching in future CASE WHEN statement
    split_part(lower_tags, 'brand/', 2) as split_brand,
    split_part(split_brand, ',', 1) AS lower_brand, -- Pulls the brand from the tag in lower case
    split_part(lower_tags, 'skus/', 2) AS SKU1_STG,
    split_part(SKU1_STG, ',', 1) as SKU1_STG1,
    CASE WHEN SKU1_STG1 LIKE '%, ' THEN LEFT(SKU1_STG1, LENGTH(SKU1_STG1)-2)
    ELSE SKU1_STG1 END AS SKU1,
    split_part(lower_tags, 'skus/', 3) AS SKU2_STG,
    split_part(SKU2_STG, ',', 1) AS SKU2_STG1,
    CASE WHEN SKU2_STG1 LIKE '%, ' THEN LEFT(SKU2_STG1, LENGTH(SKU2_STG1)-2)
    ELSE SKU2_STG1 END AS SKU2,
    SPLIT_PART(lower_tags, 'skus/', 4) AS SKU3_STG,
    SPLIT_PART(SKU3_STG, ',', 1) AS SKU3_STG1,
    CASE WHEN SKU3_STG1 LIKE '%, ' THEN LEFT(SKU3_STG1, LENGTH(SKU3_STG1)-2)
    ELSE SKU3_STG1 END AS SKU3,
    SPLIT_PART(lower_tags, 'skus/', 5) AS SKU4_STG,
    SPLIT_PART(SKU4_STG, ',', 1) AS SKU4_STG1,
    CASE WHEN SKU4_STG1 LIKE '%, ' THEN LEFT(SKU4_STG1, LENGTH(SKU4_STG1)-2)
    ELSE SKU4_STG1 END AS SKU4,
    split_part(lower_tags, 'sku/', 2) AS SKU_STG,
    split_part(SKU_STG, ',', 1) as SKU_STG1,
    CASE WHEN SKU_STG1 LIKE '%, ' THEN LEFT(SKU_STG1, LENGTH(SKU_STG1)-2)
    ELSE SKU_STG1 END AS SKU
FROM BRAZE_PRD.CAMPAIGN_DETAILS.PE_CAMPAIGN_DETAILS

UNION ALL
SELECT 'PY' AS country,
    campaign_id,
    name,
    message_channel,
    created_at,
    first_sent,
    last_sent,
    ARRAY_TO_STRING(tags, ', ') AS str_tags, -- flattens the TAGS array
    lower(str_tags) AS lower_tags, -- Makes all characters lowercase for easier matching in future CASE WHEN statement
    split_part(lower_tags, 'brand/', 2) as split_brand,
    split_part(split_brand, ',', 1) AS lower_brand, -- Pulls the brand from the tag in lower case
    split_part(lower_tags, 'skus/', 2) AS SKU1_STG,
    split_part(SKU1_STG, ',', 1) as SKU1_STG1,
    CASE WHEN SKU1_STG1 LIKE '%, ' THEN LEFT(SKU1_STG1, LENGTH(SKU1_STG1)-2)
    ELSE SKU1_STG1 END AS SKU1,
    split_part(lower_tags, 'skus/', 3) AS SKU2_STG,
    split_part(SKU2_STG, ',', 1) AS SKU2_STG1,
    CASE WHEN SKU2_STG1 LIKE '%, ' THEN LEFT(SKU2_STG1, LENGTH(SKU2_STG1)-2)
    ELSE SKU2_STG1 END AS SKU2,
    SPLIT_PART(lower_tags, 'skus/', 4) AS SKU3_STG,
    SPLIT_PART(SKU3_STG, ',', 1) AS SKU3_STG1,
    CASE WHEN SKU3_STG1 LIKE '%, ' THEN LEFT(SKU3_STG1, LENGTH(SKU3_STG1)-2)
    ELSE SKU3_STG1 END AS SKU3,
    SPLIT_PART(lower_tags, 'skus/', 5) AS SKU4_STG,
    SPLIT_PART(SKU4_STG, ',', 1) AS SKU4_STG1,
    CASE WHEN SKU4_STG1 LIKE '%, ' THEN LEFT(SKU4_STG1, LENGTH(SKU4_STG1)-2)
    ELSE SKU4_STG1 END AS SKU4,
    split_part(lower_tags, 'sku/', 2) AS SKU_STG,
    split_part(SKU_STG, ',', 1) as SKU_STG1,
    CASE WHEN SKU_STG1 LIKE '%, ' THEN LEFT(SKU_STG1, LENGTH(SKU_STG1)-2)
    ELSE SKU_STG1 END AS SKU
FROM BRAZE_PRD.CAMPAIGN_DETAILS.PY_CAMPAIGN_DETAILS

UNION ALL
SELECT 'SV' AS country,
    campaign_id,
    name,
    message_channel,
    created_at,
    first_sent,
    last_sent,
    ARRAY_TO_STRING(tags, ', ') AS str_tags, -- flattens the TAGS array
    lower(str_tags) AS lower_tags, -- Makes all characters lowercase for easier matching in future CASE WHEN statement
    split_part(lower_tags, 'brand/', 2) as split_brand,
    split_part(split_brand, ',', 1) AS lower_brand, -- Pulls the brand from the tag in lower case
    split_part(lower_tags, 'skus/', 2) AS SKU1_STG,
    split_part(SKU1_STG, ',', 1) as SKU1_STG1,
    CASE WHEN SKU1_STG1 LIKE '%, ' THEN LEFT(SKU1_STG1, LENGTH(SKU1_STG1)-2)
    ELSE SKU1_STG1 END AS SKU1,
    split_part(lower_tags, 'skus/', 3) AS SKU2_STG,
    split_part(SKU2_STG, ',', 1) AS SKU2_STG1,
    CASE WHEN SKU2_STG1 LIKE '%, ' THEN LEFT(SKU2_STG1, LENGTH(SKU2_STG1)-2)
    ELSE SKU2_STG1 END AS SKU2,
    SPLIT_PART(lower_tags, 'skus/', 4) AS SKU3_STG,
    SPLIT_PART(SKU3_STG, ',', 1) AS SKU3_STG1,
    CASE WHEN SKU3_STG1 LIKE '%, ' THEN LEFT(SKU3_STG1, LENGTH(SKU3_STG1)-2)
    ELSE SKU3_STG1 END AS SKU3,
    SPLIT_PART(lower_tags, 'skus/', 5) AS SKU4_STG,
    SPLIT_PART(SKU4_STG, ',', 1) AS SKU4_STG1,
    CASE WHEN SKU4_STG1 LIKE '%, ' THEN LEFT(SKU4_STG1, LENGTH(SKU4_STG1)-2)
    ELSE SKU4_STG1 END AS SKU4,
    split_part(lower_tags, 'sku/', 2) AS SKU_STG,
    split_part(SKU_STG, ',', 1) as SKU_STG1,
    CASE WHEN SKU_STG1 LIKE '%, ' THEN LEFT(SKU_STG1, LENGTH(SKU_STG1)-2)
    ELSE SKU_STG1 END AS SKU
FROM BRAZE_PRD.CAMPAIGN_DETAILS.SV_CAMPAIGN_DETAILS

UNION ALL
SELECT 'UY' AS country,
    campaign_id,
    name,
    message_channel,
    created_at,
    first_sent,
    last_sent,
    ARRAY_TO_STRING(tags, ', ') AS str_tags, -- flattens the TAGS array
    lower(str_tags) AS lower_tags, -- Makes all characters lowercase for easier matching in future CASE WHEN statement
    split_part(lower_tags, 'brand/', 2) as split_brand,
    split_part(split_brand, ',', 1) AS lower_brand, -- Pulls the brand from the tag in lower case
    split_part(lower_tags, 'skus/', 2) AS SKU1_STG,
    split_part(SKU1_STG, ',', 1) as SKU1_STG1,
    CASE WHEN SKU1_STG1 LIKE '%, ' THEN LEFT(SKU1_STG1, LENGTH(SKU1_STG1)-2)
    ELSE SKU1_STG1 END AS SKU1,
    split_part(lower_tags, 'skus/', 3) AS SKU2_STG,
    split_part(SKU2_STG, ',', 1) AS SKU2_STG1,
    CASE WHEN SKU2_STG1 LIKE '%, ' THEN LEFT(SKU2_STG1, LENGTH(SKU2_STG1)-2)
    ELSE SKU2_STG1 END AS SKU2,
    SPLIT_PART(lower_tags, 'skus/', 4) AS SKU3_STG,
    SPLIT_PART(SKU3_STG, ',', 1) AS SKU3_STG1,
    CASE WHEN SKU3_STG1 LIKE '%, ' THEN LEFT(SKU3_STG1, LENGTH(SKU3_STG1)-2)
    ELSE SKU3_STG1 END AS SKU3,
    SPLIT_PART(lower_tags, 'skus/', 5) AS SKU4_STG,
    SPLIT_PART(SKU4_STG, ',', 1) AS SKU4_STG1,
    CASE WHEN SKU4_STG1 LIKE '%, ' THEN LEFT(SKU4_STG1, LENGTH(SKU4_STG1)-2)
    ELSE SKU4_STG1 END AS SKU4,
    split_part(lower_tags, 'sku/', 2) AS SKU_STG,
    split_part(SKU_STG, ',', 1) as SKU_STG1,
    CASE WHEN SKU_STG1 LIKE '%, ' THEN LEFT(SKU_STG1, LENGTH(SKU_STG1)-2)
    ELSE SKU_STG1 END AS SKU
FROM BRAZE_PRD.CAMPAIGN_DETAILS.UY_CAMPAIGN_DETAILS

UNION ALL
SELECT 'ZA' AS country,
    campaign_id,
    name,
    message_channel,
    created_at,
    first_sent,
    last_sent,
    ARRAY_TO_STRING(tags, ', ') AS str_tags, -- flattens the TAGS array
    lower(str_tags) AS lower_tags, -- Makes all characters lowercase for easier matching in future CASE WHEN statement
    split_part(lower_tags, 'brand/', 2) as split_brand,
    split_part(split_brand, ',', 1) AS lower_brand, -- Pulls the brand from the tag in lower case
    split_part(lower_tags, 'skus/', 2) AS SKU1_STG,
    split_part(SKU1_STG, ',', 1) as SKU1_STG1,
    CASE WHEN SKU1_STG1 LIKE '%, ' THEN LEFT(SKU1_STG1, LENGTH(SKU1_STG1)-2)
    ELSE SKU1_STG1 END AS SKU1,
    split_part(lower_tags, 'skus/', 3) AS SKU2_STG,
    split_part(SKU2_STG, ',', 1) AS SKU2_STG1,
    CASE WHEN SKU2_STG1 LIKE '%, ' THEN LEFT(SKU2_STG1, LENGTH(SKU2_STG1)-2)
    ELSE SKU2_STG1 END AS SKU2,
    SPLIT_PART(lower_tags, 'skus/', 4) AS SKU3_STG,
    SPLIT_PART(SKU3_STG, ',', 1) AS SKU3_STG1,
    CASE WHEN SKU3_STG1 LIKE '%, ' THEN LEFT(SKU3_STG1, LENGTH(SKU3_STG1)-2)
    ELSE SKU3_STG1 END AS SKU3,
    SPLIT_PART(lower_tags, 'skus/', 5) AS SKU4_STG,
    SPLIT_PART(SKU4_STG, ',', 1) AS SKU4_STG1,
    CASE WHEN SKU4_STG1 LIKE '%, ' THEN LEFT(SKU4_STG1, LENGTH(SKU4_STG1)-2)
    ELSE SKU4_STG1 END AS SKU4,
    split_part(lower_tags, 'sku/', 2) AS SKU_STG,
    split_part(SKU_STG, ',', 1) as SKU_STG1,
    CASE WHEN SKU_STG1 LIKE '%, ' THEN LEFT(SKU_STG1, LENGTH(SKU_STG1)-2)
    ELSE SKU_STG1 END AS SKU
FROM BRAZE_PRD.CAMPAIGN_DETAILS.ZA_CAMPAIGN_DETAILS
)

SELECT country,
    campaign_id,
    name,
    message_channel,
    created_at,
    first_sent,
    last_sent,
    lower_tags AS tags,
    CASE WHEN lower_tags LIKE '%sales%' AND lower_tags NOT LIKE '%algo%' AND lower_tags NOT LIKE '%marketplace%'
            AND lower_tags NOT LIKE '%logistics%' AND lower_tags NOT LIKE '%rewards%'
            AND lower_tags NOT LIKE '%satisfaction%' AND lower_tags NOT LIKE '%survey%' THEN 'Sales'
         WHEN lower_tags LIKE '%algo%' AND lower_tags NOT LIKE '%sales%' AND lower_tags NOT LIKE '%marketplace%'
            AND lower_tags NOT LIKE '%logistics%' AND lower_tags NOT LIKE '%rewards%'
            AND lower_tags NOT LIKE '%satisfaction%' AND lower_tags NOT LIKE '%survey%' THEN 'Algo'
         WHEN lower_tags LIKE '%marketplace%' AND lower_tags NOT LIKE '%algo%' AND lower_tags NOT LIKE '%sales%'
            AND lower_tags NOT LIKE '%logistics%' AND lower_tags NOT LIKE '%rewards%'
            AND lower_tags NOT LIKE '%satisfaction%' AND lower_tags NOT LIKE '%survey%' THEN 'Marketplace'
         WHEN lower_tags LIKE '%logistics%' AND lower_tags NOT LIKE '%algo%' AND lower_tags NOT LIKE '%marketplace%'
            AND lower_tags NOT LIKE '%sales%' AND lower_tags NOT LIKE '%rewards%'
            AND lower_tags NOT LIKE '%satisfaction%' AND lower_tags NOT LIKE '%survey%' THEN 'Logistics'
         WHEN lower_tags LIKE '%rewards%' AND lower_tags NOT LIKE '%algo%' AND lower_tags NOT LIKE '%marketplace%'
            AND lower_tags NOT LIKE '%logistics%' AND lower_tags NOT LIKE '%sales%'
            AND lower_tags NOT LIKE '%satisfaction%' AND lower_tags NOT LIKE '%survey%' THEN 'Rewards'
         WHEN lower_tags LIKE '%satisfaction%' AND lower_tags NOT LIKE '%algo%' AND lower_tags NOT LIKE '%marketplace%'
            AND lower_tags NOT LIKE '%logistics%' AND lower_tags NOT LIKE '%rewards%'
            AND lower_tags NOT LIKE '%sales%' AND lower_tags NOT LIKE '%survey%' THEN 'Satisfaction'
         WHEN lower_tags LIKE '%survey%' AND lower_tags NOT LIKE '%algo%' AND lower_tags NOT LIKE '%marketplace%'
            AND lower_tags NOT LIKE '%logistics%' AND lower_tags NOT LIKE '%rewards%'
            AND lower_tags NOT LIKE '%satisfaction%' AND lower_tags NOT LIKE '%sales%' THEN 'Survey'
         ELSE 'Uncategorized' END AS campaign_type,
    CASE WHEN lower_tags LIKE '%sales/innovation%' THEN 'Innovation'
         WHEN lower_tags LIKE '%sales/promo%' THEN 'Promo'
         WHEN lower_tags LIKE '%sales/imc%' THEN 'IMC'
         WHEN lower_tags LIKE '%sales/key selling%' THEN 'Key Selling'
         WHEN lower_tags LIKE '%sales/engagement%' THEN 'Engagement'
         WHEN lower_tags LIKE '%algo/recommendation%' THEN 'Recommendation'
         WHEN lower_tags LIKE '%algo/quick order%' THEN 'Quick Order'
         WHEN lower_tags LIKE '%algo/promo%' THEN 'Promo'
         WHEN lower_tags LIKE '%marketplace/imc%' THEN 'IMC'
         WHEN lower_tags LIKE '%marketplace/new product%' THEN 'New Product'
         WHEN lower_tags LIKE '%marketplace/promo%' THEN 'Promo'
         WHEN lower_tags LIKE '%logistics/order visibility%' THEN 'Order Visibility'
         WHEN lower_tags LIKE '%logistics/returnable bottles%' THEN 'Returnable Bottles'
         WHEN lower_tags LIKE '%logistics/flex%' THEN 'Flex'
         WHEN lower_tags LIKE '%rewards/photo challenge%' THEN 'Photo Challenge'
         WHEN lower_tags LIKE '%rewards/purchase challenge%' THEN 'Purchase Challenge'
         WHEN lower_tags LIKE '%rewards/sign up%' THEN 'Sign Up'
         WHEN lower_tags LIKE '%rewards/raffle%' THEN 'Raffle'
         WHEN lower_tags LIKE '%rewards/redemption%' THEN 'Redemption'
         WHEN lower_tags LIKE '%rewards/educational%' THEN 'Educational'
         WHEN lower_tags LIKE '%rewards/club b%' THEN 'Club B'
         WHEN lower_tags LIKE '%satisfaction/update%' THEN 'Update'
         WHEN lower_tags LIKE '%satisfaction/rating%' THEN 'Rating'
         WHEN lower_tags LIKE '%satisfaction/holiday%' THEN 'Holiday'
         WHEN lower_tags LIKE '%satisfaction/education' THEN 'Educational'
         WHEN lower_tags LIKE '%survey/nps%' THEN 'NPS'
         ELSE 'Uncategorized' END AS campaign_subtype
         /*,
    CASE WHEN lower_tags LIKE '%program/flex%' THEN 'Flex'
         When lower_tags LIKE '%program/club b%' THEN 'Club B'
         WHEN lower_tags LIKE '%program/social media%' THEN 'Social Media'
         WHEN lower_tags LIKE '%program/returnable bottles%' THEN 'Returnable Bottles'
         WHEN lower_tags LIKE '%program/mi negocio%' THEN 'Mi Negocio'
         WHEN lower_tags LIKE '%program/b2o%' THEN 'B2O'
         WHEN lower_tags LIKE '%sales/b2o%' THEN 'B2O'
         ELSE NULL END AS campaign_program,
    lower_brand AS brand,
    coalesce(NULLIF(sku1, ''), sku) as sku,
    sku2,
    sku3,
    sku4
    */

FROM global_campaign_details
