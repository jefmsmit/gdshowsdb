class SongRef < ActiveRecord::Base
	include Extensions::UUID

	has_many :songs, :foreign_key => :song_ref_uuid, :primary_key => :uuid

	attr_accessible :uuid, :name

	def shows
		show_sets = Set.new
		songs.each do |song|
			show_sets << song.show_set
		end

		shows = {}
		show_sets.each do |show_set|
			show = show_set.show
			shows["#{show.year}/#{show.month}/#{show.day}"] = show
		end

		shows.values
	end
end