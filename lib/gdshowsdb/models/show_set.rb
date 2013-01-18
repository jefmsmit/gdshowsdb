class ShowSet < ActiveRecord::Base
	include Extensions::UUID
	
	belongs_to :show
	
	attr_reader :uuid, :order
end