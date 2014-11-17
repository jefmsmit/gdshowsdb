module Gdshowsdb
  class SongRefYAMLParser
    def initialize(song_ref_list)
      @song_ref_list = song_ref_list
    end

    def parse
      @song_ref_list.map do |song_ref|
        song_ref.invert
      end        
    end
  end
end