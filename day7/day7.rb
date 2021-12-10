def load_data(input_file)
  lines = File.read(input_file).strip.split(",")
  lines.map { |x| Integer(x) }
end

# borrowed from https://stackoverflow.com/a/14859546 - ruby's math module is quite weak
def median(array)
  return nil if array.empty?
  sorted = array.sort
  len = sorted.length
  (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
end

# borrowed from https://stackoverflow.com/a/1341318 - ruby is also missing average
def average(array)
  array.inject { |sum, el| sum + el }.to_f / array.size
end

def part1(input)
  m = median(input)
  input.map { |x| (m - x).abs }.sum
end

# Average - 1 is the minima - maybe due to rounding issues?
def part2(input)
  a = average(input).round
  print "avg ", a, "\n"
  print input.map { |x| sum_one_to_n(((a + 1) - x).abs.to_i) }.sum, "\n"
  print input.map { |x| sum_one_to_n(((a - 1) - x).abs.to_i) }.sum, "\n"
  print input.map { |x| sum_one_to_n(((a - 2) - x).abs.to_i) }.sum, "\n"
  input.map { |x| sum_one_to_n((a - x).abs.to_i) }.sum
end

def sum_one_to_n(n)
  n * (n + 1) / 2
end

def main
  # input_file = "inputSample.txt"
  input_file = "input.txt"

  print part1(load_data(input_file)), "\n"
  print part2(load_data(input_file)), "\n"
end

main
