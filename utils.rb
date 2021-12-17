def print_array(a, header = "")
  header != "" and print header, "\n"
  print "[\n"
  a.each_with_index { |x, i| print "  #{i}: #{x}\n" }
  print "]\n"
end

def print_hash(h, header = "")
  header != "" and print header, "{\n"
  h.each { |k, v| print "  #{k} => #{v} \n" }
  print "}\n"
end

class Point2d
  include Comparable
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def to_s
    inspect
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

def visualize_sparse_points(points)
  width = points.map { |p| p.x }.max
  height = points.map { |p| p.y }.max
  table = (0..height).map { |y| (0..width).map { |x| "." } }
  points.each { |p| table[p.y][p.x] = "#" }
  table = table.map { |row| row.join("") }
  print_array(table)
end


class Table2d
  def initialize(array2d)
    @table = array2d
  end

  def enumerate_indexes(&fn)
    e = Enumerator.new do |yielder|
      (0..(@table.length - 1)).each do |x|
        (0..(@table[0].length - 1)).each { |y| yielder << [x, y] }
      end
    end

    return e unless fn
    e.each(&fn)
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
end