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
      eject! if @map.count >= @max
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
    @store.append(key, val)
    @map.set(key, @store.last)

    return val
  end

  def update_node!(node)
    # suggested helper method; move a node to the end of the list
    # NOTE: nothing has to change with the hash map
    node.prev.next = node.next
    node.next.prev = node.prev

    @store.tail.prev.next = node
    node.prev = @store.tail.prev

    @store.tail.prev = node
    node.next = @store.tail
  end

  def eject!
    # 1. remove the LRU node from the LinkedList
    # 2. remove the key from the HashMap
    to_ej = @store.head.next.key
    @store.remove(to_ej)
    @map.delete(to_ej)
  end
end
