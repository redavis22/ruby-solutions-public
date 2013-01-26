class AIPlayer
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def self.deal_player_in(deck)
    AIPlayer.new(deck.take(8))
  end

  def play_card(pile, card)
    if card.value == :eight
      pile.play_eight(card, favorite_suit)
    else
      pile.play(card)
    end

    # TODO: delete card?
  end

  def play_card_from_hand(pile)
    eights = []

    @cards.each do |card|
      if card.value == :eight
        eights << card
      elsif pile.valid_play?(card)
        play_card(pile, card)
        return true
      end
    end

    play_card(pile, eights.first) unless eights.empty?
    !eights.empty?
  end

  def play_card_from_deck(pile, deck)
    while deck.count > 0
      card = deck.take(1).first
      if pile.valid_play?(card)
        play_card(pile, card)
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
