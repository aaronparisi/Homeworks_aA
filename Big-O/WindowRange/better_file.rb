require_relative 'min_max_stack_queue'
require 'byebug'
require 'benchmark'
require 'rspec'
require './solution/07_max_windowed_range'

def windowed_max_range(arr, w)
    cpy = arr.dup
    my_window = MinMaxStackQueue.new

    w.times do
        my_window.enqueue(cpy.shift)
    end

    cur_max = nil

    while true do
        cur_max = [my_window.get_range, cur_max].compact.max
        break if cpy.empty?
        my_window.move_window_one(cpy.shift)
    end
    
    cur_max
end

describe "windowed_max_range" do
    it "returns the max range from all possible windows of size n" do
        test = [1, 0, 2, 5, 4, 8]
        expect(windowed_max_range(test, 2)).to eq(4)
        expect(windowed_max_range(test, 3)).to eq(5)
        expect(windowed_max_range(test, 4)).to eq(6)
        expect(windowed_max_range(test, 5)).to eq(8)
    end
end

arr = Array.new(20_000_000) {rand 10_000_000}
size = 100_000

Benchmark.bm(10) do |x|
    x.report('Mine: ') {windowed_max_range(arr, size)}
    x.report('Theirs ') {max_windowed_range(arr, size)}
end