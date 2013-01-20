require_relative 'piece'

class Bishop < SlidingPiece
  def move_dirs
    SlidingPiece::DIAGONAL_DIRS
  end
end
