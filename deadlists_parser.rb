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
    ],
    "1969/04/04": [
        "Good Morning Little Schoolgirl [9:57] ; [0:023] % [0:22] ; Doin' That Rag [6:19] ; [0:18] ; Cryptical Envelopment [1:56] > Drums [0:20] > The Other One [8:56] > Cryptical Envelopment [8:57] > Death Don't Have No Mercy",
        "Turn On Your Love Light [22:22] [0:14] ; Dark Star [20:18] > St. Stephen [5:36] > The Eleven [11:47] > Feedback"
    ],
    "1969/04/06": [
        "Good Morning Little Schoolgirl [#5:22] ; [1:39] ; Beat It On Down The Line [1:42] ; [0:47] ; It's All Over Now, Baby Blue [6:59] ; [0:48] ; King Bee",
        "Cryptical Envelopment [1:50] > Drums [0:17] > The Other One [10:39] > Cryptical Envelopment [9:#56] > Death Don't Have No Mercy [11:02] ; [0:32] ; Turn On Your Love Light [22:34] ; [1:53] ; Viola Lee Blues"
    ],
    "1969/04/11": [
        "Morning Dew % Sittin' On Top Of The World % The Other One [#1:22] > Cryptical Envelopment [7:18] > It's A Sin [4:32] ; [1:27] ; Hard To Handle",
        "Dark Star [20:20] > St. Stephen [3:#51] > The Eleven [5:#56] > Turn On Your Love Light"
    ],
    "1969/04/12": [
        "Morning Dew [9:47] ; [0:25] ; Yellow Dog Story (part one) [0:56] ; Good Morning Little Schoolgirl [9:10] ; [2:06] ; Yellow Dog Story (part two) [1:15] ; Doin' That Rag [6:58] ; [0:19] ; He Was A Friend Of Mine [13:21] ; [0:19] ; Cryptical Envelopment [1:11#] % The Other One",
        "Dark Star [#22:21] > St. Stephen [6:04] > The Eleven [11:36] > Turn On Your Love Light [15:04] > Feedback"
    ],
    "1969/04/13": [
        "Turn On Your Love Light [24:55#] % Doin' That Rag [#4:18] ; [0:45] ; Good Morning Little Schoolgirl [8:09] ; [1:05] ; Morning Dew [11:02] [0:14] % Dark Star [24:01] > St. Stephen [7:50] > The Eleven [13:02] > Death Don't Have No Mercy",
        "Alligator [3:45] > Drums [4:50] > Caution Jam [4:00] > And We Bid You Good Night Jam"
    ],
    "1969/04/15": [
        "Hard To Handle ; Morning Dew [10:09] ; [0:32] ; It Hurts Me Too [5:26] ; [0:07] % [0:04] ; China Cat Sunflower [3:04] > Jam [2:23] > Doin' That Rag [6:52] > It's A Sin % Turn On Your Love Light",
        "Sittin' On Top Of The World % The Other One % Dark Star > St. Stephen > The Eleven"
    ],
    "1969/04/17": [
        "Hard To Handle % Morning Dew % Good Morning Little Schoolgirl % Dark Star > St Stephen > It's a Sin > St Stephen > The Eleven > Turn On Your Love Light % Cryptical Envelopment > The Other One > Cryptical Envelopment > Caution (Do Not Stop On Tracks)"
    ],
    "1969/04/18": [
        "Hard To Handle [4:58] ; [1:30] ; Morning Dew [10 ;30] ; [1:35] ; Cryptical Envelopment [1:55] > Drums [0:21] > The Other One [9:41] > Cryptical Envelopment [6:43] > Sittin' On Top Of The World [2:58] > King Bee [8:00] ; [0:10] % [0:22] ; Doin' That Rag [7:#39] ; [0:17] ; Turn On Your Love Light [27:02] ; [0:28] ; Cosmic Charlie [6:29] ; [0:30] ; Beat It On Down The Line"
    ],
    "1969/04/20": [
        "Morning Dew % Good Morning Little Schoolgirl % Doin' That Rag % Dark Star [21:59] > St Stephen [5:21] > The Eleven [7:45] > Death Don't Have Mercy [10:09] % Turn On Your Love Light",
        "Dupree's Diamond Blues [3:52] > Mountains Of The Moon"
    ],
    "1969/04/21": [
        "Hard To Handle [5:26] ; [1:20] ; Morning Dew [8:12] % [0:22] ; Cryptical Envelopment [1:56] > Drums [0:40] > The Other One [9:00] > Cryptical Envelopment [8:#01] > Sittin On Top Of The World [2:58] ; [0:07] % [1:14] ; Alligator [3:43] > Drums [3:32] > Jam [7:24] > Doin' That Rag",
        "Foxy Lady Jam [2:39] ; [1:00] % [0:29] ; Dark Star [22:48] > St. Stephen [5:41] > The Eleven [12:16] > Turn On Your Love Light [1:17] > Drums [0:36] > Turn On Your Love Light [4:20] > Drums [0:21] > Turn On Your Love Light ",
        "Viola Lee Blues [13:56] > Feedback"
    ],
    "1969/04/22": [
        "Sittin On Top Of The World [2:51] ; [1:14] ; Morning Dew [10:18] ; [2:50] ; Beat It On Down The Line [2:48] > Good Morning Little Schoolgirl [8:30] ; [1:42] ; Doin' That Rag [7:36] ; [1:13] ; Cryptical Envelopment [2:00] > Drums [0:45] > The Other One [2:#04] > Cryptical Envelopment [9:21] > Death Don't Have No Mercy",
        "Dupree's Diamond Blues [4:21] > Mountains Of The Moon [4:30] > Jam [2:47] > Dark Star [28:09] > St. Stephen [5:27] > The Eleven [12:30] > Turn On Your Love Light [6:53] > Drums [0:28] > Turn On Your Love Light"
    ],
    "1969/04/23": [
        "He Was A Friend Of Mine [10:59] ; [0:39] ; Dark Star [21:02} > St. Stephen [1:38#] % It's A Sin [#2:04] > St. Stephen [2:16] > Cryptical Envelopment [1:58] > Drums [0:45] > The Other One [8:40] > Cryptical Envelopment [6:55] > Sittin On Top Of The World [2:57] > Turn On Your Love Light ",
        "Morning Dew [9:29] ; [0:45] ; Hard To Handle [6:06] ; [0:21] ; Doin' That Rag [6:56] ; [0:24] ; Alligator [3:41] > Drums [4:40] > drummer's chant [0:22] > Jam [3:18] > The Eleven [8:59] > Jam [7:45] > Caution (Do Not Stop On Tracks) [12:52#] % Feedback [#2:54] > And We Bid You Good Night",
        "Not Fade Away tease [1:12] ; [0:54] ; It's All Over Now Baby Blue"
    ],
    "1969/04/25": [
        "Hard to Handle [4:25] % Doin' That Rag [7:32] % Good Morning Little Schoolgirl [11:28] % Morning Dew [7:32] % Yellow dog story [1:58] % Sitting on Top of the World [3:46] % Turn On Your Love Light"
    ],
    "1969/04/26": [
        " Dupree's Diamond Blues [4:03] ; Mountains Of The Moon [3:55] > Dark Star Jam [2:50] > China Cat Sunflower [5:51] > Doin' That Rag [6:37] ; It Hurts Me Too [5:46] > Hard To Handle [4:28] ; Cryptical Envelopment [2:04] > Drums [0:58] > The Other One [7:27] > The Eleven Jam [4:48] > The Other One 2nd vocals [0:43] > It's A Sin [4:11] ; Morning Dew [9:21] ; Sittin On Top Of The World [3:33] ; New Minglewood Blues [3:42] ; Silver Threads And Golden Needles [3:17] % It's All Over Now, Baby Blue [7:34] ; Saint Stephen [5:48] > Turn On Your Love Light ",
        "Drums [0:45] > Viola Lee Blues [9:29] > Caution Jam [8:18] > Viola Lee Blues [1:39] > Feedback [4:43] > What's Become Of The Baby [8:05] > Feedback [2:18] > And We Bid You Good Night"
    ],
    "1969/04/27": [
        "Turn On Your Love Light [20:55] > Me And My Uncle [3:52] > Jam [0:17] > Sittin On Top Of The World [3:21] [0:05] % [0:05] ; Dark Star [25:45] > St. Stephen [6:02] > The Eleven [13:27] > Turn On Your Love Light ",
        "Morning Dew"
    ],
    "1969/05/07": [
        "Bill Graham intro [1:57] ; He Was A Friend Of Mine [9:00] ; [0:22] ; Cryptical Envelopment [1:56] > Drums [0:39] > The Other One [11:45] > Cryptical Envelopment [7:22] > Doin That Rag [7:09] ; [0:11] ; Me And My Uncle"
    ],
    "1969/05/10": [
        "Hard To Handle [5:33] ; [1:05] ; Me And My Uncle [3:31] ; [0:57] ; Morning Dew [8:06] ; Yellow Dog Story [1:51] ; [0:23] ; Doin' That Rag [6:32] ; [0:31] ; Dark Star [20:59] > St. Stephen [6:08] > The Eleven [15:56] > Turn On Your Love Light"
    ],
    "1969/05/16": [
        "Good Morning Little Schoolgirl [12:08] ; [0:14] ; Doin' That Rag [6:00] ; [3:53] ; Me And My Uncle [3:28] ; [0:10] ; Hard To Handle [4:31] ; [0:5] ; Turn On Your Love Light"
    ],
    "1969/05/23": [
        "Hard To Handle [4:31] ; [0:15] ; Morning Dew [9:13] ; [0:06] ; Me And My Uncle [3:05] ; [0:12] ; Dark Star [18:47] > St. Stephen [6:10] > The Eleven [13:26] > Turn On Your Love Light"
    ],
    "1969/05/24": [
        "Turn On Your Love Light [26:25] ; [0:08] % Doin' That Rag [6:37] > He Was A Friend Of Mine [6:47] > China Cat Sunflower > [2:43] > Jam [1:51] > The Eleven [9:03] > Death Don't Have No Mercy [6:42] ; [0:06] % Alligator [3:54] > Drums [7:03] > drummers' chant [0:15] > Drums [0:11] > St. Stephen [6:11] > Feedback [3:58] > And We Bid You Good Night"
    ],
    "1969/05/28": [
        "Smokestack Lightnin ; That's It For The Other One > Turn On Your Love Light"
    ],
    "1969/05/29": [
        "Morning Dew [8:59] ; [1:05] ; Cryptical Envelopment [1:53] > Drums [0:49] > The Other One [8:45] > Cryptical Envelopment [8:14] > Good Morning Little Schoolgirl [8:49] % Me And My Uncle [2:48] % Alligator [3:05] > Drums [1:35] > Jam [2:00] > Drums [0:31] > Jam [2:29] > Drums [3:47] > Turn On Your Love Light "
    ],
    "1969/05/30": [
        "Morning Dew ; Me & My Uncle ; Doin' That Rag ; I'm A King Bee ; Dark Star [17:02] > Cosmic Charlie [6:#16] ; Saint Stephen > The Eleven [12:33] > Turn On Your Love Light"
    ],
    "1969/05/31": [
        "Hard To Handle [3:57] ; [0:55] ; Cold Rain And Snow [4:13] ; [6:15] ; Yellow Dog Story [1:40] ; [2:45] ; Green Green Grass Of Home [4:05] ; [1:04] ; Me And My Uncle [3:02] ; [0:46] ; Cryptical Envelopment [1:56] > Drums [0:54] > The Other One [10:46] > Cryptical Envelopment [3:#11] > Sittin On Top Of The World [3:28] ; [0:58] ; It Hurts Me Too [5:34] ; [0:59] ; Turn On Your Love Light",
        "He Was A Friend Of Mine [14:27] ; [0:16] % Dark Star [23:58] > Doin' That Rag [4:37#] > Cosmic Charlie",
        "It's All Over Now, Baby Blue [8:51] ; [0:10] ; And We Bid You Good Night [3:11]"
    ],
    "1969/06/05": [
        "Morning Dew [9:33] ; [0:10] % [0:12] ; Me And My Uncle [3:12] ; [0:22] ; Doin' That Rag [7:07] > He Was A Friend Of Mine [10:26] ; [1:27] ; Hard To Handle [5:00] ; [0:42] ; Cosmic Charlie [6:26] ; [0:11] ; Cryptical Envelopment [2:14] > Drums [1:32] > The Other One [8:36] > Cryptical Envelopment",
        "China Cat Sunflower [2:44] > Jam [1:47] > Sittin On Top Of The World [3:29] > Dark Star [21:11] > St. Stephen [5:53] > The Eleven [12:56] > Turn On Your Love Light"
    ],
    "1969/06/08": [
        "Dancing In The Street [12:40] > He Was A Friend Of Mine [12:12] > China Cat Sunflower [2:46] > Jam [1:28] > New Potato Caboose [13:15] ; [0:42] ; Me And My Uncle",
        "Turn On Your Love Light [35:36] ; [0:56] % [0:11] ; The Things I Used To Do [6:37] ; [1:31] ; Who's Lovin' You Tonight [4:59] ; [0:12] % Cryptical Envelopment [2:08] > Drums [1:01] > The Other One [11:24] > Cosmic Charlie "
    ],
    "1969/06/11": [
        "Let It Be Me ; Silver Threads And Golden Needles ; Mama Tried ; Cathy's Clown ; Me And My Uncle ; Slewfoot: Dire Wolf ; Games People Play ; The Race Is On ; Green Green Grass Of Home",
        "Tiger By The Tail ; I've Just Seen A Face ; All I Have To Do Is Dream ; Wabash Cannonball ; Railroading The Great Divide"
    ],
    "1969/06/13": [
        "Hard To Handle [5:23] ; Yellow Dog Story [1:50] ; [0:48] ; Me And My Uncle [3:00] ; [0:48] ; Sittin On Top Of The World [3:47] ; [0:08] ; Beat It On Down The Line [2:28] ; [0:13] ; Good Morning Little Schoolgirl [12:22] ; [0:17] ; China Cat Sunflower [2:44] > Jam [2:50] > Morning Dew [8:54] ; [0:11] ; St. Stephen [5:33] > The Eleven [15:24] > Turn On Your Love Light"
    ],
    "1969/06/14": [
        "Turn On Your Love Light [26:30] > Me And My Uncle [3:13] > Doin' That Rag [7:18] > He Was A Friend Of Mine [9:40] > China Cat Sunflower tease [0:10] ; [0:13] ; Dire Wolf [3:06] ; [0:05] ; China Cat Sunflower tease [0:07] ; [0:38] ; Dark Star [15:09] > St. Stephen [5:59] > The Eleven [14:45] > Turn On Your Love Light [3:25] > Drums [5:12] > drummers' chant [0:12] > Drums [0:10] > Turn On Your Love Light"
    ],
    "1969/06/27": [
        "Slewfoot [3:04] ; [0:17] ; Mama Tried [2:41] > High Time [5:55] % [0:07] ; Dupree's Diamond Blues [3:57] ; [0:24] ; Me And My Uncle [3:20] ; [0:04] % Jam [1:28] > Casey Jones [4:36] ; [3:24] ; Dire Wolf [2:24] ; [0:50] ; Sittin On Top Of The World [3:23] > Big Boss Man [5:42] ; [0:11] % Dark Star [25:53] > St. Stephen [6:52] > The Eleven [2:37] > Green Green Grass Of Home",
        "It's All Over Now, Baby Blue"
    ],
    "1969/06/28": [
        "Slewfoot [3:09] ; [0:51] ; Silver Threads And Golden Needles [4:35] ; [0:19] ; Mama Tried [3:22] ; [1:17] ; Me And My Uncle [3:14] ; [0:05] % [0:09] ; Doin' That Rag [6:47] > High Time [6:06] ; [0:15] ; King Bee [7:38] ; [0:13] ; Sittin On Top Of The World [4:23] ; [0:19] ; Turn On Your Love Light"
    ],
    "1969/07/03": [
        "Green Green Grass Of Home > Slewfoot ; Sittin On Top Of The World ; Morning Dew ; High Time ; Me And My Uncle ; Casey Jones ; Mama Tried ; Hard To Handle ; He Was A Friend Of Mine ; Turn On Your Lovelight"
    ],
    "1969/07/04": [
        "Hard To Handle [4:29] ; [0:25] ; Mama Tried [3:00] [0:26] % Slewfoot [2:58] ; [1:06] ; Silver Threads And Golden Needles [3:08] ; [1:18] ; Cryptical Envelopment [1:56] > Drums [0:40] > The Other One [12:30] > High Time [6:18] > Casey Jones [6:09] ; [0:33] % [0:13] ; King Bee [7:33] ; [1:54] % [0:04] ; Sittin On Top Of The World [2:58] > Me And My Uncle [1:58#] % [0:08] ; Doin' That Rag [#6:21] ; [2:23] ; Let Me In [3:42] ; [4:25] ; Dire Wolf [2:31] ; [1:46] ; St. Stephen [5:39] > Turn On Your Love Light"
    ],
    "1969/07/05": [
        "Morning Dew [10:00] ; [0:06] % Dark Star [18:11] > St. Stephen [5:42] > The Eleven [11:08] > It's All Over Now, Baby Blue",
        "China Cat Sunflower [2:58] > Jam [2:13] > High Time [6:21] > Mama Tried [2:54] ; [1:21] ; Hard To Handle [5:11] ; [0:10] ; Casey Jones [4:43#] % Turn On Your Love Light"
    ],
    "1969/07/07": [
        "Morning Dew [10:12] ; [0:15] ; Mama Tried [3:12] > High Time [8:26] > Casey Jones [4:10] ; [2:25] ; Dark Star [26:#58] > St. Stephen [6:04] > The Eleven [14:36] > Turn On Your Love Light"
    ],
    "1969/07/08": [
        "Green Green Grass Of Home % El Paso % Cryptical Envelopment > Drums > The Other One > Cryptical Envelopment % Casey Jones % Morning Dew"
    ],
    "1969/08/02": [
        "Casey Jones ; Hard To Handle ; Mama Tried ; High Time ; Seasons ; Slewfoot ; Big Boss Man ; Cryptical Envelopment > Drums > The Other One > Cryptical Envelopment > Turn On Your Love Light"
    ],
    "1969/08/03": [
        "Hard To Handle ; Beat It On Down The Line ; Hi-Heel Sneakers ; High Time ; Mama Tried ; Dark Star ; Alligator > Drums > The Other One > Caution (Do Not Stop On Tracks) > And We Bid You Goodnight"
    ],
    "1969/08/16": [
        "St. Stephen [1:#59] > Mama Tried [2:37] > High Time false start [0:23] ; [10:29] ; Dark Star [18:04] > High Time [5:31] % [0:03] ; Turn On Your Love Light"
    ],
    "1969/08/28": [
        "It's A Sin [7:38] ; [0:31] ; Hi-Heeled Sneakers [6:56] ; [1:46] ; Dark Star [31:21# + #15:58] > The Eleven Jam [9:49] > Dark Star"
    ],
    "1969/08/29": [
        "Casey Jones [5:08] ; [0:10] ; Easy Wind [7:55] ; [0:18] Me And My Uncle [3:07] > High Time [7:03] ; [1:03] ; New Orleans [3:24] > Searchin [3:21] > Good Lovin' Jam [0:26] > Good Lovin' [4:#00] ; [0:30] ; Dire Wolf [4:28] > King Bee [7:38] ; [0:15] ; Turn On Your Love Light"
    ],
    "1969/08/30": [
        "China Cat Sunflower [2:55] > Jam [2:43] > Doin' That Rag [7:42] ; [0:47] ; Morning Dew [10:47] ; [0:25] ; Easy Wind [8:20] ; [0:10] % [0:04] ; Dark Star [28:52] > St. Stephen [6:26] > The Eleven [6:35] > Drums [5:14] > High Time "
    ],
    "1969/09/01": [
        "Casey Jones [#5:29] % [1:41] ; Morning Dew [10:34] > Mama Tried [2:36] > High Time [6:32] ; [0:24] ; Easy Wind [7:14] ; [0:10] % Dark Star [17:22] > St. Stephen [6:17] > The Eleven [11:53] > Turn On Your Love Light "
    ],
    "1969/09/06": [
        "Good Morning Little Schoolgirl [11:48] ; [0:13] ; Doin' That Rag [6:28] ; [0:09] ; He Was A Friend Of Mine [12:24] ; [0:06] % [0:16] ; Big Boy Pete [3:09] > Good Lovin' [3:55] ; [0:53] ; It's All Over Now"
    ],
    "1969/09/07": [
        "Peggy Sue [3:26] % That'll Be The Day [3:20] % Johnny B. Goode [3:44] % Baby What You Want Me To Do [4:54] % [0:46] ; Wipe Out Drums [0:16] > Wipe Out Jam [3:54] > Big RR Blues [1:16] % Louie Louie [3:02] > Twist & Shout [1:36] > Blue Moon"
    ],
    "1969/09/26": [
        "Dark Star [#16:40] > St. Stephen [5:52] > The Eleven [10:57] > King Bee [3:35] > Death Don't Have No Mercy"
    ],
    "1969/09/27": [
        "Morning Dew [10:02] ; [0:42] ; Mama Tried [2:36] ; [0:10] ; Next Time You See Me [3:32] ; [0:08] % Casey Jones [4:30] ; [0:10] China Cat Sunflower [2:50] > Jam [3:32] > High Time [7:25] % Dire Wolf [#5:25] ; [0:10] ; Me And My Uncle"
    ],
    "1969/09/30": [
        "China Cat Sunflower [#2:13] >Jam [2:03] > I Know You Rider [3:46] % The Merry Go Round Broke Down tuning ; Take Me Out To The Ballgame tuning[0:55] % Alligator [3:56] > Drums [7:57] > The Other One [10:28] > Death Don't Have No Mercy "
    ],
    "1969/10/25": [
        "High Time [0:10] ; Dark Star [21:42] > St. Stephen [6:00] > The Eleven [9:26#] > Turn On Your Love Light"
    ],
    "1969/10/26": [
        "Jam [3:43] ; [0:14] % [0:14] ; Hard To Handle [6:38] ; [0:25] ; Cold Rain And Snow [5:20] ; [0:09] ; Me And My Uncle [3:26] ; [0:02] % Next Time You See Me [#3:41] ; [2:01] ; Dire Wolf [5:15] ; [1:14] ; Casey Jones [4:34] ; [0:53] ; Easy Wind"
    ],
    "1969/10/31": [
        "Casey Jones [#4:04] ; [0:14] ; Yellow Dog Story [2:52] ; Dire Wolf [4:35] % [0:10] ; It Hurts Me Too [5:54] ; [0:14] % [0:05] ; Cryptical Envelopment [1:57] > Drums [4:33] > The Other One [10:14] > Cryptical Envelopment [7:12] > China Cat Sunflower [3:15] > Jam [3:51] > I Know You Rider [3:38] ; [0:16] % High Time [7:14] ; [0:05] % [0:12] ; Sittin On Top Of The World [3:37] ; [0:05] ; Next Time You See Me [3:19] > Easy Wind [5:55] ; [0:06] % [0:02] ; Turn On Your Love Light "
    ],
    "1969/11/01": [
        "Morning Dew [11:00] ; [0:13] ; Dire Wolf [8:13] > Cold Rain And Snow [5:23] ; [1:18] ; Hard To Handle [6:15] ; [0:16] ; Mama Tried [2:44] > High Time 8:03] ; [0:05] % Good Lovin' [2:05] > Drums [3:42] > Good Lovin' [4:35] ; Easy Wind",
        "He Was A Friend Of Mine [14:25] > China Cat Sunflower [3:01] > Jam [1:12] > I Know You Rider [4:03] > Casey Jones [4:37] % [0:14] ; Alligator [3:49] > Drums [0:11] > Jam [11:19] > And We Bid You Good Night Jam [1:33] > Uncle John's Band Jam [1:58] > Turn On Your Turn On Your Love Light"
    ],
    "1969/11/02": [
        "Cold Rain And Snow [5:45] ; [0:10] % Midnight Hour [8:07] ; [0:10] ; Seasons ; Mama Tried ; Next Time You See Me ; Good Lovin' ; Big Boss Man ; Casey Jones ; Dancing In The Street ; Dark Star [30:07] > St. Stephen [6:18] > The Eleven [12:58] > Death Don't Have No Mercy"
    ],
    "1969/11/07": [
        "Morning Dew [10:40] ; [0:25] % [0:08] ; Mama Tried [2:41] ; [0:03] % [1:15] ; The Star Spangled Banner [1:04] ; The Merry Go Round Broke Down tuning [0:43]] ; Spring Song tuning [0:28] ; Take Me Out To The Ballgame tuning [0:27] [0:07] % [0:04] ; Next Time You See Me [4:19] ; [0:03] % [0:07] ; Good Lovin' [1:43] > Drums [2:43] > Good Lovin' [5:28] ; [0:10] % [0:44] ; China Cat Sunflower [2:56] > Jam [2:30] > I Know You Rider [3:21] > Dark Star [18:33] > Uncle John's Jam [1:45#] > Dark Star [#5:47] > Cryptical Envelopment [1:46] > Drums [4:56] > The Other One [9:54] > Turn On Your Love Light"
    ],
    "1969/11/08": [
        "Good Morning Little Schoolgirl [#12:43] ; [0:18] % Casey Jones [4:14] ; [0:09] % Dire Wolf [7:44] ; [0:08] % Easy Wind [8:24] ; [0:12] % [0:06] ; China Cat Sunflower [3:00] > Jam [3:03] > I Know You Rider [3:18] > High Time [7:16] ; [0:22] ; Mama Tried [2:39] ; [0:09] ; Good Lovin' [1:37] > Drums [2:19] > Good Lovin' [4:34] ; [0:12] % [0:06] ; Cumberland Blues",
        "Dark Star [14:08] > The Other One [12:05] > Dark Star [1:08] > Uncle John's Jam [2:25] > Dark Star [3:05] > St. Stephen [6:32] > The Eleven [15:03] > Caution (Do Not Stop On Tracks) [16:22#] > Jam with recitation [#0:52] > Main Ten Jam [3:04] > Caution (Do Not Stop On Tracks) [8:40] > space [8:10] > Feedback [4:16] > And We Bid You Good Night"
    ],
    "1969/11/21": [
        "Casey Jones [4:20] ; [1:43] ; Good Morning Little Schoolgirl [9:47] ; [0:09] ; Cold Rain And Snow [5:51] ; [1:33] ; Cumberland Blues [4:03] ; [0:09] ; Easy Wind [8:01] ; [0:24] ; Yellow Dog Story",
        "Good Lovin' [1:42] > Drums [1:40] > Good Lovin' [5:54] ; [0:29] ; China Cat Sunflower [2:53] > Jam [2:37] > I Know You Rider [3:40] ; [0:39] ; High Time [7:34] ; [0:17] ; Me And My Uncle [3:15] > Dark Star tease [0:04] ; [0:05] % [0:28] ; Turn On Your Love Light"
    ],
    "1969/12/04": [
        "Casey Jones [4:10] ; [1:04] ; Black Peter [12:27] ; [2:49] ; Big Boss Man [4:20] ; [0:18] ; Me And My Uncle [3:38] ; [0:40] ; Cumberland Blues [4:56] ; [0:48] ; Dire Wolf [1:08#] % Dark Star [29:28] > High Time [7:00] ; [0:25] ; Good Morning Little Schoolgirl [12:40] > Good Lovin' [1:58] > Drums [5:38] > Good Lovin' [5:06] ; [0:36] ; China Cat Sunflower [3:07] > Jam [3:04] > I Know You Rider [3:50] ; [0:34] ; Uncle John's Band"
    ],
    "1969/12/05": [
        "Me And My Uncle [3:16] % [0:55] % Casey Jones [4:#22] % Black Peter [9:10] % Mama Tried [2:20] % It Hurts Me Too [#5:16] % Cumberland Blues [6:51] % Cryptical Envelopment [2:02] > Drums [4:#45] > The Other One 8:#23] > Eleven Jam [1:30] > The Other One [2:37] > Cryptical Envelopment [2:13] > Cosmic Charlie [5:#53] % Dancing In The Street [8:34] % Dire Wolf [4:40] % China Cat Sunflower [#3:01] > Jam [5:00] > I Know You Rider [4:03] > High Time [7:04] % Uncle John's Jam [#0:39#] > The Main Ten [#2:43] > It's All Over Now, Baby Blue"
    ],
    "1969/12/07": [
        "Black Peter [9:35] ; [0:27] ; Hard To Handle [5:38] ; [0:05] % [0:13] ; Cumberland Blues [5:00] ; [0:11] ; Mama Tried [2:30] > Easy Wind [8:02] ; [0:59] ; Dancing In The Street [7:44#] % Good Lovin' [#1:28] > Drums [0:14] > Good Lovin' [5:33] ; [0:37] ; China Cat Sunflower [3:14] > Jam [3:14] > I Know You Rider [3:15] > St. Stephen [6:35] > The Eleven [14:18] > Turn On Your Love Light "
    ],
    "1969/12/10": [
        "China Cat Sunflower > I Know You Rider [#4:29] ; [2:32] ; Black Peter [10:53] ; [1:17] ; Me And My Uncle [3:13] ; [0:19] ; Cold Rain And Snow [4:43] ; [0:11] ; Mama Tried [ 2:40] > High Time [7:16] ; [0:56] ; Easy Wind [6:11] ; [1:42] ; Casey Jones [4:41] ; [0:36] ; Good Morning Little Schoolgirl [11:04] ; [3:33] ; Morning Dew [10:00] ; [0:51] ; Black Queen [11:04] > Turn On Your Love Light",
        "Cryptical Envelopment [2:03] > Drums [6:13] > The Other One [12:14] > Cryptical Envelopment [5:14] > Cosmic Charlie"
    ],
    "1969/12/11": [
        "Casey Jones [4:50] % Cold Rain And Snow [5:09] ; Mama Tried [2:42] ; [0:03] % Yellow Dog Story (1) [2:31] % [0:05] ; Dire Wolf [4:18] % It Hurts Me Too [5:06] ; [0:04] % China Cat Sunflower [3:20] > Jam [3:53] > I Know You Rider [4:12] % Black Peter [11:09] > Me And My Uncle [3:10] % [0:25] ; Hard To Handle [5:37] % [0:31] ; Dark Star [19:42] > St Stephen [7:25] > The Eleven [12:#21] > Cumberland Blues",
        "Morning Dew [10:11] ; [0:53] ; Next Time You See Me [4:44] > Sittin In Top Of The World [3:27] ; [2:55] ; Beat It On Down The Line [2:34] ; [0:26] ; Big Boss Man [3:52] ; [0:40] ; Good Lovin' [1:39] > Drums [3:57#] > Good Lovin' [#2:58] ; [0:26] ; High Time [7:31] ; [0:09] % [0:09] ; Dancing In The Street [9:26] ; [0:18] ; Easy Wind [6:14] ; [0:06] % [0:06] ; Cryptical Envelopment [2:06] > Drums [7:46] > The Other One [8:50] > Cryptical Envelopment [1:17] > Cosmic Charlie"
    ],
    "1969/12/12": [
        "Cold Rain And Snow [5:00] ; [0:18] ; Me And My Uncle [3:21] ; [1:11] ; Easy Wind [9:06] ; [0:23] ; Cumberland Blues [7:15] ; [0:14] ; Black Peter [11:#34] ; [0:26] ; Next Time You See Me [5:20] ; [0:36] ; China Cat Sunflower [2:55]] > Jam [3:14] > I Know You Rider [4:50] ; [0:53] ; Turn On Your Love Light ",
        "Tuning [0:09] ; Hard To Handle [4:24] ; [1:06] ; Casey Jones [4:53] ; [0:19] ; Mama Tried [2:39] > High Time [7:31] ; [0:14] ; Dire Wolf [4:40] ; [0:38] ; Good Lovin' [1:46] > Drums [1:44] > Good Lovin' [2:#21] ; [0:18] ; King Bee [7:38] ; [0:10] % Uncle John's Band [7:31] > Jam [1:27] > He Was A Friend Of Mine [3:16] > Alligator [4:16] > Drums [6:00] > Caution (Do Not Stop On Tracks) [4:12] > And We Bid You Good Night Jam [1:46] > Caution (Do Not Stop On Tracks) [26:24] > Feedback [7:22] > And We Bid You Good Night"
    ],
    "1969/12/13": [
        "Casey Jones [4:26] ; [0:30] ; Hard To Handle [4:43] ; [0:21 ; Black Peter [12:14] ; [1:50] ; Mama Tried [2:31] > China Cat Sunflower [3:11] > Jam [2:39] > I Know You Rider [4:47] > High Time [7:30] ; [0:53] ; Good Lovin' [1:43] > Drums [3:37] > Good Lovin' [4:33] > Cumberland Blues [6:12] ; [1:54] ; St. Stephen [6:59] > Turn On Your Love Light"
    ],
    "1969/12/19": [
        "The Monkey And The Engineer [1:37] ; [0:08] ; Little Sadie [3:23] ; [0:12] ; Long Black Limousine [3:20] % All Around This World [3:41] ; [0:11] % [0:18] % Mason's Children [6:11] % Black Peter [8:42] ; [0:13] % Hard To Handle [3:55] % Cumberland Blues [4:48] ; [0:02] % Casey Jones [4:05] % [0:02] ; Good Lovin' [1:40] > Drums [1:07] > Good Lovin' [5:12] ; [0:04] % Cryptical Envelopment [2:02] > Drums [5:21] > The Other One [8:58] > Cryptical Envelopment [7:28] > Uncle John's Band [5:09] > Turn On Your Love Light"
    ],
    "1969/12/20": [
        "Mason's Children [6:18] ; [1:07] ; China Cat Sunflower [3:08] > Jam [3:51] > I Know You Rider [4:43] > High Time",
        "The Eleven [#11:41] > New Speedway Boogie [8:22] > Turn On Your Love Light"
    ],
    "1969/12/21": [
        "Smokestack Lightning [11:26] > New Speedway Boogie [5:09] ; Dire Wolf [5:03] ; Mason's Children [6:38] ; China Cat Sunflower [5:14] > I Know You Rider [5:27] > Black Peter [9:13] ; [0:10] % [0:06] ; Not Fade Away [8:51] ; [0:21] ; Good Lovin' [1:58] > Drums [6:46] > The Other One [13:04] > Cumberland Blues"
    ],
    "1969/12/26": [
        "he Monkey And The Engineer [1:36] ; [0:14] ; Little Sadie [3:30] ; [0:13] ; Long Black Limousine [4:38] ; [1:26] ; All Around This World [3:44] ; [1:51] ; Gathering Flowers for the Master's Bouquet [2:35] ; [0:15] ; Black Peter [9:28] ; [1:52] ; Uncle John's Band [6:10] ; [0:15] % Casey Jones [#4:03] ; [0:20] ; [0:20] ; Hard To Handle [4:28] ; [0:06] % [0:16] ; Cold Rain And Snow [5:35] ; [0:16] ; China Cat Sunflower [2:29] >Jam [3:36] > I Know You Rider [4:20] > High Time [7:08] ; [1:05] ; Me And My Uncle [3:03] ; [2:42] ; Dark Star [26:00#] % New Speedway Boogie [#3:44] ; [0:39] ; Turn On Your Love Light "
    ],
    "1969/12/31": [
        "China Cat Sunflower [1:57] > Jam [3:06] > I Know You Rider [4:36] ; [2:03] ; Mama Tried [2:37] ; [1:21] ; Next Time You See Me [3:48] ; [0:21] ; Cold Rain And Snow [5:08] ; [0:12] ; Black Peter [9:03] % [0:11] ; Hard To Handle [6:16] ; [0:24] ; Me And My Uncle [3:14] ; [0:16] % [0:11] ; Mason's Children [7:56] ; [0:24] ; Dire Wolf [4:50] ; [0:38] ; Uncle John's Band",
        "Alligator [4:46] > Drums [2:04] > Alligator [8:52] > Jam [2:17] > And We Bid You Good Night Jam [1:08] > Alligator [1:21] > Caution (Do Not Stop On Tracks) [6:44] > Feedback [2:#59] > Good Lovin' [1:54] > Drums [1:25] > The Eleven [13:#10] ; [1:45] ; High Time [8:12] ; [1:11] ; Cumberland Blues [7:03] ; [0:22] ; Big Boy Pete [3:31] ; [0:10] ; Not Fade Away ; [8:25] ; [1:11] % [0:04] ; Seasons [4:18] ; [0:18] ; The Race Is On [2:52] ; [0:46] ; Silver Threads And Golden Needles [1:#54] ; [0:25] ; Slewfoot [3:32] ; [1:33] ; Dancing In The Street"
    ]

}

sets.keys.sort.each do |key|
    value = sets[key]
    value.each do |set|
        parser = DeadlistsParser.new(set)
        puts "key is #{key}"
        year_data[key.to_s][:sets] << {
            uuid: SecureRandom.uuid,
            songs: parser.parse
        }
    end
end

Gdshowsdb.write_yaml("#{year}.yaml", year_data)