module Enumerable
  def group_by_first_letter
    groups = {}
    # iterate over all characters and group by first character in string
    (0..255).each do |charNo|
      char = charNo.chr # convert number to character
      starts_with = self.find_all{|elem| elem[0] == char}
      if starts_with.length > 0
        groups[char] = starts_with
      end
    end
    return groups
  end

  def each_group_by_first_letter
    groups = self.group_by_first_letter
    groups.each_pair do |k, v|
      yield(k, v)
    end
  end
end


x = ["abcd", "axyz", "able", "xyzab", "qrst"]
x.each_group_by_first_letter do |letter, words|
  printf("%s: %s\n", letter, words.join(" "));
end

puts "\n"

x = ["Abcd", "axyz", "Able", "xyzab", "qrst", "alamo", "1Z2D", "Xy"]
x.each_group_by_first_letter do |letter, words|
  printf("%s: %s\n", letter, words.join(" "));
end