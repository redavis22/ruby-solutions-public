require 'rspec'
require 'blackjack'

include Blackjack

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

describe Hand do
  describe "::deal_from" do
    it "deals a hand of two cards" do
      cards = [
        Card.new(:spades, :deuce),
        Card.new(:spades, :three)
      ]

      deck = Deck.new(cards.dup)
      hand = Hand.deal_from(deck)

      deck.cards.count.should == 0
      hand.cards.should =~ cards
    end
  end

  context "with low hand" do
    subject(:low_hand) do
      Hand.new([
          Card.new(:spades, :deuce),
          Card.new(:spades, :four)
        ])
    end

    its(:points) { should == 6 }

    describe "#busted?" do
      it "is not busted?" do
        low_hand.busted?.should be_false
      end
    end

    describe "#hit" do
      let(:deck) { Deck.new([Card.new(:spades, :seven)]) }

      before do
        low_hand.hit(deck)
      end

      it "takes a card" do
        low_hand.cards.count.should == 3
      end

      it "increases score" do
        low_hand.points.should == 13
      end
    end

    describe "#return_cards" do
      let(:deck) { double("deck") }

      it "returns cards to deck" do
        deck.should_receive(:return) do |cards|
          cards.count.should == 2
        end

        low_hand.return_cards(deck)

        low_hand.cards.count.should == 0
      end
    end
  end

  context "with high hand" do
    subject(:high_hand) do
      Hand.new([
          Card.new(:spades, :ten),
          Card.new(:spades, :ace)
        ])
    end

    let(:deck) do
      Deck.new([
          Card.new(:spades, :deuce),
          Card.new(:spades, :ten),
          Card.new(:spades, :four)
        ])
    end

    it "uses ace as 11 by default" do
      high_hand.points.should == 21
    end

    it "uses ace as 1 if needed" do
      high_hand.hit(deck)
      high_hand.points.should == 15
    end

    it "handles multiple aces" do
      Hand.new([
          Card.new(:spades, :ten),
          Card.new(:hearts, :ace),
          Card.new(:clubs, :ace)
        ]).points.should == 12
    end

    context "busted" do
      before do
        high_hand.hit(deck)
        high_hand.hit(deck)
      end

      it "is busted" do
        high_hand.busted?.should be_true
      end

      it "won't allow further hits" do
        expect do
          high_hand.hit(deck)
        end.to raise_error("already busted")
      end
    end
  end

  context "with two hands" do
    let(:hand1) do
      Hand.new([
          Card.new(:spades, :ten),
          Card.new(:spades, :four)
        ])
    end

    let(:hand2) do
      Hand.new([
          Card.new(:spades, :ten),
          Card.new(:spades, :jack)
        ])
    end

    let(:busted_hand1) do
      Hand.new([
          Card.new(:spades, :ten),
          Card.new(:spades, :jack),
          Card.new(:spades, :queen)
        ])
    end

    let(:busted_hand2) do
      Hand.new([
          Card.new(:spades, :ten),
          Card.new(:spades, :jack),
          Card.new(:spades, :four)
        ])
    end

    describe "#beats?" do
      it "awards win to higher hand" do
        hand2.beats?(hand1).should be_true
      end

      it "can compare tied hands" do
        hand1.beats?(hand1).should be_false
      end

      it "awards win if we didn't bust, but they did" do
        hand1.beats?(busted_hand1).should be_true
      end

      it "never lets busted hand win" do
        busted_hand1.beats?(busted_hand2).should be_false
        busted_hand2.beats?(busted_hand1).should be_false
      end
    end
  end
end

describe Player do
  subject(:player) do
    Player.new("Nick the Greek", 200_000)
  end

  let(:deck) do
    Deck.new([
        Card.new(:spades, :deuce),
        Card.new(:spades, :three)
      ])
  end

  before do
    player.hand = Hand.deal_from(deck)
  end

  its(:name) { should == "Nick the Greek" }
  its(:bankroll) { should == 200_000 }
  its("hand.cards.count") { should == 2 }

  describe "#place_bet" do
    let(:dealer) { double("dealer", :take_bet => nil) }

    it "registers bet with dealer" do
      dealer.should_receive(:take_bet).with(player, 10_000)

      player.place_bet(dealer, 10_000)
    end

    it "deducts bet from bankroll" do
      player.place_bet(dealer, 10_000)

      player.bankroll.should == 190_000
    end

    it "enforces limits" do
      expect do
        player.place_bet(dealer, 1_000_000)
      end.to raise_error("player can't cover bet")
    end
  end

  describe "#pay_winnings" do
    it "adds to winnings" do
      expect do
        player.pay_winnings(200)
      end.to change{player.bankroll}.by(200)
    end
  end

  describe "#return_cards" do
    it "returns player's cards to the deck" do
      deck = double("deck")
      player.hand.should_receive(:return_cards).with(deck)

      player.return_cards(deck)
    end

    it "resets hand to nil" do
      player.return_cards(deck)
      player.hand.should be_nil
    end
  end
end

describe HumanPlayer do
  subject(:human_player) { HumanPlayer.new("Ned", 25) }

  it "implements `#request_bet` somehow" do
    human_player.should respond_to(:request_bet)
  end

  it "implements `#play_hand somehow" do
    human_player.should respond_to(:play_hand)
  end
end

describe Dealer do
  subject(:dealer) { Dealer.new }

  it "calls super with a default name/empty bankroll" do
    dealer.name.should == "dealer"
    dealer.bankroll.should == 0
  end

  it { should be_a(Player) }

  it "should not place bets" do
    expect do
      dealer.place_bet(dealer, 100)
    end.to raise_error("Dealer doesn't bet")
  end

  describe "#play_hand" do
    let(:dealer_hand) { double("hand") }
    let(:deck) { double("deck") }
    before do
      dealer.hand = dealer_hand
    end

    it "should not hit on seventeen" do
      dealer_hand.stub(
        :busted? => false,
        :points => 17)
      dealer_hand.should_not_receive(:hit)

      dealer.play_hand(deck)
    end

    it "should hit until seventeen acheived" do
      dealer_hand.stub(:busted? => false)
      points = 12

      dealer_hand.stub(:points) { points }
      dealer_hand.should_receive(:hit).with(deck).exactly(3).times do
        points += 2
      end

      dealer.play_hand(deck)
    end

    it "should stop when busted" do
      dealer_hand.stub(:busted? => true)
      dealer_hand.should_not_receive(:hit)
      dealer.play_hand(deck)
    end
  end

  context "with a player" do
    let(:player) do
      double("player", :hand => player_hand)
    end

    let(:dealer_hand) do
      double("dealer_hand")
    end

    let(:player_hand) do
      double("player_hand")
    end

    before do
      dealer.stub(:hand => dealer_hand)
      player.stub(:hand => player_hand)
    end

    it "should take bets" do
      dealer.take_bet(player, 100)
      dealer.bets.should == { player => 100 }
    end

    it "should not pay losers (or ties)" do
      dealer.take_bet(player, 100)
      player_hand.should_receive(:beats?).with(dealer_hand).and_return(false)

      # loses
      player.should_not_receive(:pay_winnings)

      dealer.pay_bets
    end

    it "should pay winners" do
      dealer.take_bet(player, 100)
      player_hand.should_receive(:beats?).with(dealer_hand).and_return(true)

      # wins twice the bet
      player.stub(:bankroll => 0)
      player.should_receive(:pay_winnings).with(200)

      dealer.pay_bets
    end
  end
end

describe Game do
  subject(:game) { Game.new(players, dealer, deck) }

  let(:players) { [player1, player2] }
  let(:player1) { HumanPlayer.new("player1", 100) }
  let(:player2) { HumanPlayer.new("player2", 200) }
  let(:deck) { Deck.new }
  let(:dealer) { Dealer.new }

  describe "#deal_cards" do
    it "deals hand to players and dealer" do
      hand1, hand2 = double("hand1"), double(hand2)
      dealer_hand = double("dealer_hand")
      hands = [hand1, hand2, dealer_hand]

      Hand.stub(:deal_from).with(deck).and_return do
        hands.shift
      end

      player1.should_receive(:hand=).with(hand1)
      player2.should_receive(:hand=).with(hand2)
      dealer.should_receive(:hand=).with(dealer_hand)

      game.deal_cards
    end
  end

  describe "#request_bets" do
    it "queries each player for bets" do
      players.each { |p| p.should_receive(:request_bet).with(dealer) }

      game.request_bets
    end
  end

  describe "#play_hands" do
    it "has each player play in turn" do
      (players + [dealer])
        .each { |p| p.should_receive(:play_hand).with(deck) }

      game.play_hands
    end
  end

  describe "#resolve_bets" do
    it "has the dealer pay out" do
      dealer.should_receive(:pay_bets)

      game.resolve_bets
    end
  end

  describe "#return_cards" do
    it "has each player return their cards" do
      (players + [dealer])
        .each { |p| p.should_receive(:return_cards).with(deck) }

      game.return_cards
    end
  end

  describe "#play_round" do
    it "goes through the steps of a round" do
      [:deal_cards,
        :request_bets,
        :play_hands,
        :resolve_bets,
        :return_cards].each do |step|
        game.should_receive(step).ordered
      end

      game.play_round
    end
  end
end
