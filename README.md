# Cohort Analysis & Retention Rate

## 📊 Description
This project analyzes user retention and acquisition quality using cohort analysis.

The goal is to understand how users behave over time and compare retention between promo and organic users.

## 🛠 Tools
- SQL (PostgreSQL)
- Google Sheets

## 🔍 What was done
- Cleaned and standardized dates with different formats using SQL (CTE, CASE, REGEXP_REPLACE, TO_DATE)
- Joined users and events tables
- Calculated cohort_month and month_offset
- Built cohort table for user analysis
- Calculated Retention Rate
- Created interactive dashboard in Google Sheets
- Compared promo vs organic users

## 📈 Result
Identified differences in retention between promo and organic users, allowing evaluation of acquisition quality.

## 🔗 Links
- Google Sheets: https://docs.google.com/spreadsheets/d/1oYie15PXTGNv0Rw95D-YaHkQt5K2jSWjA8AauZfR-Dc/edit
- SQL Script: https://github.com/Viktor0018-lgtm/cohort-analysis-retention/blob/main/cohort_analysis.sql
