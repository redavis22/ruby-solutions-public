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
    @rows.all? { |row| row.none? { |el| el.nil? }}
  end

  def winner
    (rows + cols + diagonals).each do |triple|
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

  def show
    # not very pretty printing!
    @board.rows.each { |row| p row }
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

  private
  def play_turn
    while true
      current_player = @players[@turn]
      pos = current_player.move(self, @turn)

      break if place_mark(pos, @turn)
    end

    # swap next who's turn it will be next
    @turn = ((@turn == :x) ? :o : :x)
  end

  def place_mark(pos, mark)
    if @board.empty?(pos)
      @board.place_mark(pos, mark)
      true
    else
      false
    end
  end
end

class HumanPlayer
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def move(game, mark)
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

  private
  def self.valid_coord?(x, y)
    [x, y].all? { |coord| (0..2).include?(coord) }
  end
end

class ComputerPlayer
  attr_reader :name

  def initialize
    @name = "Tandy 400"
  end

  def move(game, mark)
    winner_move(game, mark) || random_move(game, mark)
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
