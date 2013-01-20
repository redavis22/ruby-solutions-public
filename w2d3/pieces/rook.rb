require_relative 'piece'

class Rook < SlidingPiece
  protected
  def move_dirs
    SlidingPiece::HORIZONTAL_DIRS
  end
end

