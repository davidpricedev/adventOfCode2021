require "set"
require "../utils"

def load_data(input_file)
  lines = File.read(input_file).strip.split("\n")
  lines.map { |a| parse_inst(a) }
end

def parse_inst(line)
  Instruction.new(*line.split(" "))
end

class Instruction
  attr_reader :instruction, :arg1, :arg2

  def initialize(instruction, arg1, arg2 = nil)
    @instruction = instruction
    @arg1 = arg1
    @arg2 = arg2 == arg2.to_i.to_s ? arg2.to_i : arg2
  end
end

class Alu
  attr_reader :registers

  def to_s
    registers.to_s
  end

  def inspect
    registers.to_s
  end

  def self.setup(instructions, inputs)
    registers = {"w" => 0, "x" => 0, "y" => 0, "z" => 0}
    Alu.new(instructions, inputs, registers)
  end

  def advance(registers)
    new_inputs = current_instruction.instruction == "inp" ? @inputs[1..] : @inputs
    new_instructions = @instructions[1..]
    Alu.new(new_instructions, new_inputs, registers)
  end

  def initialize(instructions, inputs, registers)
    @instructions = instructions
    @inputs = inputs
    @registers = registers
  end

  def current_instruction
    @instructions[0]
  end

  def current_input
    @inputs[0]
  end

  def get_value(register)
    registers[register]
  end

  def get_current_arg1_value
    get_value(current_instruction.arg1)
  end

  def get_current_arg2_value
    current_instruction.arg2.class == Integer ? current_instruction.arg2 : get_value(current_instruction.arg2)
  end

  def apply_instruction
    return self if @instructions.length == 0
    case current_instruction.instruction
    when "inp"
      # print "inp #{current_instruction.arg1} #{current_input}\n"
      apply_input
    when "add"
      # print "add #{current_instruction.arg1} #{current_instruction.arg2}\n"
      apply_add
    when "mul"
      # print "mul #{current_instruction.arg1} #{current_instruction.arg2}\n"
      apply_multiply
    when "div"
      # print "div #{current_instruction.arg1} #{current_instruction.arg2}\n"
      apply_division
    when "mod"
      # print "mod #{current_instruction.arg1} #{current_instruction.arg2}\n"
      apply_modulo
    when "eql"
      # print "eql #{current_instruction.arg1} #{current_instruction.arg2}\n"
      apply_equals_check
    end
  end

  def apply_input
    new_registers = case current_instruction.arg1
    when "w"
      {"w" => current_input, "x" => registers["x"], "y" => registers["y"], "z" => registers["z"]}
    when "x"
      {"w" => registers["w"], "x" => current_input, "y" => registers["y"], "z" => registers["z"]}
    when "y"
      {"w" => registers["w"], "x" => registers["x"], "y" => current_input, "z" => registers["z"]}
    when "z"
      {"w" => registers["w"], "x" => registers["x"], "y" => registers["y"], "z" => current_input}
    end
    advance(new_registers)
  end

  def apply_add
    apply_operation { |a, b| a + b }
  end

  def apply_multiply
    apply_operation { |a, b| a * b }
  end

  def apply_division
    apply_operation { |a, b| a / b }
  end

  def apply_modulo
    apply_operation { |a, b| a % b }
  end

  def apply_equals_check
    apply_operation { |a, b| a == b ? 1 : 0 }
  end

  def apply_operation(&operation)
    arg2 = get_current_arg2_value
    new_registers = case current_instruction.arg1
    when "w"
      {"w" => operation.call(registers["w"], arg2), "x" => registers["x"], "y" => registers["y"], "z" => registers["z"]}
    when "x"
      {"w" => registers["w"], "x" => operation.call(registers["x"], arg2), "y" => registers["y"], "z" => registers["z"]}
    when "y"
      {"w" => registers["w"], "x" => registers["x"], "y" => operation.call(registers["y"], arg2), "z" => registers["z"]}
    when "z"
      {"w" => registers["w"], "x" => registers["x"], "y" => registers["y"], "z" => operation.call(registers["z"], arg2)}
    end
    advance(new_registers)
  end

  def is_done?
    @instructions.length == 0
  end
end

def run_program(instructions, inputs)
  state = Alu.setup(instructions, inputs)
  loop do
    state = state.apply_instruction
    if state.is_done?
      return state.registers
    end
  end
end

def is_valid(instructions, input)
  result = run_program(instructions, input)
  result["z"] == 0
end

def part1(instructions)
  is_valid(instructions, (1..14).map { |a| 2 })
end

def part2(input)
end

def main
  # input_file = "inputSample1.txt"
  # input_file = "inputSample2.txt"
  input_file = "inputSample3.txt"

  print "Part1 Answer: ", part1(load_data(input_file)), "\n"
  # print "Part2 Answer: ", part2(load_data(input_file)), "\n"
end

main
