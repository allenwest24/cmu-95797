-- models/staging/stg__fhv_bases.sql

{{ config(
    materialized='view',
    alias='for_hire_vehicle_bases'
) }} -- Improved table name.

with cleaned_fhv_bases as (
    -- Remove duplicate rows
    select distinct
        -- Casting base_number to varchar
        try_cast(base_number as varchar) as base_number,
        
        -- Standardize base_name to all uppercase, trim leading/trailing whitespace, normalize common abbreviations, and rename the column
        nullif(
            replace(
                replace(
                    replace(
                        upper(trim(try_cast(base_name as varchar))),
                        ' INC.', ' INC'
                    ),
                    ' CORP.', ' CORP'
                ),
                ' LLC.', ' LLC'
            ),
            ''
        ) as base_name,
        
        -- Standardize dba to all uppercase, trim leading/trailing whitespace, normalize common abbreviations, and rename the column to doing_business_as for clarity
        nullif(
            replace(
                replace(
                    replace(
                        upper(trim(try_cast(dba as varchar))),
                        ' INC.', ' INC'
                    ),
                    ' CORP.', ' CORP'
                ),
                ' LLC.', ' LLC'
            ),
            ''
        ) as doing_business_as,
        
        -- Standardize dba_category to all uppercase, trim leading/trailing whitespace, normalize common abbreviations, and rename the column to doing_business_as_category for clarity
        nullif(
            replace(
                replace(
                    replace(
                        upper(trim(try_cast(dba_category as varchar))),
                        ' INC.', ' INC'
                    ),
                    ' CORP.', ' CORP'
                ),
                ' LLC.', ' LLC'
            ),
            ''
        ) as doing_business_as_category,
        
        -- Casting filename to varchar
        try_cast(filename as varchar) as filename
    from {{ source('main', 'fhv_bases') }}
    
    -- Filter out rows where base_number is null
    where base_number is not null
        and base_name is not null
)

-- Kept all columns
select
    base_number,
    base_name,
    doing_business_as,
    doing_business_as_category,
    filename
from cleaned_fhv_bases
