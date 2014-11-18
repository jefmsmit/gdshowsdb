module Gdshowsdb
  class SongRefDBExtractor
    def initialize(song_ref_list)
      @song_ref_list = song_ref_list
    end

    def extract
      @song_ref_list.map do |song_ref|
        song_ref.attributes.convert_to_sym.reject {|k,v| k == :slug || k == :song_occurences_count }
      end
    end
  end
end