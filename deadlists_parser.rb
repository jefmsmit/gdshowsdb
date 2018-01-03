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

data = {sets: []}

sets = [
    "Dancing In The Street [#8:29] ; Mr. Charlie [3:38] ; Brown Eyed Women [4:22] ; Beat It On Down The Line [2:56] ; You Win Again [3:36] ; Jack Straw [4:31] ; Sugaree [7:01] ; El Paso [4:14] ; Chinatown Shuffle [2:35] ; Tennessee Jed [6:41] ; Mexicali Blues [3:16] ; China Cat Sunflower [4:40] ; I Know You Rider [5:18] ; Next Time You See Me [4:30] ; Playing In The Band [6:09] ; Loser [6:15] ; One More Saturday Night (1) [4:23#]",
    "Truckin' [8:45] > Drums [3:07] > The Other One Jam [6:01] > Me And My Uncle [2:50] > The Other One [10:19] ; Space [1:53] > Black Peter [8:38] ; Big River [3:32] ; The Same Thing [7:22] ; Ramble On Rose [5:45] ; Sugar Magnolia [6:42] ; Not Fade Away [6:09] > Goin' Down The Road Feeling Bad [7:08] > Not Fade Away [3:00]",
    "Casey Jones"
].each do |set| 
    parser = DeadlistsParser.new(set)    
    data[:sets] << {
        uuid: SecureRandom.uuid,
        songs: parser.parse
    }
end
puts data.to_yaml