
  
    

    create or replace table `primer-impacto-test`.`primer_analytics_marts`.`dim_campaigns`
      
    
    

    
    OPTIONS()
    as (
      with campaigns as (

    select *
    from `primer-impacto-test`.`primer_analytics_staging`.`stg_campaigns`

),

deduplicated as (

    select
        *,
        row_number() over (
            partition by campaign_id
            order by updated_at_sys desc, created_at desc
        ) as row_num

    from campaigns

)

select
    campaign_id,
    campaign_code,
    campaign_name,

    project_id,
    project_code,
    client_code,

    campaign_start_date,
    campaign_end_date,

    is_active,
    campaign_state_id,
    campaign_state,

    total_visits_planned,
    total_pos_planned,
    visit_duration_minutes,

    has_invalid_date_range,

    created_at,
    updated_at_sys

from deduplicated
where row_num = 1
    );
  