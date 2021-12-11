require "set"

def load_data(input_file)
  lines = File.read(input_file).strip.split("\n")
  lines.map { |x| x.chars.map { |y| y.to_i } }
end

class Table2d
  def initialize(array2d)
    @table = array2d
  end

  def enumerate_indexes(&fn)
    Enumerator.new do |e|
      (0..(@table.length - 1)).each do |x|
        (0..(@table[0].length - 1)).each { |y| e << fn.call(x, y) }
      end
    end
  end

  def get(x, y)
    if x < 0 || x >= @table.length
      print "error, tried to access beyond the bounds (x) ", x, " ", y, "\n"
    end
    if y < 0 || y >= @table[0].length
      print "error, tried to access beyond the bounds (y) ", x, " ", y, "\n"
    end

    @table[x][y]
  end

  def get_adjacent_values(x, y)
    get_adjacent_points(x, y).map { |p| get(p[0], p[1]) }
  end

  def get_adjacent_points(x, y)
    adj = []
    # west
    if x > 0
      adj << [x - 1, y]
    end
    # east
    if x < @table.length - 1
      adj << [x + 1, y]
    end
    # north
    if y > 0
      adj << [x, y - 1]
    end
    # south
    if y < @table[0].length - 1
      adj << [x, y + 1]
    end
    # print "adj for #{x}, #{y} ", adj, "\n"
    adj
  end

  def is_local_min(x, y)
    adj = get_adjacent_values(x, y)
    p = get(x, y)
    # print "is #{p} a local min compared to ", adj, "\n"
    # print adj.reduce(true) { |state, q| state && p < q }, "\n"
    adj.reduce(true) { |state, q| state && p < q }
  end
end

def part1(input)
  table = Table2d.new(input)
  table
    .enumerate_indexes { |x, y| table.is_local_min(x, y) ? table.get(x, y) : -1 }
    .filter { |n| n >= 0 }
    .map { |n| n + 1 }
    .sum
end

class Point2d
  include Comparable
  attr_reader :x, :y
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

  def inspect
    "(#{x}, #{y})"
  end

  def <=>(other)
    if other.nil?
      nil
    elsif x == other.x && y == other.y
      0
    else
      x <= other.x ? -1 : 1
    end
  end

  def eql?(other)
    x == other.x && y == other.y
  end

  def hash
    (x + y).hash
  end
end

def part2(input)
  table = Table2d.new(input)
  low_points = table
    .enumerate_indexes { |x, y| table.is_local_min(x, y) ? Point2d.new(x, y) : nil }
    .filter { |n| !n.nil? }
  basins = low_points.to_h { |p| [p.tostring, p] }
  basins
    .reduce({}) { |hash, (k, v)| hash.merge(k => grow_basin(table, v).length) }
    .values
    .sort
    .slice(-3..-1)
    .reduce(1) { |state, x| state * x }
end

# Essentially a recursive algorithm, but I use a mutating array to avoid actual recursion
def grow_basin(table, point)
  basin = Set[point]
  candidates = get_adj_basin_points(table, point)
  candidates.each do |p|
    basin.add(p)
    new_candidates = get_adj_basin_points(table, p).to_set
    add_uniq(candidates, new_candidates)
  end
  basin
end

# Can't use a set b/c they can't be changed during enumeration
# arrays can, but don't have native de-duplication, so I had to implement this
def add_uniq(array, new_items)
  # mutates the array!
  new_items.each { |x| array.index(x).nil? and array.append(x) }
end

def get_adj_basin_points(table, point)
  table
    .get_adjacent_points(point.x, point.y)
    .filter { |p| table.get(p[0], p[1]) != 9 }
    .map { |p| Point2d.new(p[0], p[1]) }
end

def main
  # input_file = "inputSample.txt"
  input_file = "input.txt"

  print "Part1 Answer: ", part1(load_data(input_file)), "\n"
  print "Part2 Answer: ", part2(load_data(input_file)), "\n"
end

main
