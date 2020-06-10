require "colorize"
require 'byebug'
require_relative "cursor"

class Display

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
    if [i, j] == @cursor.cursor_pos
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

  def render
    system("clear")
    build_grid.each { |row| puts row.join }
    nil
  end
end