require "set"
require "../utils"

def load_data(input_file)
  lines = File.read(input_file).strip.split("\n")
  lines.map { |a| parse_line(a) }
end

def parse_line(line)
  parts1 = line.split(" ")
  cmd = parts1[0] == "off" ? 0 : 1
  parts2 = parts1[1].split(",").map { |a| a[2..].split("..") }
  [cmd, parts2]
end

def apply_step(state, position, step)
  cmd, ranges = step
  xrange, yrange, zrange = ranges
  x, y, z = position
  if in_range?(x, xrange) || in_range?(y, yrange) || in_range?(z, zrange)
  end
  if in_range?(x, xrange) && in_range?(y, yrange) && in_range?(z, zrange)
    cmd
  else
    state
  end
end

def in_range?(point, range)
  min, max = range
  Integer(min) <= point && point <= Integer(max)
end

def part1(radius, input)
  # This algo isn't fast ~3m to get the answer for part1
  (-radius..radius).sum do |x|
    (-radius..radius).sum do |y|
      (-radius..radius).sum do |z|
        input.reduce(0) { |state, a| apply_step(state, [x,y,z], a) }
      end
    end
  end
end

def part2(input)
end

def main
  # input_file = "inputSample1.txt"
  # part1_radius = 15
  # input_file = "inputSample2.txt"
  # part1_radius = 50
  input_file = "input.txt"
  part1_radius = 50

  print "Part1 Answer: ", part1(part1_radius, load_data(input_file)), "\n"
  # print "Part2 Answer: ", part2(load_data(input_file)), "\n"
end

main
