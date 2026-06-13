
    
    

with child as (
    select route_id as from_field
    from `primer-impacto-test`.`primer_analytics_marts`.`fct_visits`
    where route_id is not null
),

parent as (
    select route_id as to_field
    from `primer-impacto-test`.`primer_analytics_marts`.`dim_routes`
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


