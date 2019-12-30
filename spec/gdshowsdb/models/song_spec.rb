require 'spec_helper'

describe 'Song' do
  let(:song_ref_one_name) { generate_uuid }
  let(:song_ref_one) { SongRef.create(uuid: generate_uuid, name: song_ref_one_name) }

  let(:show) { Show.create(uuid: generate_uuid) }
  let(:set_one_uuid) { generate_uuid }
  let(:set_one) do
    ShowSet.create(uuid: set_one_uuid) do |s|
      s.show = show
      s.position = 0
      s.encore = false
    end
  end
  let(:song_one_uuid) { generate_uuid }
  let(:song_spec) { {uuid: song_one_uuid, position: 0, segued: true, show_set_uuid: set_one.uuid, name: song_ref_one.name} }
  let(:song) { Song.create_from(song_spec) }

  context '#create_from' do
    context 'song_ref' do
      subject { song_ref_one }
      it{ expect(subject.songs).to include(song) }
    end

    context 'occurences' do
      before(:each) { song }
      subject { song_ref_one.song_occurences.find_by_show_uuid(show.uuid) }
      it { expect(subject.song_ref).to eq(song_ref_one) }
    end
  end

  context '#remove_from' do
    before(:each) do
      song
      Song.remove_from(song_spec)
    end

    context 'song_ref' do
      subject { song_ref_one }
      it { expect(subject.songs).to be_empty }
    end

    context 'occurences' do
      subject { song_ref_one.song_occurences.find_by_show_uuid(show.uuid) }
      it { is_expected.to be_nil }
    end
  end

  context '#update_from' do
    let(:new_set_uuid) { generate_uuid }
    let(:new_show_set) do
      ShowSet.create(uuid: new_set_uuid) do |s|
        s.show = show
        s.position = 1
        s.encore = true
      end
    end

    subject do
      Song.create_from(song_spec)
      song_spec[:show_set_uuid] = new_show_set[:uuid]
      song_spec[:segued] = false
      Song.update_from(song_spec)
    end

    it { is_expected.not_to be_nil }
    it { expect(subject.show_set).to eq(new_show_set) }
    it { expect(subject.segued).to be false }
  end
end
