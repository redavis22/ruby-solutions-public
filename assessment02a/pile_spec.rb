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
end
