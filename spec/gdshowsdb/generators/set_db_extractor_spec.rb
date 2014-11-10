require 'spec_helper'

include Gdshowsdb::Utils

describe 'SetDBExtractor' do
  let(:show_uuid) { generate_uuid }
  let(:show) { Show.create(uuid: show_uuid) }
  
  let(:first_show_set_uuid) { generate_uuid }
  let(:sets) do
    [
      ShowSet.create(uuid: first_show_set_uuid) do |s|
        s.show = show
        s.position = 0
        s.encore = false
      end,
      ShowSet.create(uuid: generate_uuid) do |s|
        s.show = show
        s.position = 1
        s.encore = false
      end,
      ShowSet.create(uuid: generate_uuid) do |s|
        s.show = show
        s.position = 2
        s.encore = true
      end
    ]    
  end

  subject(:extracted) { Gdshowsdb::SetDBExtractor.new(sets).extract }
  
  its(:size) { should equal 3 }
  
  context 'individual item' do
    subject { extracted[0] }

    its(:class) { should equal Hash }
    it { should == ({ uuid: first_show_set_uuid, show_uuid: show_uuid, position: 0, encore: false }) }    
  end
end