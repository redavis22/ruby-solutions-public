# -*- coding: utf-8 -*-

require_relative 'piece'

class Knight < SteppingPiece
  def symbols
    ['♘', '♞']
  end

  protected
  def move_diffs
    [ [-3, -2],
      [-3,  2],
      [-2, -3],
      [-2,  3],
      [ 2, -3],
      [ 2,  3],
      [ 3, -2],
      [ 3,  2] ]
  end
end
