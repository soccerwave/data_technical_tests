select
    route_employee_id,
    route_id,
    employee_id,
    main_employee,
    ip_percentage,
    created_at,
    updated_at,
    deleted_at

from {{ ref('stg_route_employee') }}