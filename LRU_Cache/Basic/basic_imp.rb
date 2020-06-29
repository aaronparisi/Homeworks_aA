require 'rspec'

class LRUCache
    def initialize(size)
        @size = size
        @contents = []
    end

    def count
        # returns the number of elements in the cache
        @contents.length
    end

    def add(el)
        # adds the element to the cache
        if @contents.include?(el)
            @contents.delete(el)
            @contents << el
        elsif count >= @size
            @contents.shift # remove element at the el put in longest ago
            @contents << el
        else
            @contents << el
        end
    end

    def show
        # displays the contents of the cache, LRU item first
        p @contents
        nil
    end

    def include?(el)
        @contents.each do |c|
            return true if c == el
        end

        return false
    end

    def last
        @contents.last
    end

    private
    # any helper methods go here
end

describe LRUCache do
    subject(:myCache) {LRUCache.new(5)}
    describe '#count' do
        it "returns the length of the cache" do
            expect(myCache.count).to eq(0)

            myCache.add("I walk the line")
            myCache.add(5)

            expect(myCache.count).to eq(2)
        end
    end

    describe '#add' do
        context "when the given element is in the list" do
            it "moves the given element to the front of the cache" do
                myCache.add("I walk the line")
                myCache.add(5)
                myCache.add(-5)
                myCache.add({a: 1, b: 2, c: 3})
                myCache.add([1, 2, 3, 4])
                myCache.add("I walk the line")
                expect(myCache.last).to eq("I walk the line")
            end
            it "does not duplicate the element" do
                myCache.add("I walk the line")
                myCache.add(5)
                myCache.add(-5)
                myCache.add({a: 1, b: 2, c: 3})
                expect {myCache.add("I walk the line")}.to_not change {myCache.count}
            end
        end
        context "when the given element is not in the list" do
            context "when the cache is full" do
                it "removes the least recently used element" do
                    myCache.add("I walk the line")
                    myCache.add(5)
                    myCache.add(-5)
                    myCache.add({a: 1, b: 2, c: 3})
                    myCache.add([1, 2, 3, 4])
                    myCache.add(:ring_of_fire)
                    expect(myCache).to_not include("I walk the line")
                end

                it "does not change the size of the cache" do
                    myCache.add("I walk the line")
                    myCache.add(5)
                    myCache.add(-5)
                    myCache.add({a: 1, b: 2, c: 3})
                    myCache.add([1, 2, 3, 4])
                    expect {myCache.add(:ring_of_fire)}.to_not change {myCache.count}
                end
            end

            it "adds the element to the end of the cache" do
                myCache.add("I walk the line")
                myCache.add(5)
                myCache.add(-5)
                myCache.add({a: 1, b: 2, c: 3})
                myCache.add([1, 2, 3, 4])
                myCache.add(:ring_of_fire)
                expect(myCache.last).to eq(:ring_of_fire)
            end
        end
    end

    describe '#show' do
        it "prints the contents of the cache" do
            myCache.add("I walk the line")
            myCache.add(5)
            myCache.add(-5)
            myCache.add({a: 1, b: 2, c: 3})
            myCache.add([1, 2, 3, 4])
            myCache.add("I walk the line")
            myCache.add(:ring_of_fire)
            myCache.add("I walk the line")
            myCache.add({a: 1, b: 2, c: 3})

            expect do
                myCache.show
            end.to output("[-5, [1, 2, 3, 4], :ring_of_fire, \"I walk the line\", {:a=>1, :b=>2, :c=>3}]\n").to_stdout
        end
    end
end