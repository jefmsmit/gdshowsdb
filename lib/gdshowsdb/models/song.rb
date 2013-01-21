class Song < ActiveRecord::Base
	include Extensions::UUID
	
	belongs_to :show_set, :foreign_key => :show_set_uuid, :primary_key => :uuid
	
	attr_accessible :uuid, :order, :segued
end