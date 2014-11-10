module Gdshowsdb
  include Gdshowsdb::Utils
  class SongRefDBExtractor
    def initialize(song_ref_list)
      @song_ref_list = song_ref_list
    end

    def extract
      @song_ref_list.map do |song_ref|
        convert_to_sym(song_ref.attributes).reject {|k,v| k == :slug }
      end
    end
  end
end