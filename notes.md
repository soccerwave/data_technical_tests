# Notes

## General approach

I first checked the raw files to understand the main tables, keys and data quality issues. After that I created staging models in dbt to clean types, parse dates and standardise some fields. Then I built a dimensional model with facts, dimensions and a bridge table for route-worker assignments.

I used a star schema because the data has clear entities such as clients, projects, campaigns, routes, workers, points of sale, visits and responses. This also made the Power BI model easier to work with, especially for slicers and relationships.

The main fact tables are:

* `fct_visits`: one row per unique visit.
* `fct_responses`: one row per answer/response.

The main dimensions are campaigns, clients, projects, points of sale, routes, questions and workers. I also kept `bridge_route_employee` as a separate table because routes can have more than one worker.

I also added two reporting marts: `mart_campaign_performance` and `mart_visit_responses`.

## Data quality findings

The raw visits table has 1,762 rows but 1,747 unique `visit_id` values. I used the unique visit ID as the grain of `fct_visits`, so recorded visits are counted as distinct visits.

There were missing values in `visit_status`. I did not remove those visits. I labelled them as `UNKNOWN` so they can still be counted and reviewed in the dashboard.

Campaign dates had more than one format, so I parsed both ISO dates and `DD/MM/YYYY` dates. I also found two campaigns where the end date is earlier than the start date. I kept these rows and flagged them with `has_invalid_date_range`.

There are 70 visits with a `route_id` that does not exist in the routes dimension. I kept these visits and flagged them with `has_missing_route_reference`. This is a source data issue, not something I wanted to hide by removing records.

Some responses also have missing `question_id` values. I kept those response rows because they are still real responses, but they cannot always be linked to a known question.

## Worker and route logic

The worker part needed extra care because a route can have more than one worker assigned. If I joined all workers directly to visits, the same visit could be counted more than once. To avoid this, worker-level metrics are based on `main_employee = true`.

There are 45 workers in the worker master table, but only 34 workers appear as main workers in the route assignment data. For that reason, the worker dashboard shows `Main Workers = 34`. The 45 workers represent all workers in the source table, while 34 represents workers actually used as main workers for routes in this dataset.

Worker first names are not unique, so I created a `worker_label` using first name and employee ID together. This avoids grouping different people under the same first name in the dashboard.

There are 1,747 recorded visits in total. Of these, 1,522 can be linked to a main worker through the route assignment table. The remaining 225 visits cannot be linked to a main worker. This is why the worker dashboard separates total recorded visits from worker-linked visits.

## KPI definitions

* Planned Visits: sum of planned visits from campaigns.
* Recorded Visits: distinct count of visit IDs after deduplication.
* Recorded / Planned Rate: recorded visits divided by planned visits.
* Total Campaigns: distinct count of campaigns.
* Active Campaigns: campaigns where `campaign_state = 'Activa'`.
* Missing Route References: visits with route IDs missing from the route dimension.
* Main Workers: workers assigned as main workers on routes.
* Assigned Routes: routes with a main-worker assignment.
* Worker-linked Visits: visits linked to a main worker through route assignment.
* Visits without Main Worker: recorded visits that cannot be linked to a main worker.

## Dashboard decisions

The dashboard has three pages.

`Portfolio Overview` gives a high-level view across clients, projects and campaigns.

`Campaign & Route Performance` focuses on planned vs recorded visits, campaign performance and route status.

`Worker & Route Activity` focuses on main-worker assignments and visit outcomes by worker.
## Main assumptions

* `visit_id` is the unique key for visits.
* `answer_id` is the unique key for responses.
* `main_employee = true` identifies the main worker for route-level worker analysis.
* Worker-level visit counts should use main workers only to avoid double-counting.
* Data quality issues should be flagged and shown, not removed without business confirmation.
* `campaign_state = 'Activa'` is used for active campaign counting in the dashboard.