class Array
  # I personally like explicit blocks because I can just look at the
  # args of the method to know that I can/need to pass one

  def my_each(&blk)
    i = 0
    while i < self.count
      blk.call(self[i])
      i += 1
    end

    self
  end

  def my_map(&blk)
    new_vals = []
    self.my_each do |el|
      new_vals << blk.call(el)
    end

    new_vals
  end

  def my_select(&blk)
    new_vals = []
    self.my_each do |el|
      new_vals << el if blk.call(el)
    end

    new_vals
  end

  def my_inject(&blk)
    val = self.first

    (self[1..-1]).my_each do |el|
      val = blk.call(val, el)
    end

    val
  end

  def my_sort!
    sorted = false
    until sorted
      sorted = true
      self.count.times do |index|
        # last element has no next element
        next if (index + 1) == self.count

        # call block to decide whether `self[index] > self[index + 1]`
        if yield(self[index], self[index + 1]) == 1
          self[index], self[index + 1] = self[index + 1], self[index]
          sorted = false
        end
      end
    end

    self
  end
end

def eval_block(*args, &blk)
  if blk.nil?
    puts "NO BLOCK GIVEN"
  else
    blk.call(*args)
  end
end
