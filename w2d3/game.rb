require_relative 'board'

class Game
  attr_reader :board

  def initialize
    @board = Board.new
    @players = {
      :white => HumanPlayer.new(:white),
      :black => HumanPlayer.new(:black)
    }
    @current_player = :white
  end

  def play
    while true
      @players[@current_player].play_turn(@board)
      @current_player = (@current_player == :white) ? :black : :white
    end

    nil
  end
end

class HumanPlayer
  def initialize(color)
    @color = color
  end

  def play_turn(board)
    while true
      puts board.render
      puts "Current player: #{@color}"

      begin
        from_pos = get_pos("From pos:")
        to_pos = get_pos("To pos:")
        board.move_piece(@color, from_pos, to_pos)
      rescue StandardError => e
        puts "Error: #{e.message}"
      else
        return
      end
    end
  end

  private
  def get_pos(prompt)
    puts prompt
    gets.chomp.split(",").map { |coord_s| Integer(coord_s) }
  end
end
