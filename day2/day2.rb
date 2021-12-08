def load_cmds(inputFile)
  lines = File.read(inputFile).strip().split("\n")
  return lines.map { |x| parse_command(x) }
end

def parse_command(line)
  parts = line.split(" ")
  parts[1] = Integer(parts[1])
  return parts
end

# Distance then Depth
def part1(input)
  return input.reduce([0,0]) { |state, cmd| handle_command_part1(state, cmd) }
end

def handle_command_part1(state, cmd)
  case cmd[0]
  when 'forward'
    newstate = [state[0] + cmd[1], state[1]]
  when 'up'
    newstate = [state[0], state[1] - cmd[1]]
  when 'down'
    newstate = [state[0], state[1] + cmd[1]]
  else
    raise "Unknown Command"
  end
end

# Distance, Aim, Depth
def part2(input)
  return input.reduce([0,0,0]) { |state, cmd| handle_command_part2(state, cmd) }
end

def handle_command_part2(state, cmd)
  case cmd[0]
  when 'forward'
    newstate = [state[0] + cmd[1], state[1], state[2] += state[1] * cmd[1]]
  when 'up'
    newstate = [state[0], state[1] - cmd[1], state[2]]
  when 'down'
    newstate = [state[0], state[1] + cmd[1], state[2]]
  else
    raise "Unknown Command"
  end
end

def main()
  #inputFile = 'inputSample.txt'
  inputFile = 'input.txt'

  x = part1(load_cmds(inputFile))
  print x[0] * x[1], "\n"
  y = part2(load_cmds(inputFile))
  print y[0] * y[2], "\n"
end

main()