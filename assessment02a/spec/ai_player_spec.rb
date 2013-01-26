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

  subject(:player) { AIPlayer.new(cards) }
  let(:cards) { [card] }

  describe "#play_card" do
    let(:pile) { double("pile") }

    context "with non-eight" do
      let(:card) { Card.new(:spades, :three) }

      before do
        pile.stub(:play)
      end

      it "plays a non-eight normally" do
        pile.should_receive(:play).with(card)

        player.play_card(pile, card)
      end

      it "doesnt't allow cards outside your hand to be played" do
        expect do
          other_card = Card.new(:spades, :ace)
          player.play_card(pile, other_card)
        end.to raise_error("cannot play card outside your hand")
      end

      it "removes card from hand" do
        player.play_card(pile, card)
        player.cards.should_not include(card)
      end
    end

    context "with eight" do
      let(:card) { Card.new(:spades, :eight) }

      it "plays an eight by picking the favorite suit" do
        player.stub(:favorite_suit => :hearts)
        pile.should_receive(:play_eight).with(card, :hearts)

        player.play_card(pile, card)
      end
    end
  end

  describe "#draw_from" do
    subject(:player) { AIPlayer.new([]) }
    it "adds a card from the deck to hand" do
      card = Card.new(:clubs, :deuce)
      deck = double("deck")
      deck.stub(:take).with(1).and_return([card])

      player.draw_from(deck)
      player.cards.should include(card)
    end
  end

  describe "#choose_card" do
    let(:card) { Card.new(:hearts, :seven) }
    let(:pile) { double("pile") }

    context "with playable card" do
      before do
        pile.stub(:valid_play?).with(card).and_return(true)
      end

      it "choose a legal card if possible" do
        player.choose_card(pile).should == card
      end
    end

    context "with an eight in the hand" do
      context "with a choice between eight and non-eight" do
        let(:cards1) { [card, eight] }
        let(:cards2) { [eight, card] }

        let(:card) { Card.new(:hearts, :three) }
        let(:eight) { Card.new(:diamonds, :eight) }

        it "doesn't play eights ahead of any other option" do
          # either play is valid
          pile.stub(:valid_play?).and_return(true)

          [cards1, cards2].each do |cards|
            # no matter the order, must not play eight
            player = AIPlayer.new(cards)

            player.choose_card(pile).should_not == eight
          end
        end

        it "plays an eight if there is no choice" do
          pile.stub(:valid_play?).and_return do |card|
            card == eight
          end

          AIPlayer.new(cards1).choose_card(pile).should == eight
        end
      end
    end

    context "without playable card" do
      it "returns nil" do
        pile.stub(:valid_play?).with(card).and_return(false)

        player.choose_card(pile).should be_nil
      end
    end
  end

  describe "#play_turn" do
  end
end
