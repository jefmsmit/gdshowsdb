module Gdshowsdb

  include Gdshowsdb::Utils

  class SetDBExtractor
    def initialize(show_sets)
      @show_sets = show_sets
    end

    def extract
      @show_sets.map do |show_set|
        hash = convert_to_sym(show_set.attributes)
        hash[:show_uuid] = show_set.show.uuid
        hash
      end
    end
  end
end