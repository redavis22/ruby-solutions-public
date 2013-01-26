# Represents the common "pile" of cards on which to play Crazy Eights.
class Pile
  attr_reader :top_card

  def initialize(top_card)
    @top_card = top_card
    @eight_suit = nil
  end

  # Returns the current suit in play; either the suit of the top card,
  # or the suit specified by the previous player if an eight was
  # played.
  def current_suit
    @eight_suit || @top_card.suit
  end

  # Returns true if a card is valid to play in this circumstance.
  def valid_play?(card)
    (card.suit == current_suit) ||
      (card.value == top_card.value) ||
      (card.value == :eight)
  end

  # Plays a non-eight card on the top of the pile, objecting if it is
  # not valid.
  def play(card)
    raise "invalid play" unless valid_play?(card)
    raise "must declare suit when playing eight" if card.value == :eight
    @top_card = card

    @eight_suit = nil
  end

  # Plays an eight on top of the pile, setting the suit choice.
  def play_eight(card, suit_choice)
    raise "must play eight" unless card.value == :eight

    @top_card = card
    @eight_suit = suit_choice
  end
end
