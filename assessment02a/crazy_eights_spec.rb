require 'rspec'
require 'card'

describe Deck do
  describe "::all_cards" do
    subject(:all_cards) { Deck.all_cards }

    its(:count) { should == 52 }

    it "returns all different cards" do
      all_cards.map { |card| [card.suit, card.value] }
        .uniq.count.should == all_cards.count
    end
  end
end
