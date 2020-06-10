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
        @rows = Array.new(8) {nil}
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
        @rows[0] = back_row(:black, 0)
        @rows[1] = front_row(:black, 1)

        @rows[2] = middle_row(2)
        @rows[3] = middle_row(3)
        @rows[4] = middle_row(4)
        @rows[5] = middle_row(5)
        

        @rows[6] = front_row(:white, 6)
        @rows[7] = back_row(:white, 7)
    end

    def middle_row(row)
        ret = Array.new(8) {nil}
        (0..7).to_a.each {|col| ret[col] = NullPiece.new([row, col])}
        ret
    end

    def back_row(color, row)
        ret = Array.new(8) {nil}
        [0, 7].each {|col| ret[col] = Rook.new(color, self, [row, col])}
        [1, 6].each {|col| ret[col] = Knight.new(color, self, [row, col])}
        [2, 5].each {|col| ret[col] = Bishop.new(color, self, [row, col])}
        ret[3] = Queen.new(color, self, [row, 3])
        ret[4] = King.new(color, self, [row, 4])

        ret
    end

    def front_row(color, row)
        ret = Array.new(8) {nil}
        (0..7).to_a.each {|col| ret[col] = Pawn.new(color, self, [row, col])}
        ret
    end

    def move_piece(orig, dest)
        raise EmptySquareError if self[orig].is_a?(NullPiece)

        moves = self[orig].moves
        raise InvalidMoveError if ! moves.include?(dest)

        dest_piece = self[dest]

        puts "about to take a #{dest.symbol.to_s}" if ! dest_piece.nil?

        self[dest] = self[orig]
        self[orig] = nil
        # there should be something here indicating that a piece was taken
        # if it was?

        puts "successfully moved!"
    end

    def valid_pos?(pos, color)
        x, y = pos
        if ! x.between?(0, 7) || ! y.between?(0, 7)
            return false
        elsif self[pos].is_a?(NullPiece)
            return true
        elsif self[pos].color == color
            return false
        else
            return true
        end
    end

    def add_piece(piece, pos)
        
    end

    def checkmate?(color)
        
    end

    def in_check?(color)
        
    end

    def find_king(color)
        
    end

    def pieces
        
    end

    def dup
        
    end

end