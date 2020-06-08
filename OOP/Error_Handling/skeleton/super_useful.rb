# PHASE 2
def convert_to_int(str)
  begin
    Integer(str)
  rescue ArgumentError
    return nil
  end
end

# PHASE 3
FRUITS = ["apple", "banana", "orange"]

def reaction(maybe_fruit)
  if FRUITS.include? maybe_fruit
    puts "OMG, thanks so much for the #{maybe_fruit}!"
  elsif maybe_fruit == "coffee"
    raise ArgumentError
  else
    raise StandardError 
  end 
end

def feed_me_a_fruit
  puts "Hello, I am a friendly monster. :)"

  begin
  puts "Feed me a fruit! (Enter the name of a fruit:)"
  maybe_fruit = gets.chomp
    reaction(maybe_fruit)
  rescue ArgumentError
    puts "I like coffee a lot!  But it's not a fruit, try again please."
    retry
  rescue StandardError
    puts "that's not a fruit I like."
  end
end  

# PHASE 4
class BestFriend
  def initialize(name, yrs_known, fav_pastime)
    raise ArgumentError.new("You haven't known them long enough to be best friends!") if yrs_known < 5
    raise ArgumentError.new("You don't even know their name!") if name.length == 0
    raise ArgumentError.new("They like to have fun too, ya know") if fav_pastime.length == 0
    @name = name
    @yrs_known = yrs_known
    @fav_pastime = fav_pastime
  end

  def talk_about_friendship
    puts "Wowza, we've been friends for #{@yrs_known}. Let's be friends for another #{1000 * @yrs_known}."
  end

  def do_friendstuff
    puts "Hey bestie, let's go #{@fav_pastime}. Wait, why don't you choose. 😄"
  end

  def give_friendship_bracelet
    puts "Hey bestie, I made you a friendship bracelet. It says my name, #{@name}, so you never forget me." 
  end
end


