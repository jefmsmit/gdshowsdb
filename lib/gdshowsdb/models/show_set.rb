class ShowSet < ActiveRecord::Base
	include Extensions::UUID
	
	has_many :songs, :foreign_key => :show_set_uuid, :primary_key => :uuid
	belongs_to :show, :foreign_key => :show_uuid, :primary_key => :uuid
	
	attr_reader :uuid, :order
end