require 'spec_helper'

describe SearchResult, "Model" do
  subject do
    #stub(OpenURI).open_uri { open('./spec/dummy/acidic_slime.html', 'r') }
  end

  describe '#urls' do
    subject { SearchResult.new(set: 'Magic 2013').urls }
    its(:length) { should == 234 }
    it { subject.uniq.length.should == 234 }
  end
end
