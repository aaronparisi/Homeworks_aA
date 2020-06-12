class Simon
  COLORS = %w(red blue green yellow)

  attr_accessor :sequence_length, :game_over, :seq

  def initialize
    @sequence_length = 1
    @game_over = false
    @seq = []
  end

  def play
    until game_over
      take_turn
    end
    game_over_message
    reset_game
  end

  def take_turn
    @sequence_length += 1
    show_sequence
    input = require_sequence
    if input != seq.join(" ")
      @game_over = true
    else
      round_success_message
    end
  end

  def show_sequence
    add_random_color
    seq.each_with_index do |col, i|
      system("clear")
      i.times {puts}
      puts col
      sleep 1
      system("clear")
    end
  end

  def require_sequence
    puts "enter the sequence"
    STDIN.gets.chomp
  end

  def add_random_color
    @seq << COLORS.sample
  end

  def round_success_message
    puts "round successful!"
    sleep(2)
  end

  def game_over_message
    puts "game over"
    puts "actual sequence is: [#{seq.join(" ")}]"
  end

  def reset_game
    @game_over = false
    @sequence_length = 1
    @seq = []
  end
end

if __FILE__ == $PROGRAM_NAME
  Simon.new.play
end