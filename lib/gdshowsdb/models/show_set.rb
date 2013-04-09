class ShowSet < ActiveRecord::Base
	include Extensions::UUID

	has_many :songs, :foreign_key => :show_set_uuid, :primary_key => :uuid
	belongs_to :show, :foreign_key => :show_uuid, :primary_key => :uuid
  accepts_nested_attributes_for :songs
	
	attr_accessible :uuid, :order
end