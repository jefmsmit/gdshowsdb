require 'spec_helper'

describe 'SongDBExtractor' do
  let(:set_one_uuid) { generate_uuid }
  let(:set_two_uuid) { generate_uuid }
  let(:song_one) { SongRef.create(uuid: generate_uuid, name: "Song #{song_one_uuid}") }
  let(:song_two) { SongRef.create(uuid: generate_uuid, name: "Song #{song_two_uuid}") }
  let(:show) { Show.create(uuid: generate_uuid) }
   
  let(:set_one) do
    ShowSet.create(uuid: set_one_uuid) do |s|
      s.show = show
      s.position = 0
      s.encore = false
    end
  end
  let(:set_two) do
    ShowSet.create(uuid: set_two_uuid) do |s|
      s.show = show
      s.position = 1
      s.encore = false
    end
  end

  let(:song_one_uuid) { generate_uuid }
  let(:song_two_uuid) { generate_uuid }
  let(:songs) do
    [
      Song.create(uuid: song_one_uuid, position: 0, segued: true) do |s|
        s.show_set = set_one
        s.song_ref = song_one
      end,
      Song.create(uuid: song_two_uuid, position: 1, segued: false) do |s|
        s.show_set = set_two
        s.song_ref = song_two
      end
    ]
  end

  subject { Gdshowsdb::SongDBExtractor.new(songs).extract }

  it { expect(subject.size).to be 2 }
  it do
    is_expected.to include(
      {uuid: song_one_uuid, name: "Song #{song_one_uuid}", show_set_uuid: set_one_uuid, position: 0, segued: true},
      {uuid: song_two_uuid, name: "Song #{song_two_uuid}", show_set_uuid: set_two_uuid, position: 1, segued: false}
    )
  end
end
