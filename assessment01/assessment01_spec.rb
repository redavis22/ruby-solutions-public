require 'rspec'
require_relative 'assessment01'

describe "#factors" do
  # given a number, return an ordered array of its factors.

  it "returns factors of 10 in order" do
    factors(10).should == [1, 2, 5, 10]
  end

  it "returns just two factors for primes" do
    factors(13).should == [1, 13]
  end
end

describe "#fibs_rec" do
  # write a recursive implementation of a method that returns the
  # first `n` fibonacci numbers.

  it "returns first fibonacci number" do
    fibs_rec(1) == [0]
  end

  it "returns first two fib numbers" do
    fibs_rec(2).should == [0, 1]
  end

  it "returns many fibonacci numbers" do
    fibs_rec(6).should == [0, 1, 1, 2, 3, 5]
  end

  it "calls itself recursively" do
    should_receive(:fibs_rec).at_least(:twice).and_call_original
    fibs_rec(6)
  end
end

describe "#bubble_sort" do
  # write a new `Array#bubble_sort` method; it should not modify the
  # array it is called on, but creates a new sorted array.

  it "works with an empty array" do
    [].bubble_sort.should == []
  end

  it "works with an array of one item" do
    [1].bubble_sort.should == [1]
  end

  it "sorts numbers" do
    [5, 4, 3, 2, 1].bubble_sort.should == [1, 2, 3, 4, 5]
  end

  it "will use block if given" do
    [1, 2, 3, 4, 5].bubble_sort do |num1, num2|
      # reverse order
      num2 <=> num1
    end.should == [5, 4, 3, 2, 1]
  end

  it "does not modify original" do
    original = [5, 4, 3, 2, 1]
    duped_original = original.dup
    duped_original.bubble_sort
    duped_original.should == original
  end
end

describe "#two_sum" do
  # Write a new `Array#two_sum` method that finds all pairs of
  # positions where the elements at those positions sum to zero.

  # NB: ordering matters. I want each of the pairs to be sorted
  # smaller index before bigger index. I want the array of pairs to be
  # sorted "dictionary-wise":
  #   [0, 2] before [2, 1] (smaller first elements come first)
  #   [0, 1] before [0, 2] (then smaller second elements come first)

  it "returns positions of pairs of numbers that add to zero" do
    [5, 1, -7, -5].two_sum.should == [[0, 3]]
  end

  it "finds multiple pairs" do
    [5, -1, -5, 1].two_sum.should == [[0, 2], [1, 3]]
  end

  it "returns [] when no pair is found" do
    [5, 5, 3, 1].two_sum.should == []
  end

  it "won't find spurious zero pairs" do
    [0, 1, 2, 3].two_sum.should == []
  end

  it "will find real zero pairs" do
    [0, 1, 2, 0].two_sum.should == [[0, 3]]
  end
end

describe "#subword_counts" do
  # Write a `String#subword_counts` method that takes a dictionary
  # (array of possible words) and returns a hash where the keys are
  # subwords, and the values are numbers of times each appears in the
  # String.

  let(:dictionary) do
    # a small dictionary of words
    ["a", "am", "an", "pa", "pan", "panama"]
  end

  it "returns words nested inside another word" do
    "raman".subword_counts(dictionary).should == {
      "a" => 2,
      "am" => 1,
      "an" => 1
    }
  end

  it "returns words nested inside another word" do
    "panama".subword_counts(dictionary).should == {
      "a" => 3,
      "am" => 1,
      "an" => 1,
      "pa" => 1,
      "pan" => 1,
      "panama" => 1
    }
  end
end
