require 'spec_helper'

describe 'SongRefYamlParser' do
  
  let(:first_song_uuid) { generate_uuid }
  let(:second_song_uuid) { generate_uuid }
  let(:song_ref_list) do
    [
      {"Song A" => first_song_uuid},
      {"Song B" => second_song_uuid}
    ]
  end

  subject { Gdshowsdb::SongRefYAMLParser.new(song_ref_list).parse }

  its(:size) { should == 2 } 
  it { should include ( {uuid: first_song_uuid, name: 'Song A'}) } 
  it { should include ( {uuid: second_song_uuid, name: 'Song B'}) }
end