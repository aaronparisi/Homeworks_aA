require 'singleton'

module Slideable
    HORIZONTAL_DIRS = [[1, 0], [-1, 0], [0, 1], [0, -1]]
    DIAGONAL_DIRS = [[1, 1], [1, -1], [-1, 1] , [-1, -1]]

    def moves
        ret = []
        dirs = move_dirs
        case dirs
        when :horizontal
            all_deltas = HORIZONTAL_DIRS
        when :diagonal
            all_deltas = DIAGONAL_DIRS
        when :both
            all_deltas = HORIZONTAL_DIRS + DIAGONAL_DIRS
        end

        
        all_deltas.each do |dx, dy|
            ret += grow_unblocked_moves_in_dir(dx, dy)
        end

        #show_moves(ret)

        ret
    end

    private

    def move_dirs
        # gets overwritten by the piece including the module?
    end

    def grow_unblocked_moves_in_dir(dx, dy)
        ret = []

        x, y = pos

        i = 1
        until ! board.valid_pos?([x + dx*i, y + dy*i], color)
            ret << [x+ dx*i, y+dy*i]
            i += 1
        end

        ret
    end
end

module Stepable

    def moves
        diffs = move_diffs
        ret = []

        diffs.each do |dx, dy|
            new = [pos[0] + dx, pos[1] + dy]
            ret << new unless ! board.valid_pos?(new, color)
        end
        
        #show_moves(ret)
        ret
    end

    def move_diffs
        # implemented by class including Stepable
    end
    
end

class Piece

    attr_reader :color, :board, :pos, :selected

    def initialize(color, board, pos)
        @color, @board, @pos = color, board, pos
        @selected = false
    end

    def to_s
        " " + symbol.to_s + " "
    end

    def empty?
        
    end

    def show_moves(moves)
        #debugger
        puts "the #{color} #{self.class} has the following moves from #{pos}"
        print moves
        puts
    end

    def pos=(val)
        x, y = val
        @pos = [x, y]
    end

    def symbol()
        
    end

    def valid_move?(amove)
        ! move_into_check?(amove)
    end

    def valid_moves()
        puts "checking if #{self.color} #{self.class} at #{self.pos} can move"
        mvs = self.moves.filter {|amove| ! move_into_check?(amove)}
        puts "that guy has #{mvs.length} moves"
        mvs
    end

    def dup(aBoard)
        # returns a deep copy of the piece
        self.class.new(self.color, aBoard, self.pos)
    end

    private

    def move_into_check?(end_pos)
        dupboard = board.dup
        dupboard.move_piece(self.pos, end_pos, true)
    
        return dupboard.in_check?(self.color)
    end
end

class Bishop < Piece
    include Slideable
    def initialize(color, board, pos)
        super(color, board, pos)
    end

    def symbol
        color == :white ? '♗' : '♝'
    end

    protected

    def move_dirs
        :diagonal
    end
end

class Rook < Piece
    include Slideable
    def initialize(color, board, pos)
        super(color, board, pos)
    end

    def symbol
        color == :white ? '♖' : '♜'
    end

    protected

    def move_dirs
        :horizontal
    end
end

class Queen < Piece
    include Slideable
    def initialize(color, board, pos)
        super(color, board, pos)
    end

    def symbol
        color == :white ? '♕' : '♛'
    end

    protected

    def move_dirs
        :both
    end
end

class Knight < Piece
    include Stepable
    def initialize(color, board, pos)
        super(color, board, pos)
    end

    def symbol
        color == :white ? '♘' : '♞'
    end

    protected

    def move_diffs
        [[2, 1], [2, -1], [1, 2], [1, -2], [-2, 1], [-2, -1], [-1, 2], [-1, -2]]
    end
end

class King < Piece
    include Stepable
    def initialize(color, board, pos)
        super(color, board, pos)
    end

    def symbol
        color == :white ? '♔' : '♚'
    end

    protected

    def move_diffs
        [[1, 0], [1, 1], [0, 1], [-1, 1], [-1 , 0], [-1, -1], [0, -1], [1, -1]]
    end
end

class Pawn < Piece

    def initialize(color, board, pos)
        super(color, board, pos)
    end

    def symbol
        color == :white ? '♙' : '♟︎'
    end

    # make sure that when you dup the board, it dups the pieces
    # I think the "duped" board ends up moving the original board's pawn
    # so when we get back to the original method (not the force-try)
    # the pawn isn't in the position it was when we started
    # and then I think Pawn#moves calls slide attacks valid
    # even if there isn't a piece there, so we get this weird
    # thing where the valid moves are "slide moves from a phantom-moved pawn"
    # and then we get an invalid move on the original call of move??
    # def moves
    #     fwd = forward_dir
    #     x = pos[0]
    #     y = pos[1]

    #     ret = []
    #     first_move = [2*fwd + x, y]
    #     non_first = [1*fwd + x, y]
    #     side_attacks = [[1*fwd + x, y+1], [1*fwd + x, y-1]]
    #     if at_start_now?
    #         ret << first_move if board[first_move].is_a?(NullPiece)
    #         ret << non_first if 
    #     else
    #         ret << non_first if board[non_first].nil?
    #         # Board#valid_pos? returns true when an opposite color piece is there
    #         # but that doesn't work for Pawns
    #         side_attacks.each do |sa|
    #             ret << sa if board.valid_pos?(sa, color)
    #             # There's a problem here
    #             # side_attacks are only valid if there is an opponent there!!
    #         end
    #     end
    #     #show_moves(ret)
    #     ret
    # end

    def moves()
        dir = forward_dir
        diffs = forward_steps(dir) + side_attacks(dir)

        x, y = self.pos
        ret = []
        diffs.each do |dx, dy|
            ret << [x + dx, y + dy]
        end
        #show_moves(ret)
        ret
    end

    private

    def at_start_now?
        return pos[0] == 1 if color == :black
        return pos[0] == 6 if color == :white
    end

    def forward_dir
        color == :white ? -1 : 1
    end

    def forward_steps(dir)
        one_away = [self.pos[0] + dir, self.pos[1]]
        two_away = [self.pos[0] + (2*dir), self.pos[1]]
        return [] if board.off_board?(one_away)
        ret = []
        if board[one_away].is_a?(NullPiece)
            ret << [dir, 0]
            if at_start_now? &&
                ! board.off_board?(two_away) &&
                board[two_away].is_a?(NullPiece)

                ret << [2*dir, 0]
            end
        end

        ret
    end

    def side_attacks(dir)
        left_side = [self.pos[0] + dir, self.pos[1]-1]
        right_side = [self.pos[0] + dir, self.pos[1]+1]
        ret = [left_side, right_side].filter do |mov|
            ! board.off_board?(mov) &&
            ! board[mov].is_a?(NullPiece) && 
            board[mov].color != self.color
        end
    end
end



class NullPiece < Piece
    
    #include Singleton

    def initialize(color = :black, board = nil, pos)
        super(:black, nil, pos) # ??????
    end

    def moves
        
    end

    def to_s
        "   "
    end
end