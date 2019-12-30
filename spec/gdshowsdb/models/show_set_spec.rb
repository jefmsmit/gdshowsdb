require 'spec_helper'

describe 'ShowSet' do
  let(:show_uuid) { generate_uuid }
  let(:show) { Show.create(uuid: show_uuid) }

  let(:show_set_uuid) { generate_uuid }
  let(:set_spec) { {uuid: show_set_uuid, show_uuid: show.uuid, position: 0, encore: false} }
  let(:show_set) { ShowSet.create_from(set_spec) }

  context '#create_from' do
    subject { show_set }
    it { is_expected.not_to be_nil }
    it { expect(subject.show).to eq(show) }
  end

  context '#remove_from' do
    before(:each) do
      ShowSet.create_from(set_spec)
      ShowSet.remove_from(set_spec)
      show.show_sets.each {}
    end

    subject { show }

    it{ expect(subject.show_sets).not_to include(show_set) }
  end

end
