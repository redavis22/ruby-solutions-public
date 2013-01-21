require_relative 'pieces'

class Board
  def initialize(fill_board = true)
    @pieces = []
    make_starting_grid(fill_board)
  end

  def piece_at(pos)
    raise "invalid pos" unless valid_pos?(pos)

    i, j = pos
    @rows[i][j]
  end

  def add_piece(piece, pos)
    raise "invalid pos" unless valid_pos?(pos)
    raise "position not empty" unless empty?(pos)

    i, j = pos
    @pieces << piece
    @rows[i][j] = piece
  end

  def move_piece(from_pos, to_pos)
    test_board = self.dup
    moved_piece = test_board.perform_move(from_pos, to_pos)

    if test_board.in_check?(moved_piece.color)
      raise "can't move into check"
    else
      perform_move(from_pos, to_pos)
    end
  end

  def valid_pos?(pos)
    pos.all? do |coord|
      (0...8).include?(coord)
    end
  end

  def empty?(pos)
    piece_at(pos).nil?
  end

  def in_check?(color)
    king = find_king(color)

    @pieces.each do |piece|
      next if piece.color == color

      return true if piece.moves.include?(king.pos)
    end

    false
  end

  def render
    @rows.map do |row|
      row.map do |piece|
        piece.nil? ? "." : piece.render
      end.join
    end.join("\n")
  end

  def dup
    new_board = Board.new(false)

    @pieces.each do |piece|
      piece.dup(new_board)
    end

    new_board
  end

  protected
  def make_starting_grid(fill_board)
    @rows = Array.new(8) { Array.new(8) }

    if fill_board
      fill_back_row(0, :black)
      fill_pawns_row(1, :black)
      fill_pawns_row(6, :white)
      fill_back_row(7, :white)
    end
  end

  def fill_back_row(i, color)
    Rook.new(color, self, [i, 0])
    Knight.new(color, self, [i, 1])
    Bishop.new(color, self, [i, 2])
    Queen.new(color, self, [i, 3])
    King.new(color, self, [i, 4])
    Bishop.new(color, self, [i, 5])
    Knight.new(color, self, [i, 6])
    Rook.new(color, self, [i, 7])
  end

  def fill_pawns_row(i, color)
    8.times do |j|
      Pawn.new(color, self, [i, j])
    end
  end

  def find_king(color)
    @pieces.each do |piece|
      return piece if piece.is_a?(King) && piece.color == color
    end

    raise "king not found?"
  end

  def perform_move(from_pos, to_pos)
    raise "from position is empty" if empty?(from_pos)

    piece = piece_at(from_pos)

    raise "piece cannot move to pos" unless piece.moves.include?(to_pos)

    to_i, to_j = to_pos
    from_i, from_j = from_pos

    captured_piece = @rows[to_i][to_j]
    @rows[to_i][to_j] = piece
    @rows[from_i][from_j] = nil

    # TODO: might be a good idea to mark a captured piece as such...
    @pieces.delete(captured_piece) if captured_piece

    piece.pos = to_pos

    # return moved piece
    piece
  end
end
