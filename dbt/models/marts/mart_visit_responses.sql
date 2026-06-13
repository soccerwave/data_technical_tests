select
    r.answer_id,
    r.visit_id,
    r.question_id,

    v.campaign_id,
    c.campaign_code,
    c.campaign_name,
    c.campaign_state,
    c.project_id,
    c.project_code,
    c.client_code,

    p.intervention_point_id,
    p.intervention_point_code,
    p.intervention_point_name,
    p.intervention_point_province,
    p.intervention_point_locality,

    v.route_id,
    rt.route_code,
    rt.route_name,
    rt.route_status,

    v.visit_date,
    v.visit_time,
    v.visit_status,
    v.visit_type,
    v.is_client_billable,
    v.has_missing_route_reference,

    q.question_code,
    q.question_name,
    q.question_type,
    q.question_category,
    q.question_order,
    q.question_is_highlighted,

    r.answer,
    r.expected_answer,
    r.is_expected_answer,

    r.created_at,
    r.updated_at_sys

from {{ ref('fct_responses') }} r
left join {{ ref('fct_visits') }} v
    on r.visit_id = v.visit_id
left join {{ ref('dim_campaigns') }} c
    on v.campaign_id = c.campaign_id
left join {{ ref('dim_pos') }} p
    on v.intervention_point_id = p.intervention_point_id
left join {{ ref('dim_routes') }} rt
    on v.route_id = rt.route_id
left join {{ ref('dim_questions') }} q
    on r.question_id = q.question_id