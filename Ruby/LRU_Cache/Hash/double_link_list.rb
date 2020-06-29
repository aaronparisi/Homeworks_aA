require_relative 'node'
require 'byebug'

class DLL

    attr_accessor :head, :tail

    def initialize
        @head = Node.new
        @tail = Node.new

        @tail.from = @head
        @head.to = @tail

        # @head.from should be nil
        # @tail.to should be nil
        # @head.val and @tail.val should be nil
    end

    def insert_at_end(aNode)
        @tail.from.to = aNode
        aNode.to = @tail
        aNode.from = @tail.from
        @tail.from = aNode
    end

    def delete_from_beg
        ret = @head.to.key
        @head.to = @head.to.to

        ret
    end

    def make_recent(aNode)
        # we want aNode to be right before tail
        # 1. bypass the node
        aNode.from.to = aNode.to
        aNode.to.from = aNode.from

        # 2. put aNode in between tail and current most recent
        @tail.from.to = aNode
        aNode.from = @tail.from
        aNode.to = @tail
        @tail.from = aNode
    end

    def render
        this = @head.to
        while this != tail
            puts this.val.center(15)
            puts "   |   ".center(15)
            puts "   V   ".center(15)
            this = this.to
        end
    end
end