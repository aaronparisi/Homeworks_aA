def windowed_max_range(arr, w)
    cur_max_range = nil
    i = 0
    while i <= arr.length-w
        window = arr[i...i+w]
        this_range = window.max - window.min

        if cur_max_range
            cur_max_range = [cur_max_range, this_range].max
        else
            cur_max_range = this_range
        end

        i += 1
    end

    cur_max_range
end

puts windowed_max_range([1, 0, 2, 5, 4, 8], 2) #== 4 # 4, 8
puts windowed_max_range([1, 0, 2, 5, 4, 8], 3) #== 5 # 0, 2, 5
puts windowed_max_range([1, 0, 2, 5, 4, 8], 4) #== 6 # 2, 5, 4, 8
puts windowed_max_range([1, 3, 2, 5, 4, 8], 5) #== 6 # 3, 2, 5, 4, 8

