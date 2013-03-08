require 'yaml'

class ImportShows < ActiveRecord::Migration
	
	def up		
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
					saved_song = show_set.songs.create(:uuid => song[:uuid], :order => song_index, 
						:segued => song[:segued])					
					
					song_ref.songs << saved_song
					song_ref.shows << show					
				end				
			end

			puts "done importing #{key}"
		end
	end	

	def down
		Song.delete_all
		ShowSet.delete_all
		Show.delete_all
	end
end