# -*- encoding: utf-8 -*-
require 'spec_helper'

describe CardProperty, 'Model', :vcr => { :cassette_name => 'gatherer/card', :record => :new_episodes } do
  before { described_class.delete_all }
  context 'when M13 cards are given' do
    it 'should not raise error' do
      card_urls = GathererScraper::search_result(set: 'Magic 2013')
      expect do
        card_urls.each do |card_url|
          begin
            described_class::parse(card_url).save!
          rescue => e
            raise e.exception(e.message + e.backtrace.join("\n") + " + card_url: #{card_url}")
          end
        end
      end.not_to raise_error
    end
  end
end
