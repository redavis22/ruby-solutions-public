require 'rspec'
require 'ai_player'
require 'card'
require 'pile'

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

  describe "#play" do
    subject(:player) { AIPlayer.new([only_card]) }

    let(:pile) { Pile.new(Card.new(:diamonds, :three)) }
    let(:deck) { double("deck") }

    context "with playable card (by suit)" do
      let(:only_card) { Card.new(:diamonds, :four) }

      it "plays a legal card of appropriate suit if possible" do
        pile.should_receive(:play).with(only_card)
        player.play(pile, deck)
      end

      it "removes a played card from hand" do
        player.play(pile, deck)
        player.cards.count.should == 0
      end
    end

    context "with playable card (by value)" do
      let(:only_card) { Card.new(:clubs, :three) }

      it "plays a legal card of appropriate value if possible" do
        pile.should_receive(:play).with(only_card)
        player.play(pile, deck)
      end
    end

    it "draws cards from the deck until one can be played" do
      only_card = Card.new(:clubs, :six)
      player = AIPlayer.new([only_card])

      playable_card = Card.new(:clubs, :three)
      deck = Deck.new([
          playable_card,
          Card.new(:clubs, :four),
          Card.new(:clubs, :five),
        ])

      deck.should_receive(:take).with(1).exactly(3).times.and_call_original
      pile.should_receive(:play).with(playable_card)

      player.play(pile, deck)

      # should have added two cards to our hand
      player.cards.count.should == 3
    end
  end
end
