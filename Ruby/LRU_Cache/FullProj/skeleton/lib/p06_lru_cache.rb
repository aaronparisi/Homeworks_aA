require_relative 'p05_hash_map'
require_relative 'p04_linked_list'

class LRUCache
  def initialize(max, prc)
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    if @map.include?(key)
      update_node!(@map.get(key))
    else
      calc!(key)
    end
  end

  def to_s
    'Map: ' + @map.to_s + '\n' + 'Store: ' + @store.to_s
  end

  private

  def calc!(key)
    # suggested helper method; insert an (un-cached) key
    val = @prc.call(key)
    new_node = @store.append(key, val)
    @map.set(key, new_node)

    eject! if @map.count > @max

    return val
  end

  def update_node!(node)
    # suggested helper method; move a node to the end of the list

    node.remove # take the node out of the list

    @map[node.key] = @store.append(node.key, node.val)
  end

  def eject!
    # 1. remove the LRU node from the LinkedList
    # 2. remove the key from the HashMap
    to_ej = @store.head.next.key
    @store.remove(to_ej)
    @map.delete(to_ej)
  end
end
