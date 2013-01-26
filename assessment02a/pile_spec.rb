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

  describe "#current_suit" do
    it "returns the top card suit (for non-eights)" do
      pile.current_suit.should == :clubs
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

  describe "#play" do
    it "changes top card on valid play" do
      played_card = Card.new(:clubs, :seven)

      pile.play(played_card)
      pile.top_card.should == played_card
    end

    it "changes current suit on valid play" do
      pile.play(Card.new(:diamonds, :deuce))
      pile.current_suit.should == :diamonds
    end

    it "rejects an invalid play" do
      expect do
        pile.play(Card.new(:diamonds, :seven))
      end.to raise_error("invalid play")
    end

    it "rejects an eight played this way" do
      expect do
        pile.play(Card.new(:diamonds, :eight))
      end.to raise_error("must declare suit when playing eight")
    end
  end
end
