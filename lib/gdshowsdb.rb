require "gdshowsdb/version"

require 'rubygems'
require 'active_record'
require 'rails/generators'

require File.dirname(__FILE__) + '/gdshowsdb/diff.rb'
Dir[File.dirname(__FILE__) + '/gdshowsdb/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/gdshowsdb/db/migrations/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/gdshowsdb/models/extensions/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/gdshowsdb/models/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/gdshowsdb/generators/*.rb'].each {|file| require file }

module Gdshowsdb

  def generate_uuid
    SecureRandom.uuid
  end

	def self.init(params = { adapter: 'sqlite3', database: 'gdshowsdb.db' })
    @@connection = ActiveRecord::Base.establish_connection(params)		
	end

  def self.load(level = nil)
    schema_migration = ActiveRecord::Base.connection.schema_migration
    migration_context = ActiveRecord::MigrationContext.new(File.dirname(__FILE__) + '/gdshowsdb/db/migrations', schema_migration) 
    ActiveRecord::Migrator.new(:up, migration_context.migrations, schema_migration, level).migrate
  end
  
  def self.yaml_file_location(file_name)
    Gem.loaded_specs['gdshowsdb'].full_gem_path + "/data/gdshowsdb/#{file_name}"
  end

  def self.load_yaml(file_name)
    YAML.load_file(yaml_file_location(file_name))
  end 

  def self.load_yaml_for_year(year)
    load_yaml("#{year}.yaml")
  end

  def self.write_yaml(file_name, data)
    File.open(yaml_file_location(file_name), "w") do |file|
      file.write data.to_yaml
    end
  end
end

class Hash
  def convert_to_sym
      inject({}) do |symboled, (k,v)| 
        symboled[k.to_sym] = v
        symboled
      end
    end
end

