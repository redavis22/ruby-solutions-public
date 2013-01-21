# -*- coding: utf-8 -*-

require_relative 'piece'

class Pawn < Piece
  def symbols
    ['♙', '♟']
  end

  def moves
    moves = []

    # NB: not in love with dependency on board orientation. Changes to
    # Board's internal representation would require a change here...
    forward_dir = (color == :white) ? -1 : 1

    i, j = pos
    one_step = [i + forward_dir, j]
    if @board.valid_pos?(one_step) && @board.empty?(one_step)
      moves << one_step

      two_step = [i + 2 * forward_dir, j]
      if at_start_row? && @board.empty?(two_step)
        moves << two_step
      end
    end

    side_attacks = [[i + forward_dir, j - 1], [i + forward_dir, j + 1]]
    side_attacks.each do |new_pos|
      next unless @board.valid_pos?(new_pos)

      threatened_piece = @board.piece_at(new_pos)
      if threatened_piece && threatened_piece.color != self.color
        move_diffs << [dx, dy]
      end
    end

    moves
  end

  private
  def at_start_row?
    pos[0] == ((color == :white) ? 6 : 1)
  end
end
