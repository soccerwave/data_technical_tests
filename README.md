# Senior Data Analyst — Technical Test · Primer Impacto

## Context

Primer Impacto is a field marketing agency. We manage campaigns for FMCG and pharma clients in which field workers visit points of sale (pharmacies, supermarkets, etc.) following assigned routes. During each visit, workers complete a form with questions — checking product facings, training pharmacy staff, recording visit outcomes, etc.

You have been given **10 raw CSV files** that represent a simplified but realistic version of our operational data model. The data corresponds to activity in **2026** across a portfolio of pharma/parafarmacia clients.

Your mission is to clean the data, model it, and extract business insights from it — exactly as you would in your first weeks in the role.

---

## The Data Model

The star schema you need to build:

```
raw_clients
    └── raw_projects
            └── raw_campaigns
                    ├── raw_questions        (form items per campaign)
                    ├── raw_routes
                    │       └── raw_route_employee  (worker assigned to route)
                    │                   └── raw_workers
                    └── raw_visits           (one row per POS visit)
                            ├── raw_pos      (point of sale details)
                            └── raw_responses        (one row per question answered)
```

### Files

| File | Description | Key columns |
|---|---|---|
| `raw_clients.csv` | Clients (pharma companies) | `client_id`, `client_name`, `sector` |
| `raw_projects.csv` | Projects per client | `project_id`, `client_id`, `project_name` |
| `raw_campaigns.csv` | Campaigns per project | `campaign_id`, `project_id`, `campaign_start_date`, `campaign_end_date`, `total_visits_planned` |
| `raw_questions.csv` | Form questions per campaign | `question_id`, `campaign_id`, `question_name`, `question_type`, `question_category` |
| `raw_workers.csv` | Field workers | `employee_id`, `employee_first_name`, `employee_address_province`, `employee_contract_type` |
| `raw_pos.csv` | Points of sale (pharmacies / POS) | `intervention_point_id`, `intervention_point_name`, `intervention_point_province` |
| `raw_routes.csv` | Routes per campaign | `route_id`, `campaign_id`, `route_start_date`, `route_end_date` |
| `raw_route_employee.csv` | Worker ↔ route assignment | `route_employee_id`, `route_id`, `employee_id`, `main_employee` |
| `raw_visits.csv` | Visits to points of sale | `visit_id`, `campaign_id`, `intervention_point_id`, `route_id`, `visit_date`, `visit_status` |
| `raw_responses.csv` | Form answers per visit | `answer_id`, `visit_id`, `question_id`, `question_type`, `answer` |

### Visit status values

| Value | Meaning |
|---|---|
| `OK` | Visit completed successfully |
| `INCID` | Visit completed with an incidence |
| `INFO` | Informational visit (no full report) |
| `NOVIS` | Visit not carried out |

### Question types

| Code | Type |
|---|---|
| `S` | Single selector (pick one option) |
| `M` | Multi selector (pick several options) |
| `N` | Numeric |
| `T` | Free text |
| `D` | Date |

---

## The Challenge

The test has **three phases** that build on each other. You have **one week**.

---

### Phase 1 — EDA & Data Quality (`/eda`)

Deliver a Jupyter notebook (or equivalent) with:

1. **Exploratory Data Analysis** — distributions, nulls, cardinalities, outliers, and date ranges across all tables
2. **Data quality issues** — identify at least 3 problems in the raw data and explain how you would handle them
3. **Star schema proposal** — draw or describe the dimensional model you will build in Phase 2, justifying your grain and dimension choices

---

### Phase 2 — dbt Transformations (`/dbt`) — mandatory

Using **dbt Core** with **DuckDB** (free, local, zero setup) or **BigQuery Sandbox** (free tier):

1. **Staging layer** (`models/staging/stg_*.sql`) — one model per raw CSV: standardise date formats, cast types, trim strings, handle nulls
2. **Marts layer** (`models/marts/`) — at least two business-ready models:
   - `mart_campaign_performance` — campaign-level visit KPIs
   - `mart_visit_responses` — flattened visit + answer table ready for BI consumption
3. **dbt tests** (`tests/`) — at minimum `not_null`, `unique`, and `relationships` tests on primary and foreign keys
4. **`dbt/README.md`** — explain your layer decisions, how to run the project locally, and what you would add with more time

> **DuckDB quickstart:** `pip install dbt-duckdb`. Place the raw CSVs in `/data/raw` (already there) and load them as dbt seeds or external sources. No database credentials needed.

---

### Phase 3 — Dashboard (`/dashboard`)

Using **Power BI**, **Tableau**, **Looker Studio**, or **Python** (Streamlit / Plotly / Seaborn):

Build a dashboard that answers the following business question:

> *"The operations team needs to understand how active campaigns are performing and whether field workers are completing their routes. Management wants a portfolio view across clients and projects."*

**We do not prescribe which metrics to show.** A senior analyst should identify the relevant KPIs from the data and the business context. Some angles worth exploring:

- Campaign execution: planned vs actual visits, completion rate by campaign and client
- Shelf KPIs derived from form responses: product presence, number of facings, out-of-stock rate
- Worker attribution: to get worker-level KPIs you need to join through `raw_route_employee → raw_routes → raw_visits`
- Temporal trends across the Jan–May 2026 window

Deliverable: push a `.pbix`, `.twbx`, Looker Studio link, or Streamlit app to `/dashboard`.

---

## Deliverables summary

```
/eda
  └── eda.ipynb                 (or .html export)

/dbt
  ├── dbt_project.yml
  ├── profiles.yml              (use env vars — do NOT commit credentials)
  ├── README.md
  ├── models/
  │   ├── staging/              stg_*.sql  (one per raw table)
  │   └── marts/                mart_*.sql (at least 2)
  └── tests/                    .yml or .sql test files

/dashboard
  └── <your file, link, or app>
```

Include a **top-level `notes.md`** in your submission with:
- Key decisions you made and why
- Assumptions you had to make
- What you would do with more time

---

## Evaluation criteria

| Area | What we assess |
|---|---|
| SQL & modelling | Star schema quality, correct grain, clean joins |
| dbt | Layer structure, test coverage, documentation |
| EDA | Depth of analysis, ability to spot and explain data quality issues |
| BI / visualisation | Clarity, hierarchy, metric relevance to the business |
| Business judgement | Do the chosen KPIs make sense for a field marketing company? |
| Communication | README clarity, decision justification |

---

## Important notes

- **Justify everything.** For every decision you make — a cleaning choice, a model design, a metric you pick or discard — write down your reasoning. We are as interested in *how you think* as in the final output. An answer without justification will not be evaluated.
- **AI assistance is not recommended.** We want to assess your own analytical thinking and SQL/dbt skills. Using AI-generated code or analysis makes it impossible for us to do that, and it will show in the follow-up conversation.

---

## Getting started

```bash
# clone and create your solution branch
git clone https://github.com/Primer-Impacto/data_technical_tests.git
cd data_technical_tests
git checkout -b solution/<your-name>

# install dbt with DuckDB adapter (recommended)
pip install dbt-duckdb

# verify
dbt --version
```

> Questions? Open an issue in this repo.

Good luck!
