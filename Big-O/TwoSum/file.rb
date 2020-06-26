# time complexity: O(n^2)
def brute_force(arr, tgt)
    (0..arr.length-1).each do |i|
        (0..arr.length-1).each do |j|
            #all << arr[i] + arr[j] unless i == j
            if i != j
                return true if arr[i] + arr[j] == tgt
            end
        end
    end

    return false
end

arr = [0, 1, 5, 7]
puts brute_force(arr, 6) == true
puts brute_force(arr, 10) == false

def by_sorting(arr, tgt)
    sorted = arr.sort

    return false if sorted.first > tgt

    n1 = arr.first

    small = 0
    big = arr.length - 1

    until small >= big
        sum = arr[small] + arr[big]

        if sum == tgt
            return true
        elsif sum > tgt
            big -= 1
        else
            small += 1
        end
    end

    return false
end

puts by_sorting(arr, 6) == true
puts by_sorting(arr, 10) == false

def by_hash(arr, tgt)
    h = {}
    arr.each {|el| h[el] = 1}


end