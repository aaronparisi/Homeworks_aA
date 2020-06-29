require 'rspec'
require 'assign'

describe "#remove_dups" do
    subject(:arr) {[1, 1, 3, 4, 6, 5, 8, 5, 3, 7, 1]}

    it "should not use the Array#uniq method" do
        expect(arr).to_not receive(:uniq)

        remove_dups(arr)
    end

    it "returns an array" do
        expect(remove_dups(arr)).to be_a(Array)
    end

    it "does not modify the original array" do
        expect(remove_dups(arr)).to_not equal(arr)
    end

    it "removes all duplicates from the given array" do
        expect(remove_dups(arr)).to match_array([1, 3, 4, 5, 6, 7, 8])
    end

    it "maintains the original ordering" do
        expect(remove_dups(arr)).to start_with(1, 3, 4, 6, 5, 8, 7)
    end
end

describe Array do
    describe "#two_sum" do
        subject(:arr) {[-1, 1, 0, 2, -2, 1, 0]}
        context "when the given array is empty" do
            it "returns an empty array" do
                expect([].two_sum).to eq([])
            end
        end

        context "when there are no pairs" do
            it "returns an empty array" do
                expect([1, 1, 1, 1, 1, 1].two_sum).to eq([])
            end
        end

        it "does not return duplicated sorted-pairs" do
            #expect(arr.two_sum.length).to eq(4)
            expect(arr.two_sum).to_not include([1, 0])
        end

        it "sorts the pairs 'dictionary-wise'" do
            expect(arr.two_sum).to eq([[0, 1], [0, 5], [2, 6], [3, 4]])
        end
    end
end

describe "#my_transpose" do
    let(:row1) {[0, 1, 2]}
    let(:row2) {[3, 4, 5]}
    let(:row3) {[6, 7, 8]}
    subject(:matrix) {[row1, row2, row3]}

    it "does not modify the original matrix" do
        expect(my_transpose(matrix)).to_not equal(matrix)
    end

    it "transposes the array" do
        expect(my_transpose(matrix)).to eq([[0, 3, 6], [1, 4, 7], [2, 5, 8]])
    end

    context "when an empty matrix is given" do
        it "returns an empty array" do
            expect(my_transpose([])).to be_empty
        end
    end
end

describe "#stock_picker" do
    subject(:stocks) {[500, 499, 500, 700, 200, 250, 500]}

    it "returns the most profitable pair of buy-sell days" do
        expect(stock_picker(stocks)).to eq([4, 6])
    end

    context "when the stock price plummets" do
        it "returns an empty array" do
            expect(stock_picker([10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0])).to eq([])
        end
    end

    context "when there are multiple pairs with the same profit" do
        #it "returns the pair starting with the lower buy price"
        it "returns the first profit-maximizing pair" do
            expect(stock_picker([1, 5, 4, 1, 5])).to eq([0, 1])
        end
    end

end