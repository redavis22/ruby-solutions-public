class Board
  def self.blank_grid
    [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
  end

  def initialize(rows = Board.blank_grid)
    @rows = rows
  end

  def dup
    # remember that `#rows` dups the rows too, so modifications to the
    # new board won't affect the old board.
    Board.new(rows)
  end

  def empty?(pos)
    mark_at(pos).nil?
  end

  def place_mark(pos, mark)
    x, y = pos[0], pos[1]
    @rows[x][y] = mark
  end

  def mark_at(pos)
    x, y = pos[0], pos[1]
    @rows[x][y]
  end

  def rows
    # deep dup inner rows so that changes to this array won't be
    # reflected in board.
    @rows.map(&:dup)
  end

  def cols
    cols = [[], [], []]
    @rows.each do |row|
      row.each_with_index do |mark, col|
        cols[col] << mark
      end
    end

    cols
  end

  def diagonals
    down_diag = [[0, 0], [1, 1], [2, 2]]
    up_diag = [[0, 2], [1, 1], [2, 0]]

    [down_diag, up_diag].map do |diag|
      # Note the `(x,y)` inside the block; this unpacks, or
      # "destructures" the argument. Read more here:
      # http://tony.pitluga.com/2011/08/08/destructuring-with-ruby.html
      diag.map { |(x, y)| @rows[x][y] }
    end
  end

  def over?
    won? or drawn?
  end

  def won?
    not winner.nil?
  end

  def drawn?
    return false if won?

    # no empty space?
    @rows.none? { |row| row.none? { |el| el.nil? }}
  end

  def winner
    (rows + cols + diagonals).any? do |triple|
      if [[:x] * 3, [:o] * 3].include?(triple)
        mark = triple[0]
        return mark
      end
    end

    nil
  end
end

class TicTacToe
  class IllegalMoveError < RuntimeError
  end

  def initialize(player1, player2)
    @turn = :x
    @players = {
      :x => player1,
      :o => player2
    }

    @board = Board.new
  end

  def board
    # let player look directly at board, but make sure it's a copy so
    # his modifications don't futz with our copy.
    @board.dup
  end

  def place_mark(pos, mark)
    if @board.empty?(pos)
      @board.place_mark(pos, mark)
    else
      raise IllegalMoveError.new("Space already taken")
    end

    self
  end

  def show
    # not very pretty printing!
    @board.rows.each { |row| p row }
  end

  def play_turn
    current_player = @players[@turn]
    current_player.move(self, @turn)

    # swap next who's turn it will be next
    @turn = ((@turn == :x) ? :o : :x)
  end

  def run
    until @board.over?
      play_turn
    end

    if @board.won?
      winning_player = @players[@board.winner]
      puts "#{winning_player.name} won the game!"
    else
      puts "No one wins!"
    end
  end
end

class HumanPlayer
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def move(game, mark)
    while true
      x, y = get_coords(game)
      break if set_move(game, mark, [x, y])
    end
  end

  private
  def self.valid_coord?(x, y)
    [x, y].all? { |coord| (0..2).include?(coord) }
  end

  def get_coords(game)
    game.show
    while true
      puts "#{@name}: please select your space"
      x, y = gets.chomp.split(",").map(&:to_i)
      if HumanPlayer.valid_coord?(x, y)
        return [x, y]
      else
        puts "Invalid coordinate!"
      end
    end
  end

  def set_move(game, mark, pos)
    begin
      game.place_mark(pos, mark)
      true
    rescue TicTacToe::IllegalMoveError
      puts "Illegal move!"
      false
    end
  end
end

class ComputerPlayer
  attr_reader :name

  def initialize
    @name = "Tandy 400"
  end

  def move(game, mark)
    m = nil
    if winner_move(game, mark).nil?
      m = random_move(game, mark)
    else
      m = winner_move(game, mark)
    end

    game.place_mark(m, mark)
  end

  private
  def winner_move(game, mark)
    (0..2).each do |x|
      (0..2).each do |y|
        board = game.board
        pos = [x, y]

        next unless board.empty?(pos)
        board.place_mark(pos, mark)

        return pos if board.winner == mark
      end
    end

    # no winning move
    nil
  end

  def random_move(game, mark)
    board = game.board
    while true
      range = (0..2).to_a
      pos = [range.sample, range.sample]

      return pos if board.empty?(pos)
    end
  end
end
