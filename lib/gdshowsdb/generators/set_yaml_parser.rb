module Gdshowsdb
  include Gdshowsdb::Utils
  
  class SetYAMLParser

    def initialize(show_list)
      @show_list = show_list
    end

    def parse      
      parsed_sets = []
      
      @show_list.each do |show_date, show| 
        sets = show[:sets]
        if sets && !sets.empty?
          sets.each_with_index do |set, i|
            parsed_sets.push(
              {uuid: set[:uuid], show_uuid: show[:uuid], position: i, encore: encore?(sets, set)}
            )
          end
        end
      end

      parsed_sets
    end

  end
end