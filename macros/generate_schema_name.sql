{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- if custom_schema_name is none -%}
        {{ target.schema | trim }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}

    {%- if target.name != "prod"  -%}
    _{{ target.name }}
    {%- endif -%}   

{%- endmacro %}