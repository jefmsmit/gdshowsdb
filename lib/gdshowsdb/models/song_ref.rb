class SongRef < ActiveRecord::Base
	include Extensions::UUID

	has_many :songs, :foreign_key => :song_ref_uuid, :primary_key => :uuid

	attr_accessible :uuid, :name
end