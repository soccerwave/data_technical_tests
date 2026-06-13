

  create or replace view `primer-impacto-test`.`primer_analytics_staging`.`stg_responses`
  OPTIONS()
  as select
    cast(answer_id as string) as answer_id,
    cast(visit_id as string) as visit_id,
    cast(question_id as string) as question_id,

    campaign_code,
    intervention_point_code,

    question_type,

    answer,
    expected_answer,

    safe_cast(created_at as date) as created_at,
    safe_cast(updated_at_sys as date) as updated_at_sys

from `primer-impacto-test`.`primer_raw`.`raw_responses`;

