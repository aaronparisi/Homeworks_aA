require_relative 'double_link_list'
require 'rspec'

class LRUCache

    def initialize(size)
        @size = size
        @keys = {}
        @list = DLL.new
    end

    def count
        @keys.length
    end

    def add(el)

        if include?(el)
            # we just need to rearrange last used order
            @list.make_recent(@keys[el])  # pass the actual node object??
        elsif count >= @size
            # we ran out of room, somebody has to be deleted
            del_key = @list.delete_from_beg
            @keys.delete(del_key)
            ins = Node.new(el)
            @list.insert_at_end(ins)
            @keys[el] = ins
        else
            # we are just adding it to the end
            ins = Node.new(el)
            @list.insert_at_end(ins)
            @keys[el] = ins
        end
    end

    def show
        @list.render
    end

    def last
        @list.tail.from
    end

    def include?(el)
        ! @keys[el].nil?
    end
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
                expect(myCache.last.val).to eq("I walk the line")
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
                expect(myCache.last.val).to eq(:ring_of_fire)
            end
        end
    end

    # describe '#show' do
    #     it "prints the contents of the cache" do
    #         myCache.add("I walk the line")
    #         myCache.add(5)
    #         myCache.add(-5)
    #         myCache.add({a: 1, b: 2, c: 3})
    #         myCache.add([1, 2, 3, 4])
    #         myCache.add("I walk the line")
    #         myCache.add(:ring_of_fire)
    #         myCache.add("I walk the line")
    #         myCache.add({a: 1, b: 2, c: 3})

    #         expect do
    #             myCache.show
    #         end.to output("[-5, [1, 2, 3, 4], :ring_of_fire, \"I walk the line\", {:a=>1, :b=>2, :c=>3}]\n").to_stdout
    #     end
    # end
end