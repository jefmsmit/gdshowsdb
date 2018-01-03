require 'securerandom'
require 'yaml'
require 'gdshowsdb'

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

year = 1969
year_data = Gdshowsdb.load_yaml_for_year(year)

sets = {
    "1969/01/25": [
        "Dark Star [#14:08] > St. Stephen [5:25] > The Eleven [11:43] > Turn On Your Love Light",
        "Dupree's Diamond Blues [4:12] > Doin' That Rag [5:30] > Cosmic Charlie [6:40] ; [0:51] ; Alligator [3:40] > Drums [2:20] > Alligator [2:56] > Caution (Do Not Stop On Tracks) [6:45] > Feedback [4:02] > And We Bid You Good Night"
    ],
    "1969/01/26": [
        "Cryptical Envelopment [1:53] > Drums [0:15] > The Other One [7:39] > Cryptical Envelopment [6:21] > Clementine [10:45] > Death Don't Have No Mercy",
        "Dark Star [9:#45] > St Stephen [7:01] > The Eleven [10:24] > Turn On Your Love Light"
    ],
    "1969/02/02": [
        "Good Morning Little Schoolgirl [11:09] ; [1:20] ; Dark Star [15:45] > St. Stephen [5:25] > The Eleven [9:55#] > Death Don't Have No Mercy [#5:53] ; [1:01] ; Cryptical Envelopment [1:54] > Drums [0:12] > The Other One [7:36] > Cryptical Envelopment [7:32] > Turn On Your Love Light"
    ],
    "1969/02/05": [
        "Turn On Your Love Light [#13:38] ; [1:41] ; Cryptical Envelopment [2:14] > The Other One [5:53] > Cryptical Envelopment [5:53#] % Dark Star [#11:43] > St. Stephen [5:10] > The Eleven [11:32] > Caution (Do Not Stop On Tracks) [7:#55] > Feedback [3:36] > And We Bid You Good Night"
    ],
    "1969/02/06": [
        "Morning Dew [#8:42] ; [1:02] ; Dark Star [13:#54] > St. Stephen [5:22] > The Eleven [11:42] > Turn On Your Love Light [4:54] > Drums [1:07 +] > Turn On Your Love Light [11:57] ; [3:47] ; Cryptical Envelopment [1:55] > Drums [0:14] > The Other One [6:58] > Cryptical Envelopment [7:38#] > Feedback [#3:58] > And We Bid You Good Night"
    ],
    "1969/02/14": [
        "Good Morning Little Schoolgirl [9:30] ; [1:46] ; Dark Star [#18:32] > St. Stephen [6:06] > The Eleven [15:47] > Turn On Your Love Light",
        "Morning Dew [10:18] ; [0:23] ; Cryptical Envelopment [2:03] > Drums [0:13] > The Other One [9:12] > Cryptical Envelopment [14:03] > Death Don't Have No Mercy"
    ],
    "1969/02/19": [
        "Turn On Your Lovelight > Drums [20:20] > Not Fade Away [4:40] > Turn On Your Lovelight [09:36] ; Jam",
        "The Main Ten (Playing In The Band) [11:08] > Jam [6:36] > Dark Star Jam [17:44] > Other One Jam"
    ],
    "1969/02/21": [
        "Good Morning Little Schoolgirl [#12:41] ; [0:16] % Doin' That Rag [6:39] ; [0:17] ; Dark Star [22:22] > St. Stephen [5:59] > The Eleven [23:00] > Turn On Your Love Light",
        "Morning Dew"
    ],
    "1969/02/22": [
        "Dupree's Diamond Blues [#3:57] > Mountains Of The Moon [3:44] > Jam [1:40] > Dark Star [22:17] > Cryptical Envelopment [1:55] > Drums [0:13] > The Other One [8:16] > Cryptical Envelopment [9:34] > Death Don't Have No Mercy ",
        "Doin' That Rag [6:46] > St. Stephen [5:56] > The Eleven [19:17] > Turn On Your Love Light [6:12] > Drums [1:22] > Turn On Your Love Light"
    ],
    "1969/02/27": [
        "Good Morning Little Schoolgirl [9:31] ; [2:30] ; Doin' That Rag [6:21] ; [2:45] ; Cryptical Envelopment [1:52] > Drums [0:13] > The Other One [8:35] > Cryptical Envelopment",
        "Dupree's Diamond Blues [3:57] > Mountains Of The Moon [3:43] > Jam [2:23] > Dark Star [21:50] > St. Stephen [6:27] > The Eleven [15:#42] > Turn On Your Love Light [4:40] > Drums [0:32] > Turn On Your Love Light",
        "Cosmic Charlie"
    ],
    "1969/02/28": [
        "Morning Dew [9:42] ; [0:40] ; Good Morning Little Schoolgirl [9:51] ; [0:26] ; Doin' That Rag [5:46] ; [0:15] ; King Bee [7:05] ; [0:07] ; Turn On Your Love Light",
        "Cryptical Envelopment [1:50] > Drums [0:16] > The Other One [7:50] > Cryptical Envelopment [8:33] > Dark Star [19:29] > St. Stephen [4:08#] > The Eleven [#17:07] > Death Don't Have No Mercy [9:31] ; [0:53] ; Alligator [3:37] > Drums [4:12] > Caution (Do Not Stop On Tracks) [20:25] > Feedback [1:28] > And We Bid You Good Night"
    ],
    "1969/03/01": [
        "Cryptical Envelopment [1:56] > Drums [0:14] > The Other One [9:58] > Cryptical Envelopment [8:37] > New Potato Caboose [11:37] > Doin' That Rag [5:56] > Cosmic Charlie",
        "Bill Graham intro [0:05] ; Dupree's Diamond Blues [3:56] ; Mountains Of The Moon [3:37] > Jam [1:03] ; [0:23] ; Dark Star [22:48] > St. Stephen [5:34] > The Eleven [8:23] > Turn On Your Love Light",
        "Hey Jude"
    ],
    "1969/03/02": [
        "Dark Star [20:37] > St. Stephen [5:07] > The Eleven [15:14] > Turn On Your Love Light",
        "Doin' That Rag [6:38] > Cryptical Envelopment [2:01] > Drums [0:18] > The Other One [9:37] > Cryptical Envelopment [10:35] > space [0:12] > Death Don't Have No Mercy [11:13] ; [1:20] ; Morning Dew [10:01] ; [1:#13] ; Alligator [4:03] > Drums [6:37] > drummers' chant [0:12] > Drums [0:14] > Jam [4:48] > And We Bid You Good Night Jam [3:22#] % Jam [#14:12] > Caution Jam [2:50] > Caution (Do Not Stop On Tracks) [8:42] > Feedback [7:47] > And We Bid You Good Night"
    ],
    "1969/03/15": [
        "Hard To Handle [4:50] ; [0:11] ; Good Morning Little Schoolgirl [8:13] ; [0:09] ; Dark Star [19:08] > St. Stephen [5:25] > The Eleven [13:#11] > Turn On Your Love Light"
    ],
    "1969/03/22": [
        "Good Morning Little Schoolgirl [#12:08] ; [0:04] % [0:44] ; Dark Star [15:25] > St. Stephen [5:23#] > The Eleven [#4:56] > Turn On Your Love Light "
    ],
    "1969/03/28": [
        "Good Morning Little Schoolgirl [#12:05] ; [0:25] ; Dark Star [22:45] > St. Stephen [6:18] > The Eleven [15:37] > Death Don't Have No Mercy [9:39] > Turn On Your Love Light [22:40] ; [2:13] ; Cryptical Envelopment [1:59] > Drums [0:21] > The Other One [9:37] > Cryptical Envelopment"
    ],
    "1969/03/29": [
        "Morning Dew [9:36] ; [0:10] ; Good Morning Little Schoolgirl [9:29] ; [0:09] ; Doin' That Rag [6:18] ; [0:37] Dark Star [21:15] > St. Stephen [5:32] > The Eleven [11:58] > Turn On Your Love Light"
    ]
}

sets.keys.sort.each do |key|
    value = sets[key]
    value.each do |set|
        parser = DeadlistsParser.new(set)
        year_data[key.to_s][:sets] << {
            uuid: SecureRandom.uuid,
            songs: parser.parse
        }
    end
end

Gdshowsdb.write_yaml("#{year}.yaml", year_data)