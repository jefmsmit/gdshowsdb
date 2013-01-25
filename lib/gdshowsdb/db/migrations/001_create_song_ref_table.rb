class CreateSongRefTable < ActiveRecord::Migration
	def up
		create_table :song_refs, :id => false do |t|
			t.string :uuid, :primary => true
			t.string :name			
		end
	end

	def down
		drop_table :song_refs
	end
end