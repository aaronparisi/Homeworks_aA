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
        (0..7).each do |row|
            (0..7).each do |col|
                case row
                when 0
                    return back_row(:black, [row, col])
                when 1
                    return front_row(:black, [row, col])
                when 6
                    return front_row(:white, [row, col])
                when 7
                    return back_row(:white, [row, col])
                else
                    return middle_row([row, col])
                end
            end
        end
    end

    def middle_row(pos)
        ret = Array.new(8) {NullPiece.new()}
    end

    def back_row(color, pos)
        row = Array.new(8) {Piece.new(color, self, pos)}
        ## we'll flesh this out later
        row
    end

    def front_row(color, pos)
        row = Array.new(8) {Piece.new(color, self, pos)}
        ## this will be all pawns
        row
    end

    def move_piece(orig, dest)
        raise EmptySquareError if self[orig].is_a?(NullPiece)
        raise InvalidMoveError if ! self[orig].valid_moves.include?(dest)?

        self[dest] = self[orig]
        self[orig] = NullPiece.new

        puts "successfully moved!"
    end

end