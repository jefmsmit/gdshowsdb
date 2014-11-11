module Gdshowsdb
  module Diff
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
  end
end