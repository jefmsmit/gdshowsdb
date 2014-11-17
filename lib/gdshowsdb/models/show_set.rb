class ShowSet < ActiveRecord::Base
	include Extensions::UUID

	has_many :songs, :foreign_key => :show_set_uuid, :primary_key => :uuid
	belongs_to :show, :foreign_key => :show_uuid, :primary_key => :uuid
  accepts_nested_attributes_for :songs
	
	attr_accessible :uuid, :position, :encore

  def self.encore?(sets, set)
    return false unless sets
    last = (sets.size - 1) == sets.index(set)
    song_size = set[:songs].size          
    song_size < 3 && last
  end

  def encore?
    encore
  end
end