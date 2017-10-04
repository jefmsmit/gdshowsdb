require 'yaml'
require 'securerandom'
require 'gdshowsdb'

class ImportShows < ActiveRecord::Migration[5.0]
	include Gdshowsdb
	
	def up
		(1965..1995).each do |year|
			create_shows(year)
			create_sets(year)
			create_songs(year)			
		end
	end

	def down
		Song.delete_all
		ShowSet.delete_all
		Show.delete_all
	end

	private

	def create_shows(year)
		show_yaml_parser = ShowYAMLParser.from_yaml(year)			
		show_yaml_parser.parse.each do |show_yaml|
			show = Show.create(show_yaml)
			puts "Created #{show.title}"
		end
	end	

	def create_sets(year)
		set_yaml_parser = SetYAMLParser.from_yaml(year)
		set_yaml_parser.parse.each do |set_yaml|
			ShowSet.create_from(set_yaml)
		end
	end

	def create_songs(year)
		song_yaml_parser = SongYAMLParser.from_yaml(year)
		song_yaml_parser.parse.each do |song_yaml|
			Song.create_from(song_yaml)
		end
	end
end