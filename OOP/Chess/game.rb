require_relative 'board'
require_relative 'display'
require_relative 'human'

class Game

    attr_reader :board, :p1, :p2, :current_player, :display

    def initialize
        @board = Board.new
        board.setup_board
        @display = Display.new(board)
        @p1 = HumanPlayer.new("Fred", :white, display)
        @p2 = HumanPlayer.new("George", :black, display)
        @current_player = p1
    end

    def switch_players
        puts "switching players"
        @current_player = (current_player == p1 ? p2 : p1)
    end

    def play
        until board.game_over?
            begin
                display.render(current_player.color)
                processed = current_player.make_move
            rescue EmptySquareError, InvalidMoveError, CheckError, ThiefError => e
                puts e.message
                sleep(2)
                retry
            end
            switch_players if processed == :moved
        end
        puts "#{current_player.name} wins!"
    end
end

g = Game.new
g.play