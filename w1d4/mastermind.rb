class Mastermind
  PEGS = [:red, :green, :blue, :yellow, :orange, :purple]
  MAX_TURNS = 10

  INPUT_CHARS = {
    "R" => :red,
    "G" => :green,
    "B" => :blue,
    "Y" => :yellow,
    "O" => :orange,
    "P" => :purple
  }

  def self.generate_secret_code
    code = []
    4.times { code << PEGS.sample }

    code
  end

  def play(secret_code = Mastermind.generate_secret_code)
    @secret_code = secret_code
    @turn = 0

    # for debugging purposes
    p @secret_code

    while true
      if @turn == MAX_TURNS
        puts "You're the worst!"
        break
      end

      guess = get_guess
      if guess == @secret_code
        puts "You're the best!"
        break
      else
        exact_matches = exact_matches(guess)
        near_matches = near_and_exact_matches(guess) - exact_matches

        puts "Near matches: #{near_matches}"
        puts "Exact matches: #{exact_matches}"
        puts "Try again!"
        @turn += 1
      end
    end

    nil
  end

  private
  def get_guess
    while true
      puts "Guess the code:"
      guess = parse_guess(gets.chomp)

      if guess.nil?
        puts "Invalid guess!"
      else
        return guess
      end
    end
  end

  def parse_guess(guess_string)
    guess = []
    guess_string.split(//).each do |letter|
      peg = INPUT_CHARS[letter.upcase]

      # uh-oh, this char was invalid
      return nil if peg.nil?

      guess << peg
    end

    guess
  end

  def exact_matches(guess)
    matches = 0
    guess.count.times do |i|
      matches += 1 if guess[i] == @secret_code[i]
    end

    matches
  end

  def near_and_exact_matches(guess)
    # Hash.new(0) makes 0 the default value
    near_and_exact_matches = Hash.new(0)

    guess.each do |peg|
      near_and_exact_matches[peg] += 1 if @secret_code.include?(peg)
    end

    deduped_near_matches = {}
    near_and_exact_matches.each do |peg, count|
      # don't return more near matches than there are pegs of that color
      deduped_near_matches[peg] = [count, @secret_code.count(peg)].min
    end

    deduped_near_matches.values.inject(:+)
  end
end
