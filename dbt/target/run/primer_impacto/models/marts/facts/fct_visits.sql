
  
    

    create or replace table `primer-impacto-test`.`primer_analytics_marts`.`fct_visits`
      
    
    

    
    OPTIONS()
    as (
      with visits as (

    select *
    from `primer-impacto-test`.`primer_analytics_staging`.`stg_visits`

),

routes as (

    select
        route_id
    from `primer-impacto-test`.`primer_analytics_marts`.`dim_routes`

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
        v.visit_id,

        v.campaign_id,
        v.intervention_point_id,
        v.route_id,

        v.campaign_code,
        v.project_code,
        v.intervention_point_code,
        v.route_code,

        v.visit_date,
        v.visit_time,
        v.visit_status,
        v.visit_type,
        v.is_client_billable,

        case
            when v.route_id is not null
             and r.route_id is null
            then true
            else false
        end as has_missing_route_reference,

        v.created_at,
        v.updated_at_sys

    from deduplicated v
    left join routes r
        on v.route_id = r.route_id

    where v.row_num = 1

)

select *
from final
    );
  