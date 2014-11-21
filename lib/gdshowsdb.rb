require "gdshowsdb/version"

require 'rubygems'
require 'active_record'
require 'rails/generators'

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
    ActiveRecord::Migrator.up File.dirname(__FILE__) + '/gdshowsdb/db/migrations', level		
	end 

  def self.load_yaml(file_name)
    YAML.load_file(Gem.datadir('gdshowsdb') + "/#{file_name}")
  end 

  def self.load_yaml_for_year(year)
    load_yaml("#{year}.yaml")
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

