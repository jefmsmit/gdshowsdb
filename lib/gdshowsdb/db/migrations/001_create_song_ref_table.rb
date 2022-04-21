class CreateSongRefTable < ActiveRecord::Migration[5.0]
	def up
		create_table :song_refs, :id => false do |t|
			t.string :uuid, primary: true, null: false
			t.string :name
      t.string :slug  
			t.index :uuid, unique: true  
			t.index :name, unique: true  
			t.index :slug, unique: true  
		end    
	end

	def down
		drop_table :song_refs
	end
end