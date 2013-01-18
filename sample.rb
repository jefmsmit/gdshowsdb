require 'gdshowsdb'

puts "Sample Application"

show = Show.find_by_year_and_month_and_day(1976,06,04)
puts show[:uuid]
puts show[:venue]
puts "#{show[:year]}/#{show[:month]}/#{show[:day]}"