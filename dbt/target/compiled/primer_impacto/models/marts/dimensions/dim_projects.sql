with projects as (

    select *
    from `primer-impacto-test`.`primer_analytics_staging`.`stg_projects`

),

deduplicated as (

    select
        *,
        row_number() over (
            partition by project_id
            order by updated_at_sys desc, created_at desc
        ) as row_num

    from projects

)

select
    project_id,
    client_id,
    project_code,
    project_name,
    client_code,
    project_exportable,
    created_at,
    updated_at_sys

from deduplicated
where row_num = 1