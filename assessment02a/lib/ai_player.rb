class AIPlayer
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def self.deal_player_in(deck)
    AIPlayer.new(deck.take(8))
  end

  def play(pile, deck)
    @cards.each do |card|
      if pile.valid_play?(card)
        pile.play(card)
        cards.delete(card)
        return
      end
    end

    while deck.count > 0
      card = deck.take(1).first
      if pile.valid_play?(card)
        pile.play(card)
        break
      else
        @cards << card
      end
    end
  end

  def favorite_suit
    favorite_suit, max_count = :clubs, 0

    Card.suits.each do |suit|
      suit_count = @cards.map(&:suit).count(suit)
      favorite_suit, max_count = suit, suit_count if suit_count > max_count
    end

    favorite_suit
  end
end
