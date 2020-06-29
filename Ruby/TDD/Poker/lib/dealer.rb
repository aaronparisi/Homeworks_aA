require_relative 'deck'
require 'byebug'

class Dealer

    attr_reader :discards, :deck, :game
    # No test here since i-vars are not exposed via attr_*'s
    def initialize(game)
        @game = game
        @deck = Deck.new
        @discards = []
        @first_deal_pos = 0
    end

    def reset_deck
        discards.each {|c| @deck.add(c)}
        @discards = []
        @deck.shuffle
    end

    def ante_up(players)
        players.each {|p| p.ante_up}
    end

    def play_round

        reset_deck

        in_round = game.in_round

        deal(in_round)

        ante_up(in_round)

        remaining = take_bets(in_round)

        if remaining.length > 1

            take_discards(remaining)

            game.reset_bet

            take_bets(remaining)
        end

        award_winner
    end

    # Two tests:
    # 1 - expect(deck).to receive(:deal_n) with n
    # 2 - expect(player).to receive(:recieve_cards) with cards
    # ( Test those methods individual in their respective classes )
    def deal(players)
        players.each {|p| p.deal_in(@deck.deal(5))}
    end

    def take_bets(players)
        left = []
        players.each do |p|
            p.show_stats
            p.take_action(1)
            left = game.in_round
            return left if left.length == 1
        end
        players.filter {|p| (game.ante + game.bet) > p.pot}.each do |p|
            p.show_stats
            p.take_action(2)
            left = game.in_round
            return left if left.length == 1
        end
        left
    end

    def take_discards(players)
        players.each do |p|
            p.show_stats
            trash = p.get_discards
            discard(trash)
            p.receive(@deck.deal(trash.length))
        end
    end

    def discard(cards)
        @discards.concat(cards)
    end

    def award_winner
        winner = game.in_round.sort_by {|p| p.show_hand.hand_value}.last
        winner.get_paid(game.pot)
        game.active_players.each {|p| p.end_hand}
        game.end_hand
    end
end