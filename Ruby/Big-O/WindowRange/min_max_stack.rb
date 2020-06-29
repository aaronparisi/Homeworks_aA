class MinMaxStack
    def initialize
        @store = []
    end

    def els
        @store.dup
    end

    def peek
        @store.last[:val] unless empty?
    end
    
    def size
        @store.size
    end

    def empty?
        @store.empty?
    end

    def min
        @store.last[:min] unless empty?
        # we need to check if it's empty
        # because, usually, .peek would just return nil
        # but now it's gonna get confused
        # "where's the :min for nil??"
    end

    def max
        @store.last[:max] unless empty?
    end

    def pop
        @store.pop[:val] unless empty?
        # pop typically returns the element, but in this case,
        # that element is a hash, so we want to POP the whole element
        # but RETURN only the :value
    end

    def push(el)
        @store.push(
            {
                :min => empty? ? el : [min, el].min,
                :max => empty? ? el : [max, el].max,
                :val => el
            }
        )
        # each element contains the max and min AT THE TIME OF PUSHING
        # so if we delete that element, all that info goes with it
        # and the next el (.peek) contains the "most recent"
        # max and min
        # if that el didn't change the max or min,
        # then the one "under" it in the stack will have the same info
    end

    def cheat
        # a cheating method to get the first el
        @store.first[:val]
    end

end