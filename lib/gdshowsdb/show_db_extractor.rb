module Gdshowsdb
  class ShowDBExtractor
    def self.from_db(year)
      ShowDBExtractor.new(Show.where(year: year))
    end

    def initialize(shows)
      @shows = shows
    end

    def extract
      @shows.map do |show|
        show.attributes.convert_to_sym.reject do |k,v| 
          k == :position and show.position == nil 
        end
      end      
    end
  end
end