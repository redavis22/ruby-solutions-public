require 'rspec'
require 'card'
require 'deck'
require 'hand'

describe Hand do
  describe "#initialize" do
    it "should initialize from an array of cards" do
      hand = Hand.new([
          Card.new(:spades, :deuce),
          Card.new(:spades, :three),
          Card.new(:spades, :four)
        ])

      hand.count.should == 3
    end
  end

  describe "::deal_hand" do
    it "draws eight cards from a deck" do
      deck = Deck.new
      hand = Hand::deal_hand(deck)

      hand.count.should == 8
    end
  end
end
