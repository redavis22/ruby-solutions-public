require_relative 'pieces'

class Board
  def initialize
    make_starting_grid
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

  protected
  def make_starting_grid
    @rows = Array.new(8) { Array.new (8) }

    fill_back_row(0, :black)
    fill_pawns_row(1, :black)
    fill_pawns_row(6, :white)
    fill_back_row(7, :white)
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
end
