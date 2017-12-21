require 'securerandom'
require 'yaml'

class DeadlistsParser
    def initialize(raw)
        @raw = raw
    end

    def parse
        raw_songs = @raw.split(";")                
        
        raw_songs.map do |item|
            if(item.include? ">")
                raw_segued = item.split(">")
                raw_segued.map.with_index do |segued_item, i|
                    name = clean_name(segued_item)
                    build_map(name, i < (raw_segued.length-1))
                end
            else 
                name = clean_name(item)
                build_map(name, false)
            end            
        end.flatten
    end

    private
    def clean_name(name)
        name.gsub(/\[.?\d+:.?\d+\]/, '').strip
    end

    def build_map(name, segued)        
        {
            uuid: SecureRandom.uuid,
            name: name,
            segued: segued                
        }
    end
end

input = "Johnny B. Goode"

parser = DeadlistsParser.new(input)
puts parser.parse.to_yaml