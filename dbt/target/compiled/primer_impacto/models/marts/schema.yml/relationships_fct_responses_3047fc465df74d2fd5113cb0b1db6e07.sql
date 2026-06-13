
    
    

with child as (
    select question_id as from_field
    from `primer-impacto-test`.`primer_analytics_marts`.`fct_responses`
    where question_id is not null
),

parent as (
    select question_id as to_field
    from `primer-impacto-test`.`primer_analytics_marts`.`dim_questions`
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


