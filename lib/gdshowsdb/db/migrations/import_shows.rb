require 'yaml'

class ImportShows < ActiveRecord::Migration
	def change		
		@shows = YAML.load_file(File.dirname(__FILE__) + '/../../shows-debug.yaml')	
		@shows.each do |key, value|
			show = Show.new
			show.uuid = value[:uuid]
			show.year, show.month, show.day = key.split("/")
			show.venue = value[:venue]
			show.city = value[:city]
			show.state = value[:state]
			show.country = value[:country]
			show.save!

			show = Show.find_by_uuid(value[:uuid])
			
			sets = value[:sets]
			sets.each_with_index do |set, index|
				show_set = ShowSet.new
				show_set.uuid = set[:uuid]
				show_set.show = show
				show_set.order = index
				show_set.save!

				show_set = ShowSet.find_by_uuid(set[:uuid])
				
				set[:songs].each_with_index do |song, song_index|
					song_ref = SongRef.find_by_name(song[:name])

					show_song = Song.new	
					show_song.uuid = song[:uuid]
					show_song.order = song_index
					show_song.show_set = show_set										
					show_song.segued = song[:segued]
					show_song.save!

					show_set.songs.push(Song.find_by_uuid(song[:uuid]))
				end

				show_set.save!
			end

			puts "done importing #{key}"
		end
	end
end