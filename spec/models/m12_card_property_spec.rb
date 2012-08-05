# -*- encoding: utf-8 -*-
require 'spec_helper'

describe M12CardProperty, 'Model', :vcr => { :cassette_name => 'gatherer/card', :record => :new_episodes } do
  before { described_class.delete_all }
  context "when 'Acidic Slime' multiverseid is given" do
    before(:all) do
      VCR.use_cassette('gatherer/card', record: :new_episodes) do
        @acidic_slime = described_class::create!(nil, {multiverseid: 265718})
      end
    end
    subject { @acidic_slime }
    its(:multiverseid) { should == 265718 }
    its(:card_name) { should == 'Acidic Slime' }
    its('mana_cost.mana_symbols') { should == [3, :Green, :Green] }
    its(:converted_mana_cost) { should == 5 }
    its('type.supertypes') { should == [] }
    its('type.cardtypes') { should == [:Creature] }
    its('type.subtypes') { should == [:Ooze] }
    its(:card_text) do
      should == (<<EOS).chomp
<div class="cardtextbox">Deathtouch <i>(Any amount of damage this deals to a creature is enough to destroy it.)</i>
</div>
<div class="cardtextbox">When Acidic Slime enters the battlefield, destroy target artifact, enchantment, or land.</div>
EOS
    end
    its(:flavor_text) { should be_nil }
    its('p_t.power') { should == '2' }
    its('p_t.toughness') { should == '2' }
    its(:expansion) { should == 'Magic 2013' }
    its(:rarity) { should == :Uncommon }

    describe '#all_sets' do
      subject { @acidic_slime.all_sets }
      it "should contain 'Magic 2010 (Uncommon)'" do
        subject.where(set_name: :'Magic 2010', rarity: :Uncommon).count.should == 1
      end
      it "should contain 'Magic 2011 (Uncommon)'" do
        subject.where(set_name: :'Magic 2011', rarity: :Uncommon).count.should == 1
      end
      it "should contain 'Magic 2012 (Uncommon)'" do
        subject.where(set_name: :'Magic 2012', rarity: :Uncommon).count.should == 1
      end
      it "should contain 'Magic 2013 (Uncommon)'" do
        subject.where(set_name: :'Magic 2013', rarity: :Uncommon).count.should == 1
      end
      it "should contain 'Magic: The Gathering-Commander (Uncommon)'" do
        subject.where(set_name: :'Magic: The Gathering-Commander', rarity: :Uncommon).count.should == 1
      end
      it "#all#count should == 5" do
        subject.all.count.should == 5
      end
    end
    its(:card_number) { should == 159 }
    its(:artist) { should == 'Karl Kopinski' }
  end
  context 'when M12 cards are given' do
    it 'should not raise error' do
      multiverseids = SearchResult.new(set: 'Magic 2013').multiverseids
      expect do
        multiverseids.each do |multiverseid|
          begin
            described_class::create!(nil, {multiverseid: multiverseid})
          rescue => e
            raise e.exception(e.message + " + multiverseid: #{multiverseid}")
          end
        end
      end.not_to raise_error
    end
  end
end
