require_relative 'piece'

class Board
    def initialize()
        @rows = setup_board
    end

    def [](pos)
        x, y = pos
        rows[x][y]
    end

    def []=(pos, val)
        @rows[pos] = val
    end

    def setup_board
        ret = Array.new(8)

        ret[0] = back_row(:black)
        ret[1] = front_row(:black)

        (2..5).each {|row| ret[row] = Array.new(8) {nil}}

        ret[6] = front_row(:white)
        ret[7] = back_row(:white)

        ret
    end

    def back_row(color)
        row = Array.new(8) {Piece.new(color)}
        ## we'll flesh this out later
        row
    end

    def front_row(color)
        row = Array.new(8) {Piece.new(color)}
        ## this will be all pawns
        row
    end

end