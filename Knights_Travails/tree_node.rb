Class TreeNode

    attr_accessor :value
    attr_reader :parent

    def initialize(value = nil)
        @value, @parent, @children = value, nil, []
    end

    def children
        @children.dup
    end

    def parent=(node)
        return self if self.parent = node

        if self.parent
            self.parent._children.delete(self)
        end

        @parent = node
        self.parent._children << self unless self.parent.nil?
        # IF we are setting self's parent to nil, don't try to modify a parent's children
        # cause there isn't one

        self
    end

    def add_child(node)
        node.parent = self
        # because parent= will do the parent's-child-array-setting for us
    end

    def remove_child(node)
        if node && !self.children.include?(node)
            raise "Tried to remove node that isn't a child!"
        end

        node.parent = nil
        # again, parent= will delete the child from the old parent's children
    end

    def bfs(tgt = nil)
        nodes = self
        until nodes.empty?
            cur = nodes.shift

            return node if cur.value == tgt
            nodes.concat(cur.children)
        end

        nil
    end

    def dfs(tgt = nil)
        return self if self.value == tgt

        children.each do |child|
            result = child.dfs(tgt)
            return result unless result == nil
        end

        nil
    end

    protected

    def _children
        @children
    end
end