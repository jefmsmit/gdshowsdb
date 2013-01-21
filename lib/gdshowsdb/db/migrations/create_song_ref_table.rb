class CreateSongRefTable < ActiveRecord::Migration
	def change
		create_table :song_refs, :id => false do |t|
			t.string :uuid, :primary => true
			t.string :name			
		end
	end
end