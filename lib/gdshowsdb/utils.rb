require 'securerandom'

module Gdshowsdb
  module Utils
    def encore?(sets, set)
      return false unless sets
      last = (sets.size - 1) == sets.index(set)
      song_size = set[:songs].size          
      song_size < 3 && last
    end

    def generate_uuid
      SecureRandom.uuid
    end

    def convert_to_sym(hash)
      hash.inject({}) do |symboled, (k,v)| 
        symboled[k.to_sym] = v
        symboled
      end
    end

  end
end