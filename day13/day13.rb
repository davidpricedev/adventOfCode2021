require "set"
require "../utils"

def load_data(input_file)
  lines = File.read(input_file).strip.split("\n")
  lines = lines.map { |x| x.start_with?("fold") ? x.split(" ")[2] : x.strip.split(",") }
  idx = lines.index([])
  points = lines[0..(idx - 1)].map { |a, b| [Integer(a), Integer(b)] }
  folds = lines[(idx + 1)..].map { |l| l.split("=") }.map { |a, b| [a, Integer(b)] }
  [points, folds]
end

def part1(input)
  points = input[0].map { |x, y| Point2d.new(x, y) }
  folds = input[1]
  fold(points, folds[0]).to_set.count
end

def fold(points, fold_pair)
  if fold_pair[0] == "x"
    foldx(points, fold_pair[1])
  else
    foldy(points, fold_pair[1])
  end
end

def foldx(points, foldx)
  points.map { |p| p.x <= foldx ? p : Point2d.new(foldx - (p.x - foldx), p.y) }
end

def foldy(points, foldy)
  points.map { |p| p.y <= foldy ? p : Point2d.new(p.x, foldy - (p.y - foldy)) }
end

def part2(input)
  points = input[0].map { |x, y| Point2d.new(x, y) }
  folds = input[1]
  result = folds.reduce(points) { |points, fold| fold(points, fold) }
  # print_array(result)
  visualize_sparse_points(result)
end

def main
  # input_file = "inputSample.txt"
  input_file = "input.txt"

  print "Part1 Answer: ", part1(load_data(input_file)), "\n"
  print "Part2 Answer: ", part2(load_data(input_file)), "\n"
end

main
