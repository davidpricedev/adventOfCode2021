require "set"

def load_data(input_file)
  lines = File.read(input_file).strip.split("\n")
  lines.map { |x| x.chars.map { |y| y.to_i } }
end

class Table2d
  def initialize(array2d)
    @table = array2d
  end

  def width
    @table.length
  end

  def height
    @table[0].length
  end

  def size
    width * height
  end

  def enumerate_indexes(&fn)
    e = Enumerator.new do |yielder|
      (0..(width - 1)).each do |x|
        (0..(height - 1)).each { |y| yielder << [x, y] }
      end
    end

    return e unless fn
    e.each(&fn)
  end

  def enumerate_values(&fn)
    e = Enumerator.new do |yielder|
      @table.each do |column|
        column.each { |point_value| yielder << point_value }
      end
    end

    return e unless fn
    e.each(&fn)
  end

  def get(x, y)
    if x < 0 || x >= width
      print "error, tried to access beyond the bounds (x) ", x, " ", y, "\n"
    end
    if y < 0 || y >= height
      print "error, tried to access beyond the bounds (y) ", x, " ", y, "\n"
    end

    @table[x][y]
  end

  def set(x, y, value)
    if x < 0 || x >= width
      print "error, tried to access beyond the bounds (x) ", x, " ", y, "\n"
    end
    if y < 0 || y >= height
      print "error, tried to access beyond the bounds (y) ", x, " ", y, "\n"
    end

    @table[x][y] = value
    self
  end

  def get_adjacent_values(x, y)
    get_adjacent_points(x, y).map { |a, b| get(a, b) }
  end

  def get_adjacent_points(x, y)
    [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
      .map { |a, b| [a + x, b + y] }
      .filter { |a, b| a >= 0 && a < width && b >= 0 && b < height }
  end
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

def part1(input)
  table = Table2d.new(input)
  # (1..100).map { |_| simulate_step(table) }.sum
  simulate_forever_indexed(table).take(100).sum { |x, _| x }
end

def simulate_step(table)
  # increment all by 1
  table.enumerate_indexes { |x, y| table.set(x, y, table.get(x, y) + 1) }
  # find all that should initially flash
  pending_flash = table.enumerate_indexes.filter { |x, y| table.get(x, y) == 10 }
  # handle percolating flashes
  pending_flash.each { |x, y| pending_flash.append(*flash(table, x, y)) }
  # count the flashed
  flash_count = table.enumerate_values.count { |x| x >= 10 }
  # reset to zero all those that have flashed
  table.enumerate_indexes do |x, y|
    value = table.get(x, y)
    value >= 10 and table.set(x, y, 0)
  end
  flash_count
end

def flash(table, x, y)
  adj = table.get_adjacent_points(x, y)
  adj.each { |a, b| table.set(a, b, table.get(a, b) + 1) }
  # return all the ones that we just pushed over the edge - these are new points that need to flash
  # checking for exactly 10 prevents any duplication of points
  adj.filter { |a, b| table.get(a, b) == 10 }
end

def part2(input)
  table = Table2d.new(input)
  table_size = table.size
  simulate_forever_indexed(table).find do |x, i|
    print "step#: #{i}, flashes: #{x} \n"
    if x == table_size
      return i + 1
    end
  end
end

def simulate_forever_indexed(table, &fn)
  e = Enumerator.new do |yielder|
    i = 0
    loop do
      yielder << [simulate_step(table), i]
      i += 1
    end
  end

  return e unless fn
  e.each(&fn)
end

def main
  # input_file = "inputSample.txt"
  input_file = "input.txt"

  print "Part1 Answer: ", part1(load_data(input_file)), "\n"
  print "Part2 Answer: ", part2(load_data(input_file)), "\n"
end

main
