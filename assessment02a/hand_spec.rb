require 'rspec'
require 'card'
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
end
