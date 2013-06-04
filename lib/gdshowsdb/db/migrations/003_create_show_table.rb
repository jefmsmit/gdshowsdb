class CreateShowTable < ActiveRecord::Migration
	
	def up
		create_table :shows, :id => false do |t|
			t.string :uuid, :primary => true
			t.integer :year
			t.integer :month
			t.integer :day
			t.string :venue
			t.string :city
			t.string :state
			t.string :country			
		end

		add_index :shows, [:uuid]
	end

	def down
		drop_table :shows
	end
end