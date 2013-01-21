# -*- coding: utf-8 -*-

require_relative 'piece'

class Pawn < SteppingPiece
  def symbols
    ['♙', '♟']
  end

  protected
  def move_diffs
    move_diffs = []

    # NB: not in love with dependency on board orientation. Changes to
    # Board's internal representation would require a change here...
    forward_dir = (color == :white) ? -1 : 1
    move_diffs << [forward_dir, 0]
    # can move two spaces the first time
    move_diffs << [forward_dir * 2, 0] if at_start_row?

    # handle side attacks
    [[forward_dir, -1], [forward_dir, 1]].each do |(dx, dy)|
      new_pos = [pos[0] + dx, pos[1] + dy]

      next unless @board.valid_pos?(new_pos)

      threatened_piece = @board.piece_at(new_pos)
      if threatened_piece && threatened_piece.color != self.color
        move_diffs << [dx, dy]
      end
    end

    move_diffs
  end

  def at_start_row?
    pos[0] == ((color == :white) ? 6 : 1)
  end
end
