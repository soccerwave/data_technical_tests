select
    cast(employee_id as string) as employee_id,

    trim(cast(employee_first_name as string)) as employee_first_name,
    safe_cast(employee_active_status as bool) as employee_active_status,
    safe_cast(employee_hire_date as date) as employee_hire_date,

    case
        when employee_address_province is null then null
        when lower(trim(cast(employee_address_province as string))) in ('zamora') then 'Zamora'
        when lower(trim(cast(employee_address_province as string))) in ('valladolid') then 'Valladolid'
        when lower(trim(cast(employee_address_province as string))) in ('madrid') then 'Madrid'
        when lower(trim(cast(employee_address_province as string))) in ('asturias') then 'Asturias'
        when lower(trim(cast(employee_address_province as string))) in ('tarragona') then 'Tarragona'
        when lower(trim(cast(employee_address_province as string))) in ('pontevedra') then 'Pontevedra'
        when lower(trim(cast(employee_address_province as string))) in ('castelló', 'castellon', 'castellón') then 'Castellón'
        when lower(trim(cast(employee_address_province as string))) in ('rioja, la', 'la rioja') then 'La Rioja'
        when lower(trim(cast(employee_address_province as string))) in ('palmas, las') then 'Las Palmas'
        when lower(trim(cast(employee_address_province as string))) in ('ciudad real') then 'Ciudad Real'
        when lower(trim(cast(employee_address_province as string))) in ('santa cruz de tenerife') then 'Santa Cruz de Tenerife'
        when lower(trim(cast(employee_address_province as string))) in ('málaga', 'malaga') then 'Málaga'
        when lower(trim(cast(employee_address_province as string))) in ('badajoz') then 'Badajoz'
        when lower(trim(cast(employee_address_province as string))) in ('lugo') then 'Lugo'
        else initcap(trim(cast(employee_address_province as string)))
    end as employee_address_province,

    trim(cast(employee_contract_type as string)) as employee_contract_type,

    cast(company_id as string) as company_id,

    safe_cast(created_at as date) as created_at,
    safe_cast(updated_at_sys as date) as updated_at_sys

from {{ source('raw', 'raw_workers') }}