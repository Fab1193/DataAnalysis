WITH facebook_ads AS (
    SELECT
        DATE(date) AS date,
        'Facebook Ads' AS platform,
        CAST(campaign_id AS STRING) AS campaign_id,
        CAST(campaign_name AS STRING) AS campaign_name,
        CAST(ad_set_id AS STRING) AS ad_set_id,
        CAST(impressions AS INT64) AS impressions,
        CAST(clicks AS INT64) AS clicks,
        CAST(spend AS FLOAT64) AS cost,
        CAST(0 AS FLOAT64) AS revenue,
        CAST(conversions AS INT64) AS conversions
    FROM `your_project.your_dataset.facebook_ads`
),

google_ads AS (
    SELECT
        DATE(date) AS date,
        'Google Ads' AS platform,
        CAST(campaign_id AS STRING) AS campaign_id,
        CAST(campaign_name AS STRING) AS campaign_name,
        CAST(ad_group_id AS STRING) AS ad_set_id,
        CAST(impressions AS INT64) AS impressions,
        CAST(clicks AS INT64) AS clicks,
        CAST(cost AS FLOAT64) AS cost,
        CAST(conversion_value AS FLOAT64) AS revenue,
        CAST(conversions AS INT64) AS conversions
    FROM `your_project.your_dataset.google_ads`
),

tiktok_ads AS (
    SELECT
        DATE(date) AS date,
        'TikTok Ads' AS platform,
        CAST(campaign_id AS STRING) AS campaign_id,
        CAST(campaign_name AS STRING) AS campaign_name,
        CAST(adgroup_id AS STRING) AS ad_set_id,
        CAST(impressions AS INT64) AS impressions,
        CAST(clicks AS INT64) AS clicks,
        CAST(cost AS FLOAT64) AS cost,
        CAST(0 AS FLOAT64) AS revenue,
        CAST(conversions AS INT64) AS conversions
    FROM `your_project.your_dataset.tiktok_ads`
),

unioned_ads AS (
    SELECT * FROM facebook_ads
    UNION ALL
    SELECT * FROM google_ads
    UNION ALL
    SELECT * FROM tiktok_ads
),

aggregated_ads AS (
    SELECT
        date,
        platform,
        campaign_id,
        campaign_name,
        COUNT(DISTINCT ad_set_id) AS ad_sets_count,
        SUM(impressions) AS impressions,
        SUM(clicks) AS clicks,
        SUM(cost) AS cost,
        SUM(revenue) AS revenue,
        SUM(conversions) AS conversions
    FROM unioned_ads
    GROUP BY 1, 2, 3, 4
)

SELECT
    date,
    platform,
    campaign_id,
    campaign_name,
    ad_sets_count,
    impressions,
    clicks,
    cost,
    revenue,
    conversions,
    SAFE_DIVIDE(clicks, impressions) AS ctr,
    SAFE_DIVIDE(cost, clicks) AS cpc,
    SAFE_DIVIDE(cost, impressions) * 1000 AS cpm,
    SAFE_DIVIDE(conversions, clicks) AS cvr,
    SAFE_DIVIDE(cost, conversions) AS cpa,
    SAFE_DIVIDE(revenue, cost) AS roas
FROM aggregated_ads
ORDER BY date, platform, campaign_id;
