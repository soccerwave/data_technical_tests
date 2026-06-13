with clients as (

    select *
    from {{ ref('stg_clients') }}

),

deduplicated as (

    select
        *,
        row_number() over (
            partition by client_id
            order by updated_at_sys desc, created_at desc
        ) as row_num

    from clients

)

select
    client_id,
    client_name,
    company_id,
    country,
    sector,
    created_at,
    updated_at_sys

from deduplicated
where row_num = 1