require 'rspec'
require 'dealer'

describe Dealer do
    let(:aGame) { double("aGame") }
    subject(:aDealer) {Dealer.new(aGame)}
    let(:aDeck) {aDealer.deck}

    describe "#play_round" do
        it "deals each player 5 cards"
        it "asks each player for initial actions"
        it "asks each player for any discards"
        it "replaces each player's discards"
        it "asks each player for second actions"
        it "determines the winner"
        it "rotates the first_deal_pos"
    end

    describe "#deal" do
        let(:aPlayer) { double("aPlayer") }
        it "calls the given player's #receive method" do
            expect(aPlayer).to receive(:receive)

            aDealer.deal(aPlayer, 5)
        end

        it "calls the deck's deal method" do
            allow(aPlayer).to receive(:receive)
            expect(aDeck).to receive(:deal).with(5)

            aDealer.deal(aPlayer, 5)
        end
    end

    describe "#request_actions" do
    end

    describe "#request_discards" do
    end

    describe "#discard_cards" do
        let(:oneCard) {double("oneCard")}
        it "adds the given cards to the discard pile" do
            expect {aDealer.discard([oneCard])}.to change {aDealer.discards.length}.from(0).to(1)
        end
    end

    describe "#award_winner" do
        it "calls the winning player's '#take_pot' method"
    end
end