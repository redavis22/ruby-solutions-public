require 'rspec'
require 'deck'

describe Deck do
  subject(:deck) { Deck.new }

  describe "::all_cards" do
    it "returns 52 cards" do
      cards = Deck.all_cards
      cards.count == 52

      # should contain one of each; no duplicates
      cards.uniq.count == 52
    end
  end

  it "contains all 52 cards by default" do
    deck.cards.count.should == 52
  end

  it "can be initialized with an array of cards" do
    cards = [
      Card.new(:spades, :ace),
      Card.new(:spades, :king)
    ]

    Deck.new(cards).cards.count == 2
  end

  it "shuffles the cards" do
    expect do
      deck.shuffle
    end.to change{deck.cards}
  end

  describe "#take" do
    it "lets user take cards" do
      taken_cards = deck.take(5)

      taken_cards.count.should == 5
      taken_cards.each { |card| card.is_a?(Card) }
    end

    it "removes those cards from deck" do
      taken_cards = deck.take(5)

      deck.cards.count.should == 47
      taken_cards.each do |card|
        deck.cards.include?(card).should be_false
      end
    end
  end

  describe "#return" do
    let(:taken_cards) { deck.take(5) }

    it "returns cards to deck" do
      deck.return(taken_cards)

      deck.cards.count.should == 52
    end

    it "returns cards to bottom of deck" do
      original_cards = taken_cards.dup

      deck.return(taken_cards)
      deck.take(47)
      deck.take(5).should =~ original_cards
    end
  end
end
