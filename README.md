# Gdshowsdb

[![Build Status](https://secure.travis-ci.org/jefmsmit/gdshowsdb.png)](http://travis-ci.org/jefmsmit/gdshowsdb)

All Grateful Dead show information in a relational database.

Hoping to make this freely available database the cannonical resource for all Grateful Dead concert information.

Additionally, This Gem can be used as an API to the data.

## Using with Ruby

```ruby
require 'gdshowsdb'

Gdshowsdb.init()
Gdshowsdb.load()

jack_straw_shows = SongRef.find_by_name('Jack Straw').shows

jack_straw_shows.each do |show|
	puts show.title
end
```

## Using with Rails

Add this to your Gemfile
```
gem 'gdshowsdb', :git => 'git://github.com/jefmsmit/gdshowsdb.git'
```

Generate the database migrations
```
rails generate gdshowsdatabase
```

