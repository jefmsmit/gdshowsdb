module Gdshowsdb
  class SetYAMLParser
    def self.from_yaml(year)
      SetYAMLParser.new(Gdshowsdb.load_yaml_for_year(year))
    end

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
              {uuid: set[:uuid], show_uuid: show[:uuid], position: i, encore: ShowSet.encore?(sets, set)}
            )
          end
        end
      end

      parsed_sets
    end

  end
end