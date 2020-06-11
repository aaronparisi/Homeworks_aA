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

class CheckError < ArgumentError
    def message
        "You can't put yourself in check"
    end
end

class Board
    
    attr_reader :rows, :selected, :white_pieces, :black_pieces

    def initialize()
        @rows = Array.new(8) {Array.new(8) {nil}}
        @selected = nil
        @white_pieces = []
        @black_pieces = []
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
        back_row(:black, 0)
        front_row(:black, 1)

        middle_row(2)
        middle_row(3)
        middle_row(4)
        middle_row(5)
        
        front_row(:white, 6)
        back_row(:white, 7)
    end

    def middle_row(row)
        (0..7).to_a.each do |col| 
            add_piece(NullPiece.new([row, col]))
        end
    end

    def back_row(color, row)
        [0, 7].each do |col| 
            add_piece(Rook.new(color, self, [row, col]))
        end
        [1, 6].each do |col| 
            add_piece(Knight.new(color, self, [row, col]))
        end
        [2, 5].each do |col| 
            add_piece(Bishop.new(color, self, [row, col]))
        end
        add_piece(Queen.new(color, self, [row, 3]))
        add_piece(King.new(color, self, [row, 4]))
    end

    def front_row(color, row)
        (0..7).to_a.each do |col|
            add_piece(Pawn.new(color, self, [row, col]))
        end
    end

    def add_piece(piece)
        pos = piece.pos
        self[pos] = piece
        add_to_pieces(piece) if ! piece.is_a?(NullPiece)
    end

    def toggle_selected(pos)
        if selected
            @selected = nil
        else
            @selected = pos
        end
    end

    def move_piece(orig, dest, force = false)
        
        if force
            self[dest] = self[orig]
            self[orig] = NullPiece.new(orig)
            
            self[dest].pos = dest

            return
        end

        raise EmptySquareError if self[orig].is_a?(NullPiece)
        
        raise CheckError if ! self[orig].valid_move?(dest)
        
        moves = self[orig].moves
        raise InvalidMoveError if ! moves.include?(dest)
        
        self[dest] = self[orig]
        self[orig] = NullPiece.new(orig)
        self[dest].pos = dest
    
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

    def add_to_pieces(piece)
        piece.color == :white ? @white_pieces << piece : @black_pieces << piece
    end

    def checkmate?(color)
        #debugger
        puts "about to check if #{color} is in checkmate"
        mine = (color == :black ? black_pieces : white_pieces)
        if in_check?(color)
            puts "ok, #{color} is in check, let's see if it's a mate!"
            mine.all? {|m| m.valid_moves.empty?}
        else
            return false
        end            
    end

    def in_check?(color)
        king_loc = find_king(color)
        
        opponents = (color == :white ? black_pieces : white_pieces)

        opponents.each do |opp|
            all_moves = opp.moves
            return true if all_moves.include?(king_loc)
        end

        false
    end

    def find_king(color)
        if color == :black
            king = black_pieces.filter {|piece| piece.is_a?(King)}[0]
        else
            king = white_pieces.filter {|piece| piece.is_a?(King)}[0]
        end
        return king.pos
    end

    def pieces
        
    end

    def dup
        # we need to return an instance of board with copies of all pieces
        ret = Board.new
        (0..7).each do |row|
            (0..7).each do |col|
                ret.add_piece(self[[row, col]].dup(ret))
            end
        end

        ret
    end

    def four_move
        move_piece([6, 4], [4, 4])
        move_piece([1, 4], [3, 4])
        move_piece([7, 5], [4, 2])
        move_piece([0, 1], [2, 2])
        move_piece([7, 3], [5, 5])
        move_piece([1, 7], [2, 7])
        move_piece([5, 5], [1, 5])
    end

end