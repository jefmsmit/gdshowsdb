class CreateShowSetTable < ActiveRecord::Migration[5.0]
	
	def up
		create_table :show_sets, :id => false do |t|
			t.string :uuid, :primary => true, :null => false
			t.string :show_uuid
			t.integer :position
			t.boolean :encore, :default => false
			t.index :uuid, unique: true
			t.index [:uuid, :show_uuid, :position], unique: true
		end
	end

	def down
		drop_table :show_sets
	end
end