module Gdshowsdb
  class SetDBExtractor
    def initialize(show_sets)
      @show_sets = show_sets
    end

    def extract
      @show_sets.map do |show_set|
        hash = show_set.attributes.inject({}) do |symboled, (k,v)| 
          symboled[k.to_sym] = v
          symboled
        end
        hash[:show_uuid] = show_set.show.uuid
        hash
      end
    end
  end
end