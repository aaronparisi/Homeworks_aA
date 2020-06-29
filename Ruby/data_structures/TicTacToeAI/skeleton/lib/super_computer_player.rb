require_relative 'tic_tac_toe_node'

class SuperComputerPlayer < ComputerPlayer
  def move(game, mark)
    # the computer player just guesses a winning guess, if there is one,
    # or a random one... not super smart
    anode = TicTacToeNode.new(game.board, mark)
    kiddos = anode.children
    kiddos.each {|akid| return akid.prev_move_pos if akid.winning_node?(mark)}

    kiddos.filter {|akid| ! akid.losing_node?(mark)}.sample.prev_move_pos
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Play the brilliant computer!"
  hp = HumanPlayer.new("Jeff")
  cp = SuperComputerPlayer.new

  TicTacToe.new(hp, cp).run
end
