class Show < ActiveRecord::Base
	include Extensions::UUID
	
	has_many :show_sets, :foreign_key => :show_uuid, :primary_key => :uuid

	attr_accessible :uuid, :year, :month, :day, :venue, :city, :state, :country
end