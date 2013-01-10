class TicTacToe
  def initialize
    @rows = [
      [nil, nil, nil],
      [nil, nil, nil],
      [nil, nil, nil]
    ]
  end

  def place_mark(pos, mark)
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

    # see the destructuring link in the method decomposition chapter.
    [down_diag, up_diag].map do |diag|
      # convert positions to marks
      diag.map { |(x, y)| @rows[x][y] }
    end
  end

  def won?
    (rows + cols + diagonals).any? do |triple|
      [[:x] * 3, [:o] * 3].include?(triple)
    end
  end
end
