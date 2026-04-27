# LLM Comment Sentiment Pipeline

This project builds an end-to-end data pipeline that extracts user comments from a public API, enriches them with simulated product feedback, applies LLM-based sentiment analysis using Gemini, and loads the structured output into BigQuery.

## Pipeline

Comments API → Python → Gemini → BigQuery → Validation query

## Tech Stack

- Python
- Pandas
- Requests
- Google Gemini
- BigQuery
- Google Cloud SDK

## Features

- API data extraction
- JSON parsing
- LLM-based sentiment classification
- Mixed public and simulated product feedback
- BigQuery load job with explicit schema
- Validation queries for downstream analytics

## Notes

The project uses public comments from DummyJSON and simulated product feedback to generate a more balanced sentiment distribution across positive, neutral, and negative examples.

API keys are not included in this repository. Use environment variables or a local `.env` file to store credentials.