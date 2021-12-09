def load_data(input_file)
  lines = File.read(input_file).strip.split("\n")
  lines.map { |x| parse_line(x) }
end

def parse_line(line)
  coord_pair = line.split(" -> ")
  [
    coord_pair[0].split(",").map { |x| Integer(x) },
    coord_pair[1].split(",").map { |x| Integer(x) }
  ]
end

def filter_part1(coords)
  coords.filter { |pair| pair[0][0] == pair[1][0] || pair[0][1] == pair[1][1] }
end

def generate_line_points_part1(pair)
  xs = pair[0][0] < pair[1][0] ? (pair[0][0]..pair[1][0]).to_a : (pair[1][0]..pair[0][0]).to_a
  ys = pair[0][1] < pair[1][1] ? (pair[0][1]..pair[1][1]).to_a : (pair[1][1]..pair[0][1]).to_a
  length = xs.length > ys.length ? xs.length : ys.length
  if xs.length == 1
    xs = (1..length).map { |x| xs[0]}
  else
    ys = (1..length).map { |x| ys[0] }
  end
  xs = pair[0][0] > pair[1][0] ? xs.reverse : xs
  ys = pair[0][1] > pair[1][1] ? ys.reverse : ys
  (0..(length - 1)).map { |i| [xs[i], ys[i]] }
end

def generate_line_points_part2(pair)
  xs = pair[0][0] < pair[1][0] ? (pair[0][0]..pair[1][0]).to_a : (pair[1][0]..pair[0][0]).to_a
  ys = pair[0][1] < pair[1][1] ? (pair[0][1]..pair[1][1]).to_a : (pair[1][1]..pair[0][1]).to_a
  length = xs.length > ys.length ? xs.length : ys.length
  if xs.length == 1
    xs = (1..length).map { |x| xs[0]}
  end
  if ys.length == 1
    ys = (1..length).map { |x| ys[0] }
  end
  xs = pair[0][0] > pair[1][0] ? xs.reverse : xs
  ys = pair[0][1] > pair[1][1] ? ys.reverse : ys
  line_data = (0..(length - 1)).map { |i| [xs[i], ys[i]] }
  return line_data
end

def part1(input)
  data = filter_part1(input)
  points = data.map { |pair| generate_line_points_part1(pair) }.flatten(1)
  points_hash = points.reduce(Hash.new) { |state, x| update_hash_part1(state, x) }
  points_hash.values.count { |x| x > 1 }
end

def update_hash_part1(state, point)
  if state[point.join(",")] == nil
    state.store(point.join(","), 1)
  else
    state[point.join(",")] += 1
  end
  return state
end

def part2(input)
  points = input.map { |pair| generate_line_points_part2(pair) }.flatten(1)
  points_hash = points.reduce(Hash.new) { |state, x| update_hash_part1(state, x) }
  points_hash.values.count { |x| x > 1 }
end

def main
  # input_file = "inputSample.txt"
  input_file = "input.txt"

  print part1(load_data(input_file)), "\n"
  print part2(load_data(input_file)), "\n"
end

main
