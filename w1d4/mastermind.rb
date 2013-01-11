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

  def initialize
    @secret_code = Mastermind.generate_secret_code
    @turn = 0

    p @secret_code
  end

  def play
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
        puts "Near matches: #{near_matches(guess)}"
        puts "Exact matches: #{exact_matches(guess)}"
        puts "Try again!"
        @turn += 1
      end
    end
  end

  private

  def get_guess
    puts "Guess the code:"

    guess = nil
    while true
      guess = []
      gets.chomp.split(//).each do |letter|
        peg = INPUT_CHARS[letter.upcase]
        # what if invalid peg?
        guess << peg
      end

      break
    end

    p guess

    guess
  end

  def exact_matches(guess)
    matches = 0
    guess.count.times do |i|
      matches += 1 if guess[i] == @secret_code[i]
    end

    matches
  end

  def near_matches(guess)
    # Hash.new(0) makes 0 the default value
    near_matches =  Hash.new(0)

    guess.each do |peg|
      near_matches[peg] += 1 if @secret_code.include?(peg)
    end

    deduped_near_matches = {}
    near_matches.each do |peg, count|
      # don't return more near matches than there are pegs of that color
      deduped_near_matches[peg] = [count, @secret_code.count(peg)].min
    end

    deduped_near_matches.values.inject(:+)
  end
end
