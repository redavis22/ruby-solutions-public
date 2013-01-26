class AIPlayer
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def self.deal_player_in(deck)
    AIPlayer.new(deck.take(8))
  end

  def play(deck, pile)
    card_to_play = choose_card_from_hand(pile)
    if card_to_play.value == :eight
      pile.play_eight(card_to_play, favorite_suit)
    else
      pile.play(card_to_play)
    end
  end

  def choose_card_from_hand(pile)
    eights = []

    @cards.each do |card|
      if card.value == :eight
        eights << card
      elsif pile.valid_play?(card)
        return card
      end
    end

    eights.first
  end

  def draw_card_to_play(pile, deck)
    while deck.count > 0
      card = deck.take(1).first
      if pile.valid_play?(card)
        return card
      else
        @cards << card
      end
    end

    nil
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
