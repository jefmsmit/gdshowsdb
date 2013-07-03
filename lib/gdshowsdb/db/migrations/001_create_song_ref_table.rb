class CreateSongRefTable < ActiveRecord::Migration
	def up
		create_table :song_refs, :id => false do |t|
			t.string :uuid, :primary => true, :null => false
			t.string :name
      t.string :slug      
		end

    add_index :song_refs, [:uuid, :name, :slug]     
	end

	def down
		drop_table :song_refs
	end
end