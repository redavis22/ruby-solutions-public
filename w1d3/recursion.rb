def sum_iter(nums)
  sum = 0
  nums.each { |num| sum += num }
  sum
end

def sum_rec(nums)
  return 0 if nums.empty?
  nums[0] + sum_rec(nums[1..-1])
end

def exp1(base, power)
  (power == 0) ? 1 : (base * exp1(base, power - 1))
end

def exp2(base, power)
  if power == 0
    1
  elsif power == 1
    base
  else
    exp2(base, (power / 2.0).floor) * exp2(base, (power / 2.0).ceil)
  end
end

class Array
  def deep_dup
    # Argh! Mario and Kriti beat me with a one line version?? Must
    # have used `inject`...
    new_array = []
    self.each do |el|
      if el.is_a?(Array)
        new_array << el.deep_dup
      else
        new_array << el
      end
    end

    new_array
  end
end

def fibs_iter(n)
  case n
  when 1
    [0]
  when 2
    [0, 1]
  else
    # can't resist a recursive call!
    fibs = fibs_iter(2)
    (n - 2).times do
      fibs << fibs[-2] + fibs[-1]
    end

    fibs
  end
end

def fibs_rec(n)
  case n
  when 1
    [0]
  when 2
    [0, 1]
  else
    fibs = fibs_rec(n - 1)
    fibs << fibs[-2] + fibs[-1]

    fibs
  end
end

def bsearch(nums, target)
  # -1 signals not found; can't find anything in an empty array
  return -1 if nums.count == 0

  probe_index = nums.length / 2
  case target <=> nums[probe_index]
  when -1
    # search in left
    bsearch(nums[0...probe_index], target)
  when 0
    probe_index # found it!
  when 1
    # search in the right; don't forget that the right subarray starts
    # at `probe_index + 1`.
    subproblem_answer = bsearch(nums[(probe_index + 1)..-1], target)

    # be careful! -1 can be returned for not found, in which case we
    # don't want to add to this.
    (subproblem_answer == -1) ? -1 : (probe_index + 1) + subproblem_answer
  end

  # note that the array size is always decreasing through each
  # recursive call, so we'll either find the item, or eventually end
  # up with an empty array.
end

def make_change(target, coins = [25, 10, 5, 1])
  return [] if target == 0

  best_change = nil
  coins.sort.reverse.each_with_index do |coin, index|
    # can't use this coin, it's too big
    next if coin > target

    # use this coin
    remainder = target - coin

    # find the best way to make change with the remainder (recursive
    # call). NB: Why `coins[index..-1]`? Because we want to avoid
    # double counting; imagine two ways to make change for 6 cents:
    #   (1) first use a nickle, then a penny
    #   (2) first use a penny, then a nickle
    # To avoid double counting, we should require that we use *larger
    # coins first*. This is what `coins[index..-1]` enforces; if we
    # use a smaller coin, we can never use larger coins later.
    best_remainder = make_change(remainder, coins[index..-1])

    this_change = [coin] + best_remainder

    if (best_change.nil? || (this_change.count < best_change.count))
      best_change = this_change
    end
  end

  best_change
end

class Array
  def merge_sort
    return self if count < 2

    middle = count / 2

    left, right = self[0...middle], self[middle..-1]
    sorted_left, sorted_right = left.merge_sort, right.merge_sort

    merge(sorted_left, sorted_right)
  end

  def merge(left, right)
    merged_array = []
    until left.empty? || right.empty?
      merged_array << ((left.first < right.first) ? (left.shift) : (right.shift))
    end

    merged_array + left + right
  end
end
