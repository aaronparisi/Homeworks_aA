class Piece
    def initialize(color)
        @color = color
    end

    def valid_move?
        true
    end
end

class NullPiece < Piece
    def initialize()
        super(nil)
    end
end