require 'protected_attributes'

class Show < ActiveRecord::Base
  include Extensions::UUID
	
  has_many :show_sets, :foreign_key => :show_uuid, :primary_key => :uuid
  has_many :song_occurences, :foreign_key => :show_uuid, :primary_key => :uuid
  has_many :song_refs, :through => :song_occurences, :foreign_key => :show_uuid

  attr_accessible :uuid, :year, :month, :day, :venue, :city, :state, :country, :position

  def self.parse_date(readable_date)
    parsed = readable_date.split('/')
    date_hash = {year: parsed[0], month: parsed[1], day: parsed[2]}
    if(parsed.length == 4)
      date_hash[:position] = parsed[3]
    end
    date_hash
  end

  def date_string(separator = "/")
    "#{year}#{separator}#{pad month}#{separator}#{pad day}"
  end

  def date_identifier
    if(position)
      date_string + "/#{position}"
    else
      date_string
    end
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