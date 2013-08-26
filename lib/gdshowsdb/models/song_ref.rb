require 'friendly_id'

class SongRef < ActiveRecord::Base
	extend FriendlyId
  include Extensions::UUID  

  friendly_id :slug

	has_many :songs, :foreign_key => :song_ref_uuid, :primary_key => :uuid
	has_many :song_occurences, :foreign_key => :song_ref_uuid, :primary_key => :uuid
	has_many :shows, :through => :song_occurences, :foreign_key => :song_ref_uuid

  accepts_nested_attributes_for :song_occurences

	attr_accessible :uuid, :name, :slug
	
end