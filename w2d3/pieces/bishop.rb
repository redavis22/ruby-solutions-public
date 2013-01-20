require_relative 'piece'

class Bishop < SlidingPiece
  protected
  def move_dirs
    SlidingPiece::DIAGONAL_DIRS
  end
end
