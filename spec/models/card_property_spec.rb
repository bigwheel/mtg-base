# -*- encoding: utf-8 -*-
require 'spec_helper'

describe CardProperty, "Model" do
  before { described_class.delete_all }
  it 'can be created' do
    should_not be_nil
  end
  it do
    acidic_slime = { card_name: 'Acidic Slime', mana_cost: [3, :green, :green],
      converted_mana_cost: 5, types: 'Creature  — Ooze',
      card_text: '<div class="cardtextbox">Deathtouch <i>' +
      '(Any amount of damage this deals to a creature is ' +
      'enough to destroy it.)</i></div><div class="cardte' +
      'xtbox">When Acidic Slime enters the battlefield, d' +
      'estroy target artifact, enchantment, or land.</div>',
      p_t: '2 / 2', expansion: 'Magic 2013',
      rarity: 'Uncommon', all_sets: ['Magic 2010 (Uncommon)',
        'Magic 2011 (Uncommon)', 'Magic 2012 (Uncommon)',
        'Magic 2013 (Uncommon)',
        'Magic: The Gathering-Commander (Uncommon)'],
        card_number: 159, artist: 'Karl Kopinski' }

    stub(OpenURI).open_uri { open('./spec/dummy/acidic_slime.html', 'r') }
    described_class.create_from_id(265718).should == described_class.new(acidic_slime)
  end
  it do
    expect { subject.value_from_label_name }.to raise_error(NoMethodError)
  end
end
