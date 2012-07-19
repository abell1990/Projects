def extract_int_from_str(string)
  (string =~ /(\d+)/ ? $1 : -1).to_i
end

def funny_sort(string_array)
  string_array.sort {|a, b| extract_int_from_str(a) <=> extract_int_from_str(b)}
end

string_array_1 = ["abc99.6", "99", "-100x500", "hello world!"]
puts "funny_sort([" + string_array_1.join(", ") + "]) = [" + funny_sort(string_array_1).join(", ") + "]"

string_array_2 = ["p13ase sort me mama", "1'll sort you papa", "damn!", "yak!"]
puts "funny_sort([" + string_array_2.join(", ") + "]) = [" + funny_sort(string_array_2).join(", ") + "]"

string_array_3 = ["Charles Darwin born 1809", "Don Knuth born 1938", "Isaac Newton born 1643", "Rudolf Lipschitz born 1832"]
puts "funny_sort([" + string_array_3.join(", ") + "]) = [" + funny_sort(string_array_3).join(", ") + "]"



