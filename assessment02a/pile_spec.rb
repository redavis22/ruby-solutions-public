require 'rspec'
require 'deck'
require 'pile'

describe Pile do
  subject(:pile) { Pile.new(top_card) }
  let(:top_card) { Card.new(:clubs, :deuce) }

  describe "#initialize" do
    it "is initialized with a 'top card'" do
      # force call to constructor
      pile
    end

    it "sets the top card" do
      pile.top_card.should == top_card
    end
  end

  describe "#valid_play?" do
    it "approves playing a card of the same suit" do
      pile.valid_play?(Card.new(:clubs, :three)).should be_true
    end

    it "aproves playing a card of the same rank" do
      pile.valid_play?(Card.new(:diamonds, :deuce)).should be_true
    end

    it "approves any eight" do
      pile.valid_play?(Card.new(:diamonds, :eight)).should be_true
    end

    it "rejects a non-matching, non-eight play" do
      pile.valid_play?(Card.new(:diamonds, :seven)).should be_false
    end
  end
end
