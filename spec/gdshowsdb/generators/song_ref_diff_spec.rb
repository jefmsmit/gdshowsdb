require 'spec_helper'

include Gdshowsdb::Utils

describe 'SongRefDiff' do

  let(:from_yaml) { nil }
  let(:from_db) { nil }
  let(:common_song_ref) { {uuid: generate_uuid, name: 'Common'} }

  before(:each) do
    @song_ref_diff = Gdshowsdb::SongRefDiff.new(from_yaml, from_db)
  end 

  context 'song_ref added to the yaml' do    
    let(:added_song_ref) { {uuid: generate_uuid, name: 'Added'} } 
    let(:from_yaml) {[common_song_ref, added_song_ref]}
    let(:from_db) { [common_song_ref] }
    subject { @song_ref_diff.added }

    it { should == [added_song_ref] }    
  end

  context 'song_ref removed from the yaml' do
    let(:removed_song_ref) { {uuid: generate_uuid, name: 'Removed'} }     
    let(:from_yaml) { [common_song_ref] }
    let(:from_db) {[common_song_ref, removed_song_ref]}
    subject { @song_ref_diff.removed } 

    it { should == [removed_song_ref] }
  end
  
  context 'song_ref updated in the yaml' do
    let(:song_ref_uuid) { generate_uuid }
    let(:added_song_ref) { {uuid: generate_uuid, name: 'Added'} } 
    let(:original_song_ref) { {uuid: song_ref_uuid, name: 'Original'} }
    let(:updated_song_ref) { {uuid: song_ref_uuid, name: 'Updated' } }
    let(:from_yaml) { [common_song_ref, updated_song_ref, added_song_ref] }
    let(:from_db) { [common_song_ref, original_song_ref] }
    subject { @song_ref_diff.updated }

    it { should == [updated_song_ref] }
  end

  context 'order of inputs should be irrelevant' do
    let(:additional_song_ref) { {uuid: generate_uuid, name: 'Additional'} }
    let(:from_yaml) { [common_song_ref, additional_song_ref] }
    let(:from_db) { [additional_song_ref, common_song_ref] }

    it 'should not find any added' do
      @song_ref_diff.updated.empty?.should == true
    end

    it 'should not find any removed' do
      @song_ref_diff.removed.empty?.should == true
    end

    it 'should not find any updated' do
      @song_ref_diff.updated.empty?.should == true
    end
  end
  
end