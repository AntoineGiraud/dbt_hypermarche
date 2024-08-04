select *
from {{ source('hypermarche', 'achats') }}
