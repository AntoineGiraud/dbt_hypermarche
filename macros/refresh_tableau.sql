{% macro refresh_tableau(source_or_workbook_name) -%}

    select bigfunctions.eu.refresh_tableau(
        '{{ source_or_workbook_name }}',
        '{{ target.tableau_site }}',
        '{{ target.tableau_url }}',
        '{{ target.tableau_token_name }}',
        'ENCRYPTED_SECRET({{ target.tableau_token_encrypted }})'
    );

{%- endmacro %}

