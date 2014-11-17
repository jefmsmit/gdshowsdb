require 'spec_helper'

describe 'SetDiff' do

  let(:from_yaml) { nil }
  let(:from_db) { nil }
  let(:common_set) { {uuid: generate_uuid, show_uuid: generate_uuid, position: 1, encore: false} }

  before(:each) do
    @set_diff = Gdshowsdb::SetDiff.new(from_yaml, from_db)
  end 

  context 'set added to the yaml' do    
    let(:added_set) { {uuid: generate_uuid, show_uuid: generate_uuid, position: 2, encore: false} } 
    let(:from_yaml) {[common_set, added_set]}
    let(:from_db) { [common_set] }
    subject { @set_diff.added }

    it { should == [added_set] }    
  end

  context 'set removed from the yaml' do
    let(:removed_set) { {uuid: generate_uuid, show_uuid: generate_uuid, position: 2, encore: false} }     
    let(:from_yaml) { [common_set] }
    let(:from_db) {[common_set, removed_set]}
    subject { @set_diff.removed } 

    it { should == [removed_set] }
  end
  
  context 'set updated in the yaml' do
    let(:set_uuid) { generate_uuid }
    let(:added_set) { {uuid: generate_uuid, show_uuid: generate_uuid, position: 2, encore: false} } 
    let(:original_set) { {uuid: set_uuid, show_uuid: generate_uuid, position: 2, encore: false} }
    let(:updated_set) { {uuid: set_uuid, show_uuid: generate_uuid, position: 1, encore: true } }
    let(:from_yaml) { [common_set, updated_set, added_set] }
    let(:from_db) { [common_set, original_set] }
    subject { @set_diff.updated }

    it { should == [updated_set] }
  end

  context 'order of inputs should be irrelevant' do
    let(:additional_set) { {uuid: generate_uuid, show_uuid: generate_uuid, position: 2, encore: false} }
    let(:from_yaml) { [common_set, additional_set] }
    let(:from_db) { [additional_set, common_set] }

    it 'should not find any added' do
      @set_diff.updated.empty?.should == true
    end

    it 'should not find any removed' do
      @set_diff.removed.empty?.should == true
    end

    it 'should not find any updated' do
      @set_diff.updated.empty?.should == true
    end
  end
  
end