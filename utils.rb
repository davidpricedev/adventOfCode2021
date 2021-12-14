def print_array(a, header = "")
  header != "" and print header, "\n"
  print "[\n"
  a.each_with_index { |x, i| print "  #{i}: #{x}\n" }
  print "]\n"
end

def print_hash(h, header = "")
  header != "" and print header, "{\n"
  h.each { |k, v| print "  #{k} => #{v} \n" }
  print "}\n"
end