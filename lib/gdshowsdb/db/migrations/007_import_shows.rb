require 'yaml'
require 'securerandom'

class ImportShows < ActiveRecord::Migration
	
	def up		
		@shows = YAML.load_file(File.dirname(__FILE__) + '/../../shows.yaml')	
		@shows.each do |key, value|
			show = save_show(key, value)			
			
			sets = value[:sets]
			sets.each_with_index do |set, index|
				show_set = save_show_set(show, set, index)

				set[:songs].each_with_index do |song, song_index|
					song_ref = SongRef.find_by_name(song[:name])
					saved_song = show_set.songs.create(:uuid => song[:uuid], :order => song_index, 
						:segued => song[:segued])					
					
					song_ref.songs << saved_song
					song_ref.song_occurences.create(:uuid => SecureRandom.uuid, :show => show)
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

	private

	def save_show(key, value)
		show = Show.new
		show.uuid = value[:uuid]
		show.year, show.month, show.day = key.split("/")
		show.venue = value[:venue]
		show.city = value[:city]
		show.state = value[:state]
		show.country = value[:country]
		show.save!

		Show.find_by_uuid(value[:uuid])
	end

	def save_show_set(show, set, index)
		show_set = ShowSet.new
		show_set.uuid = set[:uuid]
		show_set.show = show
		show_set.order = index
		show_set.save!

		ShowSet.find_by_uuid(set[:uuid])
	end
end