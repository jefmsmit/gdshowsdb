require 'spec_helper'

describe 'Diff' do

  let(:from_yaml) { nil }
  let(:from_db) { nil }
  let(:common_set) { {uuid: generate_uuid, show_uuid: generate_uuid, position: 1, encore: false} }

  before(:each) do
    @diff = Gdshowsdb::Diff.new(from_yaml, from_db)
  end

  context 'set added to the yaml' do
    let(:added_set) { {uuid: generate_uuid, show_uuid: generate_uuid, position: 2, encore: false} }
    let(:from_yaml) {[common_set, added_set]}
    let(:from_db) { [common_set] }
    subject { @diff.added }

    it { is_expected.to eq([added_set]) }
  end

  context 'set removed from the yaml' do
    let(:removed_set) { {uuid: generate_uuid, show_uuid: generate_uuid, position: 2, encore: false} }
    let(:from_yaml) { [common_set] }
    let(:from_db) {[common_set, removed_set]}
    subject { @diff.removed }

    it { is_expected.to eq([removed_set]) }
  end

  context 'set updated in the yaml' do
    let(:set_uuid) { generate_uuid }
    let(:added_set) { {uuid: generate_uuid, show_uuid: generate_uuid, position: 2, encore: false} } 
    let(:original_set) { {uuid: set_uuid, show_uuid: generate_uuid, position: 2, encore: false} }
    let(:updated_set) { {uuid: set_uuid, show_uuid: generate_uuid, position: 1, encore: true } }
    let(:from_yaml) { [common_set, updated_set, added_set] }
    let(:from_db) { [common_set, original_set] }
    subject { @diff.updated }

    it { is_expected.to eq([updated_set]) }

    it 'should not include updated set in added' do
      expect(@diff.added.select { |item| item[:uuid] == set_uuid }.size).to eq(0)
    end

    it 'should not include updated set in removed' do
      expect(@diff.removed.select { |item| item[:uuid] == set_uuid }.size).to eq(0)
    end
  end

  context 'order of inputs should be irrelevant' do
    let(:additional_set) { {uuid: generate_uuid, show_uuid: generate_uuid, position: 2, encore: false} }
    let(:from_yaml) { [common_set, additional_set] }
    let(:from_db) { [additional_set, common_set] }

    it 'should not find any added' do
      expect(@diff.updated).to be_empty
    end

    it 'should not find any removed' do
      expect(@diff.removed).to be_empty
    end

    it 'should not find any updated' do
      expect(@diff.updated).to be_empty
    end
  end
end
