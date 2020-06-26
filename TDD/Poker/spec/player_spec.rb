require 'rspec'
require 'player'
require 'game'
require 'card'

describe Player do
    let(:aGame) { Game.new() }
    let(:aDealer) {aGame.dealer}
    subject(:aPlayer) { Player.new("Fred", 1000, aGame) }
    let(:aCard) { Card.new("Ace", "Spades") }

    describe "#receive_cards" do
        it "adds the cards to the player's hand" do
            aPlayer.receive_cards([aCard])
            expect(aPlayer.hand.include?(aCard)).to be true
        end
    end

    describe "#show_hand" do
        it "returns the player's hand" do
            aPlayer.receive_cards([aCard])
            expect(aPlayer.show_hand).to include(aCard)
        end
    end

    describe "#discard" do
        it "removes the corresponding cards from the player's hand" do
            aPlayer.receive_cards([aCard])
            aPlayer.discard([aCard])
            expect(aPlayer.hand).to_not include(aCard)
        end

        it "instructs the dealer to discard the cards" do
            aPlayer.receive_cards([aCard])
            expect(aGame.dealer).to receive(:discard).with([aCard])
            aPlayer.discard([aCard])
        end
    end

    describe "#fold" do
        # before(:all) do
        #     aPlayer.receive_cards([aCard])
        # end
        #aPlayer.receive_cards([aCard])
        it "empties the player's hand" do
            aPlayer.receive_cards([aCard])
            expect { aPlayer.fold }.to change { aPlayer.hand.size }.from(1).to(0)
        end
        it "instructs the dealer to discard the cards"
        it "empties the player's pot"
    end

    describe "#see" do
        it "sets the player's pot equal to the game's bet" do
            aGame.pot = 1000
            aGame.bet = 1000
            expect {aPlayer.see}.to change {aPlayer.pot}.from(0).to(1000)
        end
        it "reduces the player's total funds" do
            aGame.pot = 1000
            aGame.bet = 1000
            expect {aPlayer.see}.to change {aPlayer.funds}.by(-1000)
        end
    end

    describe "#raise" do
        it "instructs the game to raise the bet" do
            aGame.pot = 1000
            aGame.bet = 1000
            aPlayer.raise(50)
            expect(aGame.bet).to eq(1050)
        end
        
        it "calls the player's see method" do
            aGame.pot = 1000
            aGame.bet = 1000
            expect(aGame).to receive(:see)
            aPlayer.raise(50)
        end
    end
end