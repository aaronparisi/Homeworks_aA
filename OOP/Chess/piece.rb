module Slideable
    HORIZONTAL_DIRS = [[1, 0], [-1, 0], [0, 1], [0, -1]]
    DIAGONAL_DIRS = [[1, 1], [1, -1], [-1, 1] , [-1, -1]]

    def horizontal_dirs
        HORIZONTAL_DIRS.map {|delta| [(delta[0]+pos[0]), (delta[1]+pos[1])]}
    end

    def diagonal_dirs
        DIAGONAL_DIRS.map {|delta| [(delta[0]+pos[0]), (delta[1]+pos[1])]}
    end

    def moves
        dirs = move_dirs
        case dirs
        when :horizontal
            all_deltas = HORIZONTAL_DIRS
        when :diagonal
            all_deltas = DIAGONAL_DIRS
        when :both
            all_deltas = HORIZONTAL_DIRS + DIAGONAL_DIRS
        end

        ret = []
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

        i = 1
        until ! board[dx*i, dy*i].piece.is_a(NullPiece)
            ret << [dx*i, dy*i]
            i += 1
        end
    end
end

module Stepable

    def moves
        
    end

    def move_diffs
        
    end
    
end

class Piece

    attr_reader :color, :board, :pos

    def initialize(color, board, pos)
        @color, @board, @pos = color, board, pos
    end

    def to_s
        symbol.to_s
    end

    def empty?
        
    end

    def valid_moves
       
    end

    def pos=(val)
        
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
    include Slideable
    def initialize(color, board, pos)
        super(color, board, pos)
    end

    def symbol
        :H
    end

    protected

    def move_dirs
        
    end
end

class King < Piece
    include Slideable
    def initialize(color, board, pos)
        super(color, board, pos)
    end

    def symbol
        :K
    end

    protected

    def move_dirs
        
    end
end

class Pawn < Piece

    def initialize(color, board, pos)
        super(color, board, pos)
    end

    def symbol
        :P
    end

    def move_dirs
        
    end

    private

    def at_start_now?
        
    end

    def forward_dir
        
    end

    def forward_steps
        
    end

    def side_attacks
        
    end
end



class NullPiece < Piece
    
    include Singleton

    def initialize()
        super(nil, nil, nil) # ??????
    end

    def moves
        
    end

    def symbol
        
    end
end