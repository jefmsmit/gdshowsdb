select shows.uuid, shows.year, shows.month, shows.day 
from shows, show_sets, songs, song_refs 
where
  shows.uuid = show_sets.show_uuid and
  songs.show_set_uuid = show_sets.uuid and
  songs.song_ref_uuid = song_refs.uuid and 
  song_refs.name = 'Scarlet Begonias' 
  and segued = false
order by shows.year, shows.month, shows.day;