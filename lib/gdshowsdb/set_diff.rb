module Gdshowsdb
  class SetDiff < Gdshowsdb::Diff
    def initialize(year)
      set_yaml_parser = SetYAMLParser.from_yaml(year)
      set_db_extractor = SetDBExtractor.from_db(year)

      super(set_yaml_parser.parse, set_db_extractor.extract)
    end    
  end
end