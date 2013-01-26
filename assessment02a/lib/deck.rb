require 'card'

# Represents a deck of playing cards
class Deck
  # Returns an array of all 52 playing cards
  def self.all_cards
    all_cards = []

    Card.suits.each do |suit|
      Card.values.each do |value|
        all_cards << Card.new(suit, value)
      end
    end

    all_cards
  end

  # Returns the number of cards in the deck
  def count
    @cards.count
  end

  def initialize(cards = Deck.all_cards)
    @cards = cards
  end

  # Takes `n` cards from the top of the deck.
  def take(n)
    raise "took too many cards" if count < n
    @cards.pop(n)
  end

  # Returns an array of cards to the bottom of the deck.
  def return(cards)
    @cards.unshift(*cards)
  end
end
