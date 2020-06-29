require 'byebug'
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
        ret.filter {|rpos| rpos.all? {|i| i.between?(0, 7)}}
    end

    attr_reader :considered, :move_tree

    def initialize(init_pos)

        @move_tree = TreeNode.new(init_pos)
        @considered = []  # <= should be an array of node values
        # how do we call an instance method inside of initialize??
    end

    def new_moves(pos)
        ret = PathFinder.valid_moves(pos).filter {|new_pos| ! considered.include?(new_pos)}.map {|new_pos| TreeNode.new(new_pos)}
        #@considered.concat(ret)
        ret
    end

    def process_node(cur_node)
        new_positions = new_moves(cur_node.value)

        new_positions.each do |new_pos|
            # each of these new nodes needs a parent
            new_pos.parent = cur_node
        end
        new_positions
    end

    def process_generation(cur_gen)
        # a "generation" is a collection of nodes which are all at the same "depth"
        # i.e. a collection of nodes who either have the same parent
        #      or whose parents are in the same generation
        @considered.concat(cur_gen.map {|cg| cg.value})
        @considered.uniq!

        #debugger
        next_gen = []
        cur_gen.each do |cur_node|
            next_gen.concat(process_node(cur_node))
        end
        next_gen
    end

    def build_move_tree
        generations = [[@move_tree]]

        until generations.empty?
            next_gen = process_generation(generations.shift)
            generations << next_gen if ! next_gen.empty?
            # next_gen.each {|ng| @considered << ng if ! considered.include?(ng.value)}

            #move_tree.pretty_print
        end
    end

    def generate_path(node)
        
    end

    def find_paths(dest)
        # given a destination [x, y]
        # returns an array of paths from self's starting position to dest,
        # or nil of no such path exists
        # a path is a series of values
        final_nodes = move_tree.get_final_nodes(dest)
        # an array of nodes, found by traversing self's move_tree,
        # whose values == dest
        paths = []
        final_nodes.each do |fnode|
            paths << fnode.gen_path_to
        end
        #debugger
        paths
    end

end

# start = [2, 3]
# pf1 = PathFinder.new(start)
# pf1.build_move_tree() # this is all moves until the ends of the board
# #pf1.move_tree.pretty_print
# dest = [7,0]
# paths = pf1.find_paths(dest)
# puts "printing out all paths from #{start} to #{dest}"
# paths.each do |path|
#     print path
#     puts
# end

    # def build_move_tree
    #     # will perform a breadth-first-build starting with the root node
    #     nodes = [@move_tree]
    #     #debugger
    #     until nodes.empty?
    #         cur = nodes.shift
    #         # work with the first node of the queue
    #         moves_from = new_move_positions(cur.value).map {|move| TreeNode.new(move)}

    #         moves_from.each do |new|
    #             new.parent = cur
    #             puts "added node with val #{new.value} to the tree"
    #             nodes << new
    #         end
    #         # set each of those nodes' parent to cur
    #         # add the node to nodes so it can be iterated over

    #         @considered << cur.value
    #         # only put them there once they have actually been shifted and assigned children
    #         # that way ????

    #         move_tree.pretty_print

    #     end
    # end

    # def pretty_print()
    #     to_print = [[move_tree]]
    #     until to_print.empty?
    #         this_row = to_print.shift
    #         next_row = []
    #         this_row.each do |node|
    #             next_row.concat(node.children)
    #         end
    #         puts this_row.map {|node| node.value.to_s}.join(" ")
    #         to_print << next_row if ! next_row.empty?
    #     end
    # end