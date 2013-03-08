class Show < ActiveRecord::Base
	include Extensions::UUID
	
	has_many :show_sets, :foreign_key => :show_uuid, :primary_key => :uuid
	has_and_belongs_to_many :song_refs, :foreign_key => :show_uuid, :association_foreign_key => :song_ref_uuid

	attr_accessible :uuid, :year, :month, :day, :venue, :city, :state, :country

	def date_string
		"#{year}/#{pad month}/#{pad day}"
	end

	def title
		"#{date_string} #{venue}, #{city}, #{state}, #{country}"
	end

	private 

	def pad(int)
		"%02d" % int
	end
end