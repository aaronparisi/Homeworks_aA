class HumanPlayer

    attr_reader :name, :color, :display

    def initialize(name, color, display)
        @name = name
        @color = color
        @display = display
    end

    def make_move
        display.cursor.get_input(color)
        # should return any errors from Board#make_move
    end
end