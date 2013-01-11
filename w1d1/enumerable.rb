def multiply_by_two(nums)
  nums.map { |num| num * 2 }
end

class Array
  def my_each
    # using `Array#each` is cheating!`
    self.count.times do |i|
      yield(self[i])
    end

    # return original array
    self
  end
end

def median(nums)
  # sort the numbers; notice that I don't modify nums at all.
  sorted_nums = nums.sort
  while sorted_nums.count > 2
    # remove smallest
    sorted_nums.shift
    # remove largest
    sorted_nums.pop
  end

  # we're left with the one or two "middle numbers"
  sorted_nums.count == 1 ? sorted_nums.first : (sorted_nums.inject(0, :+) / 2.0)
end

def concatenate_strings(strings)
  strings.inject("") do |total, string|
    total + string
  end
end
