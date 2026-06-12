\# Notes



\## EDA Summary



The raw data is usable, but needs some cleaning before building marts.



Main findings:

\- `raw\_responses` has 10,192 rows, while `raw\_visits` has 1,762 rows and 1,747 unique visits. I will model visits and responses separately.

\- Duplicate keys exist in `raw\_clients`, `raw\_workers`, and `raw\_visits`.

\- 70 visits reference route IDs that do not exist in `raw\_routes`.

\- 71 visits have missing `visit\_status`; these should be treated as `UNKNOWN`, not `NOVIS`.

\- 28 questions have missing `question\_type`.

\- Campaign dates use mixed formats: 60 ISO values and 12 DD/MM/YYYY values.

\- 2 campaigns have an end date earlier than the start date.



\## Modeling Notes



Main grain:

\- `raw\_visits`: one row per visit attempt

\- `raw\_responses`: one row per answer

\- `raw\_campaigns`: one row per campaign

\- `raw\_route\_employee`: one row per route-worker assignment



Planned model:

\- `fct\_visits`

\- `fct\_responses`

\- dimensions for clients, projects, campaigns, workers, routes, POS, and questions



The staging layer will handle deduplication, date parsing, missing categorical values, and data quality flags before the marts are built.

