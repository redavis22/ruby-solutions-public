require 'rspec'
require 'ai_player'
require 'card'

describe AIPlayer do
  describe "#initialize" do
    it "sets the players initial cards" do
      cards = double("cards")
      AIPlayer.new(cards).cards.should == cards
    end
  end

  describe "::deal_player_in" do
    it "deals eight cards from the deck to a new player" do
      deck = double("deck")
      cards = double("cards")
      deck.should_receive(:take).with(8).and_return(cards)

      AIPlayer.should_receive(:new).with(cards)
      AIPlayer.deal_player_in(deck)
    end
  end

  let(:pile) { double("pile") }
  describe "#choose_card_from_hand" do
    subject(:player) { AIPlayer.new([only_card]) }
    subject(:only_card) { double("only_card") }

    it "plays a legal card of appropriate suit if possible" do
      pile.should_receive(:valid_play?).with(only_card).and_return(true)
      player.choose_card_from_hand(pile).should == only_card
    end

    it "returns nil if no such playable card" do
      pile.should_receive(:valid_play?).with(only_card).and_return(false)
      player.choose_card_from_hand(pile).should == nil
    end
  end

  describe "#draw_card_to_play" do
    subject(:player) { AIPlayer.new([]) }

    let(:card1) { double("card1") }
    let(:deck) do
      Deck.new([
          card1,
          double("card2"),
          double("card3")
        ])
    end

    context "with deck containing a playable card" do
      before do
        pile.stub(:valid_play?).and_return { |card| card == card1 }
      end

      it "draws until a playable card is drawn" do
        pile.should_receive(:valid_play?).exactly(3)

        player.draw_card_to_play(pile, deck)
      end

      it "adds unused cards to hand" do
        player.draw_card_to_play(pile, deck)
        player.cards.count.should == 2
      end

      it "returns the playable card" do
        player.draw_card_to_play(pile, deck).should == card1
      end
    end

    context "deck doesn't contain playable card" do
      before do
        pile.stub(:valid_play?).and_return(false)
      end

      it "draws all cards into hand" do
        player.draw_card_to_play(pile, deck)
        player.cards.count.should == 3
      end

      it "returns nil" do
        player.draw_card_to_play(pile, deck).should == nil
      end
    end
  end

  describe "#favorite suit" do
    it "computes the suit player has the most of" do
      AIPlayer.new([
          Card.new(:hearts, :five),
          Card.new(:diamonds, :four),
          Card.new(:hearts, :four)
        ]).favorite_suit.should == :hearts
    end
  end
end
