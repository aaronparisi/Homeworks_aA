require 'byebug'

class Board
  attr_accessor :cups

  def initialize(name1, name2)
    @name1 = name1
    @name2 = name2
    @cups = place_stones
  end

  def place_stones
    # helper method to #initialize every non-store cup with four stones each
    arr = Array.new(14) {[]}
    ((0..5).to_a + (7..12).to_a).each do |idx|
      #debugger
      4.times do
        arr[idx] << :stone
      end
    end
    arr
  end

  def valid_move?(start_pos)
    raise "Invalid starting cup" if ! (start_pos.between?(0,5) || start_pos.between?(7, 12))

    raise "Starting cup is empty" if cups[start_pos].empty?
  end

  def make_move(start_pos, current_player_name)
    num_stones = cups[start_pos].length
    @cups[start_pos] = []

    i = start_pos
    while num_stones > 0
      i += 1
      i = i % 14
      next if i == (current_player_name == @name1 ? 13 : 6)
      @cups[i] << :stone
      num_stones -= 1
    end
    render
    # at this point, i => index of ending cup
    next_turn(i)
  end

  def next_turn(ending_cup_idx)
    # helper method to determine whether #make_move returns :switch, :prompt, or ending_cup_idx
    if [6,13].include?(ending_cup_idx)
      return :prompt
    elsif cups[ending_cup_idx].length == 1
      return :switch
    else
      return ending_cup_idx
    end
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    return cups[0..5].all? {|cup| cup.empty?} || cups[7..12].all? {|cup| cup.empty?}
  end

  def winner
    points1 = cups[6].length
    points2 = cups[13].length
    if points1 == points2
      :draw
    elsif points1 > points2
      @name1
    else
      @name2
    end
  end
end
