require 'friendly_id'

class SongRef < ActiveRecord::Base
	extend FriendlyId
  include Extensions::UUID  

  friendly_id :slug

	has_many :songs, :foreign_key => :song_ref_uuid, :primary_key => :uuid
	has_many :song_occurences, :foreign_key => :song_ref_uuid, :primary_key => :uuid
	has_many :shows, -> {distinct}, :through => :song_occurences, :foreign_key => :song_ref_uuid

  accepts_nested_attributes_for :song_occurences

  def self.create_from(spec)
    song_ref = SongRef.new
    set_spec(song_ref, spec)
    song_ref.save    
  end

  def self.update_from(spec) 
    song_ref = SongRef.find_by_uuid(spec[:uuid])
    set_spec(song_ref, spec)
    song_ref.save
  end
	
  def self.remove_from(spec)
    SongRef.find_by_uuid(spec[:uuid]).delete
  end

  private

  def self.set_spec(song_ref, spec)
    song_ref.uuid = spec[:uuid]
    song_ref.name = spec[:name]
    song_ref.slug = spec[:name].parameterize.underscore
    song_ref
  end
end