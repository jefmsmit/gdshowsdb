require 'spec_helper'

describe 'SongRefDBExtractor' do

  let(:first_song_uuid) { generate_uuid }
  let(:second_song_uuid) { generate_uuid }
  let(:song_ref_list) do
    [
      SongRef.create(uuid: first_song_uuid, name: "Song #{first_song_uuid}"),
      SongRef.create(uuid: second_song_uuid, name: "Song #{second_song_uuid}")
    ]
  end

  subject { Gdshowsdb::SongRefDBExtractor.new(song_ref_list).extract }

  it { is_expected.to include({uuid: first_song_uuid, name: "Song #{first_song_uuid}"}) }
  it { is_expected.to include({uuid: second_song_uuid, name: "Song #{second_song_uuid}"}) }
end
