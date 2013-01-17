class CreateSongRefTable < ActiveRecord::Migration
	def change
		create_table :song_refs, :id => false do |t|
			t.string :name
			t.string :uuid, :primary => true
		end
	end
end