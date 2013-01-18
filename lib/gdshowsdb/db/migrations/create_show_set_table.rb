class CreateShowSetTable < ActiveRecord::Migration
	def change
		create_table :show_sets, :id => false do |t|
			t.string :uuid, :primary => true
			t.string :show_uuid
			t.integer :order
		end
	end
end