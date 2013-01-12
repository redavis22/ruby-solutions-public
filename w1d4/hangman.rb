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
    @guesser.register_secret_length(secret_length)
    @current_board = [nil] * secret_length

    while @tries < MAX_TRIES
      guess = @guesser.guess(@current_board.dup)
      response =  @referee.check_guess(guess)
      @guesser.handle_response(guess, response)
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
  def register_secret_length(length)
    puts "Secret is #{length} letters long"
  end

  def guess(board)
    p board
    puts "Input guess:"
    gets.chomp
  end

  def handle_response(guess, response)
    # don't really need to do anything here...
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

    # didn't check for bogus input here; got lazy :-)
    positions = gets.chomp.split(",").map(&:to_i)
  end
end

class ComputerPlayer
  def initialize(dictionary)
    @candidate_words = dictionary.dup
    @previous_guesses = []
  end

  def inspect
    # super hack just so I don't see the dictionary
    "Don't show me dictionary!"
  end

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

  def register_secret_length(length)
    @candidate_words.select! { |word| word.length == length }
  end

  def guess(board)
    # I left this here so you can see it narrow things down.
    p @candidate_words
    freq_table = freq_table(board)
    top_letter, top_count = freq_table.sort_by { |letter, count| count }.last

    top_letter
  end

  def handle_response(guess, response_indices)
    if response_indices.empty?
      @candidate_words.delete_if { |word| word.include?(guess) }
    else
      @candidate_words.delete_if do |word|
        response_indices.any? do |index|
          word[index] != guess
        end
      end
    end
  end

  private
  def freq_table(board)
    # this makes 0 the default value; see the RubyDoc.
    freq_table = Hash.new(0)
    @candidate_words.each do |word|
      board.each_with_index do |letter, index|
        # only count letters at missing positions
        next unless letter.nil?

        freq_table[word[index]] += 1
      end
    end

    freq_table
  end
end
