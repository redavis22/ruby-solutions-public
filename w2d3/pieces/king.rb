# -*- coding: utf-8 -*-

require_relative 'piece'

class King < SteppingPiece
  def symbols
    ['♔', '♚']
  end

  protected
  def move_diffs
    [ [-1, -1],
      [-1,  0],
      [-1,  1],
      [ 0, -1],
      [ 0,  1],
      [ 1, -1],
      [ 1,  0],
      [ 1,  1] ]
  end
end
