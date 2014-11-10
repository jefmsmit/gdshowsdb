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

	def self.init(params = { adapter: 'sqlite3', database: 'gdshowsdb.db' })
    @@connection = ActiveRecord::Base.establish_connection(params)		
	end

	def self.load(level = nil)
    ActiveRecord::Migrator.up File.dirname(__FILE__) + '/gdshowsdb/db/migrations', level		
	end  
end


