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
    
    attr_reader :rows, :selected

    def initialize()
        @rows = Array.new(8) {Array.new(8) {nil}}
        @selected = nil
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
        
        front_row(:white, 6)
        back_row(:white, 7)
    end

    # def middle_row(row)
    #     (0..7).to_a.each do |col| 
    #         add_piece(NullPiece.new([row, col]))
    #     end
    # end

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
        #add_to_pieces(piece) if ! piece.is_a?(NullPiece)
    end

    def toggle_selected(pos)
        if selected
            #puts "prev selection was #{selected}, moving it to #{pos}"
            if time_to_move?(pos)
                move_piece(selected, pos)
                @selected = nil
                return :moved
            end
            @selected = nil
            return :deselected
        else
            raise EmptySquareError if self[pos].nil?
            @selected = pos
            return :selected
        end
    end

    def time_to_move?(dest)
        ! self[selected].nil? && selected != dest
    end

    def move_piece(orig, dest, force = false)
        if force
            reassign(orig, dest)
            return
        end

        raise EmptySquareError if self[orig].nil?
        raise CheckError if ! self[orig].valid_move?(dest)
        
        moves = self[orig].moves
        raise InvalidMoveError if ! moves.include?(dest)
        reassign(orig, dest)
    
    end

    def reassign(orig, dest)
        self[dest] = self[orig]
        self[orig] = nil
        self[dest].pos = dest
    end

    # def delete_piece(piece)
    #     if piece.color == :black
    #         @black_pieces.delete(piece)
    #     else
    #         @white_pieces.delete(piece)
    #     end
    # end

    def valid_pos?(pos, color)
        if off_board?(pos)
            return false
        elsif self[pos].nil?
            return true
        elsif self[pos].color == color
            return false
        else
            return true
        end
    end

    def valid_pawn_attack?(pos, color)
        ! off_board?(pos) &&
        ! self[pos].nil? && 
        self[pos].color != color
    end

    def off_board?(pos)
        x, y = pos
        ! x.between?(0, 7) || ! y.between?(0, 7)
    end

    # def add_to_pieces(piece)
    #     piece.color == :white ? @white_pieces << piece : @black_pieces << piece
    # end

    def game_over?
        checkmate?(:black) || checkmate?(:white)
    end

    def checkmate?(color)
        if in_check?(color)
            pieces(color).all? {|m| m.valid_moves.empty?}
        else
            return false
        end            
    end

    def in_check?(color)
        king_loc = find_king(color)
        
        opponents = (color == :black ? white_pieces : black_pieces)
        opponents.each do |opp|
            return true if opp.moves.include?(king_loc)
        end

        false
    end

    def find_king(color)
        pieces(color).filter {|piece| piece.is_a?(King)}[0].pos
    end

    def black_pieces
        pieces(:black)
    end

    def white_pieces
        pieces(:white)
    end

    def pieces(color)
        ret = []
        @rows.each do |row|
            row.each do |piece|
                ret << piece if ! piece.nil? && piece.color == color
            end
        end

        ret
    end

    def dup
        # we need to return an instance of board with copies of all pieces
        ret = Board.new
        (0..7).each do |row|
            (0..7).each do |col|
                cur = self[[row, col]]
                ret.add_piece(cur.dup(ret)) if ! cur.nil?
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