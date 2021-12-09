def load_data(input_file)
  lines = File.read(input_file).strip.split(",")
  lines.map { |x| Integer(x) }
end

def part1_naive(input)
  (1..80).reduce(input) { |state, _| age_a_day_naive(state) }.count
end

def age_a_day_naive(ages)
  ages.flat_map { |x| x == 0 ? [6, 8] : [x - 1] }
end

def population_simulation(input, days)
  hashed_ages = (0..8).to_h { |x| [x, 0] }
  input.each { |x| hashed_ages[x] += 1 }
  (1..days).reduce(hashed_ages) { |state, _| age_a_day_hash(state) }.values.sum
end

def part1(input)
  population_simulation(input, 80)
end

def part2(input)
  population_simulation(input, 256)
end

def age_a_day_hash(hash)
  zeroes = hash[0]
  (1..8).each { |x| hash[x - 1] = hash[x] }
  hash[6] += zeroes
  hash[8] = zeroes
  hash
end

def main
  # input_file = "inputSample.txt"
  input_file = "input.txt"

  print part1(load_data(input_file)), "\n"
  print part2(load_data(input_file)), "\n"
end

main
