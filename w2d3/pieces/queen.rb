require_relative 'piece'

class Queen < SlidingPiece
  protected
  def move_dirs
    SlidingPiece::HORIZONTAL_DIRS + SlidingPiece::DIAGONAL_DIRS
  end
end
