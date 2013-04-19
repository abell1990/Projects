def is_filtered_out?(num, filter)
  return filter.has_key?(:min) && num < filter[:min] ||
      filter.has_key?(:max) && num > filter[:max] ||
      filter.has_key?(:odd) && num % 2 == 0 ||
      filter.has_key?(:even) && num % 2 != 0
end

def filter(array, *params)
  array.each do |num|
    if params.length == 1 # filter is present, check if num passes filter
      filter = params[0]
      if is_filtered_out?(num, filter)
        next
      elsif filter.has_key?(:scale)
        num *= filter[:scale]
      end
    end
    yield(num)
  end
end


puts "nums = [6, -5, 319, 400, 18, 94, 11]"
nums = [6, -5, 319, 400, 18, 94, 11]
puts " "

puts "filter(nums, :min => 10, :max => 350, :odd => 1, :scale => 2) {|n| puts n} : "
filter(nums, :min => 10, :max => 350, :odd => 1, :scale => 2) {|n| puts n}
puts " "

puts "filter(nums, :max => 0) {|n| puts n} : "
filter(nums, :max => 0) {|n| puts n}
puts " "

puts "filter(nums) {|n| puts n} : "
filter(nums) {|n| puts n}
puts " "
