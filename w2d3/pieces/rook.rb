require_relative 'piece'

class Rook < SlidingPiece
  def move_dirs
    SlidingPiece::HORIZONTAL_DIRS
  end
end

