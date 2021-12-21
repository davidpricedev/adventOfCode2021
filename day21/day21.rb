require "set"
require "../utils"

class DeterministicDie
  attr_reader :roll_count

  def initialize
    @last = 0
    @enum = _build_rolls_enum
    @roll_count = 0
  end

  def _build_rolls_enum
    Enumerator.new do |yielder|
      loop do
        current_roll = @last + 1
        @last = @last % 10 + 1
        @roll_count += 1
        yielder << current_roll
      end
    end
  end

  def get_rolls
    @enum.take(3)
  end
end

class Player
  attr_reader :score

  def initialize(position, score = 0)
    @position = position
    @score = score
  end

  def advance(rolls)
    new_position = (@position - 1 + rolls.sum) % 10 + 1
    new_score = score + new_position
    Player.new(new_position, new_score)
  end
end

def play_game_part1(player1_init, player2_init)
  die = DeterministicDie.new
  player1 = Player.new(player1_init)
  player2 = Player.new(player2_init)
  loop do
    p1rolls = die.get_rolls
    player1 = player1.advance(p1rolls)
    if player1.score >= 1000 || player2.score >= 1000
      return [player1.score, player2.score, die.roll_count]
    end
    p2rolls = die.get_rolls
    player2 = player2.advance(p2rolls)
    if player1.score >= 1000 || player2.score >= 1000
      return [player1.score, player2.score, die.roll_count]
    end
  end
end

def part1(input)
  p1_score, p2_score, die_rolls = play_game_part1(*input)
  min_score = p1_score < p2_score ? p1_score : p2_score
  min_score * die_rolls
end

def part2(input)
end

def main
  # input = [4, 8]
  input = [5, 8]

  print "Part1 Answer: ", part1(input), "\n"
  # print "Part2 Answer: ", part2(input), "\n"
end

main
