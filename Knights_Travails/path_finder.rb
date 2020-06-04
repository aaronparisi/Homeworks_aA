require_relative 'tree_node'

class PathFinder

    def self.valid_moves(pos)
        # given a position ([x, y])
        # returns an array of all valid knight-moves from the given pos
        # valid meaning 1. movement follows the rules of chess and 
        #               2. move is actually on the board still
        # NOTE: this will NOT check whether or not a move has been
        #       considered already by a particular instance of PathFinder
        # => a move is on the board if x and y are between 0 and 8, inclusive
        posx, posy = pos[0], pos[1]
        shifters = [[2, 1], [2, -1], [-2, 1], [-2, -1], [1, 2], [-1, 2], [1, -2], [-1, -2]]
        ret = []
        shifters.each do |shift|
            ret << [posx + shift[0], posy + shift[1]]
        end
        ret.filter {|rpos| rpos.all? {|i| i.between?(0, 8)}}
    end

    attr_reader :considered

    def initialize(init_pos)

        @root = TreeNode.new(init_pos)
        @move_tree
        @considered = []
        # how do we call an instance method inside of initialize??
    end

    def new_move_positions(pos)
        return PathFinder.valid_moves(pos).filter {|move| ! considered.include?(move)}
    end

    def build_move_tree
        
    end

    def find_path
        
    end
end