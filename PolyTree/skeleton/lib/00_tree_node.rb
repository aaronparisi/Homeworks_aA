require 'byebug'

class PolyTreeNode

    attr_writer :children

    attr_reader :parent, :children, :value

    def initialize(value)
        @value = value
        @parent = nil
        @children = []
    end

    def parent=(node)
        # remove self from self.parent's children, if it's in there
        self.parent.remove_child(self) if parent && node != nil
        @parent = node
        node.children.push(self) if node && ! node.children.include?(self)
    end

    def add_child(child)
        @children << child
        child.parent = self
    end

    def remove_child(child)
        @children.delete_at(children.index(child))
        child.parent = nil
    end

    def dfs(tgt)
        return self if value == tgt
        children.each do |child|
            child_search = child.dfs(tgt)
            return child_search if child_search
        end
        nil
    end

    def bfs(tgt)
        #return self is value == tgt
        nodes = []
        nodes << self
        until nodes.empty?
            cur_node = nodes.shift
            return cur_node if cur_node.value == tgt
            cur_node.children.each {|child| nodes << child}
            #nodes += cur_node.children
        end
        nil
    end


    # def inspect()
    #     #"parent" => parent.value; "value" => value; => "children" => children.map {|child| child.value}}
    #     #children = [#{children.map {|child| child.value}.join(",")}]
    #     "[parent => #{parent ? parent.value : "none"}; value => #{value}]"
    # end
end