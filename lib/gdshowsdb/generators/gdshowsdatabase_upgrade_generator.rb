require 'yaml'

class GdshowsdatabaseUpgradeGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  @@migrations_dir = File.expand_path('../../templates', __FILE__) 
  source_root @@migrations_dir

  def self.next_migration_number(path)
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end

  def create_update_migration_file
    song_ref_diff = Gdshowsdb::SongRefDiff.new
    @added_song_refs = song_ref_diff.added
    @updated_song_refs = song_ref_diff.updated
    @removed_song_refs = song_ref_diff.removed

    # diff(Gdshowsdb::SongRefDiff.new, "SongRefs")
    
    @added_shows = []
    @updated_shows = []
    @removed_shows = []
    @added_sets = []
    @updated_sets = []
    @removed_sets = []
    (1965..1995).each do |year|
      show_diff = Gdshowsdb::ShowDiff.new(year)
      @added_shows.concat(show_diff.added)
      @updated_shows.concat(show_diff.updated)
      @removed_shows.concat(show_diff.removed)

      set_diff = Gdshowsdb::SetDiff.new(year)
      @added_sets.concat(set_diff.added)
      @updated_sets.concat(set_diff.updated)
      @removed_sets.concat(set_diff.removed)      

      song_diff = Gdshowsdb::SongDiff.new(year)
      @added_songs.concat(song_diff.added)
      @updated_songs.concat(song_diff.updated)
      @removed_songs.concat(song_diff.removed)      

    #   diff(Gdshowsdb::ShowDiff.new(year), "Shows")
    #   diff(Gdshowsdb::SetDiff.new(year), "ShowSets")
    #   diff(Gdshowsdb::SongDiff.new(year), "Songs")
    end

    file = @@migrations_dir + "/update_migration.rb.erb"
    migration_template(file, "db/migrate/update_gdshowsdb_data.rb")
  end  

  private

  def diff(differ, name)
    puts "Added #{name}"
    puts differ.added.size

    puts "Removed #{name}"
    puts differ.removed.size

    puts "Updated #{name}"
    puts differ.updated.size
  end  
end