class ShowSet < ActiveRecord::Base
	include Extensions::UUID

	has_many :songs, :foreign_key => :show_set_uuid, :primary_key => :uuid
	belongs_to :show, :foreign_key => :show_uuid, :primary_key => :uuid
  accepts_nested_attributes_for :songs
	
	attr_accessible :uuid, :show_uuid, :position, :encore
  
  def self.create_from(spec)
    ShowSet.create(spec) do |show_set|
      show_set.show = Show.find_by_uuid(spec[:show_uuid])
    end
  end

  def self.update_from(spec)
    ShowSet.update(spec[:uuid], spec) do |show_set|
      show_set.show = Show.find_by_uuid(spec[:show_uuid])
    end
  end
  
  def self.remove_from(spec)
    ShowSet.find_by_uuid(spec[:uuid]).delete
  end

  def self.find_all_by_year(year)
    ShowSet.joins(:show).where('shows.year = ?', year)
  end

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