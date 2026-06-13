select
    cast(employee_id as string) as employee_id,

    employee_first_name,
    employee_active_status,
    safe_cast(employee_hire_date as date) as employee_hire_date,
    employee_address_province,
    employee_contract_type,

    cast(company_id as string) as company_id,

    safe_cast(created_at as date) as created_at,
    safe_cast(updated_at_sys as date) as updated_at_sys

from {{ source('raw', 'raw_workers') }}