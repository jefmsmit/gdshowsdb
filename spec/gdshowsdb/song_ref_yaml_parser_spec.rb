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

  it { expect(subject.size).to be 2 }
  it do
    is_expected.to include(
      {uuid: first_song_uuid, name: 'Song A'},
      {uuid: second_song_uuid, name: 'Song B'}
    )
  end
end
