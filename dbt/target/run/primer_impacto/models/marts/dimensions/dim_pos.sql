
  
    

    create or replace table `primer-impacto-test`.`primer_analytics_marts`.`dim_pos`
      
    
    

    
    OPTIONS()
    as (
      with pos as (

    select *
    from `primer-impacto-test`.`primer_analytics_staging`.`stg_pos`

),

deduplicated as (

    select
        *,
        row_number() over (
            partition by intervention_point_id
            order by updated_at desc, created_at desc
        ) as row_num

    from pos

)

select
    intervention_point_id,
    intervention_point_code,
    intervention_point_name,
    intervention_point_address,
    intervention_point_province,
    intervention_point_locality,
    intervention_point_postal_code,
    intervention_point_latitude,
    intervention_point_longitude,
    intervention_point_is_active,
    created_at,
    updated_at

from deduplicated
where row_num = 1
    );
  