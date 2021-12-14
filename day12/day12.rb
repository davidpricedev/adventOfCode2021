require "set"

def load_data(input_file)
  lines = File.read(input_file).strip.split("\n")
  lines.map { |x| x.split("-") }
end

class Path
  include Comparable
  attr_reader :path_so_far

  def eql?(other)
    path_so_far == other.path_so_far
  end

  def hash
    path_so_far.hash
  end

  def to_s
    path_so_far.to_s
  end

  def inspect
    path_so_far.to_s
  end

  def initialize(path_so_far)
    @path_so_far = path_so_far
  end

  def legal?(x)
    x.downcase != x || !@path_so_far.include?(x)
  end

  def complete?
    last_junct == "end"
  end

  def last_junct
    path_so_far.length > 0 ? path_so_far[-1] : nil
  end

  def append(junction)
    if legal?(junction)
      path_copy = @path_so_far.map { |x| x }
      path_copy << junction
      Path.new(path_copy)
    end
  end
end

class PathPart2 < Path
  def initialize(path_so_far)
    @path_so_far = path_so_far
    @dupe = nil
    path_so_far.tally.find { |k, v| v == 2 && k == k.downcase and @dupe = k }
  end

  def legal?(x)
    x != "start" && (x.downcase != x || @dupe.nil? || !@path_so_far.include?(x))
  end

  def append(junction)
    if legal?(junction)
      path_copy = @path_so_far.map { |x| x }
      path_copy << junction
      PathPart2.new(path_copy)
    end
  end
end

def part1(input)
  juncts = build_junctions(input)
  build_all_paths([Path.new(["start"])], juncts).count
end

def build_all_paths(seed_paths, junctions)
  next_paths = seed_paths
  loop do
    next_paths = progress_paths(junctions, next_paths).filter { |x| !x.nil? }
    if next_paths.all? { |x| x.complete? }
      return next_paths
    end
  end
end

def progress_paths(juncts, paths)
  if paths.nil?
    nil
  else
    paths.flat_map do |path|
      new_juncts = juncts[path.last_junct]
      if path.complete? || new_juncts.nil?
        path
      else
        new_juncts.map { |j| path.append(j) }
      end
    end
  end
end

def build_junctions(input)
  juncts = input.flat_map { |x| x }.to_set.map { |x| [x, []] }.to_h
  input.each do |a, b|
    juncts[a].include? b or juncts[a] << b
    juncts[b].include? a or juncts[b] << a
  end
  # by keeping end out of the hashes, we have a good way of stopping.
  juncts.delete("end")
  juncts
end

def part2(input)
  juncts = build_junctions(input)
  result = build_all_paths([PathPart2.new(["start"])], juncts)
  result.count
end

def main
  # input_file = "inputSample.txt"
  # input_file = "inputSample1.txt"
  # input_file = "inputSample2.txt"
  input_file = "input.txt"

  print "Part1 Answer: ", part1(load_data(input_file)), "\n"
  print "Part2 Answer: ", part2(load_data(input_file)), "\n"
end

main
