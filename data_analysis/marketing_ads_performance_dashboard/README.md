# Marketing Ads Performance Dashboard

## Overview

This project analyzes paid media performance across Facebook Ads, Google Ads, and TikTok Ads.

The objective was to consolidate data from multiple ad platforms into a unified reporting table and build a dashboard to monitor key marketing KPIs such as cost, revenue, impressions, clicks, conversions, CPA, CPC, CPM, CVR, CTR, and ROAS.

## Data Sources

The project uses three ad platform datasets:

- Facebook Ads
- Google Ads
- TikTok Ads

Each dataset was standardized and combined into a single table with a consistent schema.

## Final Table Schema

| Field | Description |
|---|---|
| date | Reporting date |
| platform | Advertising platform |
| campaign_id | Campaign identifier |
| campaign_name | Campaign name |
| ad_sets_count | Number of ad sets or ad groups |
| impressions | Total impressions |
| clicks | Total clicks |
| cost | Total ad spend |
| revenue | Revenue attributed to campaigns |
| conversions | Total conversions |
| ctr | Click-through rate |
| cpc | Cost per click |
| cpm | Cost per mille |
| cvr | Conversion rate |
| cpa | Cost per acquisition |
| roas | Return on ad spend |

## Metrics Logic

```sql
ctr = SAFE_DIVIDE(clicks, impressions)
cpc = SAFE_DIVIDE(cost, clicks)
cpm = SAFE_DIVIDE(cost, impressions) * 1000
cvr = SAFE_DIVIDE(conversions, clicks)
cpa = SAFE_DIVIDE(cost, conversions)
roas = SAFE_DIVIDE(revenue, cost)
```

## Dashboard Preview (https://datastudio.google.com/reporting/7a159557-31ae-4254-af14-246e57ba64a1)

![Looker Studio Dashboard](images/looker_dashboard.png)

## Key Insights

- **Facebook Ads showed the strongest acquisition efficiency**, with the lowest cost per acquisition and a solid conversion rate. It also had a strong click-through rate, suggesting that the ads generated meaningful engagement.

- **Google Ads delivered strong business performance**, especially in terms of ROAS. The best-performing campaign overall came from Google Ads, indicating that this platform is generating valuable returns.

- **TikTok Ads drove the highest reach**, but its performance was weaker from an efficiency and return perspective. None of its campaigns ranked among the top-performing campaigns, which suggests that the current campaign strategy may need to be reviewed.

## Recommendations

- Redirect more budget toward **Facebook Ads**, given its strong CPA and conversion performance.
- Continue investing in the **top-performing Google Ads campaign**, since it shows strong ROAS and business value.
- Review and redesign **TikTok Ads campaigns** to improve efficiency, especially around conversion quality and cost effectiveness.
- Since ROAS is only available for Google Ads, CPA and CVR should be monitored closely across all platforms to better compare campaign productivity.

## Next Steps

- Analyze campaign performance individually, since each campaign may have a different objective.
- Separate traffic campaigns from awareness campaigns, as the most relevant success metrics may differ depending on campaign type.
- For traffic campaigns, prioritize metrics such as CTR, CPC, CVR, and CPA.
- For awareness campaigns, prioritize reach, impressions, CPM, and engagement indicators.

## Tools Used

- BigQuery SQL
- Looker Studio
- CSV
- GitHub