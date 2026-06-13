with source as (

    select *
    from {{ source('raw', 'raw_campaigns') }}

),

casted as (

    select
        cast(campaign_id as string) as campaign_id,
        cast(project_id as string) as project_id,

        campaign_code,
        campaign_name,

        coalesce(
            safe_cast(campaign_start_date as date),
            safe.parse_date('%d/%m/%Y', campaign_start_date)
        ) as campaign_start_date,

        coalesce(
            safe_cast(campaign_end_date as date),
            safe.parse_date('%d/%m/%Y', campaign_end_date)
        ) as campaign_end_date,

        safe_cast(created_at as date) as created_at,
        safe_cast(updated_at_sys as date) as updated_at_sys

    from source

)

select
    *,
    campaign_end_date < campaign_start_date as has_invalid_date_range

from casted