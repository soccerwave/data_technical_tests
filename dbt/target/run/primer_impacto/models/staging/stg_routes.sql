

  create or replace view `primer-impacto-test`.`primer_analytics_staging`.`stg_routes`
  OPTIONS()
  as select
    cast(route_id as string) as route_id,
    route_code,
    route_name,

    cast(campaign_id as string) as campaign_id,
    campaign_code,

    safe_cast(route_start_date as date) as route_start_date,
    safe_cast(route_end_date as date) as route_end_date,

    route_status,
    delegation_code,

    safe_cast(recall_mail_sent as bool) as recall_mail_sent,

    safe_cast(created_at as date) as created_at,
    safe_cast(updated_at_sys as date) as updated_at_sys

from `primer-impacto-test`.`primer_raw`.`raw_routes`;

