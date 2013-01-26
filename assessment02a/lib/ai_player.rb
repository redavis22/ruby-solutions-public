# Represents a computer Crazy Eights player.
class AIPlayer
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  # Creates a new player and deals him a hand.
  def self.deal_player_in(deck)
    AIPlayer.new(deck.take(8))
  end

  # Returns the suit the player has the most of; this is the suit to
  # switch to if player gains control via eight.
  def favorite_suit
    favorite_suit, max_count = :clubs, 0

    Card.suits.each do |suit|
      suit_count = @cards.map(&:suit).count(suit)
      favorite_suit, max_count = suit, suit_count if suit_count > max_count
    end

    favorite_suit
  end

  # Plays a card from hand to the pile, removing it from the hand.
  def play_card(pile, card)
    raise "cannot play card outside your hand" unless @cards.include?(card)
    if card.value == :eight
      pile.play_eight(card, favorite_suit)
    else
      pile.play(card)
    end

    @cards.delete(card)
  end

  def draw_from(deck)
    @cards << deck.take(1).first
  end

  def choose_card(pile)
    @cards.each do |card|
      if card.value != :eight && pile.valid_play?(card)
        return card
      end
    end

    @cards.select { |card| card.value == :eight }.first
  end
end
