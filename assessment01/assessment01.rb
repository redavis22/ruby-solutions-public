def factors(num)
  (1..num).to_a.select { |i| (num % i) == 0 }
end

def fibs_rec(count)
  # If you didn't get fibs_rec right, step through my version in the
  # debugger. You need to know how this works *cold*.
  case count
  when 1
    [0]
  when 2
    [0, 1]
  else
    rest = fibs_rec(count - 1)
    one_more = rest[-1] + rest[-2]
    rest + [one_more]
  end
end

class Array
  def bubble_sort(&blk)
    self.dup.bubble_sort!(&blk)
  end

  def bubble_sort!(&blk)
    # See how I create a Proc if no block was given; this eliminates
    # having to later have two branches of logic, one for a block and
    # one for no block.
    blk = Proc.new { |x, y| x <=> y } unless blk

    sorted = false
    until sorted
      sorted = true

      count.times do |i|
        next if i == count - 1

        if blk.call(self[i], self[i + 1]) == 1
          # Parallel assignment; use it when swapping.
          self[i], self[i + 1] = self[i + 1], self[i]
          sorted = false
        end
      end
    end

    self
  end
end

class Array
  def two_sum
    pairs = []
    count.times do |i1|
      count.times do |i2|
        next if i2 <= i1
        pairs << [i1, i2] if self[i1] + self[i2] == 0
      end
    end

    pairs
  end
end

class String
  def subword_counts(dictionary)
    counts = Hash.new(0)
    length.times do |i1|
      length.times do |i2|
        next if i2 < i1

        substring = self[i1..i2]
        counts[substring] += 1 if dictionary.include?(substring)
      end
    end

    counts
  end
end
