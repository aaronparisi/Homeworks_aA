require 'singleton'

module Slideable
    HORIZONTAL_DIRS = [[1, 0], [-1, 0], [0, 1], [0, -1]]
    DIAGONAL_DIRS = [[1, 1], [1, -1], [-1, 1] , [-1, -1]]

    def moves
        ret = []
        dirs = move_dirs
        all_deltas = get_deltas(dirs)
        
        all_deltas.each do |dx, dy|
            ret += grow_unblocked_moves_in_dir(dx, dy)
        end

        #show_moves(ret)

        ret
    end

    private

    def get_deltas(dirs)
        case dirs
        when :horizontal
            return HORIZONTAL_DIRS
        when :diagonal
            return DIAGONAL_DIRS
        when :both
            return HORIZONTAL_DIRS + DIAGONAL_DIRS
        end
    end

    def move_dirs
        # gets overwritten by the piece including the module?
    end

    def grow_unblocked_moves_in_dir(dx, dy)
        ret = []

        x, y = pos

        i = 1
        until ! board.valid_pos?([x + dx*i, y + dy*i], color)
            ret << [x+ dx*i, y+dy*i]
            break if ! board[[x+ dx*i, y+dy*i]].nil?
            # valid moves that hit a piece are captures, can't go further
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
        mvs = self.moves.filter {|amove| ! move_into_check?(amove)}
        mvs
    end

    def dup(aBoard)
        # returns a deep copy of the piece
        self.class.new(self.color, aBoard, [self.pos[0], self.pos[1]])
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

        return [] if board.off_board?(one_away) && board[one_away].is_a?(Piece)
        
        ret = [[dir, 0]]
        if at_start_now? &&
            ! board.off_board?(two_away) &&
            board[two_away].nil?

            ret << [2*dir, 0]
        end

        ret
    end

    def side_attacks(dir)
        left_side = [self.pos[0] + dir, self.pos[1]-1]
        right_side = [self.pos[0] + dir, self.pos[1]+1]

        ret = [left_side, right_side].filter do |mov|
            board.valid_pawn_attack?(mov, self.color)
        end
    end
end



class NullPiece < Piece
    
    include Singleton

    def initialize(color = :clear, board = nil, pos)
        super(color, nil, pos) # ??????
    end

    def moves
        
    end

    def to_s
        "   "
    end
end