class Queue

    attr_reader :aQueue

    def initialize
        @aQueue = []
    end

    def enqueue(el)
        # add an element to the "back" of the queue (beginning of the array)
        @aQueue.unshift(el)
    end

    def dequeue()
        # remove the element from the "front" of the queue (end of the array)
        @aQueue.pop()
    end

    def peek()
        # return the "next-in-line" (i.e. end of the array)
        aQueue[-1]
    end
end

q1 = Queue.new()
puts q1.peek == nil
q1.enqueue("Andrew")
puts q1.peek == "Andrew"
q1.enqueue("Aaron")
puts q1.peek == "Andrew"
q1.enqueue("Christopher")
q1.enqueue("Sarah")
puts q1.peek == "Andrew"
q1.dequeue()
puts q1.peek == "Aaron"