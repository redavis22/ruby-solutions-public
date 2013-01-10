class TicTacToe
  class IllegalMoveError < RuntimeError
  end

  def initialize(player1, player2)
    @turn = :x
    @players = {
      :x => player1,
      :o => player2
    }

    @rows = [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
  end

  def place_mark(pos, mark)
    x, y = pos[0], pos[1]

    raise IllegalMoveError.new("Space already taken") unless @rows[x][y].nil?
    @rows[x][y] = mark

    self
  end

  def rows
    @rows
  end

  def cols
    cols = [[], [], []]
    rows.each do |row|
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

  def won?
    not winner.nil?
  end

  def winner
    (rows + cols + diagonals).any? do |triple|
      if [[:x] * 3, [:o] * 3].include?(triple)
        mark = triple[0]
        return @players[mark]
      end
    end

    nil
  end

  def show
    # not very pretty!
    @rows.each { |row| p row }
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

    puts "#{winner.name} won the game!"
  end
end

class HumanPlayer
  def initialize(name)
    @name = name
  end

  def move(game, mark)
    while true
      puts "#{@name}: please select your space"

      x, y = gets.chomp.split(",").map(&:to_i)
      if [x, y].all? { |coord| (0..2).include?(coord) }
        begin
          game.place_mark([x, y], mark)
        rescue TicTacToe::IllegalMoveError
          puts "Illegal move!"
          next
        end
        break
      else
        # repeat if input invalid
        puts "Invalid input!"
        next
      end
    end
  end
end
