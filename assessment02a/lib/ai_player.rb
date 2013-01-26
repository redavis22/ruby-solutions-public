class AIPlayer
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def self.deal_player_in(deck)
    AIPlayer.new(deck.take(8))
  end
end
