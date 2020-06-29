require_relative 'hand'

class InvalidDiscardError < ArgumentError

    attr_reader :code

    def initialize(code)
        @code = code
    end

    def message
        case code
        when :delim
            "Please separate values with a single space"
        when :type
            "Please enter integers only"
        when :quant
            "Please enter 5 or fewer indices"
        when :range
            "Please select indeces between 0 and 4"
        when :poverty
            "Ok, please try again"
        end
    end
end

class InvalidActionError < ArgumentError

    attr_reader :code

    def initialize(code)
        @code = code
    end

    def message
        case code
        when :action
            "Please enter a valid action"
        when :poverty
            "You don't have enough money to see that bet"
        when :ambitious
            "You don't have enough money to do that"
        when :silliness
            "Please enter a valid amount"
        end
    end
end

class Player

    attr_reader :name, :pot, :funds, :game, :in_round

    def initialize(name, funds)
        @name, @funds = name, funds
        @game = nil
        @pot = 0
        @hand = Hand.new
        @in_round = true
    end

    def join_game(game)
        @game = game
    end
    
    end

    def deal_in(cards)
        @in_round = true
        receive(cards)
    end

    def receive(cards)
        cards.each {|c| @hand.add(c)}
    end

    def show_hand
        @hand.dup
    end

    def show_stats
        system("clear")
        puts "#{name}:-------------------"
        puts "#{"Remaining Funds".center(20)}|#{"Your Pot".center(10)}|#{"Current Bet".center(15)}|#{"Total Pot".center(15)}"
        puts "#{funds}".center(20) + "|" + "#{pot}".center(10) + "|" + "#{game.bet}".center(15) + "|" + "#{game.pot}".center(15)
        puts
        puts "Your hand: ---------------------"
        @hand.render
    end

    def ante_up
        diff = [game.ante, funds].min
        @pot += diff
        @funds -= diff
        game.see(diff)
    end

    def discard(cards)
        cards.each do |c|
            @hand.remove(c)
        end
        cards
    end

    def get_discards
        begin
            puts "#{name}, please enter the indices of the cards you would like to discard"
            str = gets.chomp
            if str.length > 0
                discard(parse_discards(str))
            else
                return []
            end
        rescue InvalidDiscardError => exception
            puts exception.message
            retry
        end
    end

    def process_action(str)
        case str
        when "fold"
            fold
        when "bet"
            get_bet
        when "see"
            if funds < game.bet - pot # helper method
                begin
                    puts "If you see the bet, you'll have to go all in.  Are you sure? y / n"
                    confirmation = gets.chomp
                    Kernel::raise ArgumentError.new if ! ["y", "n"].include?(confirmation)
                rescue ArgumentError
                    puts "Please enter y or n"
                    retry
                end
                if confirmation == "n"
                    Kernel::raise InvalidActionError.new(:poverty)
                else
                    see
                end
            else
                see
            end
        when "raise"
            Kernel::raise InvalidActionError.new(:ambitious) if funds <= game.bet
            raise(get_raise)
        end
    end

    def action_string(n)
        actions = []
        if game.bet == 0
            actions << "check"
            actions << "bet" if funds > 0
        else
            actions << "see"
            actions << "raise" if n == 1
        end
        actions << "fold"

        actions.join(" | ")
    end

    def take_action(round_num)
        begin
            puts "#{name}, please enter the action you would like to take"
            actions = action_string(round_num)
            puts actions
            act = gets.chomp
            Kernel::raise InvalidActionError.new(:action) if ! actions.include?(act)
            process_action(act)
        rescue InvalidActionError => exception
            puts exception.message
            retry
        end
    end

    # private??

    def fold
        @game.dealer.discard(@hand.empty)
        @pot
        @in_round = false
    end

    def make_bet(amt)
        game.raise(amt)  # sets the bet to this amt
        @pot += amt
        @funds -= amt
        @game.see(amt)
    end

    def get_bet
        begin
            puts "How much would you like to bet?"
            bet = gets.chomp.to_i
            Kernel::raise InvalidActionError.new(:ambitious) if bet > funds
            Kernel::raise InvalidActionError.new(:silliness) if bet <= 0
            make_bet(bet)
        rescue InvalidActionError => exception
            puts exception.message
            retry
        end
    end

    def see
        @pot += game.bet
        @funds -= game.bet
        game.see(game.bet)
    end

    def get_raise
        begin
            puts "What would you like to raise? (up to #{funds - game.bet})"
            amt = gets.chomp.to_i
            Kernel::raise InvalidActionError.new(:ambitious) if game.bet + amt > funds
        rescue InvalidActionError => exception
            puts exception.message
            retry
        end

        amt
    end

    def raise(amt)
        game.raise(amt)
        self.see
    end

    def get_paid(winnings)
        @funds += winnings
        system("clear")
        puts "#{name} wins #{winnings}!  Total funds are now #{funds}"
        sleep(5)
    end

    def end_hand
        @pot = 0
        @game.dealer.discard(@hand.empty)
        if funds == 0
            game.kill(self)
            @in_round = false
        else
            @in_round = true
        end
    end

    def parse_discards(str)
        idxs = str.split(" ")
        if idxs.any? {|c| c.length > 1}
            Kernel::raise InvalidDiscardError.new(:delim)
        elsif ! idxs.all? {|c| "0123456789".include?(c)}
            Kernel::raise InvalidDiscardError.new(:type)
        elsif idxs.length > 5
            Kernel::raise InvalidDiscardError.new(:quant)
        elsif idxs.map(&:to_i).any? {|c| c > 4}
            Kernel::raise InvalidDiscardError.new(:range)
        end

        idxs.map {|i| @hand[i.to_i]}
    end

end

# me = Player.new("Aaron", 1_000, "aGame")
# me.get_discards