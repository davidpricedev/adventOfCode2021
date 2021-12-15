require "set"
require "../utils"

def load_data(input_file)
  lines = File.read(input_file).strip.split("\n")
  template = lines[0]
  rules = lines[2..].map { |x| x.split(" -> ") }
  [template, rules]
end

def part1(input)
  template = input[0]
  rules = input[1]
  result = simulate_forever_naive(template, rules).take(1)[-1]
  occurrences = result.chars.tally.values.sort
  occurrences[-1] - occurrences[0]
end

def simulate_forever_naive(state, rules)
  Enumerator.new do |yielder|
    i = 0
    loop do
      state = apply_step_naive(state, rules)
      yielder << state
      i += 1
    end
  end
end

def apply_step_naive(state, rules)
  rules
    .flat_map { |rule| indices_of_matches(state, rule[0]).map { |x| [x, rule] } }
    .filter { |x| !x.nil? && x != [] }
    .sort { |a, b| b[0] <=> a[0] }
    .each { |i, rule| state = state.insert(i + 1, rule[1]) }
  state
end

# borrowed from https://stackoverflow.com/a/43332509 since ruby doesn't have it built-in
def indices_of_matches(str, target)
  sz = target.size
  (0..str.size - sz).select { |i| str[i, sz] == target }
end

def part2(input)
  template = input[0]
  rules = input[1]
  pairshash = split_to_segments(template, 2).each_with_object({}) do |x, state|
    state[x] = (state[x] or 0) + 1
  end
  result = simulate_forever(pairshash, rules).take(40)
  counts = count_values(result[-1], template)
  occurrences = counts.values.sort
  occurrences[-1] - occurrences[0]
end

def split_to_segments(str, seg_size)
  (0..str.size - seg_size).map do |i|
    print "i: #{i}  \n"
    str[i, seg_size]
  end
end

def simulate_forever(state, rules)
  Enumerator.new do |yielder|
    i = 0
    loop do
      state = apply_step(state, rules)
      yielder << state
      i += 1
    end
  end
end

def apply_step(state, rules)
  step_cmds = rules.map { |k, v| [k, state[k], v] }.filter { |a, b, c| !b.nil? }
  step_cmds.each do |k, n, v|
    state[k] -= n
    newk1 = "#{k[0]}#{v}"
    newk2 = "#{v}#{k[1]}"
    state[newk1] = (state[newk1] or 0) + n
    state[newk2] = (state[newk2] or 0) + n
  end
  state
end

# convert hash of pair counts to hash of individual letter counts
def count_values(hash, template)
  counts = hash
    .flat_map { |k, v| [[k[0].chars, v], [k[1].chars, v]] }
    .each_with_object({}) do |x, state|
    state[x[0]] = (state[x[0]] or 0) + x[1]
  end
  counts[template[0].chars] += 1
  counts[template[-1].chars] += 1
  counts.map { |k, v| [k, v / 2] }.to_h
end

def main
  # input_file = "inputSample.txt"
  input_file = "input.txt"

  print "Part1 Answer: ", part1(load_data(input_file)), "\n"
  print "Part2 Answer: ", part2(load_data(input_file)), "\n"
end

main
