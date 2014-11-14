require 'spec_helper'

describe 'SongYAMLParser' do
  
  let(:show_one_set_one_uuid) { generate_uuid }
  let(:show_one_set_two_uuid) { generate_uuid }
  let(:show_two_set_one_uuid) { generate_uuid }
  let(:song_one_uuid) { generate_uuid }
  let(:song_two_uuid) { generate_uuid }
  let(:song_three_uuid) { generate_uuid }
  let(:song_a_uuid) { generate_uuid }
  let(:song_b_uuid) { generate_uuid }
  let(:song_c_uuid) { generate_uuid }
  let(:shows) do
    {
      '1999/01/01' => {
        uuid: generate_uuid,
        venue: 'Boulder Theater',
        city: 'Boulder',
        state: 'CO',
        country: 'US',
        sets: [
          {
            uuid: show_one_set_one_uuid
          },
          {
            uuid: show_one_set_two_uuid,
            songs: [
              {
                uuid: song_one_uuid,
                name: 'Song Name 1',
                segued: true  
              },
              {
                uuid: song_two_uuid,
                name: 'Song Name 2',
                segued: true
              },
              {
                uuid: song_three_uuid,
                name: 'Song Name 3',
                segued: false
              }
            ]
          }

        ]
      },
      '1999/01/02' => {
        uuid: generate_uuid,
        venue: 'Ogden Theater',
        city: 'Denver',
        state: 'CO',
        country: 'US',
        sets: [
          {
            uuid: show_two_set_one_uuid,
            songs: [
              {
                uuid: song_a_uuid,
                name: 'Song Name A',
                segued: true  
              },
              {
                uuid: song_b_uuid,
                name: 'Song Name B',
                segued: true
              },
              {
                uuid: song_c_uuid,
                name: 'Song Name C',
                segued: false
              }
            ]
          }
        ]  
      }
    }
  end

  subject { Gdshowsdb::SongYAMLParser.new(shows).parse }

  its(:size) { should == 6 }

  it { should include ( {uuid: song_one_uuid, name: 'Song Name 1', show_set_uuid: show_one_set_two_uuid, position: 0, segued: true} ) }
  it { should include ( {uuid: song_two_uuid, name: 'Song Name 2', show_set_uuid: show_one_set_two_uuid, position: 1, segued: true} ) }
  it { should include ( {uuid: song_three_uuid, name: 'Song Name 3', show_set_uuid: show_one_set_two_uuid, position: 2, segued: false} ) }
  it { should include ( {uuid: song_a_uuid, name: 'Song Name A', show_set_uuid: show_two_set_one_uuid, position: 0, segued: true} ) }
  it { should include ( {uuid: song_b_uuid, name: 'Song Name B', show_set_uuid: show_two_set_one_uuid, position: 1, segued: true} ) }
  it { should include ( {uuid: song_c_uuid, name: 'Song Name C', show_set_uuid: show_two_set_one_uuid, position: 2, segued: false} ) }


end