require "set"
require "../utils"

def load_data(input_file)
  lines = File.read(input_file).strip.split("\n")
  lines.map { |x| x.chars.map { |y| Integer(y) } }
end

def part1(input)
  # first position has zero cost
  input[0][0] = 0
  calculate_best_cost(input)
end

def calculate_best_cost(cost_table)
  # build the initial result table
  result_table = (0..cost_table.length - 1).map { |x| (0..cost_table[0].length - 1).map { |y| 0 } }
  # set initial cost of the last point
  result_table[cost_table.length - 1][cost_table.length - 1] = cost_table[cost_table.length - 1][cost_table.length - 1]
  steps = build_steps(cost_table.length)
  result_table = steps.reduce(result_table) { |state, s| calculate_step(cost_table, s, state) }
  result_table[0][0]
end

# Build an array of points that is the bottom edge followed by the left edge
def build_steps(length)
  steps = (0..length - 1).to_a.reverse.flat_map do |x|
    (0..length - 1).to_a.reverse.map do |y|
      Point2d.new(x, y)
    end
  end
  steps[1..]
end

def calculate_step(cost_table, point, result_table)
  result_table[point.x][point.y] = calculate_cost(cost_table, result_table, point)
  result_table
end

def calculate_cost(cost_table, result_table, point)
  pointr = Point2d.new(point.x + 1, point.y)
  costr = valid_point?(pointr, cost_table.length) ? result_table[pointr.x][pointr.y] : 99999999
  pointd = Point2d.new(point.x, point.y + 1)
  costd = valid_point?(pointd, cost_table.length) ? result_table[pointd.x][pointd.y] : 99999999
  min_prev_cost = [costr, costd].min
  cost_table[point.x][point.y] + min_prev_cost
end

def valid_point?(p, length)
  p.x >= 0 && p.x < length && p.y >= 0 && p.y < length
end

# I'm not getting the right answer for part2
# probably because this dynamic programming algorithm isn't guaranteed to give the absolute best route - just a good one
def part2(input)
  cost_table = expand_5x(input)
  print_array(cost_table)
  # first position has zero cost
  cost_table[0][0] = 0
  calculate_best_cost(cost_table)
end

def expand_5x(input)
  length = 5 * input.length
  (0..length - 1).map do |x|
    (0..length - 1).map do |y|
      root_x = x % input.length
      root_y = y % input.length
      root_value = input[root_x][root_y]
      xm = x / input.length
      ym = y / input.length
      calc_value = root_value + xm + ym
      calc_value == 9 ? 9 : calc_value % 9
    end
  end
end

def main
  # input_file = "inputSample.txt"
  input_file = "input.txt"

  print "Part1 Answer: ", part1(load_data(input_file)), "\n"
  print "Part2 Answer: ", part2(load_data(input_file)), "\n"
end

main
