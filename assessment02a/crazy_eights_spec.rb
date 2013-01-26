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

  describe "#initialize" do
    it "by default fills itself with 52 cards" do
      deck = Deck.new
      deck.count.should == 52
    end

    it "can be initialized with an array of cards" do
      deck = Deck.new([
          Card.new(:spades, :deuce),
          Card.new(:hearts, :three),
          Card.new(:diamonds, :jack)
        ])
      deck.count.should == 3
    end
  end

  describe "#take" do
    let(:deck) do
      Deck.new([
          Card.new(:spades, :deuce),
          Card.new(:hearts, :three),
          Card.new(:diamonds, :jack)
        ])
    end

    # **use the back of the cards array as the top**
    it "takes cards off the top of the deck" do
      deck.take(1).should == [Card.new(:diamonds, :jack)]
    end

    it "removes cards from deck on take" do
      deck.take(2)
      deck.count.should == 1
    end
  end
end
