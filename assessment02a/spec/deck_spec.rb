require 'rspec'
require 'deck'

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

  let(:deck) do
    Deck.new([
        Card.new(:spades, :deuce),
        Card.new(:hearts, :three),
        Card.new(:diamonds, :jack)
      ])
  end

  describe "#take" do
    # **use the back of the cards array as the top**
    it "takes cards off the top of the deck" do
      deck.take(1).should == [Card.new(:diamonds, :jack)]
    end

    it "removes cards from deck on take" do
      deck.take(2)
      deck.count.should == 1
    end

    it "doesn't allow you to take more cards than are in the deck" do
      expect do
        deck.take(10)
      end.to raise_error("took too many cards")
    end
  end

  describe "#return" do
    let(:more_cards) do
      [ Card.new(:hearts, :four),
        Card.new(:hearts, :five),
        Card.new(:hearts, :six) ]
    end

    it "should return cards to the deck" do
      deck.return(more_cards)
      deck.count.should == 6
    end

    it "should not destroy the passed array" do
      deck.return(more_cards)
      more_cards.count.should == 3
    end

    it "should add new cards to the bottom of the deck" do
      deck.return(more_cards)
      deck.take(3) # toss 3 cards away

      deck.take(3).should =~ more_cards
    end
  end
end
