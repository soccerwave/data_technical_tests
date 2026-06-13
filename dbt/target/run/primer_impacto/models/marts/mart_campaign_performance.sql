
  
    

    create or replace table `primer-impacto-test`.`primer_analytics_marts`.`mart_campaign_performance`
      
    
    

    
    OPTIONS()
    as (
      with visits as (

    select
        campaign_id,
        count(distinct visit_id) as recorded_visits,
        count(distinct case when visit_status = 'OK' then visit_id end) as ok_visits,
        count(distinct case when visit_status = 'INCID' then visit_id end) as incid_visits,
        count(distinct case when visit_status = 'NOVIS' then visit_id end) as novis_visits,
        count(distinct case when visit_status = 'INFO' then visit_id end) as info_visits,
        count(distinct case when visit_status = 'UNKNOWN' then visit_id end) as unknown_status_visits,
        count(distinct case when has_missing_route_reference then visit_id end) as missing_route_reference_visits

    from `primer-impacto-test`.`primer_analytics_marts`.`fct_visits`
    group by campaign_id

)

select
    c.campaign_id,
    c.campaign_code,
    c.campaign_name,
    c.project_id,
    c.project_code,
    c.client_code,
    c.campaign_start_date,
    c.campaign_end_date,
    c.campaign_state,
    c.is_active,
    c.total_visits_planned,
    c.total_pos_planned,
    c.visit_duration_minutes,
    c.has_invalid_date_range,

    coalesce(v.recorded_visits, 0) as recorded_visits,
    safe_divide(coalesce(v.recorded_visits, 0), c.total_visits_planned) as recorded_planned_rate,

    coalesce(v.ok_visits, 0) as ok_visits,
    coalesce(v.incid_visits, 0) as incid_visits,
    coalesce(v.novis_visits, 0) as novis_visits,
    coalesce(v.info_visits, 0) as info_visits,
    coalesce(v.unknown_status_visits, 0) as unknown_status_visits,
    coalesce(v.missing_route_reference_visits, 0) as missing_route_reference_visits

from `primer-impacto-test`.`primer_analytics_marts`.`dim_campaigns` c
left join visits v
    on c.campaign_id = v.campaign_id
    );
  