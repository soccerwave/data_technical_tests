

  create or replace view `primer-impacto-test`.`primer_analytics_staging`.`stg_questions`
  OPTIONS()
  as select
    cast(question_id as string) as question_id,
    cast(campaign_id as string) as campaign_id,

    campaign_code,
    question_code,
    question_name,

    coalesce(question_type, 'UNKNOWN') as question_type,
    question_category,

    safe_cast(question_order as int64) as question_order,
    safe_cast(question_is_highlighted as bool) as question_is_highlighted,
    safe_cast(image_associated as bool) as image_associated,

    safe_cast(created_at as date) as created_at,
    safe_cast(updated_at_sys as date) as updated_at_sys

from `primer-impacto-test`.`primer_raw`.`raw_questions`;

