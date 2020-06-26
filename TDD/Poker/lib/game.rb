require_relative 'dealer'
require_relative 'player'

class Game

    BUYIN = 1_000

    attr_reader :active_players, :dealer, :ante

    attr_accessor :pot, :bet

    def initialize(players)
        @active_players = players
        @dead_players = []
        @dealer = Dealer.new(self)
        @pot = 0
        @bet = 0
        @ante = 100
    end

    def reset_bet
        @bet = 0
    end

    def raise(amt)
        @bet += amt
    end

    def see(amt)
        @pot += amt
    end

    def in_round
        active_players.filter {|p| p.in_round}
    end

    def kill(player)
        @dead_players << player
        @active_players.delete(player)
    end

    def end_hand
        @pot = 0
        @bet = 0
        @ante += 50
    end

    # This method likely delegates to other objects to determine if game is over
    # I would stub out helper methods and test all possibilities. We can talk more
    # about this when you implement this
    def game_over?
        active_players.length == 1
    end

    def seat_players
        active_players.each {|p| p.join_game(self)}
    end

    # IMHO this is more of an integration test than a unit test. This is the whole
    # meat of the program, the proverbial `main` method. I would potentially pull
    # this out into its own spec file and maybe just walk through a whole game. Maybe...
    def play_game

        seat_players

        puts "Welcome to Poker!  Playing today are:"
        puts active_players.map {|p| p.name}.join(", ")

        dealer.play_round until game_over?

        puts "#{active_players.first.name} wins!"
    end
end

p1 = Player.new("Aaron", Game::BUYIN)
p2 = Player.new("Kelsey", Game::BUYIN)
g = Game.new([p1, p2])
g.play_game