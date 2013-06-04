class CreateSongOccurencesTable < ActiveRecord::Migration
  
  def up
    create_table :song_occurences, :id => false do |t|
      t.string :uuid, :primary => true
      t.string :show_uuid
      t.string :song_ref_uuid
      t.integer :order      
    end

    add_index :song_occurences, [:uuid, :song_ref_uuid]
  end

  def down
    drop_table :song_occurences
  end
end