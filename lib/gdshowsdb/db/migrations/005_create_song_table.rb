class CreateSongTable < ActiveRecord::Migration
	
	def up
		create_table :songs, :id => false do |t|
			t.string :uuid, :primary => true
			t.string :show_set_uuid
			t.string :song_ref_uuid
			t.integer :order
			t.boolean :segued
		end
	end

	def down
		drop_table :songs
	end
end