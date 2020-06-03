class Stack

    attr_accessor :aStack

    def initialize
        @aStack = []
    end

    def push(el)
        @aStack << el
    end

    def pop()
        @aStack.pop()
    end

    def peek
        aStack[-1]
    end

    def size()
        aStack.length
    end
end

s1 = Stack.new()
puts s1.peek == nil
s1.pop
puts s1.peek == nil

s1.push("Andrew")
s1.push("Aaron")
puts s1.peek == "Aaron"
s1.push("Christopher")
puts s1.pop() == "Christopher"
s1.push("Sarah")
puts s1.peek == "Sarah"
puts s1.size == 3
