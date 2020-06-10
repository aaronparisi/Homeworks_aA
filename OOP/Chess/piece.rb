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

        ret
    end

    def move_diffs
        # implemented by class including Stepable
    end
    
end

class Piece

    attr_reader :color, :board, :pos

    def initialize(color, board, pos)
        @color, @board, @pos = color, board, pos
    end

    def to_s
        " " + symbol.to_s + " "
    end

    def empty?
        
    end

    def pos=(val)
        x, y = val
        pos[x][y] = val
    end

    def symbol()
        
    end

    private

    def move_into_check?(end_pos)
        
    end
end

class Bishop < Piece
    include Slideable
    def initialize(color, board, pos)
        super(color, board, pos)
    end

    def symbol
        :B
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
        :R
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
        :Q
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
        :H
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
        :K
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
        :P
    end

    def moves
        fwd = forward_dir
        x = pos[0]
        y = pos[1]

        ret = []
        first_move = [2*fwd + x, y]
        non_first = [1*fwd + x, y]
        side_attacks = [[1*fwd + x, 1+y], [1*fwd + x, -1+y]]

        if at_start_now?
            ret << first_move
            ret << non_first
        else
            ret << non_first if board[non_first].nil?
            # Board#valid_pos? returns true when an opposite color piece is there
            # but that doesn't work for Pawns
            side_attacks.each do |sa|
                ret << sa if board.valid_pos?(sa, color)
            end
        end
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

    def forward_steps
        
    end

    def side_attacks
        
    end
end



class NullPiece < Piece
    
    #include Singleton

    def initialize(pos)
        super(:black, nil, pos) # ??????
    end

    def moves
        
    end

    def to_s
        "   "
    end
end