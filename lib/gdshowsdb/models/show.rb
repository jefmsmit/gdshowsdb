class Show < ActiveRecord::Base
	include Extensions::UUID
	
	attr_reader :uuid, :year, :month, :day, :venue, :city, :state, :country
end