def my_uniq(array)
  uniq_array = []
  array.each do |el|
    uniq_array << el unless uniq_array.include?(el)
  end

  uniq_array
end

def two_sum(array)
  array.each do |num|
    if num > 0
      return true if array.include?(-1 * num)
    else
      # -1 * 0 == 0; array includes at least one zero (this num here),
      # -but does it contain a second?
      return true if array.count(0) > 1
    end
  end

  false
end

class TowersOfHanoi
  def self.disks
    # can always make the game harder by changing max value :-)
    (1..3).to_a.reverse
  end

  def initialize
    @stacks = [TowersOfHanoi.disks, [], []]
  end

  def display
    max_height = @stacks.map(&:count).max

    max_height.times do |height|
      @stacks.each do |stack|
        # this || trick says that if stack[height] is `nil` (that is,
        # the stack isn't that high), print `" "` instead of `nil`,
        # because we need a blank space. Try for yourself to see what
        # happens if we leave out `|| " "`.
        print (stack[height] || " ")
        print "\t"
      end

      # just want a newline
      puts
    end
    puts "a\tb\tc"
  end

  def move(from_stack_num, to_stack_num)
    # #values_at is pretty sweet; check out the RubyDoc
    from_stack, to_stack = @stacks.values_at(from_stack_num, to_stack_num)

    # just ignore moves from empty piles
    return unless from_stack.count > 0

    to_stack.push(from_stack.pop)

    # what should `move` return? Perhaps `nil`, since we only call
    # `move` for its side-effect. But returning `self` is also common,
    # this let's us *chain* calls to `move`: `towers.move(1, 2).move(0,
    # 1).move(3, 0)`.
    self
  end

  def game_won?
    @stacks[(1..2)].include?(TowersOfHanoi.disks)
  end

  def run_game
    # I wrote this last; I always write the user input last

    until game_won?
      display

      # this uses *array destructuring*
      from_stack_num, to_stack_num = get_move

      move(from_stack_num, to_stack_num)
    end

    puts "You did it!"
  end

  def get_stack(prompt)
    move_hash = {
      "a" => 0,
      "b" => 1,
      "c" => 2
    }

    while true
      print prompt
      stack_num = move_hash[gets.chomp]

      if stack_num.nil?
        puts "Invalid move!"
        next
      else
        return stack_num
      end
    end
  end

  def get_move
    from_stack_num = get_stack("Move from: ")
    to_stack_num = get_stack("Move to: ")

    [from_stack_num, to_stack_num]
  end
end

def pick_stocks(prices)
  # assume you can buy/sell same day for 0 profit
  best_pair = [0, 0]
  best_profit = 0

  prices.count.times do |buy_date|
    prices.count.times do |sell_date|
      next if sell_date < buy_date

      profit = prices[sell_date] - prices[buy_date]
      if profit > best_profit
        best_pair = [buy_date, sell_date]
        best_profit = profit
      end
    end
  end

  best_pair
end
