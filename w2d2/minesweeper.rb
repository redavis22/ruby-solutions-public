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

  attr_reader :pos, :explored
  attr_accessor :bombed, :flagged

  # You can't name an instance variable with a '?', but it's common to
  # give boolean accessors names ending with a '?'. We can use
  # `alias_method` as a directive to generate a "wrapper" method with
  # a new name:
  #     http://www.ruby-doc.org/core-1.9.3/Module.html#method-i-alias_method
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

  def adjacent_bomb_count
    neighbors.map { |tile| tile.bombed? ? 1 : 0 }.inject(0, :+)
  end

  def flagged_correctly?
    bombed? && flagged?
  end

  def explore
    # don't explore a location user thinks is bombed.
    return self if flagged?

    raise "Must not explore bombed position." if bombed?

    # don't revisit previously explored tiles
    return self if explored?

    @explored = true
    if adjacent_bomb_count == 0
      neighbors.each { |adj_tile| adj_tile.explore }
    end

    self
  end

  def inspect
    { :pos => pos,
      :bombed => bombed,
      :flagged => flagged,
      :explored => explored }.inspect
  end

  def render(debug = false)
    if flagged?
      "F"
    elsif bombed? && debug
      "B"
    elsif explored? || debug
      adjacent_bomb_count == 0 ? "_" : adjacent_bomb_count.to_s
    else
      # unexplored, unflagged
      "*"
    end
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

  def render(debug = false)
    rendered_rows = []
    @grid.map do |row|
      row.map { |tile| tile.render(debug) }.join("")
    end.join("\n")
  end

  def won?
    correct_flags = 0
    @grid.each do |row|
      row.each { |tile| correct_flags += 1 if tile.correctly_flagged? }
    end

    correct_flags == @num_bombs
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
