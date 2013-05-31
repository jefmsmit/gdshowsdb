class SongOccurence < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :show, :foreign_key => :show_uuid, :primary_key => :uuid
  belongs_to :song_ref, :foreign_key => :song_ref_uuid, :primary_key => :uuid, :counter_cache => true
  accepts_nested_attributes_for :show

  attr_accessible :order, :uuid, :order, :show
end