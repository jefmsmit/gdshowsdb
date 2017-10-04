class CreateSongTable < ActiveRecord::Migration[5.0]
	
	def up
		create_table :songs, :id => false do |t|
			t.string :uuid, :primary => true, :null => false
			t.string :show_set_uuid
			t.string :song_ref_uuid
			t.integer :position
			t.boolean :segued			
		end

		add_index :songs, [:uuid, :song_ref_uuid]
	end

	def down
		drop_table :songs
	end
end