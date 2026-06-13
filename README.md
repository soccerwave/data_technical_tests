# Data Technical Test

## Overview

This project analyses campaign, route, visit and response data for Primer Impacto. The goal was to review the raw data, build a cleaned analytical model with dbt and BigQuery, and create a Power BI dashboard for business users.

The final dashboard is designed to help two main audiences:

* Operations teams, who need to understand campaign execution, route activity and field-worker assignments.
* Management teams, who need a higher-level view across clients, projects and campaigns.

The project includes exploratory analysis, dbt models, dbt tests, documentation notes and a Power BI dashboard.

---

## Repository structure

```text
data_technical_tests/
│
├── dashboard/
│   ├── primer-impacto-test.pbix
│   ├── executive_dashboard_screenshot.png
│   ├── campaign_performance_screenshot.png
│   └── worker_dashboard_screenshot.png
│
├── dbt/
│   ├── models/
│   │   ├── staging/
│   │   └── marts/
│   │       ├── dimensions/
│   │       ├── facts/
│   │       ├── reporting/
│   │       └── schema.yml
│   ├── dbt_project.yml
│   └── README.md
│
├── eda/
│   └── eda.ipynb
│
├── notes.md
└── README.md
```

---

## Data sources

The raw data contains ten CSV files:

* `raw_campaigns`
* `raw_clients`
* `raw_pos`
* `raw_projects`
* `raw_questions`
* `raw_responses`
* `raw_route_employee`
* `raw_routes`
* `raw_visits`
* `raw_workers`

The files were loaded into BigQuery as raw tables. dbt was then used to create staging models, dimensions, facts and reporting marts.

---

## dbt model structure

The dbt project has three main layers.

### Staging layer

The staging models clean and standardise the raw data. This includes casting IDs and dates, parsing mixed date formats, standardising missing visit statuses and preparing the raw tables for modelling.

### Mart layer

The mart layer contains the dimensional model used for analysis:

* `dim_campaigns`
* `dim_clients`
* `dim_projects`
* `dim_pos`
* `dim_routes`
* `dim_questions`
* `dim_workers`
* `fct_visits`
* `fct_responses`
* `bridge_route_employee`

The model follows a star-schema approach. Visits and responses are kept as fact tables, while clients, projects, campaigns, routes, workers, points of sale and questions are kept as dimensions.

The `bridge_route_employee` table is kept separately because routes can be linked to more than one worker.

### Reporting marts

Two additional business-ready marts are included:

* `mart_campaign_performance`
* `mart_visit_responses`

`mart_campaign_performance` gives campaign-level metrics such as planned visits, recorded visits, recorded/planned rate and visit status counts.

`mart_visit_responses` provides a flattened table combining visits, responses, questions, campaigns, routes and points of sale. This is useful for response-level analysis.

---

## Running the dbt project


The project was developed using BigQuery as the data warehouse.

One known data quality issue is that some visits contain route IDs that do not exist in the route dimension. These records are kept and flagged in the model because they represent a real source-data issue. The details are explained in `notes.md`.

---

## Dashboard

The Power BI dashboard is available in the `dashboard/` folder:

```text
dashboard/primer-impacto-test.pbix
```

Screenshots are also included:

```text
dashboard/executive_dashboard_screenshot.png
dashboard/campaign_performance_screenshot.png
dashboard/worker_dashboard_screenshot.png
```

The dashboard has three pages.

### 1. Portfolio Overview

This page gives a management level view of clients, projects and campaigns. It shows planned visits, recorded visits, recorded/planned rate, total campaigns and active campaigns.

### 2. Campaign & Route Performance

This page focuses on campaign execution and route status. It compares planned and recorded visits and highlights missing route references.

### 3. Worker & Route Activity

This page focuses on field worker and route activity. Worker level metrics are based on main-worker assignments to avoid double-counting visits when a route has more than one worker.

---

## Main dashboard metrics

Some of the main final metrics are:

* Planned Visits: 16,768
* Recorded Visits: 1,747
* Recorded / Planned Rate: 10.42%
* Total Campaigns: 72
* Active Campaigns: 16
* Missing Route References: 70
* Main Workers: 34
* Assigned Routes: 241
* Worker-linked Visits: 1,522
* Visits without Main Worker: 225
* NOVIS Visits linked to main workers: 119

These metrics are explained in more detail in `notes.md`.

---

## Notes

The file `notes.md` contains the main assumptions, data quality findings, KPI definitions and dashboard design decisions.