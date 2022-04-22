require 'spec_helper'

describe 'ShowDBExtractor' do

  first = {uuid: generate_uuid, venue: 'The Venue', city: 'Boulder', state: 'CO', country: 'US', year: 1972, month: 6, day: 12, position: 0} 
  second = {uuid: generate_uuid, venue: 'The Venue', city: 'Boulder', state: 'CO', country: 'US', year: 1972, month: 6, day: 12, position: 1} 
  third = {uuid: generate_uuid, venue: 'The Other Venue', city: 'Denver', state: 'CO', country: 'US', year: 1972, month: 6, day: 13} 
  shows =    
    [
      Show.create(first),
      Show.create(second),
      Show.create(third) do |show|
        show.show_sets.push(ShowSet.create(uuid: generate_uuid, show: show))
      end
    ] unless shows

  subject { Gdshowsdb::ShowDBExtractor.new(shows).extract }

  it { expect(subject.size).to be 3 }
  it { is_expected.to include(first, second, third) }
end
