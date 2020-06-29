require_relative 'card'

class Deck

    attr_reader :cards

    def initialize()
        @cards = []
        fill_deck
    end
    
    def [](card_str)
        cards.each {|c| return c if c.by_string(card_str)}
    end

    # Same as above
    def []=(pos, val)
        @cards[pos] = val
    end

    # Quick test
    def size    
        cards.length
    end

    def add(c)
        @cards << c
    end

    # Two tests, one for true, one for false
    # (As an aside, a more production-grade application might check the validity
    # of `val` and `suit`, i.e. 15 of spears ain't valid)
    def include?(card_str)
        cards.any? {|c| c.by_string(card_str)}
    end

    # Yep, expect(deck.shuffle.cards).to.not eq(deck.cards)
    def shuffle
        @cards.shuffle!
    end

    # Yep. Also you can just do @cards.shift(n) I think.
    # But yeah, check that you return an array of `n` cards, and potentially that
    # the deck has `n` fewer cards. Also, what happens when `n` > `@cards.length`?
    # Also, I think deal(n) is better than deal_n(n)
    def deal(n)
        @cards.shift(n)
    end

    # Please change to justt `empty` lol. Also, easy test
    def empty
        @cards = []
    end

    private

    # Don't test directly, but potentially test by looking at deck.cards after calling
    # Deck.new ...
    # Something like ... expect(deck.cards.map(&:suit).uniq).to match_array(["Spades", "Clubs", "Diamonds", "Hearts"])
    def fill_deck
        # returns a complete deck of cards
        vals = (2..10).to_a.map {|v| v.to_s} + ["Jack", "Queen", "King", "Ace"]
        suits = ["Spades", "Clubs", "Diamonds", "Hearts"]

        suits.each do |suit|
            vals.each do |val|
                @cards << Card.new(val, suit)
            end
        end

    end
end