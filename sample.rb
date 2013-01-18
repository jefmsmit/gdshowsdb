require 'gdshowsdb'

puts "Sample Application"

show = Show.find_by_year_and_month_and_day(1976,06,04)

puts "#{show.year}/#{show.month}/#{show.day} @ #{show.venue}"

show.sets.each do |set|
	puts "Set #{set.order}"
	set.songs.each do |song|
		puts "#{song.order} #{song.segued}"
	end
end