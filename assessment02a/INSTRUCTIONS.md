# Crazy Eights

## Rules

Game rules are here:

    http://en.wikipedia.org/wiki/Crazy_eights

In a nutshell:

* Players are initially dealt eight cards.
* Discard pile contains one initial card.
* Play goes around in turns.
* Player may play either the same number as the top card in the
  discard pile, or the same suit.
* The player may also always play an eight of any suit, in which case
  they also get to specify the suit that follows.
* Winner is the first with no cards in their hand

## RSpec/Rakefile

First solve the `Deck` specs: `rake spec spec/deck_spec.rb`. The move
on to `Pile`, and finally `AIPlayer`.

RSpec's `--fail-fast` mode is on by default; it produces less output
by stopping on the first failed test. If you prefer to turn it off,
remove that flag from the Rakefile.
