require 'yaml'
require 'securerandom'
require 'gdshowsdb'

class ImportShows < ActiveRecord::Migration
	include Gdshowsdb
	
	def up
		(1965..1995).each do |year|
			show_yaml_parser = ShowYAMLParser.from_yaml(year)			
			show_yaml_parser.parse.each do |show_yaml|
				Show.create(show_yaml)
			end

			set_yaml_parser = SetYAMLParser.from_yaml(year)
			set_yaml_parser.parse.each do |set_yaml|
				ShowSet.create(set_yaml) do |show_set|
					show_set.show = Show.find_by_uuid(set_yaml[:show_uuid])
				end
			end

			song_yaml_parser = SongYAMLParser.from_yaml(year)
			song_yaml_parser.parse.each do |song_yaml|
				created_song = Song.create(song_yaml) do |song|
					song.show_set = ShowSet.find_by_uuid(song_yaml[:show_set_uuid])
				end
				song_ref = SongRef.find_by_name(song_yaml[:name])
				song_ref.songs << Song.find_by_uuid(song_yaml[:uuid])
				
				song_ref.song_occurences.create(uuid: generate_uuid, position: song_yaml[:position]) do |occurence|
					occurence.show = ShowSet.find_by_uuid(song_yaml[:show_set_uuid]).show					
				end
			end
		end
	end

	def down
		Song.delete_all
		ShowSet.delete_all
		Show.delete_all
	end	
end