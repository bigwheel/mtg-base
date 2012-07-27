require 'spec_helper'

describe SearchResult, "Model" do
  describe '#multiverseids', :vcr => { :cassette_name => 'gatherer/search', :record => :new_episodes } do
    subject { SearchResult.new(set: 'Magic 2013').multiverseids }
    its(:length) { should == 234 }
    it { subject.uniq.length.should == 234 }
  end
end
