def load_cmds(input_file)
  lines = File.read(input_file).strip.split("\n")
  lines.map { |x| parse_command(x) }
end

def parse_command(line)
  parts = line.split(" ")
  parts[1] = Integer(parts[1])
  parts
end

# Distance then Depth
def part1(input)
  input.reduce([0, 0]) { |state, cmd| handle_command_part1(state, cmd) }
end

def handle_command_part1(state, cmd)
  case cmd[0]
  when "forward"
    [state[0] + cmd[1], state[1]]
  when "up"
    [state[0], state[1] - cmd[1]]
  when "down"
    [state[0], state[1] + cmd[1]]
  else
    raise "Unknown Command"
  end
end

# Distance, Aim, Depth
def part2(input)
  input.reduce([0, 0, 0]) { |state, cmd| handle_command_part2(state, cmd) }
end

def handle_command_part2(state, cmd)
  case cmd[0]
  when "forward"
    [state[0] + cmd[1], state[1], state[2] += state[1] * cmd[1]]
  when "up"
    [state[0], state[1] - cmd[1], state[2]]
  when "down"
    [state[0], state[1] + cmd[1], state[2]]
  else
    raise "Unknown Command"
  end
end

def main
  # input_file = 'inputSample.txt'
  input_file = "input.txt"

  x = part1(load_cmds(input_file))
  print x[0] * x[1], "\n"
  y = part2(load_cmds(input_file))
  print y[0] * y[2], "\n"
end

main
