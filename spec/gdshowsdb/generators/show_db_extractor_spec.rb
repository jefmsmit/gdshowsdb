require 'spec_helper'

include Gdshowsdb::Utils

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

  its(:size) { should == 3 }
  it { should include first }
  it { should include second }
  it { should include third }
  
end