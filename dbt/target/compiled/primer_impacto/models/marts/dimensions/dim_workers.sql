with workers as (

    select *
    from `primer-impacto-test`.`primer_analytics_staging`.`stg_workers`

),

deduplicated as (

    select
        *,
        row_number() over (
            partition by employee_id
            order by updated_at_sys desc, created_at desc
        ) as row_num

    from workers

)

select
    employee_id,
    employee_first_name,
    employee_active_status,
    employee_hire_date,
    employee_address_province,
    employee_contract_type,
    company_id,
    created_at,
    updated_at_sys

from deduplicated
where row_num = 1