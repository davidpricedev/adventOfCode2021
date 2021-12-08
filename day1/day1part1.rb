
def load_ints()
  lines = File.read('day1Input.txt').strip().split("\n")
  return lines.map { |x| Integer(x) }
end

def part1(input)
  results = []
  input.each_cons(2) { |a| results << (a[0] < a[1]) }
  return results.count { |x| x }
end

def part2(input)
  results = []
  input.each_cons(3).each_cons(2) { |a, b| results << (a.sum() < b.sum()) }
  return results.count { |x| x }
end

print part1(load_ints()), "\n"
print part2(load_ints()), "\n"
