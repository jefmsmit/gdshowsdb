require 'yaml'

class GdshowsdatabaseUpgradeGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  @@migrations_dir = File.expand_path('../../templates', __FILE__) 
  source_root @@migrations_dir

  def self.next_migration_number(path)
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end

  def create_update_migration_file
    diff_song_refs
    
    (1980..1981).each do |year|
      diff_shows(year)  
      diff_sets(year)
      diff_songs(year)
    end

    # file = @@migrations_dir + "/update_migration.rb.erb"
    # migration_template(file, "db/migrate/update_gdshowsdb_data.rb")
  end  

  private

  def diff_song_refs
    song_ref_diff = Gdshowsdb::SongRefDiff.new
    puts "Added SongRefs"
    puts song_ref_diff.added.size

    puts "Removed SongRefs"
    puts song_ref_diff.removed.size

    puts "Updated SongRefs"
    puts song_ref_diff.updated.size
  end

  def diff_shows(year)
    show_diff = Gdshowsdb::ShowDiff.new(year)

    puts "Added Shows for #{year}"
    puts show_diff.added.size

    puts "Removed Shows for #{year}"
    puts show_diff.removed.size

    puts "Updated Shows for #{year}"
    puts show_diff.updated.size
  end

  def diff_sets(year)
    set_diff = Gdshowsdb::SetDiff.new(year)

    puts "Added sets for #{year}"
    puts set_diff.added.size

    puts "Removed sets for #{year}"
    puts set_diff.removed.size

    puts "Updated sets for #{year}"
    puts set_diff.updated.size
  end

  def diff_songs(year)
    song_diff = Gdshowsdb::SongDiff.new(year)

    puts "Added songs for #{year}"
    puts song_diff.added.size

    puts "Removed songs for #{year}"
    puts song_diff.removed.size

    puts "Updated songs for #{year}"
    puts song_diff.updated.size
  end
end