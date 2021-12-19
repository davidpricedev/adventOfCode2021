require "set"
require "../utils"

def load_data(input_file)
  File.read(input_file).strip.split("\n")
end

class Sfn
  attr_reader :array

  def initialize(a)
    @array = a
  end

  def left
    array[0]
  end

  def left_sfn
    Sfn.new(left)
  end

  def right
    array[1]
  end

  def right_sfn
    Sfn.new(right)
  end

  def to_s
    left_str = left.instance_of?(Array) ? left_sfn.to_s : left
    right_str = right.instance_of?(Array) ? right_sfn.to_s : right
    "[#{left_str},#{right_str}]"
  end

  def inspect
    to_s
  end

  def to_token_array
    new_left = left.instance_of?(Array) ? left_sfn.to_token_array : [left]
    new_right = right.instance_of?(Array) ? right_sfn.to_token_array : [right]
    ["["] + new_left + new_right + ["]"]
  end

  def magnitude
    left_value = left.instance_of?(Array) ? left_sfn.magnitude : left
    right_value = right.instance_of?(Array) ? right_sfn.magnitude : right
    left_value * 3 + right_value * 2
  end

  def self.from_token_array(tokens)
    stack = []
    tokens.each do |t|
      case t
      when "]"
        b = stack.pop
        a = stack.pop
        stack.pop # the starting bracket
        stack << [a, b]
      else
        stack << t
      end
    end
    Sfn.new(stack.pop)
  end

  def self.from_string(sfn_str)
    stack = []
    sfn_str = sfn_str.delete(",")
    sfn_str.chars.each do |c|
      case c
      when "["
        stack << c
      when "]"
        b = stack.pop
        a = stack.pop
        stack.pop # the starting bracket
        stack << [a, b]
      else
        stack << Integer(c)
      end
    end
    Sfn.new(stack.pop)
  end

  def add(other)
    # print "+Adding #{other}", "\n"
    if other.instance_of?(Array)
      reduce_sfn(Sfn.new([array, other]))
    elsif other.instance_of?(String)
      reduce_sfn(Sfn.new([array, Sfn.from_string(other).array]))
    elsif other.instance_of?(Sfn)
      reduce_sfn(Sfn.new([array, other.array]))
    else
      print "unknown type: #{other.class}, #{other.instance_of?(String)}, #{other.class.class} \n"
    end
  end

  def split
    result_left = left.instance_of?(Array) ? left_sfn.split : new_split_values(left)
    if result_left[1] == true
      new_left = result_left[0].instance_of?(Sfn) ? result_left[0].array : result_left[0]
      [Sfn.new([new_left, right]), true]
    else
      result_right = right.instance_of?(Array) ? right_sfn.split : new_split_values(right)
      if result_right[1] == true
        new_right = result_right[0].instance_of?(Sfn) ? result_right[0].array : result_right[0]
        [Sfn.new([left, new_right]), true]
      else
        [self, false]
      end
    end
  end
end

def new_split_values(n)
  if n > 9
    half = n / 2
    [Sfn.new([half.floor, n - half.floor]), true]
  else
    [n, false]
  end
end

def explode(sfn)
  sfn_tokens = sfn.to_token_array
  depth = 0
  index = nil
  sfn_tokens.each_with_index do |token, i|
    if token == "["
      depth += 1
    elsif token == "]"
      depth -= 1
    end
    if depth == 5
      index = i
      break
    end
  end
  if index.nil?
    [sfn, false]
  else
    [Sfn.from_token_array(explode_at(sfn_tokens, index)), true]
  end
end

def explode_at(sfn_tokens, index)
  before = sfn_tokens[0..index - 1]
  ending = index + sfn_tokens[index..].index("]")
  pair = sfn_tokens[index + 1..ending - 1]
  after = sfn_tokens[ending + 1..]

  new_before = increment_first_integer(before.reverse, pair[0]).reverse
  new_after = increment_first_integer(after, pair[1])
  new_before + [0] + new_after
end

# Increments the first integer found in the array
def increment_first_integer(array, increment)
  index = first_number(array)
  if !index.nil?
    old_num = Integer(array[index])
    new_num = increment + old_num
    array[index] = new_num
  end
  array
end

# Returns the index of the first integer in the array
def first_number(array)
  array.each_with_index do |x, i|
    return i if x.instance_of?(Integer)
  end
  nil
end

# apply the reduce rules
def reduce_sfn(sfn)
  loop do
    result = explode(sfn)
    if result[1] == false # if we didn't explode
      result = sfn.split
      break unless result[1] == true
    end
    sfn = result[0]
  end
  sfn
end

def part1(input)
  initial = Sfn.from_string(input[0])
  input[1..].reduce(initial) { |state, x| state.add(x) }.magnitude
end

def part2(input)
  max = 0
  input.each_with_index do |a, i|
    print " -- #{i}\n" if i % 5 == 0
    input.each do |b|
      if a != b
        result = Sfn.from_string(a).add(b).magnitude
        max = result >= max ? result : max
      end
    end
  end
  max
end

def main
  # input_file = "inputSample1.txt"
  # input_file = "inputSample2.txt"
  input_file = "input.txt"

  print "Part1 Answer: ", part1(load_data(input_file)), "\n"
  print "Part2 Answer: ", part2(load_data(input_file)), "\n"
end

main
