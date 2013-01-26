class Pile
  attr_reader :top_card

  def initialize(top_card)
    @top_card = top_card
  end

  def valid_play?(card)
    (top_card.suit == card.suit) ||
      (top_card.value == card.value) ||
      (card.value == :eight)
  end
end
