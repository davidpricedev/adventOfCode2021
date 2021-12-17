require "set"
require "../utils"

def load_data(input_file)
  lines = File.read(input_file).strip.split("\n")
  calls = lines[0].split(",").map { |n| Integer(n) }
  board_lines = lines[2..]
  boards = []
  i = 1
  loop do
    if !board_lines.nil? && board_lines.length >= 5
      boards << BingoBoard.from_lines(board_lines[0..4], i)
      board_lines = board_lines[6..]
      i += 1
    else
      break
    end
  end
  [calls, boards]
end

class BingoBoard < Table2d
  attr_reader :board_num

  def to_s
    inspect
  end

  def inspect
    print "Board ##{board_num}, status: #{has_bingo?}\n"
  end

  def initialize(table, number)
    @table = table
    @rows = (0..4).map { |i| 0 }
    @cols = (0..4).map { |i| 0 }
    @calls = []
    @board_num = number
  end

  def self.from_lines(lines, number)
    BingoBoard.new(lines.map { |y| y.split(" ").map { |x| Integer(x) } }, number)
  end

  def apply_call(n)
    @table.each_with_index do |y, i|
      y.each_with_index do |x, j|
        if x == n
          @cols[i] += 1
          @rows[j] += 1
          @calls << [i, j]
        end
      end
    end
  end

  def has_bingo?
    @rows.max == 5 || @cols.max == 5
  end

  def unmarked_values
    enumerate_indexes.map { |x, y| @calls.include?([x, y]) ? 0 : get(x, y) }
  end
end

def apply_step(boards, call)
  winners = []
  boards.each do |b|
    b.apply_call(call)
    if b.has_bingo?
      winners << b
    end
  end
  [boards, winners]
end

def part1(input)
  calls = input[0]
  boards = input[1]
  last_call = -1
  winner = []
  calls.each do |call|
    result = apply_step(boards, call)
    last_call = call
    if result[1] != []
      winner = result[1][0]
      break
    end
    boards = result[0]
  end
  last_call * winner.unmarked_values.sum
end

def part2(input)
  calls = input[0]
  boards = input[1]
  last_call = -1
  winners = []
  winner = []
  calls.each do |call|
    result = apply_step(boards, call)
    boards = result[0].filter { |b| !b.has_bingo? }
    last_call = call
    winners.append(*result[1])
    if boards == []
      winner = result[1][0]
      break
    end
  end
  last_call * winner.unmarked_values.sum
end

def main
  # input_file = "inputSample.txt"
  input_file = "input.txt"

  print "Part1 Answer: ", part1(load_data(input_file)), "\n"
  print "Part2 Answer: ", part2(load_data(input_file)), "\n"
end

main
