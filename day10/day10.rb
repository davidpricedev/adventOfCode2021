require "set"
require "../utils"

def load_data(input_file)
  lines = File.read(input_file).strip.split("\n")
  lines.map { |x| x.chars }
end

def parse(line)
  start_syms = ["{", "[", "(", "<"]
  expected_pair = {"}" => "{", "]" => "[", ")" => "(", ">" => "<"}
  stack = []
  line.each_with_index do |symbol, i|
    if start_syms.include?(symbol)
      stack << symbol
    elsif stack[-1] == expected_pair[symbol]
      stack.pop
    else
      return symbol
    end
  end
  stack
end

def score_part1(symbol)
  score_table = {")" => 3, "]" => 57, "}" => 1197, ">" => 25137}
  score_table[symbol] or 0
end

def part1(input)
  input.map { |line| score_part1(parse(line)) }.sum
end

def part2(input)
  scores = input.map { |line| score_part2(parse(line)) }.filter { |x| x > 0 }.sort
  scores[scores.length / 2]
end

def score_part2(stack)
  end_syms = ["}", "]", ")", ">"]
  score_table = {"{" => 3, "[" => 2, "(" => 1, "<" => 4}
  if end_syms.include?(stack)
    0 # the corrupted lines
  else
    stack.reverse.reduce(0) { |score, symbol| score * 5 + score_table[symbol] }
  end
end

def main
  # input_file = "inputSample.txt"
  input_file = "input.txt"

  print "Part1 Answer: ", part1(load_data(input_file)), "\n"
  print "Part2 Answer: ", part2(load_data(input_file)), "\n"
end

main
