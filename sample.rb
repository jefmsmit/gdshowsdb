require 'gdshowsdb'

puts "Sample Application"

show = Show.find_by_year_and_month_and_day(1995,7,8)

puts "#{show.year}/#{show.month}/#{show.day} @ #{show.venue}"

show.show_sets.each do |set|
	puts "Set #{set.order}"
	set.songs.each do |song|
		puts song.inspect
	end
end