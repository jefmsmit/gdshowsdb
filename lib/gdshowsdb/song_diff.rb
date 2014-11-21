module Gdshowsdb
  class SongDiff < Gdshowsdb::Diff
    def initialize(year)
      song_yaml_parser = SongYAMLParser.from_yaml(year)
      song_db_extractor = SongDBExtractor.from_db(year)

      super(song_yaml_parser.parse, song_db_extractor.extract)
    end    
  end
end