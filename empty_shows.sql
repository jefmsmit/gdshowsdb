select shows.uuid, shows.year, shows.month, shows.day
from shows left outer join show_sets on shows.uuid = show_sets.show_uuid
where
  show_sets.uuid is null
order by shows.year, shows.month, shows.day
;