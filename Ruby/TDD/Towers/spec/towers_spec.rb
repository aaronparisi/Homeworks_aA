require 'rspec'
require 'towers'

describe "Towers" do
    subject(:mygame) {Towers.new}
    describe "#initialize" do
        it "sets @piles to 3 arrays" do
            expect(mygame.piles.length).to eq(3)
        end
        it "puts all the disks in the first pile" do
            expect(mygame.piles[0]).to eq([1, 2, 3])
            expect([mygame.piles[1], mygame.piles[2]]).to eq([[], []])
        end
    end

    describe "#move" do

        it "prevents user from moving from an empty pile" do
            expect {mygame.move(2, 1)}.to raise_error(EmptyPileError)
        end

        it "prevents user from placing larger disk on top of smaller one" do
            mygame.move(0, 1)
            expect {mygame.move(0, 1)}.to raise_error(DiskMismatchError)
        end

        it "moves the disk from one pile to another" do
            mygame.move(0, 1)
            expect(mygame.piles).to eq([[2, 3], [1], []])
        end
    end

    describe "#game_over?" do
        it "returns false if all the disk are not in the 3rd pile" do
            expect(mygame.game_over?).to be true
        end

        before(:each) do
            mygame.move(0, 2)
            mygame.move(0, 1)
            mygame.move(2, 1)
            mygame.move(0, 2)
            mygame.move(1, 0)
            mygame.move(1, 2)
            mygame.move(0, 2)
        end
        it "returns true if all the disks are in the 3rd pile" do
            expect(mygame.game_over?).to be true
        end
    end
end