class Hangman
  MAX_TRIES = 10

  def initialize(guesser, referee)
    @guesser, @referee = guesser, referee
  end

  def update_board(guess, indices)
    indices.each { |index| @current_board[index] = guess }
  end

  def play
    @tries = 0
    secret_length = @referee.pick_secret_word
    @current_board = [nil] * secret_length

    while @tries < MAX_TRIES
      p @current_board

      guess = @guesser.guess
      response =  @referee.check_guess(guess)
      update_board(guess, response)

      if @current_board.all?
        p @current_board
        puts "Guesser wins!"
        break
      end

      @tries += 1
    end

    self
  end
end

class HumanPlayer
  def guess
    puts "Input guess:"
    gets.chomp
  end

  def pick_secret_word
    while true
      puts "Think of a secret word; how long is it?"
      len = gets.chomp.to_i

      if len > 0
        return len
      else
        puts "Invalid length!"
      end
    end
  end

  def check_guess(guess)
    puts "Player guessed #{guess}"
    puts "What positions does that occur at?"

    positions = gets.chomp.split(",").map(&:to_i)
  end
end

class ComputerPlayer
  def pick_secret_word
    @secret_word = "secrets"

    @secret_word.length
  end

  def check_guess(guess)
    response = []

    @secret_word.split(//).each_with_index do |letter, index|
      response << index if letter == guess
    end

    response
  end
end
