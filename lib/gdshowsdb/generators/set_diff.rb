module Gdshowsdb
  class SetDiff

    include Gdshowsdb::Utils
    
    def initialize(year)
      @year = year
    end

    def diff
      @set_data = yaml_sets
      @set_data_db = database_sets      
    end

    private

    def yaml_sets
      shows = YAML.load_file(Gem.datadir('gdshowsdb') + "/#{@year}.yaml")

      yaml_sets = []
      
      shows.each do |key, value|
        sets = value[:sets]
        
        yaml_set = {}
        sets.each_with_index do |set, i|
          yaml_set[:uuid] = set[:uuid]
          yaml_set[:position] = i
          yaml_set[:encore] = encore?(sets, set)
          yaml_sets.push(yaml_set)          
        end if sets
      end

      yaml_sets

    end

    def database_sets
      ShowSet.joins(:show).where("shows.year = #{@year}")      
    end
  end
end