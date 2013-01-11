class Hangman
  MAX_TRIES = 10

  def initialize(guesser, referee)
    @guesser, @referee = guesser, referee
  end

  def update_board(guess, response)
    response.each { |index| @current_board[index] = guess }
  end

  def play
    @tries = 0
    secret_length = @referee.pick_secret_word
    @current_board = [nil] * secret_length

    while @tries < MAX_TRIES
      guess = @guesser.guess
      response =  @referee.check_guess(guess)
      update_board(guess, response)

      p response
      p @current_board
      if @current_board.all?
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
