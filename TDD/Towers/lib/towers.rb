class EmptyPileError < ArgumentError
end

class DiskMismatchError < ArgumentError
    
end

class Towers

    attr_reader :piles

    def initialize
        @piles = [[1, 2, 3], [], []]
    end

    def move(orig, dest)
        raise EmptyPileError if piles[orig].length == 0
        if piles[dest].length > 0
            raise DiskMismatchError if piles[orig].first > piles[dest].first
        end

        piles[dest].unshift(piles[orig].shift)
    end

    def game_over?
        piles[2].length == 3 ? true : false
    end
end