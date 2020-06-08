require_relative 'piece'

class EmptySquareError < ArgumentError
    def message
        "There's no piece there"
    end
end

class InvalidMoveError < ArgumentError
    def message
        "That move is invalid"
    end
end

class Board
    
    attr_reader :rows

    def initialize()
        @rows = setup_board
    end

    def [](pos)
        x, y = pos
        @rows[x][y]
    end

    def []=(pos, val)
        x, y = pos
        @rows[x][y] = val
    end

    def setup_board
        ret = Array.new(8)

        ret[0] = back_row(:black)
        ret[1] = front_row(:black)

        (2..5).each {|row| ret[row] = Array.new(8) {NullPiece.new}}

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

    def move_piece(orig, dest)
        raise EmptySquareError if self[orig].is_a?(NullPiece)
        raise InvalidMoveError if ! self[orig].valid_move?

        self[dest] = self[orig]
        self[orig] = NullPiece.new

        puts "successfully moved!"
    end

end