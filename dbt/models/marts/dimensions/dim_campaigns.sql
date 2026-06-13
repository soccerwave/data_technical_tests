with campaigns as (

    select *
    from {{ ref('stg_campaigns') }}

),

deduplicated as (

    select
        *,
        row_number() over (
            partition by campaign_id
            order by updated_at_sys desc, created_at desc
        ) as row_num

    from campaigns

)

select
    campaign_id,
    project_id,
    campaign_code,
    campaign_name,
    campaign_start_date,
    campaign_end_date,
    has_invalid_date_range,
    created_at,
    updated_at_sys

from deduplicated
where row_num = 1