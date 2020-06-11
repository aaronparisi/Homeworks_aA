require "colorize"
require 'byebug'
require_relative "cursor"
require_relative "board"
require_relative "piece"

class Display

    attr_reader :board

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0, 0], board)
  end

  def build_grid
    @board.rows.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    row.map.with_index do |piece, j|
      color_options = colors_for(piece)
      piece.to_s.colorize(color_options)
    end
  end

  def colors_for(apiece)
    i, j = apiece.pos
    #debugger
    if board.selected == [i, j]
        bg = :red
    elsif [i, j] == @cursor.cursor_pos
      bg = :light_red
    elsif (i+j).odd?
      bg = :light_black
    else
      bg = :blue
    end
    { background: bg, color: apiece.color }
    # the backgrounds of the pieces alternates light and dark blue
    # and the text color is white?
  end

  def looper()
      while true
        render
        @cursor.get_input
      end
  end

  def render
    #system("clear")
    puts "   0  1  2  3  4  5  6  7"
    build_grid.each_with_index { |row, i| puts i.to_s + " " + row.join }
    nil
  end
end

b = Board.new
b.setup_board
d = Display.new(b)
d.render
b.four_move
d.render
# # b[[5, 5]].moves
# # puts
# # b[[0, 3]].moves
# # puts
puts "black is in checkmate? => #{b.checkmate?(:black)}"