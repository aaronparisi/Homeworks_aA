require_relative 'p04_linked_list'
require 'byebug'

class HashMap
  include Enumerable

  attr_accessor :count, :store

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    bucket(key).include?(key)
  end

  def set(key, val)
    aBucket = bucket(key)
    if aBucket.include?(key)
      aBucket.update(key, val)
    else
      resize! if count >= num_buckets
      bucket(key).append(key, val)
      @count += 1
    end
  end

  def get(key)
    # calls the LINKEDLIST's get method
    bucket(key).get(key)
  end

  def delete(key)
    @count -= 1 if bucket(key).remove(key)
    # one issue w this is that you're not returning the deleted item
  end

  def each(&blck)
    self.store.each do |aList|
      aList.each {|aNode| yield(aNode.key, aNode.val)}
    end
  end

  # uncomment when you have Enumerable included
  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k.to_s} => #{v.to_s}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
    # new_size = num_buckets*2
    # new_bucks = Array.new(new_size) {LinkedList.new}

    # each do |k, v|
    #   new_bucks[k.hash % new_size].append(k, v)
    # end

    # @store = new_bucks
    # notice how here, you have to manually set the bucket item
    # rather than taking advantage of the linked list's ability
    # to set an element
    # instead, store the old list and set @store to a new array
    # of linked list objs
    # that way, when you call set(), you'll be adding the old
    # links to the new version of self
    # that is, set() doesn't know that we are populating it from
    # an array that used to be it
    old_store = self.store
    self.store = Array.new(num_buckets*2) {LinkedList.new}
    self.count = 0

    old_store.each do |aList|
      aList.each {|link| set(link.key, link.val)}
    end
  end

  def bucket(key)
    # optional but useful; return the bucket corresponding to `key`
    self.store[key.hash % num_buckets]    
  end
end
