class Piece
  attr_reader :color

  def initialize(color, board, pos)
    @color, @board, @pos = color, board, pos

    board.place_piece(self, pos)
  end

  def pos
    @pos.dup
  end

  def moves
    raise NotImplementedError
  end
end

class SlidingPiece < Piece
  HORIZONTAL_DIRS = [
    [-1,  0],
    [ 0, -1],
    [ 0,  1],
    [ 1,  0]
  ]

  DIAGONAL_DIRS = [
    [-1, -1],
    [-1,  1],
    [ 1, -1],
    [ 1,  1]
  ]

  def moves
    moves = []

    move_dirs.each do |dx, dy|
      moves += grow_unblocked_moves_in_dir(dx, dy)
    end

    moves
  end

  def move_dirs
    raise NotImplementedError
  end

  private
  def grow_unblocked_moves_in_dir(dx, dy)
    cur_x, cur_y = pos

    moves = []
    while true
      cur_x, cur_y = cur_x + dx, cur_y + dy
      pos = [cur_x, cur_y]

      break unless @board.valid_pos?(pos)

      if @board.empty?(pos)
        moves << pos
      else
        # can take an opponent's piece
        moves << pos if @board.piece_at(pos).color != self.color

        # can't move past blocking piece
        break
      end
    end

    moves
  end
end
