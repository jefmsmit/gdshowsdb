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
    puts "Added SongRefs"
    puts song_ref_diff.added.size

    puts "Removed SongRefs"
    puts song_ref_diff.removed.size

    puts "Updated SongRefs"
    puts song_ref_diff.updated.size
    
    # (1980..1981).each do |year|
    #   Gdshowsdb::ShowDiff.new(year).diff 
    #   Gdshowsdb::SetDiff.new(year).diff     
    # end

    # file = @@migrations_dir + "/update_migration.rb.erb"
    # migration_template(file, "db/migrate/update_gdshowsdb_data.rb")
  end  
end