class Integer
  # Integer#hash already implemented for you
end

class Array
  def hash
    hc = self.length
    self.each do |el|
      hc *= 31
      hc += el.hash  # our array can have int, string, or hash elements
    end

    hc
  end
end

class String
  def hash
    # use Array#hash
    self.chars.map(&:ord).hash # we hash over an array of ASCII vals
  end
end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    # 1. turn the hash into an array
    #    [[k, v], [k, v], ...]
    # 2. stable sort this array
    #    i.e. sort by value first, then by key
    #    ["early" keys first, "early" vals first w/in same key]
    # 3. use the Array#hash method on this array
    #    QUESTION: do we hash sub arrays??
    to_a.sort_by(&:hash).hash
  end
end
