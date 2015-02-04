module Gdshowsdb
  class SetDBExtractor    
    def self.from_db(year)      
      SetDBExtractor.new(ShowSet.find_all_by_year(year))
    end

    def initialize(show_sets)
      @show_sets = show_sets
    end

    def extract
      @show_sets.map do |show_set|
        hash = show_set.attributes.convert_to_sym
        hash[:show_uuid] = show_set.show.uuid
        hash
      end
    end
  end
end