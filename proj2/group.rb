module Enumerable
  def group_by_first_letter
    groups = {}
    ("a".."z").each do |letter|
      starts_with = self.find_all{|elem| elem[0] == letter}
      if starts_with.length > 0
        groups[letter] = starts_with
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