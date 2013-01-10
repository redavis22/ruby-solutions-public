class TicTacToe
  def initialize(player1, player2)
    @players = [player1, player2]
    @rows = [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
  end

  def place_mark(pos, mark)
    # does't enforce overriding a mark
    x, y = pos[0], pos[1]
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
      # check to see if the game is three in a row, then return what
      # it's three of.
      return triple[0] if [[:x] * 3, [:o] * 3].include?(triple)
    end

    nil
  end

  def show
    # not very pretty!
    @rows.each { |row| p row }
  end

  def run
    until won?
      show

      current_player = @players.shift
      current_player.move(self)
      @players << current_player
    end

    puts "The #{winner} won the game!"
  end
end

class HumanPlayer
  def initialize(name)
    @name = name
  end

  def move(game)
    while true
      puts "#{@name}: please select your space"

      x, y = gets.chomp.split(",").map(&:to_i)
      if [x, y].all? { |coord| (0..2).include?(coord) }
        game.place_mark([x, y], :o)
        break
      else
        # repeat if input invalid
        puts "Invalid input!"
        next
      end
    end
  end
end
