require_relative 'min_max_stack'
require 'byebug'

class MinMaxStackQueue
    # a queue, implemented with 2 stacks,
    # which will also keep track of min and max
    def initialize
        @store = MinMaxStack.new
        @dump = MinMaxStack.new
    end

    def size
        @store.size
    end

    def empty?
        @store.empty? && @dump.empty?
    end

    def peek
        # returns the value of the item which would be popped next
        # this will always be @dump.peek
        # UNLESS @dump is empty, which I accounted for in the
        # enque
        @dump.peek
    end

    def min
        # the last element added will have the min we want
        return if empty?

        @store.empty? ? @dump.min : @store.min
    end

    def max
        # the last element added will have the max we want
        return if empty?

        @store.empty? ? @dump.max : @store.max
    end

    def enqueue(el)
        empty? ? @dump.push(el) : @store.push(el)
    end

    def dequeue
        if @dump.empty?
            @dump.push(@store.pop) until @store.empty?
        end

        @dump.pop
    end

    def move_window_one(el)
        enqueue(el)
        dequeue
    end

    def get_range
        #debugger
        max - min
    end

    def render
        dump_arr = @dump.els.reverse.map {|e| e[:val]}
        store_arr = @store.els.map {|e| e[:val]}
        puts "dump: " + dump_arr.join(", ") + " | store: " + store_arr.join(", ")
    end
end