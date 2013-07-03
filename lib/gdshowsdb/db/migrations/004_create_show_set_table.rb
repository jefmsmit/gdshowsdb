class CreateShowSetTable < ActiveRecord::Migration
	
	def up
		create_table :show_sets, :id => false do |t|
			t.string :uuid, :primary => true, :null => false
			t.string :show_uuid
			t.integer :order
			t.boolean :encore, :default => false
		end
	end

	def down
		drop_table :show_sets
	end
end