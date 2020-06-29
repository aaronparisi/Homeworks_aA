require 'byebug'

def remove_dups(arr)
    ret = []

    arr.each {|el| ret << el if ! ret.include?(el)}

    ret
end

class Array

    def two_sum
        return [] if self.empty?
        ret = []
        (0..self.length-2).to_a.each do |i|
            el = self[i]
            (i+1..self.length-1).each do |j|
                other = self[j]
                if el + other == 0
                    ret << [i, j].sort if ! ret.include?([i, j].sort)
                end
            end
        end

        ret
    end
end

def my_transpose(arr)
    ret = Array.new(arr.length) {[]}

    arr.each do |group|
        group.each_with_index do |el, i|
            ret[i] << el
        end
    end

    ret
end

def stock_picker(prices)
    return [] if prices.sort.reverse == prices
    ret = [0, 1]
    curmax = prices[1] - prices[0]

    (0..prices.length-2).to_a.each do |buy|
        buyat = prices[buy]
        (buy+1..prices.length-1).each do |sell|
            sellat = prices[sell]
            if sellat - buyat > curmax
                ret = [buy, sell]
                curmax = sellat - buyat
            end
        end
    end

    ret
end