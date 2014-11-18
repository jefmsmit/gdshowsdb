require 'yaml'
require 'gdshowsdb'

class ImportSongRefs < ActiveRecord::Migration
	def up		
		song_refs = Gdshowsdb.load_yaml('song_refs.yaml')
		song_refs_yaml_parser = Gdshowsdb::SongRefYAMLParser.new(song_refs)
		
		song_refs_yaml_parser.parse.each do |song_ref_hash|
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