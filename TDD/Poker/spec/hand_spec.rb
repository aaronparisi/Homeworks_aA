require 'rspec'

require 'hand'
require 'card'

require 'deck'

describe Hand do
    subject { described_class.new }
    #let(:card) { Card.new(10, 'spades') }
    let(:aCard) {double("card")}

    let(:aDeck) {Deck.new}
    let(:royal_flush) {Hand.new}
    let(:straight_flush) {Hand.new}
    let(:four_of_a_kind) {Hand.new}
    let(:full_house) {Hand.new}
    let(:flush) {Hand.new}
    let(:straight) {Hand.new}
    let(:three_of_a_kind) {Hand.new}
    let(:two_pair) {Hand.new}
    let(:pair) {Hand.new}
    let(:nothing_burger) {Hand.new}

    let(:ace_spades) {aDeck["Ace Spades"]}
    let(:king_spades) {aDeck["King Spades"]}
    let(:queen_spades) {aDeck["Queen Spades"]}
    let(:jack_spades) {aDeck["Jack Spades"]}
    let(:ten_spades) {aDeck["10 Spades"]}

    describe '#initialize' do
        it 'initializes an empty hand' do
            expect(subject.cards).to be_empty        
        end
    end

    describe '#include?' do
        it 'returns true if the deck includes the card' do
            subject.add(aCard)
            expect(subject).to include(aCard)
        end

        it 'returns false if the deck doesn\'t include the card' do
            expect(subject).to_not include(aCard)
        end
    end
    
    describe '#add' do
        it 'adds a card to the hand' do
             subject.add(aCard)
             expect(subject.cards).to include(aCard)
             
             # OR 
             # expect { subject.add(card) }.to change { subject.cards.length }.from(0).to(1)
        end
    end
    
    describe '#remove' do
        before(:each) { subject.add(aCard) }
        it 'removes a card from the hand' do
            subject.remove(aCard)
            expect(subject.cards).to be_empty

            # OR 
            # 
            # expect { subject.remove(card) }.to change { subject.cards.length }.from(1).to(0)
        end
    end

    describe '#size' do
        it "returns the size of the hand" do
            subject.add(aCard)
            subject.add(aCard)
            expect(subject.size).to eq(2)
        end
    end

    describe '#empty' do
        it "empties the hand" do
            subject.add(aCard)
            subject.add(aCard)
            expect {subject.empty}.to change {subject.size}.from(2).to(0)
        end
        it "returns an array" do
            expect(subject.empty).to be_an(Array)
        end
    end

    describe '#hand_value' do
        it "returns the property point value of the hand" do
            royal_flush.add(aDeck["Ace Spades"])
            royal_flush.add(aDeck["King Spades"])
            royal_flush.add(aDeck["Queen Spades"])
            royal_flush.add(aDeck["Jack Spades"])
            royal_flush.add(aDeck["10 Spades"])

            straight_flush.add(aDeck["4 Clubs"])
            straight_flush.add(aDeck["5 Clubs"])
            straight_flush.add(aDeck["6 Clubs"])
            straight_flush.add(aDeck["7 Clubs"])
            straight_flush.add(aDeck["8 Clubs"])

            four_of_a_kind.add(aDeck["Jack Hearts"])
            four_of_a_kind.add(aDeck["Jack Clubs"])
            four_of_a_kind.add(aDeck["Jack Spades"])
            four_of_a_kind.add(aDeck["Ace Hearts"])
            four_of_a_kind.add(aDeck["Jack Diamonds"])

            full_house.add(aDeck["10 Hearts"])
            full_house.add(aDeck["10 Diamonds"])
            full_house.add(aDeck["9 Diamonds"])
            full_house.add(aDeck["10 Spades"])
            full_house.add(aDeck["9 Hearts"])

            flush.add(aDeck["4 Spades"])
            flush.add(aDeck["Jack Spades"])
            flush.add(aDeck["8 Spades"])
            flush.add(aDeck["2 Spades"])
            flush.add(aDeck["9 Spades"])

            straight.add(aDeck["9 Spades"])
            straight.add(aDeck["10 Hearts"])
            straight.add(aDeck["8 Diamonds"])
            straight.add(aDeck["6 Clubs"])
            straight.add(aDeck["7 Spades"])

            three_of_a_kind.add(aDeck["7 Spades"])
            three_of_a_kind.add(aDeck["7 Clubs"])
            three_of_a_kind.add(aDeck["King Spades"])
            three_of_a_kind.add(aDeck["7 Diamonds"])
            three_of_a_kind.add(aDeck["Queen Hearts"])

            two_pair.add(aDeck["4 Spades"])
            two_pair.add(aDeck["4 Diamonds"])
            two_pair.add(aDeck["3 Hearts"])
            two_pair.add(aDeck["Queen Clubs"])
            two_pair.add(aDeck["3 Spades"])

            pair.add(aDeck["Ace Hearts"])
            pair.add(aDeck["8 Clubs"])
            pair.add(aDeck["Ace Spades"])
            pair.add(aDeck["4 Clubs"])
            pair.add(aDeck["2 Clubs"])

            nothing_burger.add(aDeck["3 Diamonds"])
            nothing_burger.add(aDeck["Jack Clubs"])
            nothing_burger.add(aDeck["8 Spades"])
            nothing_burger.add(aDeck["4 Hearts"])
            nothing_burger.add(aDeck["2 Spades"])

            expect(royal_flush.disect).to eq(429)
            expect(straight_flush.disect).to eq(422)
            expect(four_of_a_kind.disect).to eq(411)
            expect(full_house.disect).to eq(396)
            expect(flush.disect).to eq(383)
            expect(straight.disect).to eq(368)
            expect(three_of_a_kind.disect).to eq(343)
            expect(two_pair.disect).to eq(262)
            expect(pair.disect).to eq(218)
            expect(nothing_burger.disect).to eq(107)

        end
    end
end