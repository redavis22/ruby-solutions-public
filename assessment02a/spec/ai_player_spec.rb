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

  describe "#favorite suit" do
    it "computes the suit player has the most of" do
      AIPlayer.new([
          Card.new(:hearts, :five),
          Card.new(:diamonds, :four),
          Card.new(:hearts, :four)
        ]).favorite_suit.should == :hearts
    end
  end

  describe "#play_card" do
    subject(:player) { AIPlayer.new([]) }
    let(:pile) { double("pile") }

    it "plays a non-eight normally" do
      card = Card.new(:spades, :three)
      pile.should_receive(:play).with(card)

      player.play_card(pile, card)
    end

    it "removes card from hand" do
      card = Card.new(:spades, :three)
      pile.stub(:play).with(card)

      player.play_card(pile, card)
      player.cards.should_not include(card)
    end

    it "plays an eight by picking the favorite suit" do
      card = Card.new(:spades, :eight)

      player.stub(:favorite_suit => :hearts)
      pile.should_receive(:play_eight).with(card, :hearts)

      player.play_card(pile, card)
    end
  end

  describe "#play_card_from_hand" do
    subject(:player) { AIPlayer.new([only_card]) }

    let(:only_card) { Card.new(:hearts, :seven) }
    let(:pile) { double("pile") }

    context "with playable card" do
      before do
        pile.stub(:valid_play?).with(only_card).and_return(true)
      end

      it "plays a legal card of appropriate suit if possible" do
        player.should_receive(:play_card).with(pile, only_card)
        player.play_card_from_hand(pile)
      end

      it "returns true" do
        player.stub(:play_card)
        player.play_card_from_hand(pile).should be_true
      end
    end

    it "returns false if no such playable card" do
      pile.should_receive(:valid_play?).with(only_card).and_return(false)

      pile.should_not_receive(:play)
      player.play_card_from_hand(pile).should be_false
    end
  end

  describe "#play_card_from_deck" do
    subject(:player) { AIPlayer.new([]) }

    let(:pile) { double("pile") }
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
        player.stub(:play_card)
      end

      it "draws until a playable card is drawn" do
        pile.should_receive(:valid_play?).exactly(3)

        player.play_card_from_deck(pile, deck)
      end

      it "adds unused cards to hand" do
        player.play_card_from_deck(pile, deck)
        player.cards.count.should == 2
      end

      it "plays the playable card" do
        player.should_receive(:play_card).with(pile, card1)
        player.play_card_from_deck(pile, deck)
      end
    end

    context "deck doesn't contain playable card" do
      before do
        pile.stub(:valid_play?).and_return(false)
      end

      it "draws all cards into hand" do
        player.play_card_from_deck(pile, deck)
        player.cards.count.should == 3
      end

      it "returns false" do
        player.play_card_from_deck(pile, deck).should be_false
      end
    end
  end

#  describe "#play_card_from_hand" do
#    let(:pile) { Pile.new(Card.new(:hearts, :four)) }
#
#    let(:cards1) { [card, eight] }
#    let(:cards2) { [eight, card] }
#
#    let(:card) { Card.new(:hearts, :three) }
#    let(:eight) { Card.new(:diamonds, :eight) }
#
#    it "doesn't play eights ahead of ny other option" do
#      # must never play eight, even if it is seen first.
#      pile.should_not_receive(:play_eight).with(eight)
#
#      AIPlayer.new(cards1).play_card_from_hand(pile)
#      AIPlayer.new(cards2).play_card_from_hand(pile)
#    end
#
#    it "plays an eight if it must" do
#      pile = Pile.new(Card.new(:clubs, :seven))
#      player = AIPlayer.new(cards1)
#
#      player.should_receive(:favorite_suit).and_return(:hearts)
#      pile.should_receive(:play_eight).with(eight, :hearts)
#
#      player.play_card_from_hand(pile)
#    end
#  end
end
