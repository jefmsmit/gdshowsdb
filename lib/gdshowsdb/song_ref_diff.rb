require 'yaml'

module Gdshowsdb
  class SongRefDiff < Gdshowsdb::Diff
    def initialize
      raw_yaml = Gdshowsdb.load_yaml('song_refs.yaml')
      song_ref_yaml_parser = Gdshowsdb::SongRefYAMLParser.new(raw_yaml) 

      raw_db = SongRef.find(:all, order: :name)
      song_ref_db_extractor = Gdshowsdb::SongRefDBExtractor.new(raw_db)

      super(song_ref_yaml_parser.parse, song_ref_db_extractor.extract)
    end
  end
end