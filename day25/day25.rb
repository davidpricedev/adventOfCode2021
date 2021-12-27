require "set"
require "../utils"

def load_data(input_file)
  lines = File.read(input_file).strip.split("\n")
  lines.map { |a| a.chars }
end

def enumerate_cuke_map(cukemap, &fn)
  e = Enumerator.new do |yielder|
    cukemap.each_with_index do |row, i|
      row.each_with_index do |x, j|
        yielder << [x, i, j]
      end
    end
  end

  return e unless fn
  e.each(&fn)
end

# modulus is 1-based so we need to account for that in zero-based indexes
def index_mod(base, x)
  ((x + 1) % base) - 1
end

def identify_east_moves(cukemap)
  moves = []
  enumerate_cuke_map(cukemap) do |x, i, j|
    nextj = index_mod(cukemap[0].length, j + 1)
    if x == ">" && cukemap[i][nextj] == "."
      moves << [i, j]
    end
  end
  moves
end

def identify_south_moves(cukemap)
  moves = []
  enumerate_cuke_map(cukemap) do |x, i, j|
    nexti = index_mod(cukemap.length, i + 1)
    if x == "v" && cukemap[nexti][j] == "."
      moves << [i, j]
    end
  end
  moves
end

def execute_east_moves(cukemap, moves)
  moves.each do |i, j|
    nextj = index_mod(cukemap[0].length, j + 1)
    cukemap[i][j] = "."
    cukemap[i][nextj] = ">"
  end
  cukemap
end

def execute_south_moves(cukemap, moves)
  moves.each do |i, j|
    nexti = index_mod(cukemap.length, i + 1)
    cukemap[i][j] = "."
    cukemap[nexti][j] = "v"
  end
  cukemap
end

def run_step(cukemap)
  emoves = identify_east_moves(cukemap)
  cukemap = execute_east_moves(cukemap, emoves)
  smoves = identify_south_moves(cukemap)
  cukemap = execute_south_moves(cukemap, smoves)
  [cukemap, emoves.length + smoves.length]
end

def simulate(cukemap)
  steps = 1
  loop do
    cukemap, move_count = run_step(cukemap)
    if move_count == 0 # || steps > 10
      return steps
    end
    steps += 1
  end
end

def part1(input)
  simulate(input)
end

def main
  # input_file = "inputSample.txt"
  input_file = "input.txt"

  print "Part1 Answer: ", part1(load_data(input_file)), "\n"
end

main
