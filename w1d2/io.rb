def guessing_game
  secret = rand(1..100)

  while true
    puts "Guess my secret!"
    guess = gets.to_i

    if guess == secret
      puts "My secret is found out!"
      break
    end
  end
end

def shuffle_file(filename)
  File.open("#{filename}-shuffled", "w") do |f|
    File.readlines(filename).shuffle.each { |line| f.puts line.chomp }
  end
end
