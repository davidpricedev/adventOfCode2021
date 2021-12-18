require "set"
require "../utils"

# maxy is technically "smaller" since it is maximally negative
class Zone
  attr_reader :minx, :miny, :maxx, :maxy
  def initialize(minx, maxx, miny, maxy)
    @minx = minx
    @miny = miny
    @maxx = maxx
    @maxy = maxy
  end

  def inspect
    "x in (#{minx}..#{maxx}), y in (#{miny}..#{maxy})"
  end

  def to_s
    inspect
  end
end

def point_in_zone?(zone, point)
  # y comparisons look funny since zone is negative
  point.x >= zone.minx && point.x <= zone.maxx &&
    point.y <= zone.miny && point.y >= zone.maxy
end

def step(velocity, position)
  new_position = Point2d.new(position.x + velocity.x, position.y + velocity.y)
  new_velocity = Point2d.new(velocity.x > 0 ? velocity.x - 1 : 0, velocity.y - 1)
  [new_velocity, new_position]
end

def in_bounds?(max_pos, current_pos)
  current_pos.x <= max_pos.x && current_pos.y >= max_pos.y
end

def trajectory(max_pos, init_velocity, &fn)
  init_pos = Point2d.new(0, 0)
  state = [init_velocity, init_pos]
  e = Enumerator.new do |yielder|
    yielder << init_pos
    loop do
      new_state = step(*state)
      break unless in_bounds?(max_pos, new_state[1])
      yielder << new_state[1]
      state = new_state
    end
  end

  return e unless fn
  e.each(&fn)
end

def lands_in_zone?(zone, trajectory)
  trajectory.any? { |p| point_in_zone?(zone, p) }
end

def part1(zone)
  zone.maxy * (zone.maxy + 1) / 2
end

def part2(zone)
  minx = Math.sqrt(2 * zone.minx).floor
  maxx = zone.maxx
  miny = zone.maxy
  maxy = Math.sqrt(2 * part1(zone)).floor
  maxpos = Point2d.new(zone.maxx, zone.maxy)
  results = (minx..maxx).map do |x|
    (miny..maxy).map do |y|
      v = Point2d.new(x, y)
      lands_in_zone?(zone, trajectory(maxpos, v)) ? 1 : 0
    end
  end
  results.flatten.sum
end

def main
  # zone = Zone.new(20, 30, -5, -10)  # sample
  zone = Zone.new(79, 137, -117, -176)  # real

  print "Part1 Answer: ", part1(zone), "\n"
  print "Part2 Answer: ", part2(zone), "\n"
end

main
