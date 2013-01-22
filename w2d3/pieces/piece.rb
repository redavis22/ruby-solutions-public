class Piece
  attr_reader :color
  attr_accessor :pos

  def initialize(color, board, pos)
    raise "invalid color" unless [:white, :black].include?(color)
    raise "invalid pos" unless board.valid_pos?(pos)

    @color, @board, @pos = color, board, pos

    board.add_piece(self, pos)
  end

  def moves
    # subclass implements this
    raise NotImplementedError
  end

  def render
    symbols[(color == :white) ? 0 : 1]
  end

  def dup(new_board)
    self.class.new(color, new_board, pos)
  end

  def symbols
    # subclass implements this with unicode chess char
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

  protected
  def move_dirs
    # subclass implements this
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

class SteppingPiece < Piece
  def moves
    moves = []

    move_diffs.each do |(dx, dy)|
      cur_x, cur_y = pos
      pos = [cur_x + dx, cur_y + dy]

      next unless @board.valid_pos?(pos)

      if @board.empty?(pos)
        moves << pos
      elsif @board.piece_at(pos).color != self.color
        moves << pos
      end
    end

    moves
  end

  protected
  def move_diffs
    # subclass implements this
    raise NotImplementedError
  end
end
