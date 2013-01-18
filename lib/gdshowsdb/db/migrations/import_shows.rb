require 'yaml'

class ImportShows < ActiveRecord::Migration
	def change		
		@shows = YAML.load_file(File.dirname(__FILE__) + '/../../shows.yaml')	
		@shows.each do |key, value|
			show = Show.new
			show.uuid = value[:uuid]
			show.year, show.month, show.day = key.split("/")
			show.venue = value[:venue]
			show.city = value[:city]
			show.state = value[:state]
			show.country = value[:country]
			show.save!
		end
	end
end