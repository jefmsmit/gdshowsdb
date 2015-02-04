require 'yaml'
require 'gdshowsdb'

class ImportSongRefs < ActiveRecord::Migration
	def up		
		Gdshowsdb::SongRefYAMLParser.from_yaml.parse.each do |song_ref_hash|
			SongRef.create_from(song_ref_hash)
		end		
	end

	def down
		SongRef.delete_all
	end
end