class CreateSongOccurencesTable < ActiveRecord::Migration[5.0]
  
  def up
    create_table :song_occurences, :id => false do |t|
      t.string :uuid, :primary => true, :null => false
      t.string :show_uuid
      t.string :song_ref_uuid
      t.integer :position
      t.index :uuid, unique: true
      t.index :song_ref_uuid
      t.index [:uuid, :song_ref_uuid, :position], unique: true      
    end
  end

  def down
    drop_table :song_occurences
  end
end