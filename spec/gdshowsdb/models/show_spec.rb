require 'spec_helper'

describe "Show" do
  let(:show_spec) { {uuid: generate_uuid, venue: 'The Venue', city: 'Boulder', state: 'CO', country: 'US', year: 1981, month: 2, day: 25, position: 0} }

  context '#update_from' do
    before(:each) { Show.create_from(show_spec) }
    subject { show_spec[:position] = 1; Show.update_from(show_spec) }

    it{ expect(subject.position).to be 1 }
  end
end
