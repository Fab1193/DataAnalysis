# Data & Analytics Portfolio – Fabricio Quesada

This repository showcases a collection of projects focused on data analytics, product insights, and data engineering workflows.

My work centers around building end-to-end data solutions, including data extraction, transformation, modeling, and analysis to support product and business decision-making.

## Areas of Focus

- Product Analytics (funnels, conversion, retention)
- Data Modeling (BigQuery, Dataform, dbt, SQL)
- Data Pipelines (API ingestion, data workflows)
- Experimentation & A/B testing
- Applied Machine Learning & LLM-based analysis

## Projects

### Data Analysis

- [Marketing Ads Performance Dashboard](data_analysis/marketing_ads_performance_dashboard)  
  Consolidated Facebook Ads, Google Ads, and TikTok Ads data into a unified BigQuery-style table and built a Looker Studio dashboard to analyze cost, revenue, conversions, CPA, CVR, CTR, and ROAS.

- [Apple Product Pricing Analysis](data_analysis/apple-pricing)  
  Cross-country product pricing analysis comparing Apple product prices across multiple countries.

- [Heart Disease Classification](data_analysis/heart-disease)  
  Machine learning classification project focused on predicting heart disease using patient-level health indicators.

### SQL Analytics

- [Customer Purchase Journey SQL](sql/customer_purchase_journey/daily_customer_purchase_journey.sql)  
  BigQuery SQL script that models a daily customer-level ecommerce purchase journey. It tracks customers from landing page view to order confirmation, identifies the last completed step, classifies exit stages, and calculates minutes to purchase.

### Data Pipelines

- [FX Rates API Pipeline](https://github.com/Fab1193/DataAnalysis/blob/main/data_engineering/fx-rates-api-pipeline/fx_rates_api_pipeline.ipynb)  
  End-to-end pipeline extracting FX rates from an API and loading the data into BigQuery.

- [LLM Comment Sentiment Pipeline](https://github.com/Fab1193/DataAnalysis/tree/main/data_engineering/llm-comment-sentiment-pipeline)  
  Pipeline that enriches user comments with LLM-based sentiment analysis using Gemini and stores the results in BigQuery.