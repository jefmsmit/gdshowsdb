require 'yaml'

module Gdshowsdb
  class SongRefDiff < Gdshowsdb::Diff
    def initialize
      song_ref_yaml_parser = SongRefYAMLParser.from_yaml
      song_ref_db_extractor = SongRefDBExtractor.from_db

      super(song_ref_yaml_parser.parse, song_ref_db_extractor.extract)
    end
  end
end