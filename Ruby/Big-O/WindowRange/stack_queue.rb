require_relative 'my_stack'

class StackQueue
    # allows us to dequeue like a queue
    # while taking advantage of a stack's constant-time pop
    def initialize
        @store = MyStack.new
        @dump = MyStack.new
    end

    def size
        @store.size
    end

    def empty?
        @store.empty? && @dump.empty?
    end

    def enqueue(el)
        @store.push(el)
    end

    def dequeue
        if @dump.empty?
            @dump.push(@store.pop) until @store.empty?
        end

        @dump.pop
    end

end