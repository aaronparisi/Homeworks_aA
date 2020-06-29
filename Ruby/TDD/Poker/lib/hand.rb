require 'byebug'
require_relative 'card'

class Hand

    attr_reader :cards

    # Yep. expect(hand.cards).to be_empty
    def initialize
        @cards = []
    end 
    
    # Easy
    def include?(c)
        cards.include?(c)
    end

    def [](pos)
        cards[pos]
    end

    # Easy
    def add(c)
        @cards << c
    end

    # Easy
    def remove(c)
        @cards.delete(c)
    end

    def size
        cards.length
    end

    def empty
        ret = cards
        @cards = []
        ret
    end

    def render
        puts "0   1   2   3   4"
        puts cards.map {|c| c.to_symb}.join(" | ")
    end

    # royal flush       428 + 1
    # straight flush    414 + high_card
    # four of a kind    400 + quad_val
    # full house        386 + trip_val
    # flush             372 + high_card
    # straight          358 + high_card
    # three of a kind   316 + (trip_val * 2) + high_card
    # two pair          232 + (high_pair * 3) + (low_pair * 2) + high_card
    # pair              190 + (pair_value * 2) + high_card
    # high card         190 => base_val_max

    def no_pairs(points, high_card_val)
        # there are no pairs at all
        is_flush = flush?
        if straight?
            if is_flush
                if high_card_val == 14
                    # royal flush
                    return 429
                else
                    # straight flush
                    return 414 + high_card_val
                end
            else
                # regular straight
                return 358 + high_card_val
            end
        elsif is_flush
            # flush, not straight
            return 372 + high_card_val
        else
            # nothing burger
            return nothing_burger(points)
        end
    end

    def yes_pairs(groups, high_card_val)
        if ! groups[4].empty?
            # four of a kind
            return 400 + groups[4][0][0].point_val
        elsif ! groups[3].empty?
            if ! groups[2].empty?
                # we have a trip and a pair => full house
                return 386 + groups[3][0][0].point_val
            else
                # we have 3 of a kind, no pairs
                return 316 + (groups[3][0][0].point_val * 2) + high_card_val
            end
        else
            if groups[2].length == 1
                # one pair
                return 190 + groups[2][0][0].point_val + high_card_val
            else
                # 2 pairs
                return 232 + (groups[2][-1][0].point_val * 3) + (groups[2][0][0].point_val * 2) + high_card_val
            end
        end
    end

    def hand_value
        sorted = cards.sort_by {|c| c.point_val}
        groups = get_groupings(sorted)

        high_card_val = sorted[-1].point_val
        
        if groups[1].length == 5
            no_pairs(sorted.map(&:point_val), high_card_val)
        else
            # we have some pairage
            yes_pairs(groups, high_card_val)
        end


    end

    def flush?
        # 5 cards of same suit, but not in sequence
        match = cards[0].suit
        cards.filter {|c| c.suit == match}.length == 5
    end

    def straight?
        # 5 cards in sequence, not same suit
        sequence?(cards.map(&:point_val).sort)
    end

    private

    def include_by_string?(str)
        cards.any? {|c| c.by_string(str)}
    end

    def sequence?(points)
        return true if points.length == 1
        (points[0] + 1) == points[1] && sequence?(points[1..-1])
    end

    def get_groupings(cards)
        ret = {1 => [], 2 => [], 3 => [], 4 => []}
        cur_group = []
        cards.each do |c|
            if cur_group.length == 0 || cur_group.first.value == c.value
                cur_group << c
            else
                ret[cur_group.length] << cur_group
                cur_group = [c]
            end
        end

        ret[cur_group.length] << cur_group
    
        ret
    end

    def nothing_burger(points)
        ret = 0
        points.each_with_index {|p, i| ret += (p*(i+1))}

        ret
    end

end