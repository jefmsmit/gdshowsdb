require 'spec_helper'

include Gdshowsdb::Utils

describe 'SongRefDBExtractor' do
  
  let(:first_song_uuid) { generate_uuid }
  let(:second_song_uuid) { generate_uuid }
  let(:song_ref_list) do
    [
      SongRef.create(uuid: first_song_uuid, name: "Song 1"),
      SongRef.create(uuid: second_song_uuid, name: "Song 2")
    ]
  end

  subject { Gdshowsdb::SongRefDBExtractor.new(song_ref_list).extract }

  it { should include ( {uuid: first_song_uuid, name: 'Song 1'} ) }

  it { should include ( {uuid: second_song_uuid, name: 'Song 2'} ) }

end