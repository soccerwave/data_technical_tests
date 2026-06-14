select
    cast(client_id as string) as client_id,

    client_name,
    cast(company_id as string) as company_id,

    case
        when lower(trim(country)) in ('spain', 'españa') then 'Spain'
        else initcap(trim(country))
    end as country,

    sector,

    safe_cast(created_at as date) as created_at,
    safe_cast(updated_at_sys as date) as updated_at_sys

from {{ source('raw', 'raw_clients') }}