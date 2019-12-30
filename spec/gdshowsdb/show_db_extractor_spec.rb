require 'spec_helper'

describe 'ShowDBExtractor' do

  let(:first) { {uuid: generate_uuid, venue: 'The Venue', city: 'Boulder', state: 'CO', country: 'US', year: 1981, month: 2, day: 25, position: 0} }
  let(:second) { {uuid: generate_uuid, venue: 'The Venue', city: 'Boulder', state: 'CO', country: 'US', year: 1981, month: 2, day: 25, position: 1} }
  let(:third) { {uuid: generate_uuid, venue: 'The Other Venue', city: 'Denver', state: 'CO', country: 'US', year: 1981, month: 2, day: 26} }
  let(:shows) do
    [
      Show.create(first),
      Show.create(second),
      Show.create(third) do |show|
        show.show_sets.push(ShowSet.create(uuid: generate_uuid, show: show))
      end
    ]
  end

  subject { Gdshowsdb::ShowDBExtractor.new(shows).extract }

  it { expect(subject.size).to be 3 }
  it { is_expected.to include(first, second, third) }
end
