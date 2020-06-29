require 'byebug'
require 'colorize'
require_relative 'path_finder'

class Board

    attr_reader :grid

    def initialize
        @grid = Array.new(8) {Array.new(8) {nil}}
    end

    def show_paths(orig, dest)
        finder = PathFinder.new(orig)
        finder.build_move_tree
        paths = finder.find_paths(dest)
        paths.each {|path| render(path)}
    end

    def render(path)
        puts "    " + (0...8).to_a.join("   ")
        puts "  ---------------------------------"
        grid.each_with_index do |row, ridx|
            print "#{ridx} | "
            puts row.each_with_index.map {|tile, cidx| path.include?([ridx, cidx]) ? "#{path.index([ridx, cidx])+1}".colorize(:white) : " "}.join(" | ") + " |"
            puts "  ---------------------------------"
        end
        nil
    end
end

orig = [0, 0]
dest = [0, 7]

b1 = Board.new()
b1.show_paths(orig, dest)