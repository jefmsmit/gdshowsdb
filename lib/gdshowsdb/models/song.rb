class Song < ActiveRecord::Base
	include Extensions::UUID
	
	belongs_to :show_set 
	has_one :song_ref
	
	attr_reader :uuid, :order
end