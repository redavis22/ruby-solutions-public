require 'card'

class Deck
  def self.all_cards
    Card.suits.product(Card.values).map do |suit, value|
      Card.new(suit, value)
    end
  end

  def initialize(cards = Deck.all_cards)
    @cards = cards
  end

  def count
    @cards.count
  end

  def peek
    @cards.last
  end

  def include?(card)
    @cards.include?(card)
  end

  def shuffle
    @cards.shuffle!
  end

  def take(n)
    raise "not enough cards" if n > count
    @cards.pop(n)
  end

  def return(cards)
    @cards.unshift(*cards)
  end
end
