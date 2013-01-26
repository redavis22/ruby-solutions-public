class Hand
  def self.deal_hand(deck)
    Hand.new(deck.take(8))
  end

  def initialize(cards)
    @cards = cards
  end

  def count
    @cards.count
  end
end
