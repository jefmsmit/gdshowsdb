require 'yaml'

class ImportSongRefs < ActiveRecord::Migration
	def change		
		@song_refs = YAML.load_file(File.dirname(__FILE__) + '/../../song_refs.yaml')	
		@song_refs.each do |key, value|
			SongRef.create(:name => key, :uuid => value)
		end
	end
end