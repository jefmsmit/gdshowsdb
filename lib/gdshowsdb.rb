require "gdshowsdb/version"

require 'rubygems'
require 'sqlite3'
require 'active_record'

Dir[File.dirname(__FILE__) + '/gdshowsdb/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/gdshowsdb/db/migrations/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/gdshowsdb/models/extensions/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/gdshowsdb/models/*.rb'].each {|file| require file }

module Gdshowsdb

	def self.init
		@@connection = ActiveRecord::Base.establish_connection(
		  :adapter => 'sqlite3',
		  :database => 'gdshowsdb.db'
		)		
	end

	def self.load
		ActiveRecord::Migrator.migrate File.dirname(__FILE__) + '/gdshowsdb/db/migrations', ARGV[0] ? ARGV[0].to_i : nil		
	end  
end


