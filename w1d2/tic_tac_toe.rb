class Board
  def initialize
    @rows = [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
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
    # deep dup inner rows so users can place marks willy-nilly.
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
      # convert positions to marks; see the destructuring link in the
      # method decomposition chapter.
      diag.map { |(x, y)| @rows[x][y] }
    end
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

  def place_mark(pos, mark)
    if @board.empty?(pos)
      @board.place_mark(pos, mark)
    else
      raise IllegalMoveError.new("Space already taken")
    end

    self
  end

  def won?
    not @board.winner.nil?
  end

  def show
    # not very pretty printing!
    @board.rows.each { |row| p row }
  end

  def play_turn
    current_player = @players[@turn]
    current_player.move(self, @turn)

    @turn = ((@turn == :x) ? :o : :x)
  end

  def run
    until won?
      show
      play_turn
    end

    winning_player = @players[@board.winner]
    puts "#{winning_player.name} won the game!"
  end
end

class HumanPlayer
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def move(game, mark)
    while true
      x, y = get_coords
      break if set_move(game, mark, [x, y])
    end
  end

  private
  def self.valid_coord?(x, y)
    [x, y].all? { |coord| (0..2).include?(coord) }
  end

  def get_coords
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
