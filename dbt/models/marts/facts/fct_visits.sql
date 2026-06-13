with visits as (

    select *
    from {{ ref('stg_visits') }}

),

deduplicated as (

    select
        *,
        row_number() over (
            partition by visit_id
            order by updated_at_sys desc, created_at desc
        ) as row_num

    from visits

),

final as (

    select
        visit_id,

        campaign_id,
        intervention_point_id,
        route_id,

        campaign_code,
        project_code,
        intervention_point_code,
        route_code,

        visit_date,
        visit_time,
        visit_status,
        visit_type,
        is_client_billable,

        created_at,
        updated_at_sys

    from deduplicated
    where row_num = 1

)

select *
from final