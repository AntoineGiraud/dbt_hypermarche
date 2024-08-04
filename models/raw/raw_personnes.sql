select *
from {{ source('hypermarche', 'personnes') }}
