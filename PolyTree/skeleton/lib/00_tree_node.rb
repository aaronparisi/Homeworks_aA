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
        self.parent.remove(self) if parent
        @parent = node
        node.children.push(self) if node && ! node.children.include?(self)
    end

    def remove(child)
        @children.delete_at(children.index(child))
    end


    def inspect()
        #"parent" => parent.value; "value" => value; => "children" => children.map {|child| child.value}}
        #children = [#{children.map {|child| child.value}.join(",")}]
        "[parent => #{parent ? parent.value : "none"}; value => #{value}]"
    end
end