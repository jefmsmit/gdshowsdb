module Gdshowsdb
  class ShowDBExtractor
    def initialize(shows)
      @shows = shows
    end

    def extract
      @shows.map do |show|
        convert_to_sym(show.attributes).reject do |k,v| 
          k == :position and show.position == nil 
        end
      end      
    end
  end
end