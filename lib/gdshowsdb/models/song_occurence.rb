class SongOccurence < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :show, :foreign_key => :show_uuid, :primary_key => :uuid
  belongs_to :song_ref, :foreign_key => :song_ref_uuid, :primary_key => :uuid, :counter_cache => true
  accepts_nested_attributes_for :show

  def self.create_from(spec)
    occurence = SongOccurence.new
    set_spec(occurence, spec)
    occurence.save
    occurence
  end

  private

  def self.set_spec(occurence, spec)
    occurence.uuid = spec[:uuid]
    occurence.position = spec[:position]    
    occurence.show = ShowSet.find_by_uuid(spec[:show_set_uuid]).show
  end
end