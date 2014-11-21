require 'yaml'

module Gdshowsdb
  class ShowDiff < Gdshowsdb::Diff
    def initialize(year)
      show_yaml_parser = ShowYAMLParser.from_yaml(year)
      show_db_extractor = ShowDBExtractor.from_db(year)

      super(show_yaml_parser.parse, show_db_extractor.extract)
    end
  end
end
