class SongRef < ActiveRecord::Base
	include Extensions::UUID

	has_many :songs, :foreign_key => :song_ref_uuid, :primary_key => :uuid
	has_and_belongs_to_many :shows, :foreign_key => :song_ref_uuid, :association_foreign_key => :show_uuid

	attr_accessible :uuid, :name
	
end