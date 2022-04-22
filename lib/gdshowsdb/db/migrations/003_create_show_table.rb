class CreateShowTable < ActiveRecord::Migration[5.0]
	
	def up
		create_table :shows, :id => false do |t|
			t.string :uuid, :primary => true, :null => false
			t.integer :year
			t.integer :month
			t.integer :day
			t.integer :position
			t.string :venue
			t.string :city
			t.string :state
			t.string :country
			t.index :uuid, unique: true		
			t.index [:year, :month, :day, :position], unique: true
		end
	end

	def down
		drop_table :shows
	end
end