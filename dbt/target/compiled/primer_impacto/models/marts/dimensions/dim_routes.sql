with routes as (

    select *
    from `primer-impacto-test`.`primer_analytics_staging`.`stg_routes`

),

deduplicated as (

    select
        *,
        row_number() over (
            partition by route_id
            order by updated_at_sys desc, created_at desc
        ) as row_num

    from routes

)

select
    route_id,
    campaign_id,
    campaign_code,
    route_code,
    route_name,
    route_start_date,
    route_end_date,
    route_status,
    delegation_code,
    recall_mail_sent,
    created_at,
    updated_at_sys

from deduplicated
where row_num = 1