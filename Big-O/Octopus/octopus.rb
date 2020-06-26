def sluggish(arr)
    # O(n**2)

    arr.each do |el1|
        catch :longer do
            arr.each do |el2|
                throw :longer if el2.length > el1.length
            end
            # if you get to there, nothing was longer than el1
            return el1
        end
        # you end up here if :longer is thrown
        # we skip the return and move on to the next element in the array
    end
end

def merge(a1, a2)
    ret = []
    while a1.length > 0 && a2.length > 0
        if a1.first.length < a2.first.length
            ret << a1.shift
        else
            ret << a2.shift
        end
    end
    ret += a1
    ret += a2

    ret
end

def merge_sort(arr)
    len = arr.length
    return arr if len == 1
    merge(merge_sort(arr[0..(len/2)-1]), merge_sort(arr[(len/2)..-1]))
end

def dominant(arr)
    merge_sort(arr).last
end

def clever(arr)
    ret = arr.first
    arr.each {|el| ret = el if el.length > ret.length}

    ret
end

arr = ['fish', 'fiiish', 'fiiiiish', 'fiiiish', 'fffish', 'ffiiiiisshh', 'fsh', 'fiiiissshhhhhh']
puts sluggish(arr) == "fiiiissshhhhhh"
puts dominant(arr) == "fiiiissshhhhhh"
puts clever(arr) == "fiiiissshhhhhh"