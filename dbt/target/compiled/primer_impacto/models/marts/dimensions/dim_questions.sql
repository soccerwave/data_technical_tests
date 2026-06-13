with questions as (

    select *
    from `primer-impacto-test`.`primer_analytics_staging`.`stg_questions`

),

deduplicated as (

    select
        *,
        row_number() over (
            partition by question_id
            order by updated_at_sys desc, created_at desc
        ) as row_num

    from questions

)

select
    question_id,
    campaign_id,
    campaign_code,
    question_code,
    question_name,
    question_type,
    question_category,
    question_order,
    question_is_highlighted,
    image_associated,
    created_at,
    updated_at_sys

from deduplicated
where row_num = 1