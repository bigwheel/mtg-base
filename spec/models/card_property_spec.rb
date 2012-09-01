# -*- encoding: utf-8 -*-
require 'spec_helper'

describe CardProperty, 'Model', :vcr => { :cassette_name => 'gatherer/card', :record => :new_episodes } do
  before(:all) { described_class.delete_all }
  shared_examples_for :expansion do |cardset_name|
    context "when #{cardset_name} cards are given", :vcr => { :cassette_name => "gatherer/cardset/#{cardset_name}", :record => :new_episodes } do
      subject { GathererScraper::search_result(set: cardset_name) }
      it 'should not raise error' do
        expect do
          subject.each do |url|
            begin
              described_class.parse(url).save!
            rescue => e
              raise e.exception(e.inspect + " + url: #{url}")
            end
          end
        end.not_to raise_error
      end
    end
  end
  CardProperty::SUPPORTING_EXPANSION_LIST.each do |expansion_name|
    include_examples :expansion, expansion_name.to_s
  end
end
