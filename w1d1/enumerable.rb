def multiply_by_two(nums)
  nums.map { |num| num * 2 }
end

def my_each(array)
  # using `Array#each` is cheating!`
  array.count.times do |i|
    yield(array[i])
  end

  array
end

def median(nums)
  sorted_nums = nums.sort
  while sorted_nums.count > 2
    # remove from front
    sorted_nums.shift
    # remove from back
    sorted_nums.pop
  end

  # we're left with the one or two "middle numbers"
  sorted_nums.count == 1 ? sorted_nums.first : (sorted_nums.inject(0, :+) / 2.0)
end

def concatenate_strings(strings)
  strings.inject do |total, string|
    total + string
  end
end
