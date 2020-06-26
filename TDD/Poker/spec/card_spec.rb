require 'rspec'

require 'card'

describe "Card" do
    subject(:aCard) {Card.new("5", "Clubs")}
    describe "#initialize" do
        it "sets the value" do
            expect(aCard.value).to eq("5")
        end
        it "sets the suit" do
            expect(aCard.suit).to eq("Clubs")
        end
    end

    describe "#==" do
        let(:aMatch) {Card.new("5", "Clubs")}
        let(:another) {Card.new("6", "Clubs")}
        context "when the given card matches in value and suit" do
            it "returns true" do
                expect(aCard == aMatch).to be true
            end
        end

        context "else" do
            it "returns false" do
                expect(aCard == another).to be false
            end
        end
    end

    describe "#by_string" do
        context "when the given value and suit match the card\'s" do
            it "returns true" do
                expect(aCard.by_string("5 Clubs")).to be true
            end
        end

        context "else" do
            it "returns false" do
                expect(aCard.by_string("6 Clubs")).to be false
            end
        end
    end
end