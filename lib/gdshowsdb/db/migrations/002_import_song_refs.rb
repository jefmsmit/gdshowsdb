require 'yaml'
require 'gdshowsdb'

class ImportSongRefs < ActiveRecord::Migration
	def up		
		Gdshowsdb::SongRefYAMLParser.from_yaml.parse.each do |song_ref_hash|
			song_ref = SongRef.create(
				uuid: song_ref_hash[:uuid],
				name: song_ref_hash[:name],
				slug: song_ref_hash[:name].parameterize.underscore
			)
		end		
	end

	def down
		SongRef.delete_all
	end
end