class myQueue
    def initialize()
        @store = []
    end

    def peek
        @store.first
    end

    def size
        @store.length
    end

    def empty?
        @store.empty?
    end

    def enqueue(el)
        @store << el
    end

    def dequeue
        @store.shift
    end
end