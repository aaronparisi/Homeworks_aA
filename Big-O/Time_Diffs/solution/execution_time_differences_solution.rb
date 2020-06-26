#O(n^2) quadratic time
#O(n^2) quadratic space
def my_min_1a(list)
  min_num = nil

  list.each do |num1|
    dup_list = list.dup
    # this will duplicate the list once for every element
    # hence n^2 space
    dup_list.delete(num1)
    min_num = num1 if dup_list.all? { |num2| num2 > num1 }
    # this will iterate through the entire dup_list once for each num1
    # hence n^2 time
    # ALSO it will NOT break out early if min_num is found
  end

  min_num
end

#O(n^2) quadratic time
#O(1) constant space
def my_min_1b(list)
  # this is more similar to my implementation
  list.each_with_index do |num1, i1|
    # first iteration through the list
    min = true
    list.each_with_index do |num2, i2|
      # second iteration through the list
      next if i1 == i2
      # allows them to skip the comparison on the next line
      min = false if num2 < num1
      # if we find a smaller number, do not return num1
      # this will, however, continue to iterate through
      # the inner loop even if min is set to false
      # in THIS code, if they said "break if ..."
      # that would be fine, because they only return num1 IF min == true
      # whereas in mine, I don't store a min variable,
      # so I needed a way to not only break out of the inner loop,
      # but also skip the remainder of the current iteration of the
      # outer loop, WITHOUT breaking out of the outer loop altogether
      # i.e. the throw allows me to basically create a simultaneous
      # BREAK from the inner loop and a NEXT in the outer loop
   end
   return num1 if min
  end
end

#O(n) linear time
#O(1) constant space
def my_min_2(list)
  min_num = list.first

  list.each { |num| min_num = num if num < min_num }

  min_num
end

#O(n^3) cubic time
#O(n^3) cubic space
def largest_contiguous_subsum1(array)
  subs = []

  array.each_index do |idx1|
    (idx1..array.length - 1).each do |idx2|
      subs << array[idx1..idx2]
    end
  end

  subs.map { |sub| sub.inject(:+) }.max
end

#O(n) linear time
#O(1) constant space
def largest_contiguous_subsum2(arr)
  largest = arr.first
  current = arr.first

  (1...arr.length).each do |i|
    current = 0 if current < 0
    current += arr[i]
    largest = current if current > largest
  end

  largest
end
