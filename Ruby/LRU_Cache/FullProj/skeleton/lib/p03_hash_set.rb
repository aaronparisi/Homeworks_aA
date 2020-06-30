class HashSet
  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(key)
    return if include?(key)

    resize! if @count >= num_buckets

    self[key] << key
    @count += 1
  end

  def include?(key)
    self[key].include?(key)
  end

  def remove(key)
    @count = [@count - 1, 0].max if self[key].delete(key)
  end

  private

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
    @store[num.hash % num_buckets]
  end

  def num_buckets
    @store.length
  end

  def resize!
    temp = Array.new(num_buckets*2) {Array.new}

    @store.each do |el|
      temp[el.hash % (num_buckets*2)] << el
    end

    @store = temp
  end
end
