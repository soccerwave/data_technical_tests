# Primer Impacto Data Technical Test Notes

## Overview

This project builds a simple analytics layer on top of the raw Primer Impacto CSV files using BigQuery and dbt.

The solution follows this structure:

```text
raw CSV files
→ BigQuery raw tables
→ dbt staging models
→ dbt marts: dimensions, bridge, and fact tables
```

The goal was to keep the solution clear, traceable, and appropriate for a junior data engineering / analytics engineering technical test. I avoided unnecessary complexity such as incremental models, snapshots, custom macros, or external dbt packages.

## Raw data

The raw data contains 10 CSV files:

```text
raw_campaigns
raw_clients
raw_pos
raw_projects
raw_questions
raw_responses
raw_route_employee
raw_routes
raw_visits
raw_workers
```

The raw tables were loaded into BigQuery under the `primer_raw` dataset. dbt reads these tables as sources and writes staging and mart models into analytics schemas.

## Initial EDA findings

The main findings from the exploratory data analysis were:

* `raw_visits` contains 1,762 rows and 1,747 distinct `visit_id` values.
* `raw_responses` contains 10,192 rows.
* Duplicate natural keys were found in:

  * `raw_clients`: 1 duplicate `client_id`
  * `raw_workers`: duplicate `employee_id` values 6 and 11
  * `raw_visits`: 15 duplicate `visit_id` values
* 70 visits reference `route_id` values that do not exist in `raw_routes`.
* `visit_status` has 71 null values.
* `question_type` contains null values in both questions and responses.
* Campaign dates use mixed formats: ISO dates and DD/MM/YYYY dates.
* Two campaigns have `campaign_end_date` earlier than `campaign_start_date`:

  * `campaign_id = 28`
  * `campaign_id = 30`

## Data modeling approach

The project uses a simple raw → staging → marts structure.

The staging layer keeps the original row grain and is used only for light cleaning:

* type casting with `safe_cast`
* date parsing
* basic categorical null handling
* data quality flags
* keeping source-level columns in a cleaner format

I intentionally did not deduplicate rows in staging. Staging models should stay close to the raw data and preserve row counts for traceability. Deduplication is applied in marts, where the final analytical grain is defined.

## Staging layer

The staging layer contains one model per raw source table:

```text
stg_campaigns
stg_clients
stg_pos
stg_projects
stg_questions
stg_responses
stg_route_employee
stg_routes
stg_visits
stg_workers
```

The staging models standardize data types and clean obvious source issues.

Examples:

* `visit_status` null values are converted to `UNKNOWN`.
* dates are parsed using safe casting.
* campaign date ranges are flagged when invalid.
* IDs are cast to strings for consistent joins.
* boolean and numeric fields are safely cast.

The staging layer preserves the row counts from the raw source tables. For example:

```text
stg_campaigns: 72 rows
stg_visits: 1,762 rows
stg_responses: 10,192 rows
```

## Mart layer

The mart layer contains dimension, bridge, and fact models.

Dimensions:

```text
dim_campaigns
dim_clients
dim_pos
dim_projects
dim_questions
dim_routes
dim_workers
```

Bridge table:

```text
bridge_route_employee
```

Fact tables:

```text
fct_visits
fct_responses
```

## Visit grain and deduplication

The raw visits table contains 1,762 rows but only 1,747 unique `visit_id` values.

I kept all rows in `stg_visits` to preserve the raw source grain. Then I created `fct_visits` with one row per `visit_id`.

Duplicate visits were resolved using:

```sql
row_number() over (
    partition by visit_id
    order by updated_at_sys desc, created_at desc
)
```

The final `fct_visits` table contains:

```text
total_rows = 1,747
unique_visit_ids = 1,747
```

This enforces the intended analytical grain: one row per visit.

## Response grain

The responses fact table uses `answer_id` as its grain.

The final `fct_responses` table contains:

```text
total_rows = 10,192
unique_answer_ids = 10,192
```

This confirms that the response fact table keeps one row per answer.

I also added a simple derived field:

```text
is_expected_answer
```

This compares `answer` and `expected_answer` where both values are available.

## Campaign date quality

Campaign dates appeared in mixed formats, including ISO dates and DD/MM/YYYY values.

In `stg_campaigns`, I parsed both formats using:

```sql
coalesce(
    safe_cast(campaign_start_date as date),
    safe.parse_date('%d/%m/%Y', campaign_start_date)
)
```

The same logic was applied to `campaign_end_date`.

Two campaigns have an end date earlier than the start date:

```text
campaign_id = 28
campaign_id = 30
```

I did not correct, null, or drop these rows. Instead, I added a flag:

```text
has_invalid_date_range
```

This keeps the issue visible while preserving the source data.

## Route data quality

There are 70 visits whose `route_id` does not exist in `raw_routes`.

I kept `route_id` in `fct_visits` and added a relationship test against `dim_routes`.

This test is configured with:

```yaml
severity: warn
```

The reason is that the issue is a known source data quality problem found during EDA. Keeping it as a warning makes the issue visible without failing the full dbt test run.

Final dbt test result:

```text
PASS = 31
WARN = 1
ERROR = 0
```

The single warning is the known route relationship issue.

## Worker-route relationship

Workers are not joined directly into `fct_visits`.

The visits table contains `route_id`, but it does not contain `employee_id`. Workers are linked to routes through `raw_route_employee`.

The relationship is:

```text
fct_visits.route_id
→ bridge_route_employee.route_id
→ dim_workers.employee_id
```

Joining workers directly into `fct_visits` could duplicate visit rows if one route has multiple workers. To avoid changing the grain of the visit fact table, I kept this relationship in a separate bridge table:

```text
bridge_route_employee
```

This preserves the intended grain of `fct_visits`.

## dbt tests

The project includes basic dbt tests for:

* primary keys using `not_null` and `unique`
* relationships between facts and dimensions
* relationship checks for bridge tables

Main examples:

* `fct_visits.visit_id` is unique and not null.
* `fct_responses.answer_id` is unique and not null.
* `fct_responses.visit_id` references `fct_visits.visit_id`.
* `fct_responses.question_id` references `dim_questions.question_id`.
* `fct_visits.campaign_id` references `dim_campaigns.campaign_id`.
* `fct_visits.intervention_point_id` references `dim_pos.intervention_point_id`.
* `fct_visits.route_id` references `dim_routes.route_id` with warning severity because of known orphan route IDs.

The final dbt test run completed with:

```text
PASS = 31
WARN = 1
ERROR = 0
```

## Final model structure

The final dbt structure is:

```text
models/
  staging/
    sources.yml
    stg_campaigns.sql
    stg_clients.sql
    stg_pos.sql
    stg_projects.sql
    stg_questions.sql
    stg_responses.sql
    stg_route_employee.sql
    stg_routes.sql
    stg_visits.sql
    stg_workers.sql

  marts/
    schema.yml

    dimensions/
      dim_campaigns.sql
      dim_clients.sql
      dim_pos.sql
      dim_projects.sql
      dim_questions.sql
      dim_routes.sql
      dim_workers.sql

    bridges/
      bridge_route_employee.sql

    facts/
      fct_visits.sql
      fct_responses.sql
```

## Final validation

The full dbt project runs successfully:

```bash
dbt run
```

The tests also complete without errors:

```bash
dbt test
```

Final result:

```text
31 tests passed
1 warning
0 errors
```

The warning corresponds to the 70 visits with route IDs missing from the route dimension, which was identified during EDA and intentionally kept visible as a data quality warning.
