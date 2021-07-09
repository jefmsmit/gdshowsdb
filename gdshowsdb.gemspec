# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gdshowsdb/version'

Gem::Specification.new do |gem|
  gem.name          = "gdshowsdb"
  gem.version       = Gdshowsdb::VERSION
  gem.authors       = ["Jeff Smith"]
  gem.email         = ["jefmsmit@gmail.com"]
  gem.description   = %q{All Grateful Dead show information in a relational database.}
  gem.summary       = %q{All Grateful Dead show information in a relational database.}
  gem.homepage      = "http://github.com/jefmsmit/gdshowdb"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency("rails", ">= 6.1")
  gem.add_dependency("friendly_id")
end
