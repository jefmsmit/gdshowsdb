class CreateShowTable < ActiveRecord::Migration
	
	def up
		create_table :shows, :id => false do |t|
			t.string :uuid, :primary => true, :null => false
			t.integer :year
			t.integer :month
			t.integer :day
			t.integer :order, :default => 0
			t.string :venue
			t.string :city
			t.string :state
			t.string :country			
		end

		add_index :shows, [:uuid, :year, :month, :day]
	end

	def down
		drop_table :shows
	end
end