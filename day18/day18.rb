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

  def is_leaf?
    left.instance_of?(Integer) && right.instance_of?(Integer)
  end

  def to_s
    left_str = left.instance_of?(Array) ? left_sfn.to_s : left
    right_str = right.instance_of?(Array) ? right_sfn.to_s : right
    "[#{left_str},#{right_str}]"
  end

  def inspect
    to_s
  end

  def magnitude
    left_value = left.instance_of?(Array) ? left_sfn.magnitude : left
    right_value = right.instance_of?(Array) ? right_sfn.magnitude : right
    left_value * 3 + right_value * 2
  end

  def self.from_string(sfn_str)
    stack = []
    sfn_str.chars.each do |c|
      case c
      when ",", "["
        stack << c
      when "]"
        b = get_value_from_stack(stack)
        stack.pop # the comma
        a = get_value_from_stack(stack)
        stack.pop # the starting bracket
        stack << [a, b]
      else
        stack << Integer(c)
      end
    end
    Sfn.new(stack.pop)
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

  def local_explode
    if left_sfn.is_leaf?
      new_right = right.instance_of?(Integer) ? left[1] + right : [left[1] + right[0], right[1]]
      [Sfn.new([0, new_right]), left[0], nil, self]
    elsif right_sfn.is_leaf?
      new_left = right[0] + left
      [Sfn.new([new_left, 0]), nil, right[1], self]
    end
  end
end

def explode(sfn)
  sfn_str = sfn.to_s
  depth = 0
  index = nil
  sfn_str.chars.each_with_index do |char, i|
    if char == "["
      depth += 1
    elsif char == "]"
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
    [Sfn.from_string(explode_at(sfn_str, index)), true]
  end
end

def explode_at(sfn_str, index)
  before = sfn_str[0..index - 1].chars
  ending = index + sfn_str[index..].index("]")
  pair = sfn_str[index + 1..ending - 1].split(",")
  after = sfn_str[ending + 1..].chars
  rbindex = first_number(before.reverse)
  if !rbindex[0].nil?
    bindex = before.length - 1 - rbindex[0] - (rbindex[1] - 1)
    old_left_num = Integer(before[bindex, rbindex[1]].join(""))
    new_left_num = Integer(pair[0]) + old_left_num
    before = before.join("").reverse.sub(old_left_num.to_s.reverse, new_left_num.to_s.reverse).reverse
  else
    before = before.join("")
  end
  aindex = first_number(after)
  if !aindex[0].nil?
    old_right_num = Integer(after[*aindex].join(""))
    new_right_num = Integer(pair[1]) + old_right_num
    after = after.join("").sub(old_right_num.to_s, new_right_num.to_s)
  else
    after = after.join("")
  end
  before + "0" + after
end

# takes array of strings and returns index of first numeric char
def first_number(array)
  numbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
  start_index = nil
  array.each_with_index do |x, i|
    if numbers.include?(x)
      start_index = i
      break
    end
  end
  length = nil
  array[start_index..].each_with_index do |x, i|
    if !numbers.include?(x)
      length = i
      break
    end
  end
  [start_index, length]
end

# somewhat complex in order to handle multi-digit numbers
def get_value_from_stack(stack)
  ones = stack.pop
  if ones.instance_of?(Array)
    ones
  else
    nums = [ones]
    multiplier = 10
    loop do
      if stack[-1].instance_of?(Integer)
        nums << multiplier * stack.pop
        multiplier *= 10
      else
        break
      end
    end
    nums.sum
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

def reduce_sfn(sfn)
  loop do
    result = explode(sfn)
    if result[1] == true
      # print " exploded to #{sfn}", "\n"
    else
      result = sfn.split
      break unless result[1] == true
      # print " split to    #{sfn}", "\n"
    end
    sfn = result[0]
  end
  sfn
end

def part1(input)
  input[1..].reduce(Sfn.from_string(input[0])) do |state, x|
    new_state = state.add(x)
    # print "New State: #{new_state} \n"
    new_state
  end.magnitude
end

def part2(input)
  max = 0
  input.each_with_index do |a, i|
    print " -- #{i}\n"
    input.each do |b|
      if a != b
        result = Sfn.from_string(a).add(b).magnitude
        max = max >= result ? max : result
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
