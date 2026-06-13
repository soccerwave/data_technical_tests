

  create or replace view `primer-impacto-test`.`primer_analytics_staging`.`stg_campaigns`
  OPTIONS()
  as select
    cast(campaign_id as string) as campaign_id,
    campaign_code,
    campaign_name,

    cast(project_id as string) as project_id,
    project_code,
    client_code,

    coalesce(
        safe_cast(campaign_start_date as date),
        safe.parse_date('%d/%m/%Y', campaign_start_date)
    ) as campaign_start_date,

    coalesce(
        safe_cast(campaign_end_date as date),
        safe.parse_date('%d/%m/%Y', campaign_end_date)
    ) as campaign_end_date,

    safe_cast(is_active as bool) as is_active,
    cast(campaign_state_id as string) as campaign_state_id,
    campaign_state,

    safe_cast(total_visits_planned as int64) as total_visits_planned,
    safe_cast(total_pos_planned as int64) as total_pos_planned,
    safe_cast(visit_duration_minutes as int64) as visit_duration_minutes,

    safe_cast(created_at as date) as created_at,
    safe_cast(updated_at_sys as date) as updated_at_sys,

    coalesce(
        safe_cast(campaign_end_date as date),
        safe.parse_date('%d/%m/%Y', campaign_end_date)
    ) <
    coalesce(
        safe_cast(campaign_start_date as date),
        safe.parse_date('%d/%m/%Y', campaign_start_date)
    ) as has_invalid_date_range

from `primer-impacto-test`.`primer_raw`.`raw_campaigns`;

