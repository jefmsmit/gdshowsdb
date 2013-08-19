class Show < ActiveRecord::Base
  include Extensions::UUID
	
  has_many :show_sets, :foreign_key => :show_uuid, :primary_key => :uuid
  has_many :song_occurences, :foreign_key => :show_uuid, :primary_key => :uuid
  has_many :song_refs, :through => :song_occurences, :foreign_key => :show_uuid

  attr_accessible :uuid, :year, :month, :day, :venue, :city, :state, :country

  def date_string(separator = "/")
    "#{year}#{separator}#{pad month}#{separator}#{pad day}"
  end

  def title
    "#{date_string} #{venue}, #{city}, #{state}, #{country}"
  end
  
  def to_s
   title
  end

  private 

  def pad(int)
    "%02d" % int
  end
end