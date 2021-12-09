def load_data(input_file)
  lines = File.read(input_file).strip.split("\n")
  lines.map { |x| parse_line(x) }
end

class Point2d
  attr_reader :x
  attr_reader :y
  def initialize(x, y)
    @x = x
    @y = y
  end

  def tostring
    [x, y].join(",")
  end

  def self.from_string(point_str)
    values = point_str.split(",")
    Point2d.new(Integer(values[0]), Integer(values[1]))
  end
end

def parse_line(line)
  coord_pair = line.split(" -> ")
  [Point2d.from_string(coord_pair[0]), Point2d.from_string(coord_pair[1])]
end

def filter_part1(coords)
  coords.filter { |pair| pair[0].x == pair[1].x || pair[0].y == pair[1].y }
end

def generate_line_points(pair)
  xs = pair[0].x < pair[1].x ? (pair[0].x..pair[1].x).to_a : (pair[1].x..pair[0].x).to_a
  ys = pair[0].y < pair[1].y ? (pair[0].y..pair[1].y).to_a : (pair[1].y..pair[0].y).to_a
  length = xs.length > ys.length ? xs.length : ys.length
  if xs.length == 1
    xs = (1..length).map { |x| xs[0] }
  end
  if ys.length == 1
    ys = (1..length).map { |x| ys[0] }
  end
  xs = pair[0].x > pair[1].x ? xs.reverse : xs
  ys = pair[0].y > pair[1].y ? ys.reverse : ys
  (0..(length - 1)).map { |i| Point2d.new(xs[i], ys[i]) }
end

def part1(input)
  data = filter_part1(input)
  points = data.flat_map { |pair| generate_line_points(pair) }
  points_hash = points.reduce({}) { |state, x| update_hash(state, x) }
  points_hash.values.count { |x| x > 1 }
end

def update_hash(state, point)
  if state[point.tostring].nil?
    state.store(point.tostring, 1)
  else
    state[point.tostring] += 1
  end
  state
end

def part2(input)
  points = input.flat_map { |pair| generate_line_points(pair) }
  points_hash = points.reduce({}) { |state, x| update_hash(state, x) }
  points_hash.values.count { |x| x > 1 }
end

def main
  # input_file = "inputSample.txt"
  input_file = "input.txt"

  print part1(load_data(input_file)), "\n"
  print part2(load_data(input_file)), "\n"
end

main
