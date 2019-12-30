require 'spec_helper'

describe 'SetYAMLParser' do

  let(:first_show_uuid) { generate_uuid }
  let(:second_show_uuid) { generate_uuid }
  let(:hash) do
    {
      '1999/01/01' => {
        uuid: first_show_uuid,
        venue: 'Boulder Theater',
        city: 'Boulder',
        state: 'CO',
        country: 'US',
        sets: first_show_sets
      },
      '1999/01/02' => {
        uuid: second_show_uuid,
        venue: 'Ogden Theater',
        city: 'Denver',
        state: 'CO',
        country: 'US',
        sets: second_show_sets
      }
    }
  end

  before(:each) do
    @parser = Gdshowsdb::SetYAMLParser.new(hash)
  end

  context 'no shows have sets' do
    let(:first_show_sets) { nil }
    let(:second_show_sets) { [] }

    it 'should not find any sets' do
      expect(@parser.parse).to be_empty
    end
  end

  context 'some shows have sets' do
    let(:first_show_set_one_uuid) { generate_uuid }
    let(:first_show_set_two_uuid) { generate_uuid }
    let(:first_show_sets) do
      [
        {
          uuid: first_show_set_one_uuid,
          songs: [
            {uuid: generate_uuid},
            {uuid: generate_uuid},
            {uuid: generate_uuid},
            {uuid: generate_uuid},
            {uuid: generate_uuid}
          ]
        },
        {
          uuid: first_show_set_two_uuid,
          songs: [
            {uuid: generate_uuid},
            {uuid: generate_uuid}
          ]
        }
      ]
    end

    let(:second_show_sets) { nil }
    subject { @parser.parse }

    it { is_expected.to eq [
        {uuid: first_show_set_one_uuid, show_uuid: first_show_uuid, position: 0, encore: false},
        {uuid: first_show_set_two_uuid, show_uuid: first_show_uuid, position: 1, encore: true} ] }
  end

end
