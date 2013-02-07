# Gdshowsdb

All Grateful Dead show information in a relational database.

Hoping to make this freely available database the cannonical resource for all Grateful Dead concert information.

Additionally, This Gem can be used as an API to the data.

```ruby
require 'gdshowsdb'

Gdshowsdb.init()
Gdshowsdb.load()

jack_straw_shows = SongRef.find_by_name('Jack Straw').shows

jack_straw_shows.each do |show|
	puts show.title
end
```


# Resources

http://blog.flatironschool.com/post/35204301093/activerecord-without-rails

https://simpleprojectmanagement.eu/blog//2012/05/dead-simple-activerecord-migrations-without-rails/
