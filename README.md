# Gdshowsdb

[ ![Codeship Status for jefmsmit/gdshowsdb](https://www.codeship.io/projects/b1f0f820-f314-0131-9281-66e36f054ecd/status)](https://www.codeship.io/projects/27798)

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
gem 'gdshowsdb'
```

Generate the database migrations
```
rails generate gdshowsdatabase
```

## Understanding the Model

The `SongRef` class represents the reference data about a song. For example there is only one `SongRef` instance (or database row if you prefer) for "Wharf Rat". This allows us to normalize song names so its always "Goin' Down The Road Feeling Bad" and not sometimes "GDTRFB". A `SongRef` knows the `Shows` where it was performed.

The `Show` class is for reprsenting all the particulars about a performance. City, State, Venue, etc.

The `ShowSet` class is for representing a segment of a show. That way we can know what was played in the first set version the second versus the encore. I did not call it `Set` in order to avoid confusing with the Ruby class of the same name.

The `Song` class is for representing the occurence of a `SongRef`. `Song`s know which set the occurence of a `SongRef` happened in, its position in the `ShowSet` as well as wether it was segued out of.

The `SongOccurence` class is named association (think join table in sql) that allows a `Show` to know which `SongRef`s were performed without having to traverse throug the `ShowSet`s. I'm not convinced of this classes value and might remove it.

