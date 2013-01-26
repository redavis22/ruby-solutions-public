class Pile
  attr_reader :top_card

  def initialize(top_card)
    @top_card = top_card
  end

  def current_suit
    @top_card.suit
  end

  def valid_play?(card)
    (top_card.suit == card.suit) ||
      (top_card.value == card.value) ||
      (card.value == :eight)
  end

  def play(card)
    raise "invalid play" unless valid_play?(card)
    raise "must declare suit when playing eight" if card.value == :eight
    @top_card = card
  end
end
