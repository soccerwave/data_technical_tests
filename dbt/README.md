# dbt project

This folder contains the dbt models used to transform the raw CSV data into analytical tables for the dashboard.

I used BigQuery for the transformation layer. The raw CSV files were loaded into a raw dataset first, and dbt reads from those raw tables using the sources defined in the staging layer.

## How to run

From this folder:

```bash
dbt debug
dbt run
dbt test
```

`dbt debug` checks that the BigQuery connection and the profile are working.

`dbt run` builds the staging models, dimensions, facts and reporting marts.

`dbt test` runs the schema tests defined for the models.

## Project structure

```text
models/
├── staging/
│   ├── sources.yml
│   └── stg_*.sql
│
└── marts/
    ├── dimensions/
    ├── facts/
    ├── reporting/
    └── schema.yml
```

## Staging layer

Staging layer

The staging layer has one model per raw table. I used this layer mainly to:

- cast IDs and dates to consistent types
- trim and standardise text fields
- standardise country and province fields used in geographic reporting
- parse campaign and visit dates that appear in more than one format
- replace missing visit_status values with UNKNOWN
- keep source records visible instead of dropping them too early

I tried to keep the staging models close to the raw data, but with cleaner column types and more consistent values. For example, I standardised country and province labels so that the same location would not appear as separate categories in the dashboard because of casing, accents, or spelling variations.

## Mart layer

The mart layer is split into dimensions, facts and reporting models.

The main dimension tables are:

- `dim_clients`
- `dim_projects`
- `dim_campaigns`
- `dim_pos`
- `dim_routes`
- `dim_questions`
- `dim_workers`

The main fact tables are:

- `fct_visits`
- `fct_responses`

I also kept `bridge_route_employee` as a separate bridge table because a route can have more than one worker assigned to it.

The two reporting marts are:

- `mart_campaign_performance`
- `mart_visit_responses`

`mart_campaign_performance` gives one row per campaign with planned visits, recorded visits and visit-status counts.

`mart_visit_responses` is a flattened table at response level. It joins visit, campaign, route, point-of-sale and question information to each response.

## Main modelling choices

The grain of `fct_visits` is one row per unique `visit_id`. The raw visits table had duplicate visit IDs, so the fact table deduplicates them.

The grain of `fct_responses` is one row per `answer_id`.

For worker analysis, I did not join all route workers directly to visits. A route can have more than one worker, so that would duplicate visit counts. Instead, worker-level metrics are based on the worker marked as `main_employee = true`.

The worker table has 45 workers, but only 34 appear as main workers in the route assignment data. This is why the dashboard uses “Main Workers” rather than total workers for the worker activity page.

I also created a worker label using the first name and employee ID together, because first names are not unique.

## What I would add with more time

With more time, I would focus more on the route and worker logic. Some visits cannot be linked clearly to a main worker, and some route IDs do not match cleanly across tables. I kept these cases visible, but in a real project I would check them with the operations team before treating them as errors.

I would also confirm the exact definition of a completed route. The visit statuses are available, but route completion is not directly defined, so I avoided creating a KPI that might look precise but be wrong.