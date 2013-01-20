class Board
  def initialize
    @rows = Board.make_empty_grid
  end

  def self.make_empty_grid
    Array.new(8) do
      Array.new(8)
    end
  end

  def piece_at(pos)
    raise "invalid pos" unless valid_pos?(pos)

    i, j = pos
    @rows[i][j]
  end

  def place_piece(piece, pos)
    raise "invalid pos" unless valid_pos?(pos)
    raise "position not empty" unless empty?(pos)

    i, j = pos
    @rows[i][j] = piece
  end

  def valid_pos?(pos)
    pos.all? do |coord|
      (0...8).include?(coord)
    end
  end

  def empty?(pos)
    piece_at(pos).nil?
  end
end
