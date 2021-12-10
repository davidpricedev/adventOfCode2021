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

  def get_adjacents(x, y)
    adj = []
    # west
    if x > 0
      adj << get(x - 1, y)
    end
    # east
    if x < @table.length - 1
      adj << get(x + 1, y)
    end
    # north
    if y > 0
      adj << get(x, y - 1)
    end
    # south
    if y < @table[0].length - 1
      adj << get(x, y + 1)
    end
    #print "adj for #{x}, #{y} ", adj, "\n"
    adj
  end

  def is_local_min(x, y)
    adj = get_adjacents(x, y)
    p = get(x, y)
    #print "is #{p} a local min compared to ", adj, "\n"
    #print adj.reduce(true) { |state, q| state && p < q }, "\n"
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

def part2(input)
end

def main
  #input_file = "inputSample.txt"
  input_file = "input.txt"

  print part1(load_data(input_file)), "\n"
  # print part2(load_data(input_file)), "\n"
end

main
