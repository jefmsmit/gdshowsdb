class CreateSongRefTable < ActiveRecord::Migration
	def change
		create_table :song_ref do |t|
			t.string :name
			t.string :uuid
		end
	end
end