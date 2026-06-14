select
    cast(intervention_point_id as string) as intervention_point_id,

    trim(intervention_point_code) as intervention_point_code,
    trim(intervention_point_name) as intervention_point_name,
    trim(intervention_point_address) as intervention_point_address,

    case
        when intervention_point_province is null then null
        when lower(trim(intervention_point_province)) in ('zamora') then 'Zamora'
        when lower(trim(intervention_point_province)) in ('valladolid') then 'Valladolid'
        when lower(trim(intervention_point_province)) in ('madrid') then 'Madrid'
        when lower(trim(intervention_point_province)) in ('asturias') then 'Asturias'
        when lower(trim(intervention_point_province)) in ('tarragona') then 'Tarragona'
        when lower(trim(intervention_point_province)) in ('zaragoza') then 'Zaragoza'
        when lower(trim(intervention_point_province)) in ('pontevedra') then 'Pontevedra'
        when lower(trim(intervention_point_province)) in ('girona') then 'Girona'
        when lower(trim(intervention_point_province)) in ('lleida') then 'Lleida'
        when lower(trim(intervention_point_province)) in ('cáceres', 'caceres') then 'Cáceres'
        when lower(trim(intervention_point_province)) in ('castelló', 'castellon', 'castellón') then 'Castellón'
        when lower(trim(intervention_point_province)) in ('rioja, la', 'la rioja') then 'La Rioja'
        when lower(trim(intervention_point_province)) in ('palmas, las') then 'Las Palmas'
        when lower(trim(intervention_point_province)) in ('ciudad real') then 'Ciudad Real'
        when lower(trim(intervention_point_province)) in ('santa cruz de tenerife') then 'Santa Cruz de Tenerife'
        when lower(trim(intervention_point_province)) in ('málaga', 'malaga') then 'Málaga'
        when lower(trim(intervention_point_province)) in ('badajoz') then 'Badajoz'
        when lower(trim(intervention_point_province)) in ('huelva') then 'Huelva'
        when lower(trim(intervention_point_province)) in ('lugo') then 'Lugo'
        else initcap(trim(intervention_point_province))
    end as intervention_point_province,

    trim(intervention_point_locality) as intervention_point_locality,
    cast(intervention_point_postal_code as string) as intervention_point_postal_code,

    safe_cast(intervention_point_latitude as float64) as intervention_point_latitude,
    safe_cast(intervention_point_longitude as float64) as intervention_point_longitude,
    safe_cast(intervention_point_is_active as bool) as intervention_point_is_active,

    safe_cast(created_at as date) as created_at,
    safe_cast(updated_at as date) as updated_at

from {{ source('raw', 'raw_pos') }}