class CreateShowsSongRefsTable < ActiveRecord::Migration
  
  def up
    create_table :shows_song_refs, :id => false do |t|
      t.string :show_uuid
      t.string :song_ref_uuid
    end
  end

  def down
    drop_table :shows_song_refs
  end
end