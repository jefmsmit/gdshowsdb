module Gdshowsdb
  class SetDiff

    def initialize(from_yaml, from_db)
      @from_yaml = from_yaml
      @yaml_uuids = extract_uuids(@from_yaml)
      @from_db = from_db
      @db_uuids = extract_uuids(@from_db)
    end

    def added
      @from_yaml - @from_db
    end

    def removed
      @from_db - @from_yaml
    end

    def updated
      added.select do |item|
        @yaml_uuids.member?(item[:uuid]) && @db_uuids.member?(item[:uuid])
      end
    end

    private

    def extract_uuids(hashes)
      hashes.map do |hash|
        hash[:uuid]
      end
    end

    # include Gdshowsdb::Utils
    
    # def initialize(year)
    #   @year = year
    # end

    # def diff
    #   @set_data = order_set_hash(yaml_sets)
    #   @set_data_db = order_set_hash(database_sets)

    #   # @set_data.each do |set| 
    #   #   puts set.inspect
    #   # end

    #   # @set_data_db.each do |set|
    #   #   puts set.inspect
    #   # end

    #   puts @set_data_db.first 
    #   puts @set_data.first  
    # end

    # private

    # def order_set_hash(set_hash_list)
    #   set_hash_list.map do |hash|
    #     scrubbed = hash.inject({}) do |symboled, (k,v)| 
    #       symboled[k.to_sym] = v
    #       symboled
    #     end

    #     {uuid: scrubbed[:uuid], show_uuid: scrubbed[:show_uuid], position: scrubbed[:position], encore: scrubbed[:encore]}
    #   end.sort_by { |hsh| hsh[:uuid] }
    # end

    # def add_sets
    # end

    # def remove_sets

    # end

    # def yaml_sets
    #   shows = YAML.load_file(Gem.datadir('gdshowsdb') + "/#{@year}.yaml")

    #   yaml_sets = []
      
    #   shows.each do |key, value|
    #     show_uuid = value[:uuid]
    #     sets = value[:sets]
        
    #     yaml_set = {}
    #     sets.each_with_index do |set, i|
    #       yaml_set[:uuid] = set[:uuid]
    #       yaml_set[:position] = i
    #       yaml_set[:encore] = encore?(sets, set)
    #       yaml_set[:show_uuid] = show_uuid
    #       yaml_sets.push(yaml_set)          
    #     end if sets
    #   end

    #   yaml_sets

    # end

    # def database_sets
    #   ShowSet.joins(:show).where("shows.year = #{@year}").map do |item|
    #     item.attributes
    #   end
    # end    
  end
end