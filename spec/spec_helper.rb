$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'bundler/setup'

require 'gdshowsdb'

include Gdshowsdb
Gdshowsdb.init({ adapter: 'sqlite3', database: ':memory:' })
Gdshowsdb.load(8) #Magic Number warning. This will migrate the DB all the way until loading the shows 

RSpec.configure do |config|
  # some (optional) config here
end
