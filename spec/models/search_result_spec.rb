require 'spec_helper'

describe SearchResult, "Model" do
  describe '#urls' do
    let(:params) { { set: 'Magic 2013' } }
    subject do
      base_url = SearchUrl.new(params)
      mock(OpenURI).open_uri(base_url.concat).
        returns(open('./spec/dummy/search_results/top.html', 'r'))
      (0...10).each do |page_number|
        mock(OpenURI).open_uri(base_url.append_params(page: page_number).concat).
          returns(open("./spec/dummy/search_results/#{page_number}.html", 'r'))
      end
      SearchResult.new(params).urls
    end
    its(:length) { should == 234 }
    it { subject.uniq.length.should == 234 }
  end
end
