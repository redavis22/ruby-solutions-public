#!/usr/bin/env ruby

# The top line tells the shell that this should be runnable as a Ruby
# script.

class RPNCalculator
  def initialize
    @stack = []
  end

  def push(num)
    @stack << num
  end

  def perform_op(op_sym)
    raise RuntimeError.new("Too few operands!") unless @stack.count >= 2

    right_operand = @stack.pop
    left_operand = @stack.pop

    case op_sym
    when :+
      @stack << left_operand + right_operand
    when :-
      @stack << left_operand - right_operand
    when :*
      @stack << left_operand * right_operand
    when :/
      # `Fixnum#fdiv` is like `/` but makes sure not to round to
      # nearest integer.
      @stack << left_operand.fdiv(right_operand)
    else
      @stack << left_op << right_op
      raise ArgumentError.new("No operation #{op_sym}")
    end

    # return self to allow chaining of `perform_op`.
    self
  end

  def extract_value
    raise RuntimeError.new("There are still #{@stack.count} operands left!") if @stack.count != 1

    @stack.pop
  end

  def self.evaluate_file(file)
    calc = RPNCalculator.new

    ops = ["+", "-", "*", "/"]
    file.each do |line|
      line = line.chomp
      if ops.include?(line)
        calc.perform_op(line.to_sym)
      else
        calc.push(line.to_i)
      end
    end

    calc.extract_value
  end
end

if __FILE__ == $PROGRAM_NAME
  # only run this in program mode
  if ARGV.empty?
    puts RPNCalculator.evaluate_file($stdin)
  else
    File.open(ARGV[0]) do |file|
      puts RPNCalculator.evaluate_file(file)
    end
  end
end
