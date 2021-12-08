def load_data(input_file)
  lines = File.read(input_file).strip.split("\n")
  lines.map { |x| parse_line(x) }
end

def parse_line(line)
  chars = line.chars
  # convert zeroes to -1 so we can simply add to get the most common bit
  chars.map { |x| x == "1" ? 1 : -1 }
end

def part1(input)
  init = (1..input[0].length).map { |_| 0 }
  gamma_source = input.reduce(init) { |state, row| add_row(state, row) }
  gamma = array_to_integer(gamma_source)
  epsilon = array_to_integer(gamma_source.map { |x| -x })
  gamma * epsilon
end

def array_to_integer(input)
  bin = input.map { |x| x < 0 ? "0" : "1" }.join
  bin.to_i(2)
end

def add_row(state, row)
  state.each_with_index.map { |x, i| x + row[i] }
end

def part2(input)
  range = (0..(input[0].length - 1))
  oxy_source = range.reduce(input) { |state, i| filter_step(state, i) { |x| x < 0 ? -1 : 1 } }
  oxy = array_to_integer(oxy_source[0])
  co2_source = range.reduce(input) { |state, i| filter_step(state, i) { |x| x < 0 ? 1 : -1 } }
  co2 = array_to_integer(co2_source[0])
  oxy * co2
end

def oxyfilter(value)
  value < 0 ? -1 : 1
end

def co2filter(value)
  value > 0 ? 1 : -1
end

def filter_step(input, index, &filterfun)
  if input.length == 1
    return input
  end
  init = (1..input[0].length).map { |_| 0 }
  source = input.reduce(init) { |state, row| add_row(state, row) }
  filter_value = filterfun.call(source[index])
  input.filter { |x| x[index] == filter_value }
end

def main
  # input_file = "inputSample.txt"
  input_file = "input.txt"

  print part1(load_data(input_file)), "\n"
  print part2(load_data(input_file)), "\n"
end

main
