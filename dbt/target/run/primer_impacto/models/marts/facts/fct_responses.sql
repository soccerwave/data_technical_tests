
  
    

    create or replace table `primer-impacto-test`.`primer_analytics_marts`.`fct_responses`
      
    
    

    
    OPTIONS()
    as (
      with responses as (

    select *
    from `primer-impacto-test`.`primer_analytics_staging`.`stg_responses`

)

select
    answer_id,
    visit_id,
    question_id,

    campaign_code,
    intervention_point_code,

    question_type,

    answer,
    expected_answer,

    case
        when answer = expected_answer then true
        when answer is null or expected_answer is null then null
        else false
    end as is_expected_answer,

    created_at,
    updated_at_sys

from responses
    );
  