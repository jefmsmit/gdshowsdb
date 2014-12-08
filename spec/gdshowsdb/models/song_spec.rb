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
  
  context '#create_from' do    
    it 'should create song with relationships' do
      kill_it(song_spec) do
        song = Song.create_from(song_spec)
        song_ref_one.songs.should include song 
        occurence = song_ref_one.song_occurences.find_by_show_uuid(show.uuid)
        occurence.song_ref.name.should == song_ref_one_name
      end      
    end
  end

  context '#remove_from' do    
    it 'should remove song relationships' do
      Song.create_from(song_spec)
      Song.remove_from(song_spec)

      song_ref_one.song_occurences.find_by_show_uuid(show.uuid).should == nil
      song_ref_one.songs.empty?.should == true
    end
  end

end

def kill_it(song_spec, &block)
  yield block
  Song.remove_from(song_spec)  
end