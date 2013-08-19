require 'yaml'
require 'securerandom'
require 'gdshowsdb'

class ImportShows < ActiveRecord::Migration
	
	def up		
		@shows = YAML.load_file(Gem.datadir('gdshowsdb') + '/shows.yaml')
		@shows.each do |key, value|
			show_song_count = {}
			show = save_show(key, value)			
			
			sets = value[:sets]
			sets.each_with_index do |set, index|
				show_set = save_show_set(show, set, index, (set == sets.last), set[:songs].length)

				set[:songs].each_with_index do |song, song_index|
					song_ref = lookup_song_ref(song[:name])
					if(show_song_count.has_key?(song_ref.uuid))
						show_song_count[song_ref.uuid] = show_song_count[song_ref.uuid] + 1
					else
						show_song_count[song_ref.uuid] = 0
					end
					save_song(show, show_set, song_ref, song, song_index, show_song_count[song_ref.uuid])
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

	def lookup_song_ref(name)
		@ref_cache = {} if @ref_cache.nil?
		@ref_cache[name] = SongRef.find_by_name(name) unless @ref_cache.has_key?(name)
		raise "#{name} is not a valid SongRef" if @ref_cache[name].nil? 
		@ref_cache[name]
	end

	def save_show(key, value)
		show = Show.new
		show.uuid = value[:uuid]
		show.year, show.month, show.day, position = key.split("/")
		show.venue = value[:venue]
		show.city = value[:city]
		show.state = value[:state]
		show.country = value[:country]
		show.position = position if position
		show.save!

		Show.find_by_uuid(value[:uuid])
	end

	def save_show_set(show, set, index, is_last, number_of_songs)
		show_set = ShowSet.new
		show_set.uuid = set[:uuid]
		show_set.show = show
		show_set.position = index
		show_set.encore = (number_of_songs < 3 && is_last)
		show_set.save!

		ShowSet.find_by_uuid(set[:uuid])
	end

	def save_song(show, show_set, song_ref, song, song_index, occurence_position)		
		saved_song = show_set.songs.create(:uuid => song[:uuid], :position => song_index, :segued => song[:segued])					
		
		song_ref.songs << saved_song
		song_ref.song_occurences.create(:uuid => SecureRandom.uuid, :show => show, :position => occurence_position)
	end
end