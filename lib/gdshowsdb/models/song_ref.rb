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

  def self.create_from(spec)
    SongRef.create(
      uuid: spec[:uuid],
      name: spec[:name],
      slug: spec[:name].parameterize.underscore
    )
  end

  def self.update_from(spec)
    SongRef.update(spec[:uuid], spec)
  end
	
  def self.remove_from(spec)
    SongRef.find_by_uuid(spec[:uuid]).delete
  end
end