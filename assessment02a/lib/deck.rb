require 'card'

class Deck
  def self.all_cards
    all_cards = []

    Card.suits.each do |suit|
      Card.values.each do |value|
        all_cards << Card.new(suit, value)
      end
    end

    all_cards
  end

  def count
    @cards.count
  end

  def initialize(cards = Deck.all_cards)
    @cards = cards
  end

  def take(n)
    raise "took too many cards" if count < n
    @cards.pop(n)
  end

  def return(cards)
    @cards.unshift(*cards)
  end
end
