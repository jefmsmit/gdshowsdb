class SongRef < ActiveRecord::Base
	include Extensions::UUID
	
	attr_reader :uuid, :name
end