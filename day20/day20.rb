require "set"
require "../utils"

def load_data(input_file)
  lines = File.read(input_file).strip.split("\n")
  lookup_array = lines[0]
  input_image = lines[2..]
  [lookup_array, input_image]
end

def grow_input_image(img, grow_value)
  new_len = img[0].length + 4
  new_row = (1..new_len).map { |x| grow_value }.join("")
  new_rows = [new_row, new_row]
  padding = grow_value + grow_value
  padded = img.map { |x| "#{padding}#{x}#{padding}" }
  new_rows + padded + new_rows
end

def get_index_value_at(input_image, x, y)
  rows = input_image[y-1..y+1].map { |a| a[x-1..x+1] }
  combined = rows.join("")
  value = combined.gsub(".", "0").gsub("#", "1").to_i(2)
  value
end

def enhance(lookup_array, input_image)
  (1..input_image.length - 2).map do |y|
    (1..input_image[0].length - 2).map do |x|
      value = get_index_value_at(input_image, x, y)
      new_value = lookup_array[value]
      new_value
    end.join("")
  end
end

def count_lit(image)
  image.map { |x| x.count("#") }.sum
end

def inf_field(seed, lookup_array, &fn)
  e = Enumerator.new do |yielder|
    yielder << seed
    state = seed
    loop do
      new_state = state == "." ? lookup_array[0] : lookup_array[-1]
      yielder << new_state
      state = new_state
    end
  end

  return e unless fn
  e.each(&fn)
end

def enhance_n(lookup_array, image, n)
  inf_field(".", lookup_array).take(n).map do |x|
    grown_img = grow_input_image(image, x)
    image = enhance(lookup_array, grown_img)
    image
  end
end

def part1(input)
  lookup_array = input[0]
  input_image = input[1]
  count_lit(enhance_n(lookup_array, input_image, 2)[-1])
end

def part2(input)
  lookup_array = input[0]
  input_image = input[1]
  result = enhance_n(lookup_array, input_image, 50)
  print_array(result[-1])
  count_lit(result[-1])
end

def main
  # input_file = "inputSample.txt"
  # input_file = "inputSample2.txt"  # expected p1 answer is 5326
  input_file = "input.txt"

  print "Part1 Answer: ", part1(load_data(input_file)), "\n"
  print "Part2 Answer: ", part2(load_data(input_file)), "\n"
end

main
