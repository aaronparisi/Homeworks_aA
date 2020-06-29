require 'rspec'
require 'deck'

describe Deck do
    subject(:aDeck) {Deck.new}
    let(:spades) { aDeck.cards.map(&:suit).filter{|s| s=="Spades"} }
    let(:ace_of_spades) {Card.new("Ace", "Spades")}
    describe "#initialize" do
        it "should create a full deck of cards" do
            expect(aDeck.size).to eq(52)
            expect(spades.length).to eq(13)
        end
    end
    describe "#[]" do
        it "retreives the card object corresponding to the string" do
            expect(aDeck["Ace Spades"]).to be_a(Card)
            #expect(aDeck["Ace Spades"]).to eq(["Ace Spade"])
        end
        it "handles edge cases appropriately?"
    end

    describe "#[]=" do
        it "handles edge cases appropriately?"
    end

    describe "#size" do
        it "returns the length of the deck" do
            expect(aDeck.size).to eq(52)
        end
    end

    describe "#include?" do
        it "returns true if the card is in the deck" do
            expect(aDeck.include?("Ace Spades")).to be true
        end
        it "returns false if the card is not in the deck" do
            expect(aDeck.include?("Joker None")).to be false
        end
    end

    describe "#shuffle" do
        it "randomly shuffles the cards in the deck"
    end

    describe "#deal" do
        it "returns `n` cards" do
            expect(aDeck.deal(5).length).to eq(5)
        end
        it "removes `n` cards from the deck" do
            expect {aDeck.deal(5)}.to change {aDeck.size}.from(52).to(47)
        end
    end

    describe "#empty" do
        it "empties the deck" do
            expect {aDeck.empty}.to change {aDeck.size}.from(52).to(0)
        end
    end
end