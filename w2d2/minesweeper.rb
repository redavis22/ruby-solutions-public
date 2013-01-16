class Tile
  DELTAS = [
    [-1, -1],
    [-1, 0],
    [-1, 1],
    [0, -1],
    [0, 1],
    [1, -1],
    [1, 0],
    [1, 1]
  ]

  attr_reader :pos

  attr_accessor :bombed, :flagged, :explored
  alias_method :bombed?, :bombed
  alias_method :flagged?, :flagged
  alias_method :explored?, :explored

  def initialize(board, pos)
    @board, @pos = board, pos
    @bombed, @flagged, @explored = false, false, false
  end

  def neighbors
    adjacent_coords = DELTAS.map do |(dx, dy)|
      [pos[0] + dx, pos[1] + dy]
    end.select do |(row, col)|
      [row, col].all? { |coord| (0...@board.grid_size).include?(coord) }
    end

    adjacent_coords.map { |pos| @board.tile_at(pos) }
  end
end

class Board
  attr_reader :grid_size

  def initialize(grid_size, num_bombs)
    @grid_size, @num_bombs = grid_size, num_bombs

    generate_board
    plant_bombs
  end

  def tile_at(pos)
    row, col = pos
    @grid[row][col]
  end

  private
  def generate_board
    @grid = Array.new(@grid_size) do |row|
      Array.new(@grid_size) { |col| Tile.new(self, [row, col]) }
    end
  end

  def plant_bombs
    total_bombs = 0
    while total_bombs < @num_bombs
      coord_range = (0...@grid_size).to_a
      rand_pos = Array.new(2) { (0...@grid_size).to_a.sample }

      tile = tile_at(rand_pos)
      next if tile.bombed?

      tile.bombed = true
      total_bombs += 1
    end
  end
end
