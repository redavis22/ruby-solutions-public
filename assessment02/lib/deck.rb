require 'card'

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
