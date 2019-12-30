require 'spec_helper'

describe 'ShowYAMLParser' do
  
  let(:first_uuid) { generate_uuid }
  let(:second_uuid) { generate_uuid }
  let(:third_uuid) { generate_uuid }
  let(:shows) do
    {
      '1981/02/25/0' => {
        uuid: first_uuid,
        venue: 'The Venue',
        city: 'Boulder',
        state: 'CO',
        country: 'US'
      },
      '1981/02/25/1' => {
        uuid: second_uuid,
        venue: 'The Venue',
        city: 'Boulder',
        state: 'CO',
        country: 'US'
      },
      '1981/02/26' => {
        uuid: third_uuid,
        venue: 'The Other Venue',
        city: 'Denver',
        state: 'CO',
        country: 'US',
        sets: []
      }
    }
  end

  subject { Gdshowsdb::ShowYAMLParser.new(shows).parse }

  it { expect(subject.size).to be 3 }
  it do
    is_expected.to include(
      {uuid: first_uuid, venue: 'The Venue', city: 'Boulder', state: 'CO', country: 'US', year: 1981, month: 2, day: 25, position: 0 },
      {uuid: second_uuid, venue: 'The Venue', city: 'Boulder', state: 'CO', country: 'US', year: 1981, month: 2, day: 25, position: 1 },
      {uuid: third_uuid, venue: 'The Other Venue', city: 'Denver', state: 'CO', country: 'US', year: 1981, month: 2, day: 26}
    )
  end
end
