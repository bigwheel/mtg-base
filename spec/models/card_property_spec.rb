require 'spec_helper'

describe "CardProperty Model" do
  let(:card_property) { CardProperty.new }
  it 'can be created' do
    card_property.should_not be_nil
  end
end
