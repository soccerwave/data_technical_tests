select
    cast(visit_id as string) as visit_id,
    cast(campaign_id as string) as campaign_id,
    campaign_code,
    project_code,

    cast(intervention_point_id as string) as intervention_point_id,
    intervention_point_code,

    cast(route_id as string) as route_id,
    route_code,

    coalesce(
        safe_cast(visit_date as date),
        safe.parse_date('%d/%m/%Y', visit_date)
    ) as visit_date,

    safe_cast(visit_time as time) as visit_time,

    coalesce(visit_status, 'UNKNOWN') as visit_status,
    visit_type,

    safe_cast(is_client_billable as bool) as is_client_billable,

    safe_cast(created_at as date) as created_at,
    safe_cast(updated_at_sys as date) as updated_at_sys

from {{ source('raw', 'raw_visits') }}