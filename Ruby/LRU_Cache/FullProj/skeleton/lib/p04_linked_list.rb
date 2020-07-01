require 'byebug'

class Node
  attr_reader :key
  attr_accessor :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end

  def remove
    # optional but useful, connects previous link to next link
    # and removes self from list.
    self.prev.next = self.next #if self.prev
    self.next.prev = self.prev #if self.next  # <= we wouldn't remove head?
    self.next = nil
    self.prev = nil   # is this necessary for garbage collection?
    self              # why??
  end
end

class LinkedList
  include Enumerable

  attr_reader :head, :tail

  def initialize
    @head = Node.new
    @tail = Node.new

    @head.next = @tail
    @tail.prev = @head
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    @head.next unless empty?
  end

  def last
    @tail.prev unless empty?
  end

  def empty?
    @head.next == @tail # && @tail.prev == @head
  end

  def get(key)
    # returns the value stored at the node with the given key
    
    # link = filter {|link| link.key == key}
    # link.empty? ? nil : link.first.val
    found = select {|link| link.key == key}
    found.first.val unless found.empty?
  end

  def include?(key)
    any? {|link| link.key == key}
  end

  def append(key, val)
    return if include?(key)

    aNode = Node.new(key, val)
    aNode.next = @tail
    aNode.prev = @tail.prev
    @tail.prev.next = aNode
    @tail.prev = aNode

    # 1. why do they append even if key is already in the list?
    # 2. why do they return the appended node?
  end

  def update(key, val)
    each do |link|
      link.val = val if link.key == key
      # I think typically a function like this would return the val
      # or something, indicating that the update actually happened
      # => this code returns false no matter what
    end
    false
  end

  def remove(key)
    each do |link|
      if link.key == key
        link.remove
        #break
        return link.val
        # again, returning something to indicate a removal happened
      end
    end
    nil
    # if the removal didn't happen, return nil
  end

  def each(&blck)
    aNode = @head.next
    while aNode != @tail do
      yield(aNode)
      aNode = aNode.next
    end
  end

  # uncomment when you have `each` working and `Enumerable` included
  def to_s
    inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end
end
