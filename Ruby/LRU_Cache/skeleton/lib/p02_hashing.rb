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
    0
  end
end
