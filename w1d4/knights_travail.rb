class KnightsPath
  attr_reader :start, :finish, :path

  def initialize(start, finish)
    @start, @finish = [start, finish].map { |pos| convert_chess_position(pos) }
    @path = []
  end

  def find_path
    queue = [KnightNode.new(@start, nil)]
    past_moves = []

    while knight = queue.shift
      break if knight.position == @finish

      past_moves << knight.position
      next_moves = possible_next_moves(knight.position)
      next_moves = prune_next_moves(next_moves, past_moves, queue)

      queue += make_knight_nodes(next_moves, knight)
    end

    @path = build_path(knight)
  end

  def print_path
    puts @path.map { |knight| convert_chess_position(knight.position) }
  end

  private

  def build_path(knight)
    knight.parent ? build_path(knight.parent) + [knight] : [knight]
  end

  def prune_next_moves(next_moves, past_moves, queue)
    do_not_check = past_moves + queue.map(&:position)
    next_moves.select { |pos| !do_not_check.include?(pos) }
  end

  def make_knight_nodes(positions, parent)
    positions.map { |pos| KnightNode.new(pos, parent) }
  end

  def convert_chess_position(position)
    if position.is_a?(String)
      [('a'..'h').to_a.index(position[0]), position[1].to_i - 1]
    else
      "#{('a'..'h').to_a[position[0]]}#{(position[1] + 1).to_s}"
    end
  end

  def possible_next_moves(position)
    all_next_moves(position).select { |pos| on_board?(pos) }
  end

  def all_next_moves(position)
    [
      [position[0] + 2, position[1] + 1],
      [position[0] + 2, position[1] - 1],
      [position[0] - 2, position[1] + 1],
      [position[0] - 2, position[1] - 1],
      [position[0] + 1, position[1] + 2],
      [position[0] + 1, position[1] - 2],
      [position[0] - 1, position[1] + 2],
      [position[0] - 1, position[1] - 2]
    ]
  end

  def on_board?(position)
    position.all? { |coord| coord.between?(0, 7) }
  end
end

class KnightNode
  attr_reader :position, :parent
  def initialize(position, parent)
    @position, @parent = position, parent
  end
end

if ARGV.length == 2
  pathfinder = KnightsPath.new(ARGV[0], ARGV[1])
  pathfinder.find_path
  pathfinder.print_path
else
  puts "Please enter 2 chess positions on the command line ('e4 a6')"
end
