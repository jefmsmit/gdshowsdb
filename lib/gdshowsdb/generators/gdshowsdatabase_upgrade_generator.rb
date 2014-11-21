require 'yaml'

class GdshowsdatabaseUpgradeGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  @@migrations_dir = File.expand_path('../../templates', __FILE__) 
  source_root @@migrations_dir

  def self.next_migration_number(path)
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end

  def create_update_migration_file
    diff(Gdshowsdb::SongRefDiff.new, "SongRefs")
    
    (1980..1981).each do |year|
      diff(Gdshowsdb::ShowDiff.new(year), "Shows")
      diff(Gdshowsdb::SetDiff.new(year), "ShowSets")
      diff(Gdshowsdb::SongDiff.new(year), "Songs")
    end

    # file = @@migrations_dir + "/update_migration.rb.erb"
    # migration_template(file, "db/migrate/update_gdshowsdb_data.rb")
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