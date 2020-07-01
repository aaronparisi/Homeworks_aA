require 'byebug'

class StaticArray
  attr_reader :store

  def initialize(capacity)
    @store = Array.new(capacity)
  end

  def [](i)
    validate!(i)
    self.store[i]
  end

  def []=(i, val)
    validate!(i)
    self.store[i] = val
  end

  def length
    self.store.length
  end

  private

  def validate!(i)
    raise "Overflow error" unless i.between?(0, self.store.length - 1)
  end
end

class DynamicArray
  include Enumerable
  attr_accessor :count

  def initialize(capacity = 8)
    @store = StaticArray.new(capacity)
    @count = 0
  end

  def [](i)
    return nil if i < 0-count
    i < 0 ? @store[@count+i] : @store[i]
  end

  def []=(i, val)
    #return if i < 0 - capacity
    
    diff = i - (capacity-1)
    if diff > 0
      diff.times do
        push(nil)
      end
    end
    i < 0 ? @store[@count+i] = val : @store[i] = val
    @count = i+1
  end

  def capacity
    @store.length
  end

  def include?(val)
    any? {|el| el == val}
  end

  def push(val)
    resize! if length >= capacity

    @store[count] = val
    @count += 1
  end

  def unshift(val)
    resize! if length >= capacity
    
    temp = StaticArray.new(capacity)
  
    each_with_index do |el, i|
      break if el.nil?
      temp[i+1] = el
    end
    temp[0] = val
    
    @store = temp
    @count += 1
  end

  def pop
    return if length == 0

    ret = last
    @store[count-1] = nil
    @count -= 1
    ret
  end

  def shift
    return if length == 0

    ret = first
    (0...count-1).each {|idx| @store[idx] = @store[idx+1]}
    @store[count-1] = nil
    @count -= 1
    ret
  end

  def first
    @store[0]
  end

  def last
    @store[count-1]
  end

  def each
    @store.store.each {|el| yield(el)}
  end

  def to_s
    "[" + inject([]) { |acc, el| acc << el }.join(", ") + "]"
  end

  def ==(other)
    return false unless [Array, DynamicArray].include?(other.class)
    # ...
    (0..length-1).all? {|idx| @store[idx] == other[idx]}
  end

  alias_method :<<, :push
  [:length, :size].each { |method| alias_method method, :count }

  private

  def resize!
    new_arr = StaticArray.new(capacity*2)
    each_with_index {|el, i| new_arr[i] = el}

    @store = new_arr
  end
end
