require 'byebug'
require_relative 'tic_tac_toe'

class TicTacToeNode

  attr_reader :board, :next_mover_mark, :prev_move_pos

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(player)
    if board.over?
      winner = board.winner
      if winner
        return winner != player
      else
        return false
      end
    end

    all_children = children
    if player == next_mover_mark
      # this means we are asking
      # "hey, is this a losing board for the person about to move next"
      # i.e. should they just forfit
      # it is a losing board for them if:
      # 1. every single child board for them is a loser
      # (if even 1 child node is a winner or a nothing-burger,
      # then this current board state is not "hopeless" for player)
      all_children.all? {|child| child.losing_node?(player)}
    else
      # this means we are asking
      # ok, so it is NOT my turn, as next_mover_mark does not equal player;
      # so, I want to know, should my opponent even make their move,
      # or can they just tell me right now that they win?
      # this happens if even 1 of their child-boards are winners
      # or, alternatively, to keep this a soley recursive method,
      # if even 1 of their child boards are a loser for ME, player
      all_children.any? {|child| child.losing_node?(player)}
    end
  end

  def winning_node?(player)
    if board.over?
      winner = board.winner
      if winner
        return winner == player
      else
        return false
      end
    end

    all_children = children
    if player == next_mover_mark
      all_children.any? {|child| child.winning_node?(player)}
      # "it's my move, I want to know, should I even go or can I tell you now,
      # I can make a move that will guarantee that I win?"
    else
      all_children.all? {|child| child.winning_node?(player)}
      # "it's your move, I want to know, should you even move,
      # or is it the case that no matter what you do, you'll be handing me a win?"
    end
  end

  # This method generates an array of all moves (nodes) that can be made after
  # the current move.
  def children
    kids = []
    posarr = []
    (0..2). each do |xval|
      (0..2).each do |yval|
        posarr << [xval, yval]
      end
    end

    posarr.each do |pos|
      if @board.empty?(pos)
        # we create a node here
        new_board = board.dup
        # I was getting an error here that said no method '[]=' for <Class....>
        # because I said new_board = Board.dup, which says "duplicate the entire Board class"!!
        new_board[pos] = next_mover_mark
        new_next = (next_mover_mark == :x ? :o : :x)
        kids << TicTacToeNode.new(new_board, new_next, pos)
      end
    end

    kids
  end
end
