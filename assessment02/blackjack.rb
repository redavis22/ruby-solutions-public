# -*- coding: utf-8 -*-

module Blackjack
  class Card
    SUIT_STRINGS = {
      :clubs    => "♣",
      :diamonds => "♦",
      :hearts   => "♥",
      :spades   => "♠"
    }

    VALUE_STRINGS = {
      :deuce => "2",
      :three => "3",
      :four  => "4",
      :five  => "5",
      :six   => "6",
      :seven => "7",
      :eight => "8",
      :nine  => "9",
      :ten   => "10",
      :jack  => "J",
      :queen => "Q",
      :king  => "K",
      :ace   => "A"
    }

    BLACKJACK_VALUE = {
      :deuce => 2,
      :three => 3,
      :four  => 4,
      :five  => 5,
      :six   => 6,
      :seven => 7,
      :eight => 8,
      :nine  => 9,
      :ten   => 10,
      :jack  => 10,
      :queen => 10,
      :king  => 10
    }

    def self.suits
      SUIT_STRINGS.keys
    end

    def self.values
      VALUE_STRINGS.keys
    end

    attr_reader :suit, :value

    def initialize(suit, value)
      unless Card.suits.include?(suit) and Card.values.include?(value)
        raise "illegal suit (#{suit.inspect}) or value (#{value.inspect})"
      end

      @suit, @value = suit, value
    end

    def blackjack_value
      raise "ace has special value" if value == :ace

      BLACKJACK_VALUE[value]
    end

    def ==(other_card)
      (self.suit == other_card.suit) && (self.value == other_card.value)
    end

    def to_s
      VALUE_STRINGS[value] + SUIT_STRINGS[suit]
    end
  end

  class Deck
    def self.all_cards
      Card.suits.product(Card.values).map do |suit, value|
        Card.new(suit, value)
      end
    end

    attr_reader :cards

    def initialize(cards = Deck.all_cards)
      @cards = cards
    end

    def shuffle
      @cards.shuffle!
    end

    def take(n)
      @cards.pop(n)
    end

    def return(cards)
      @cards.unshift(*cards)
    end
  end

  class Hand
    # This is called a *factory method*; it's a *class method* that
    # takes the a `Deck` and creates and returning a `Hand`
    # object. This is in contrast to the `#initialize` method that
    # expects an `Array` of cards to hold.
    def self.deal_from(deck)
      Hand.new(deck.take(2))
    end

    attr_accessor :cards

    def initialize(cards)
      @cards = cards
    end

    def points
      points = 0
      aces = 0

      cards.each do |card|
        case card.value
        when :ace
          aces += 1
        else
          points += card.blackjack_value
        end
      end

      aces.times do
        points += ((points + 11) <= 21) ? 11 : 1
      end

      points
    end

    def busted?
      points > 21
    end

    def hit(deck)
      raise "already busted" if busted?

      @cards += deck.take(1)
    end

    def beats?(other_hand)
      return false if busted?

      (other_hand.busted?) || (self.points > other_hand.points)
    end

    def return_cards(deck)
      deck.return(@cards)
      @cards = []
    end

    def to_s
      @cards.join(",") + " (#{points})"
    end
  end

  class Player
    attr_reader :name, :bankroll
    attr_accessor :hand

    def initialize(name, bankroll)
      @name, @bankroll = name, bankroll
    end

    def place_bet(dealer, bet_amt)
      raise "player can't cover bet" if bet_amt > bankroll

      dealer.take_bet(self, bet_amt)

      @bankroll -= bet_amt
    end

    def pay_winnings(bet_amt)
      @bankroll += bet_amt
    end

    def return_cards(deck)
      hand.return_cards(deck)
      self.hand = nil
    end
  end

  class HumanPlayer < Player
    def request_bet(dealer)
      print_status
      puts "Place bet"
      place_bet(dealer, Integer(gets))
    end

    def play_hand(deck)
      until hand.busted?
        print_status
        puts "    Hit or stay?"
        case gets.chomp.downcase
        when "hit"
          hand.hit(deck)
        when "stay"
          break
        end
      end

      puts "    Hand: #{hand}"
    end

    private
    def print_status
      puts "Name:"
      puts "    Bankroll: #{bankroll}"
      puts "    Hand: #{hand}"
    end
  end

  class Dealer < Player
    attr_reader :bets

    def initialize
      super("dealer", 0)

      @bets = {}
    end

    def play_hand(deck)
      until hand.busted? || (hand.points >= 17)
        hand.hit(deck)
      end
    end

    def place_bet(dealer, amt)
      raise "Dealer doesn't bet"
    end

    def take_bet(player, amt)
      @bets[player] = amt
    end

    def pay_bets
      @bets.each do |player, amt|
        player.pay_winnings(2 * amt) if player.hand.beats?(self.hand)
      end

      nil
    end
  end

  class Game
    def initialize(players, dealer = Dealer.new, deck = nil)
      if deck.nil?
        deck = Deck.new
        deck.shuffle
      end

      @players, @dealer, @deck = players, dealer, deck
    end

    def deal_cards
      (@players + [@dealer]).each { |p| p.hand = Hand.deal_from(@deck) }
    end

    def request_bets
      (@players).each { |p| p.request_bet(@dealer) }
    end

    def play_hands
      (@players + [@dealer]).each { |p| p.play_hand(@deck) }
    end

    def resolve_bets
      puts "Dealer hand: #{@dealer.hand}"
      @dealer.pay_bets
    end

    def return_cards
      (@players + [@dealer]).each { |p| p.return_cards(@deck) }
    end

    def play_round
      deal_cards
      request_bets
      play_hands
      resolve_bets
      return_cards

      nil
    end
  end
end
