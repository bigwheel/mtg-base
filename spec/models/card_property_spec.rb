# -*- encoding: utf-8 -*-
require 'spec_helper'

describe CardProperty, "Model" do
  before { described_class.delete_all }
  it 'can be created' do
    should_not be_nil
  end
  describe 'Acidic Slime' do
    subject do
      mock(OpenURI).open_uri(CardUrl.new(multiverseid: 265718).concat).
        returns(open('./spec/dummy/acidic_slime.html', 'r'))
      described_class.create_from_id(265718)
    end
    its(:card_name) { should == 'Acidic Slime' }
    its(:mana_cost) { should == ['3', 'Green', 'Green'] }
    its(:converted_mana_cost) { should == 5 }
    its(:types) { should == 'Creature  — Ooze' }
    its(:card_text) do
      should == '<div class="cardtextbox">Deathtouch <i>' +
        '(Any amount of damage this deals to a creature is ' +
        'enough to destroy it.)</i>' + "\n</div>\n" + '<div class="cardte' +
        'xtbox">When Acidic Slime enters the battlefield, d' +
        'estroy target artifact, enchantment, or land.</div>'
    end
    its(:flavor_text) { should == '' }
    its(:p_t) { should == '2 / 2' }
    its(:expansion) { should == 'Magic 2013' }
    its(:rarity) { should == 'Uncommon' }
    its(:all_sets) { should == ['Magic 2010 (Uncommon)', 'Magic 2011 (Uncommon)',
                                'Magic 2012 (Uncommon)', 'Magic 2013 (Uncommon)',
                                'Magic: The Gathering-Commander (Uncommon)'] }
    its(:card_number) { should == 159 }
    its(:artist) { should == 'Karl Kopinski' }
  end
  it do
    expect { subject.value_from_label_name }.to raise_error(NoMethodError)
  end
end
