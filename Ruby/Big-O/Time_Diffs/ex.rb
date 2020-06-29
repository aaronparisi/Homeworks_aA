def my_min1(arr)
    # O(n^2)
    arr.each do |el1|
        catch :found do
            arr.each do |el2|
                throw :found if el1 > el2
            end
            return el1
        end
    end
end

def my_min2(arr)
    # O(n)
    min = arr.first
    arr.each {|el| min = el if el < min}

    min
end

list = [ 0, 3, 5, 4, -5, 10, 1, 90 ]
# puts my_min1(list) == -5
# puts my_min2(list) == -5

def largest_cont_subsum(arr)
    # O(n^3) ??
    subs = []
    arr.each_with_index do |el, i|
        (i...arr.length).each do |dest|
            subs << arr[i..dest]
        end
    end
    subs.map(&:sum).max
end

def faster_cont_subsum(arr)
    # in order for this to be O(n),
    # we can only iterate over the numbers 1 time

    largest = arr[0]
    cur = arr[0]

    arr[1..-1].each do |el|
        if cur < 0 #&& el >= 0
            # no point tacking on negative sum to positive stuff
            cur = el
        # elsif cur < 0 && el > cur
        #     # el is the "least negative" thing so far
        #     #largest = el
        #     cur = el
        # elsif cur + el < 0
        #     # el is so negative that it destroys the entire prior sum
        #     #largest = cur
        #     cur = el
        else
            # ok just add el to the cur
            cur += el
        end

        largest = cur if cur > largest
    end

    largest

end

list2 = [5, 3, -7]              # [5, 3]                => 8
list3 = [2, 3, -6, 7, -6, 7]    # [7, -6, 7]            => 8
list4 = [-5, -1, -3]            # [-1]                  => -1
list5 = [-1, -1, -1, 3000, -1]  # [3000]                => 3000
list6 = [7, 3, -6, 7, -6, 7]    # [7, 3, -6, 7, -6, 7]  => 12
list7 = [-2, 3, -6, 7, 6, -6, 7]# [7, 6, -6, 7]         => 14
list8 = [1000, -2, 3, -6, 7, 6, -6, 7]                # => 1009
list9 = [-1]                    # [-1]                  => -1
list10 = [-1, -2, 0, -1]        # [0]                   => 0
list11 = [-1, -2, 3, -1, 2]     # [3, -1, 2]            => 4
list12 = [-1, -2, 3, -1, -1]    # [3]                   => 3
# puts largest_cont_subsum(list2) == 8
# puts largest_cont_subsum(list3) == 8
# puts largest_cont_subsum(list4) == -1

puts faster_cont_subsum(list2)
puts faster_cont_subsum(list3)
puts faster_cont_subsum(list4)
puts faster_cont_subsum(list5)
puts faster_cont_subsum(list6)
puts faster_cont_subsum(list7)
puts faster_cont_subsum(list8)
puts faster_cont_subsum(list9)
puts faster_cont_subsum(list10)
puts faster_cont_subsum(list11)
puts faster_cont_subsum(list12)